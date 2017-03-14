

open DirvishStats

type image_selection =
  | LatestImage
  | Image of string

let image_of_selection vault selection =
  match selection with 
    | LatestImage ->
        begin
          try
            latest_image vault
          with Not_found ->
            failwith "No latest image found."
        end
    | Image str ->
        begin
          try 
            find_image vault str
          with Not_found ->
            failwith (Printf.sprintf "Image %S not found." str)
        end

let selection_of_string =
  function
    | "latest" -> LatestImage
    | str -> Image str


let () = 
  let size_filename_of_image image = 
    Filename.concat (dirname_of_image image) "size"
  in

  let genvar help parse =
    let v = ref None in
    let set_v vl = 
      v := Some vl
    in
    let get_v () = 
      match !v with 
        | Some vl ->
            parse vl
        | None ->
            failwith help
    in
      set_v, get_v
  in

  let set_vault, get_vault = 
    genvar 
      "You need to select a vault."
      (fun str ->
         try 
           find_vault str
         with Not_found ->
           failwith 
             (Printf.sprintf 
                "Vault %S not found." str)) 
  in
  let set_image, get_image = 
    genvar
      "You need to select an image."
      (fun str ->
         image_of_selection 
           (get_vault ())
           (selection_of_string str))
  in

  let human =
    ref false
  in

  let output = 
    ref print_endline
  in

  let cmd_list_vault () =
    List.iter 
      (fun vault -> !output (name_of_vault vault))
      (list_vault ())
  in

  let cmd_list_image vault () =
    List.iter 
      (fun image -> !output (name_of_image image))
      (list_image vault)
  in

  let cmd_size_image image () =
    let size64 = size_of_image image in
      if !human then
        !output (FileUtil.string_of_size ~fuzzy:true (FileUtil.B size64))
      else
        !output (Int64.to_string size64)
  in

  let cmd_generate_size dn () =
    (* Create a $VAULT/$IMG/size file that can be read back. *)
    let sz, _ = FileUtil.du [Filename.concat dn "tree"] in
    let sz64 = FileUtil.byte_of_size sz in
    let chn = open_out (Filename.concat dn "size") in
      Printf.fprintf chn "%Ld\n" sz64;
      close_out chn
  in

  let cmd_collectd () =
    (* Check all images and output value for the latest image of each vault. *)
    let hostname = 
      try 
        Sys.getenv "COLLECTD_HOSTNAME"
      with Not_found ->
        "localhost"
    in
    let interval =
      try 
        max 
          1
          (int_of_float 
             (float_of_string 
                (Sys.getenv "COLLECTD_INTERVAL")))
      with 
        | Not_found ->
            60
        | Failure _ ->
            failwith 
              (Printf.sprintf
                 "Cannot parse COLLECTD_INTERVAL: %S."
                 (Sys.getenv "COLLECTD_INTERVAL"))
    in
      while true do 
        let now = Unix.gettimeofday () in
          List.iter
            (fun vault ->
               try 
                 let image = latest_image vault in
                 let size = 
                   try 
                     let chn = open_in (size_filename_of_image image) in
                     let str = input_line chn in
                       close_in chn;
                       Int64.of_string str
                   with _ ->
                     0L
                 in
                   Printf.printf
                     "PUTVAL \"%s/dirvish-stats/gauge-%s-age\" interval=%d N:%Ld\n%!"
                     hostname (name_of_vault vault) interval 
                     (Int64.of_float (now -. timestamp_of_image image));
                   Printf.printf
                     "PUTVAL \"%s/dirvish-stats/gauge-%s-size\" interval=%d N:%Ld\n%!"
                     hostname (name_of_vault vault) interval 
                     size
               with _ ->
                 ())
            (list_vault ());
          Unix.sleep interval
        done
  in

  let action = 
    ref cmd_list_vault
  in

  let args = 
    [
      "--human",
      Arg.Set human,
      " Output data in human readable form.";

      "--list_vault",
      Arg.Unit (fun () -> action := cmd_list_vault),
      " List vault.";

      "--list_image",
      Arg.Tuple
        [
          Arg.String set_vault;
          Arg.Unit (fun () -> action := cmd_list_image (get_vault ()));
        ],
      "vault List image in a vault.";

      "--size_image",
      Arg.Tuple
        [
          Arg.String set_vault;
          Arg.String set_image;
          Arg.Unit (fun () -> action := cmd_size_image (get_image ()));
        ],
      "vault image|latest Output the size of an image.";

      "--generate_size",
      Arg.String (fun dn -> action := cmd_generate_size dn),
      "dn Generate $dn/size file that contains the size in bytes of $dn/tree.";

      "--collectd",
      Arg.Unit (fun () -> action := cmd_collectd),
      " Run as a collectd plugin.";
    ]
  in

    Arg.parse 
      (Arg.align args)
      (fun str -> 
         failwith 
           (Printf.sprintf 
              "Don't know what to do with commad line argument '%s'"
              str))
      (Printf.sprintf 
         "dirvish-stats v%s, written by Sylvain Le Gall\n\
          \n\
          dirvish-stats [options]*\n\
          \n\
          Options:\n"
         Conf.version);
    !action ()
