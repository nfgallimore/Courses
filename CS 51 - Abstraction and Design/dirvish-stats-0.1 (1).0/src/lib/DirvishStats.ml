
include DirvishStatsInternal

type byte = int64

type image = 
    {
      image_ctxt: ctxt;
      image_name: string;
      image_dirname: filename;
      image_timestamp: float;
      image_reference: string option;
      image_vault_string: string;
    }

type vault = 
    {
      vault_ctxt: ctxt;
      vault_name: string;
      vault_dirname: filename;
      vault_images: image list;
    }

module MapString = Map.Make(String)
module TreeString = 
struct
  type t = string list MapString.t

  let empty = MapString.empty

  (* Get children of a parent. *)
  let get_children parent tree =
    try
      MapString.find parent tree
    with Not_found -> 
      []

  (* Build a tree using MapString. *)
  let add_child parent child tree =
    MapString.add parent 
      (child :: (get_children parent tree)) 
      tree
end

(* Test if the image really exists. *)
let image_is_valid ~ctxt image = 
  let fn = 
    Filename.concat image.image_dirname "tree"
  in
    ctxt.file_exists fn && ctxt.is_directory fn 

(* See DirvishStats.mli *)
let name_of_vault vault =
  vault.vault_name

(* See DirvishStats.mli *)
let string_of_vault vault =
  Printf.sprintf "vault:%S" vault.vault_name 

(** Read a .hist file and return the list of valid images of vault. *)
let load_hist ~ctxt vault_dirname vault_string fn = 
  (* List of image found in fn.hist. *)
  let lst = parse_hist ~ctxt  fn in

  (* All possible images, the tree and the roots of the tree.
   * At this stage, the image reference is invalid.
   *)
  let all_images, roots, tree = 
    List.fold_left
      (fun ((all_images, roots, tree) as acc) line ->
         match line with 
           | [name; created; reference; expires] ->
               begin
                 let timestamp = 
                   let datetime = 
                     CalendarLib.Printer.Calendar.from_fstring
                       "%F %T"
                       created
                   in
                   let timestamp =
                     CalendarLib.Calendar.to_unixfloat datetime
                   in
                     timestamp
                 in
                 let image =
                   {
                     image_ctxt = ctxt;
                     image_name = name;
                     image_dirname =
                       Filename.concat vault_dirname name;
                     image_timestamp = timestamp;
                     image_reference = None;
                     image_vault_string = vault_string;
                   }
                 in
                 let all_images = MapString.add name image all_images in
                   match reference with 
                     | "default" ->
                         all_images,
                         name :: roots,
                         tree
                     | parent_name ->
                         all_images,
                         roots, 
                         TreeString.add_child parent_name name tree
               end
           | _ ->
               acc)
      (MapString.empty, [], TreeString.empty) lst
  in

  (* Go through the tree and find which are the real image_reference. *)
  let rec dfs images last_valid_image name =
    let images, last_valid_image =
      let image = MapString.find name all_images in
        if image_is_valid ~ctxt image then
          {image with image_reference = last_valid_image} :: images,
          Some name
        else
          begin
            images, last_valid_image
          end
    in
      (* Go through all children of this image. *)
      List.fold_left
        (fun images child_name ->
           dfs images last_valid_image child_name)
        images
        (TreeString.get_children name tree)
  in
    (* Start with roots of the tree. *)
    List.fold_left
      (fun images root_name ->
         dfs images None root_name)
      []
      roots

(** Check that a particular directory contains a vault and load 
  * images from it.
  *)
let load_vault ~ctxt acc bank_dn vault = 
  let vault_dirname = Filename.concat bank_dn vault in
  let default_hist = 
    Filename.concat
      vault_dirname
      (Filename.concat "dirvish" "default.hist")
  in
    if ctxt.file_exists default_hist &&
       not (ctxt.is_directory default_hist) then
      begin
        let fake_vault = 
          {
            vault_ctxt = ctxt;
            vault_name = vault;
            vault_dirname = vault_dirname;
            vault_images = [];
          }
        in
        let images =  
          load_hist ~ctxt 
            vault_dirname
            (string_of_vault fake_vault)
            default_hist
        in
        let vault =
          {fake_vault with vault_images = images}
        in
          vault :: acc
      end
    else 
      acc

