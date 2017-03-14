{
  open DirvishStatsParser
  exception Eof

  let strip str =
    let fst_non_blank = ref (String.length str) in
    let lst_non_blank = ref 0 in
      for i = 0 to (String.length str) - 1 do
        match str.[i] with
          | ' ' | '\t' ->
              ()
          | _ ->
              fst_non_blank := min !fst_non_blank i;
              lst_non_blank := i
      done;
        String.sub str !fst_non_blank (!lst_non_blank + 1 - !fst_non_blank)
}

let comment = '#' [^'\n']*

rule token_conf = parse
    [' ' '\t']
      { token_conf lexbuf }
  | "SET"
      { SET }
  | "UNSET"
      { UNSET }
  | "RESET"
      { RESET }
  | ['A'-'Z' 'a'-'z' '-']+ as lxm 
      { ID lxm }
  | ':'
      { VALUE(value_conf [] lexbuf) }
  | comment
      { token_conf lexbuf }
  | '\n'
      { Lexing.new_line lexbuf; token_conf lexbuf }
  | eof
      { EOF }
and value_conf acc = parse
  | ([^'\n''#']+ as lxm) comment? 
      { value_conf (strip lxm :: acc) lexbuf }
  | '\n' [' ' '\t']+  
      { Lexing.new_line lexbuf; value_conf acc lexbuf }
  | '\n' [' ' '\t']* comment
      { Lexing.new_line lexbuf; value_conf acc lexbuf }
  | '\n'
      { Lexing.new_line lexbuf; List.rev acc }
  | eof
      { List.rev acc }
and token_hist = parse
    '\t'                    { TAB }
  | '#' [^'\n']* '\n'       { Lexing.new_line lexbuf; token_hist lexbuf }
  | [^'\n''\t''#']+ as lxm  { VALUE_STRING lxm }
  | '\n'                    { Lexing.new_line lexbuf; EOL }
  | eof                     { EOF }
