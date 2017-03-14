
open OUnit2
open Unix
open Unix.LargeFile
open FilePath.UnixPath
open DirvishStats

module MapString = Map.Make(String)

let ctxt test_ctxt =
  let file_stat = 
    {
      st_dev = 1;
      st_ino = 0;
      st_kind = S_REG;
      st_perm = 420;
      st_nlink = 1;
      st_uid = 1000;
      st_gid = 1000;
      st_rdev = 0;
      st_size = 1374L;
      st_atime = 1367712007.;
      st_mtime = 1367696812.;
      st_ctime = 1367696812.;
    }
  in
  let dir_stat =
    {
      st_dev = 1;
      st_ino = 0;
      st_kind = S_DIR;
      st_perm = 493; 
      st_nlink = 5; 
      st_uid = 1000;
      st_gid = 1000; 
      st_rdev = 0; 
      st_size = 4096L;
      st_atime = 1367760010.;
      st_mtime = 1367759439.;
      st_ctime = 1367759439.;
    }
  in
  let new_inode = 
    let r = ref 1 in
      fun stat ->
        let res = {stat with st_ino = !r} in
          incr r;
          res
  in
  let fs = 
    ref MapString.empty
  in
  let norm fn = 
    if String.length fn > 1 && fn.[String.length fn - 1] = '/' then
      String.sub fn 0 (String.length fn - 1)
    else
      fn
  in
  let retrieve_data fn = 
    try
      MapString.find (norm fn) !fs 
    with Not_found ->
      raise 
        (Sys_error 
           (Printf.sprintf 
              "%s: No such file or directory"
              fn))
  in
  let file_exists fn =
    MapString.mem (norm fn) !fs
  in
  let lstat fn =
    fst (retrieve_data fn)
  in
  let is_directory fn = 
    (lstat fn).st_kind = S_DIR
  in
  let readdir fn =
    let fn = norm fn in
    let lst = 
      MapString.fold
        (fun fn' _ lst ->
           if dirname fn' = fn then
             basename fn' :: lst
           else 
             lst)
        !fs
        []
    in
      Array.of_list lst
  in
  let read fn = 
    snd (retrieve_data fn)
  in
  let rec mkdir fn = 
    let fn = norm fn in
      if file_exists fn then
        begin
          if is_directory fn then
            ()
          else
            failwith 
              (Printf.sprintf 
                 "Cannot create directory %s, a file already exists."
                 fn)
        end
      else
        begin
          if fn <> "/" then
            mkdir (dirname fn);
          fs := 
            MapString.add 
              fn ((new_inode dir_stat), "")
              !fs
        end
  in

  let mkfile fn cnt =
    let fn = norm fn in
      mkdir (dirname fn);
      fs := 
        MapString.add
          fn ({(new_inode file_stat) with st_size = Int64.of_int (String.length cnt)}, cnt)
          !fs
  in
  let cp_hard fn1 fn2 =
    mkdir fn2;
    fs := 
      MapString.fold
        (fun fn data fs ->
           if is_subdir fn fn1 then
             MapString.add
               (reparent fn1 fn2 fn)
               data
               fs
           else
             fs)
        !fs !fs
  in
  let debug () =
    MapString.iter
      (fun fn (lstat, cnt) ->
        logf test_ctxt LInfo "%s inode: %d" fn lstat.st_ino)
      !fs
  in
    mkfile
      "/etc/dirvish/master.conf"
      "bank:\n\t/srv/dirvish/";
    mkfile
      "/srv/dirvish/vault1/dirvish/default.hist"
      "#IMAGE  CREATED REFERECE  EXPIRES\n\
      20100426\t2010-04-26 18:04:44\tdefault\t+2 months == 2010-06-26 17:58:34\n\
      20100602\t2010-06-02 09:53:26\t20100426\t+2 months == 2010-08-02 09:52:41\n\
      20100603\t2010-06-03 09:54:51\t20100602\t+2 months == 2010-08-03 09:53:44\n\
      20100607\t2010-06-07 10:10:42\t20100603\t+2 months == 2010-08-07 10:09:28\n";
    mkfile
      "/srv/dirvish/vault1/20100426/tree/foo.txt"
      (String.make 1000 'x');
    cp_hard
      "/srv/dirvish/vault1/20100426"
      "/srv/dirvish/vault1/20100603";
    mkfile
      "/srv/dirvish/vault1/20100603/tree/bar.txt"
      (String.make 15000 'y');
    debug ();
    {
      master_fn = "/etc/dirvish/master.conf";
      read = read;
      lstat = lstat;
      readdir = readdir;
      file_exists = file_exists;
      is_directory = is_directory;
      blocksize = fun _ -> 4096;
    }

