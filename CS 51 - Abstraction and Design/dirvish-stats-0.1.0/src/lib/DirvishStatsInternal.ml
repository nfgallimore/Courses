
type filename = string

(* See DirvishStats.mli *)
type ctxt = 
    {
      master_fn: filename;
      read: filename -> string;
      lstat: filename -> Unix.LargeFile.stats;
      readdir: filename -> filename array;
      file_exists: filename -> bool;
      is_directory: filename -> bool;
      blocksize: filename -> int;
    }

(* See DirvishStats.mli *)
let default =
  {
    master_fn = "/etc/dirvish/master.conf";
    read =
      (fun fn ->
         let chn = open_in fn in
         let len = in_channel_length chn in
         let str = String.make len 'x' in
           really_input chn str 0 len;
           close_in chn;
           str);
    lstat = Unix.LargeFile.lstat;
    readdir = Sys.readdir;
    file_exists = Sys.file_exists;
    is_directory = Sys.is_directory;
    blocksize = fun _ -> 4096; (* TODO: find a way to determine block size. *)
  }

let lexbuf_init lexbuf fn = 
  lexbuf.Lexing.lex_start_p <- 
    {lexbuf.Lexing.lex_start_p with 
         Lexing.pos_fname = fn;
         Lexing.pos_lnum = 1;
         Lexing.pos_bol = 1};
  lexbuf.Lexing.lex_curr_p <- 
    {lexbuf.Lexing.lex_curr_p with 
         Lexing.pos_fname = fn;
         Lexing.pos_lnum = 1;
         Lexing.pos_bol = 1}

let lexbuf_error lexbuf exc =
  let pos = lexbuf.Lexing.lex_curr_p in
    match exc with 
      | Parsing.Parse_error ->
          failwith 
            (Printf.sprintf
               "Parsing error line %d, character %d, filename '%s'."
               pos.Lexing.pos_lnum
               (* TODO: bol doesn't seems updated, check if there is a pb in
                * OCaml stdlib. *)
               pos.Lexing.pos_bol
               pos.Lexing.pos_fname)
      | Failure str ->
          failwith 
            (Printf.sprintf
               "Error line %d, character %d, filename '%s': %s."
               pos.Lexing.pos_lnum
               pos.Lexing.pos_bol
               pos.Lexing.pos_fname
               str)
      | e ->
          raise e


(** Parse a .conf file. *)
let parse_conf ~ctxt fn =
  let lexbuf = 
    Lexing.from_string 
      (ctxt.read fn)
  in
    try 
      lexbuf_init lexbuf fn;
      DirvishStatsParser.main_conf 
        DirvishStatsLexer.token_conf
        lexbuf
    with e ->
      lexbuf_error lexbuf e

(** Parse a .hist file. *)
let parse_hist ~ctxt fn =
  let lexbuf = 
    Lexing.from_string 
      (ctxt.read fn)
  in
  let lst =
    try
      lexbuf_init lexbuf fn;
      DirvishStatsParser.main_hist
        DirvishStatsLexer.token_hist
        lexbuf
    with e ->
      lexbuf_error lexbuf e
  in
    List.rev lst