(* See DirvishStats.mli *)
let list_vault ?(ctxt=default) () =
  let lst = parse_conf ~ctxt ctxt.master_fn in
  let bank_lst = 
    try
      List.assoc "bank" lst
    with Not_found ->
      failwith 
        (Printf.sprintf 
           "Cannot find 'bank' field in '%s'."
           ctxt.master_fn)
  in
    List.fold_left
      (fun acc bank_dn ->
         Array.fold_left
           (fun acc vault ->
              load_vault ~ctxt acc bank_dn vault)
           acc
           (ctxt.readdir bank_dn))
      []
      bank_lst

let find_vault  ?(ctxt=default) str =
  List.find
    (fun vault -> vault.vault_name = str)
    (list_vault ~ctxt ())

(* See DirvishStats.mli *)
let dirname_of_vault vault =
  vault.vault_dirname 

(* See DirvishStats.mli *)
let list_image vault =
  vault.vault_images

(* See DirvishStats.mli *)
let find_image vault str =
  List.find
    (fun image -> image.image_name = str)
    vault.vault_images

(* See DirvishStats.mli *)
let latest_image vault =
  match vault.vault_images with 
    | hd :: tl ->
        List.fold_left
          (fun latest_image image ->
             if image.image_timestamp > latest_image.image_timestamp then
               image
             else
               latest_image)
          hd tl
    | [] ->
        raise Not_found

(* See DirvishStats.mli *)
let dirname_of_image image =
  image.image_dirname

(* See DirvishStats.mli *) 
let reference_of_image vault image =
  match image.image_reference with 
    | Some str ->
        find_image vault str
    | None ->
        raise Not_found

(* See DirvishStats.mli *)
let timestamp_of_image image =
  image.image_timestamp
  
(* See DirvishStats.mli *)
let string_of_image image =
  Printf.sprintf
    "%s:image:%S"
    image.image_vault_string
    image.image_name

(* See DirvishStats.mli *)
let name_of_image image =
  image.image_name

type inode = 
    {
      ino: int;
      dev: int;
      size: int64;
    }

module SetInode = 
  Set.Make
    (struct
       type t = inode

       let compare t1 t2 = 
         if t1.ino = t2.ino then
           t1.dev - t2.dev 
         else
           t1.ino - t2.ino
     end)

let inodes_of_image image = 
  let ctxt = image.image_ctxt in
  let blocksize = Int64.of_int (ctxt.blocksize (dirname_of_image image)) in

  let round_size i = 
    if Int64.rem i blocksize <> 0L then
      Int64.mul blocksize (Int64.succ (Int64.div i blocksize))
    else
      i
  in

  let rec add set fn = 
    let st = ctxt.lstat fn in
    let size = round_size st.Unix.LargeFile.st_size in 
    let inode = 
      {
        ino = st.Unix.LargeFile.st_ino;
        dev = st.Unix.LargeFile.st_dev;
        size = size;
      }
    in
    let set = 
      inode :: set 
    in
      match st.Unix.LargeFile.st_kind with 
        | Unix.S_DIR ->
            Array.fold_left
              (fun set bn ->
                 add set (Filename.concat fn bn))
              set
              (ctxt.readdir fn)

        | Unix.S_REG
        | Unix.S_CHR
        | Unix.S_BLK 
        | Unix.S_FIFO
        | Unix.S_LNK 
        | Unix.S_SOCK ->
            set
  in
    add [] (dirname_of_image image)

let size_of_inodes inodes = 
  List.fold_left
    (fun size inode ->
       Int64.add inode.size size)
    0L
    inodes

(* See DirvishStats.mli *) 
let size_of_image image =
  size_of_inodes (inodes_of_image image)

(* See DirvishStats.mli *) 
let diff_size_of_images image1 image2 =
  let rec to_set set = 
    function
      | [] ->
          set
      | hd :: tl ->
          to_set
            (SetInode.add hd set)
            tl
  in
  let inodes1 = to_set SetInode.empty (inodes_of_image image1) in
  let inodes2 = to_set SetInode.empty (inodes_of_image image2) in
  let new_nodes = SetInode.diff inodes2 inodes1 in
  let del_nodes = SetInode.diff inodes1 inodes2 in
    Int64.sub 
      (size_of_inodes (SetInode.elements new_nodes)) 
      (size_of_inodes (SetInode.elements del_nodes))
