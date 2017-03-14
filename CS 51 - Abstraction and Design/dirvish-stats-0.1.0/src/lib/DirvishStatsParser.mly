%token <string list> VALUE
%token <string> VALUE_STRING
%token <string> ID
%token EOL SET UNSET RESET EOF TAB
%start main_conf
%start main_hist
%type <(string * (string list)) list> main_conf
%type <string list list> main_hist
%%
main_conf:
    lines_conf EOF      { List.rev (List.flatten $1) }
;
lines_conf:
                         { [] }                   
  | lines_conf line_conf { $2 :: $1 }
;
line_conf:
    ID VALUE                { [($1, $2)] }
  | SET id_list             { List.rev_map (fun id -> id, ["1"]) $2 }
  | UNSET id_list           { List.rev_map (fun id -> id, ["0"]) $2 }
  | RESET id_list           { List.rev_map (fun id -> id, []) $2 }
;
id_list:
               { [] }
  | id_list ID { $2 :: $1 }
;
main_hist:
  { [] }
  | main_hist line_hist { $2 :: $1 }
;
line_hist:
    expr_hist EOF { List.rev $1 }
  | expr_hist EOL { List.rev $1 }
;
expr_hist:
  | expr_hist TAB VALUE_STRING { $3 :: $1  }
  | VALUE_STRING               { [$1] }
;