module VaultSet = 
  OUnitDiff.SetMake
    (struct
       type t = string * string
       let pp_printer fmt (dn, vlt) = 
         Format.fprintf fmt "dirname: %S; vault: %s" dn vlt
       let compare = Pervasives.compare
       let pp_print_sep = OUnitDiff.pp_comma_separator
     end)

module ImageSet =
  OUnitDiff.SetMake
    (struct
       type t = string * string * string * float
       let pp_printer fmt (dn, img1, img2, timestamp) =
         Format.fprintf fmt 
           "dirname: %S; image: %s; reference: %s; timestamp: %f"
           dn img1 img2 timestamp

       let compare (s11, s12, s13, f1) (s21, s22, s23, f2) = 
         let res = 
           Pervasives.compare (s11, s12, s13) (s21, s22, s23)
         in
           if res = 0 then
             begin
               let diff = f1 -. f2 in
                 if diff  <= -0.1 then
                   -1
                 else if diff <= 0.1 then
                   0
                 else
                   1
             end
           else
             res

       let pp_print_sep = OUnitDiff.pp_comma_separator
     end)

let tests = 
  [
    "list_vaults" >::
    (fun test_ctxt ->
       let ctxt = ctxt test_ctxt in
         VaultSet.assert_equal
           (VaultSet.of_list 
              ["/srv/dirvish/vault1", "vault:\"vault1\""])
           (VaultSet.of_list
              (List.map
                 (fun vault -> dirname_of_vault vault, string_of_vault vault)
                 (list_vault ~ctxt ()))));

    "find_vault" >::
    (fun test_ctxt ->
       let ctxt = ctxt test_ctxt in
         assert_equal
           ~printer:(Printf.sprintf "%S")
           "/srv/dirvish/vault1"
           (dirname_of_vault (find_vault ~ctxt "vault1")));

    "list_image" >::
    (fun test_ctxt ->
       let ctxt = ctxt test_ctxt in
       let vault = find_vault ~ctxt "vault1" in
         ImageSet.assert_equal
           (ImageSet.of_list
             [
               "/srv/dirvish/vault1/20100426",
               "vault:\"vault1\":image:\"20100426\"",               
               "none",
               1272305084.0;

               "/srv/dirvish/vault1/20100603",
               "vault:\"vault1\":image:\"20100603\"",
               "vault:\"vault1\":image:\"20100426\"",
               1275558891.0;
             ])
           (ImageSet.of_list 
              (List.map
                 (fun img ->
                    dirname_of_image img,
                    string_of_image img,
                    (try
                       string_of_image (reference_of_image vault img)
                     with Not_found ->
                       "none"),
                    timestamp_of_image img)
                 (list_image vault))));

    "find_image" >::
    (fun test_ctxt ->
       let ctxt = ctxt test_ctxt in
       let vault = find_vault ~ctxt "vault1" in
       let img = find_image vault "20100426" in
         assert_equal
           ~printer:(Printf.sprintf "%S")
           "/srv/dirvish/vault1/20100426"
           (dirname_of_image img));

    "latest_image" >::
    (fun test_ctxt ->
       let ctxt = ctxt test_ctxt in
       let vault = find_vault ~ctxt "vault1" in
       let img = latest_image vault in
         assert_equal
           ~printer:(Printf.sprintf "%S")
           "/srv/dirvish/vault1/20100603"
           (dirname_of_image img));

    "size_of_image" >::
    (fun test_ctxt ->
       let ctxt = ctxt test_ctxt in
       let vault = find_vault ~ctxt "vault1" in
       let img = find_image vault "20100603" in
         assert_equal
           ~printer:(Printf.sprintf "%Ld")
           28672L
           (size_of_image img));

    "diff_size_of_image" >::
    (fun test_ctxt ->
       let ctxt = ctxt test_ctxt in
       let vault = find_vault ~ctxt "vault1" in
       let img1 = find_image vault "20100426" in
       let img2 = find_image vault "20100603" in
         assert_equal
           ~printer:(Printf.sprintf "%Ld")
           16384L
           (diff_size_of_images img1 img2));

    "parse_conf" >:::
    (let lst = 
       FileUtil.filter
         (FileUtil.Has_extension "conf")
         (FileUtil.ls
            (FilePath.make_filename ["test"; "data"]))
     in
       List.map
         (fun fn ->
            fn >::
            (fun test_ctxt ->
               let lst = 
                 DirvishStatsInternal.parse_conf
                   ~ctxt:DirvishStatsInternal.default
                   fn
               in
                 List.iter 
                   (fun (id, values) ->
                      logf test_ctxt LInfo 
                        "file '%s', parsed data: %s = [%s]" 
                        fn id
                        (String.concat ";"
                           (List.map (Printf.sprintf "%S") values)))
                   lst))
         lst);
  ]

let () =
  run_test_tt_main
    ("DirvishStats" >::: tests)
