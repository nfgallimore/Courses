(* This file demonstrates how you might not only do matching, but
   extracting information...i.e., lexing. *)

(**************************************)
(* Some utilies                       *)
(**************************************)

(* explode a string into a list of characters *)
let explode(s:string) : char list = 
  let rec loop i cs = 
    if i < 0 then cs else 
      loop (i - 1) ((String.get s i)::cs)
  in 
    loop (String.length s - 1) []

(* collapse a list of characters into a string *)
let implode(cs:char list) : string = 
  let buf = String.create (List.length cs) in 
  let rec loop i cs = 
    match cs with 
      | [] -> buf
      | c::cs -> String.set buf i c ; loop (i+1) cs
  in 
    loop 0 cs

(* just a wrapper for consing a pair of values *)
let cons(x,y) = x::y 

(*******************************************)
(* Our interface for the basic lexing      *)
(*******************************************)
module type LEX = 
sig
  (* an ['a regexp] matches a string and returns an ['a] value *)
  type 'a regexp 

  (* [ch c] matches ["c"] and returns ['c'] *)
  val ch : char -> char regexp 

  (* [eps] matches [""] and returns [()] *)
  val eps : unit regexp

  (* [void] never matches (so never returns anything) *)
  val void : 'a regexp

  (* [r1 ++ r2] matches [s] and returns [v] if [r1] matches [s] and
     returns [v], or else [r2] matches [s] and returns [v]. *)
  val (++) : 'a regexp -> 'a regexp -> 'a regexp

  (* [r1 $ r2] matches [s] and returns [(v1,v2)] if [s = s1 ^ s2]
     and [r1] matches [s1] and returns [v1], and [r2] matches [s2]
     and returns [v2]. *)
  val ($) : 'a regexp -> 'b regexp -> ('a * 'b) regexp

  (* [star r] matches [s] and returns the list [vs] if either
     [s = ""] and [vs = []], or else [s = s1 ^ s2] and [vs = v1::v2]
     and [r] matchs s1 and returns v1, and [star r] matches [s2] and
     returns [v2]. *)
  val star : 'a regexp -> ('a list) regexp

  (* [r % f] matches [s] and returns [v] if [r] matches [s] and returns
     [w], and [v = f(w)]. *)
  val (%) : 'a regexp -> ('a -> 'b) -> 'b regexp

  (* [lex r s] tries to match [s] against [r] and returns the list
     of all values that we can get out of the match. *)
  val lex : 'a regexp -> string -> 'a list
end

(****************************************************)
(* A functor for extending a basic [LEX] module.    *)
(****************************************************)
module ExtendLex(L : LEX) = 
struct
  include L

  (* matches one or more *)
  let plus(r: 'a regexp) : ('a list) regexp = 
    (r $ (star r)) % cons 

  (* when we want to just return a value and 
     ignore the values we get out of r. *)
  let (%%) (r:'a regexp) (v:'b) : 'b regexp = 
    r % (fun _ -> v) 
  
  (* optional match *)
  let opt(r:'a regexp) : 'a option regexp = 
    (r % (fun x -> Some x)) ++ (eps %% None);;
  
  let alts (rs: ('a regexp) list) : 'a regexp = 
    List.fold_right (++) rs void 
  
  let cats (rs: ('a regexp) list) : ('a list) regexp = 
    List.fold_right (fun r1 r2 -> (r1 $ r2) % cons) rs 
      (eps % (fun _ -> [])) 
  
  (* Matches any digit *)
  let digit : char regexp = 
    alts (List.map (fun i -> ch (char_of_int (i + (int_of_char '0'))))
            [0;1;2;3;4;5;6;7;8;9])
  
  (* Matches 1 or more digits *)
  let natural : int regexp = 
    (plus digit) %
      (List.fold_left (fun a c -> a*10 + (int_of_char c) - (int_of_char '0')) 0)
      
  (* Matches a natural or a natural with a negative sign in front of it *)
  let integer : int regexp = 
    natural ++ (((ch '-') $ natural) % (fun (_,n) -> -n)) 
  
  (* Generate a list of numbers [i,i+1,...,stop] -- assumes i <= stop *)
  let rec gen(i:int)(stop:int) : int list = 
    if i > stop then [] else i::(gen (i+1) stop)
  
  (* Matches any lower case letter *)
  let lc_alpha : char regexp =
    let chars = List.map char_of_int (gen (int_of_char 'a') (int_of_char 'z')) in
      alts (List.map ch chars)
  
  (* Matches any upper case letter *)
  let uc_alpha : char regexp = 
    let chars = List.map char_of_int (gen (int_of_char 'A') (int_of_char 'Z')) in
      alts (List.map ch chars)
  
  (* Matches an identifier a la Ocaml:  must start with a lower case letter, 
   followed by 1 or more letters (upper or lower case), an underscore, or a digit. *)
  let identifier : string regexp = 
    (lc_alpha $ (star (alts [lc_alpha; uc_alpha; ch '_'; digit]))) %
      (fun (c,s) -> implode (c::s))
  
  type token = 
      INT of int | ID of string | LET | IN | PLUS | TIMES | MINUS | DIV | LPAREN
    | RPAREN | EQ ;;

  let keywords = [ ("let",LET) ; ("in",IN) ]
  
  (* here are the regexps for our little ML language *)
  let token_regexps = [
    integer % (fun i -> INT i) ; 
    identifier % (fun s -> 
                    try List.assoc s keywords
                    with Not_found -> ID s) ; 
    (ch '+') %% PLUS ; 
    (ch '*') %% TIMES ; 
    (ch '-') %% MINUS ; 
    (ch '/') %% DIV ; 
    (ch '(') %% LPAREN ; 
    (ch ')') %% RPAREN ;
    (ch '=') %% EQ ; 
  ];;

  (* so we can define a regexp to match any legal token *)
  let token = alts token_regexps ;;
  
  (* white space *)
  let ws = (plus (alts [ch ' ' ; ch '\n' ; ch '\r' ; ch '\t'])) %% () ;;

  (* document -- zero or more tokens separated by one or more white spaces *)
  let doc : token list regexp = 
    ((opt ws) $ ((star ((token $ ws) % fst)) $ (opt token))) % 
      (fun p -> let (_,(ts,topt)) = p in 
         match topt with 
           | None -> ts
           | Some t -> ts @ [t])
  
end

module Lex = 
struct
  (* This definition is similar to the matcher we had when
     we returned a set of lists of unconsumed characters.
     The only difference is that here, an ['a regexp] will
     return not only unconsumed characters, but also an ['a]
     value. 

     The only problem with this is that it will loop forever
     on certain regular expressions (e.g., (star eps)).
  *)
  type 'a regexp = char list -> ('a * char list) list 

  let ch(c:char) : char regexp = 
    function 
      | c'::rest -> if c = c' then [(c,rest)] else []
      | _ -> []
  
  let eps : unit regexp = fun s -> [((), s)] 

  let void : 'a regexp = fun s -> [] 

  let (++)(r1 : 'a regexp) (r2: 'a regexp) : 'a regexp = 
    fun s -> (r1 s) @ (r2 s) 

  let ($)(r1: 'a regexp) (r2:'b regexp) : ('a * 'b) regexp = 
  fun s -> 
    List.fold_right 
      (function (v1,s1) -> fun res -> 
         (List.fold_right 
            (function (v2,s2) -> 
               fun res -> ((v1,v2),s2)::res) (r2 s1) res)) (r1 s) [] 

  let (%) (r:'a regexp) (f:'a -> 'b) : 'b regexp = 
    fun s -> 
      List.map (function (v,s') -> (f v,s')) (r s) 

  let rec star(r:'a regexp) : ('a list) regexp = 
    fun s -> (((r $ (star r)) % cons) ++ (eps % (fun _ -> []))) s 

  let lex (r: 'a regexp) (s:string) : 'a list = 
    let results = r (explode s) in
    let uses_all = List.filter (fun p -> snd p = []) results in 
      List.map fst uses_all 
end

module ExtendedLex = ExtendLex(Lex)

(****************************************************)
(* An alternative lexer based on derivatives.  This *)
(* one doesn't have the looping problem, but is     *)
(* generally slower.                                *)
(****************************************************)
module Lex2 = 
struct

  (* This is a special type of datatype known as a 
     "generalized algebraic datatype" or GADT.  The
     key feature is that it allows us to index the
     type of a data-constructor in a more refined way
     than just being parametric.  We need that here
     in order to track the types of the values returned
     by the regexp. *)
  type _ regexp = 
    | Char : char -> char regexp
    | Eps : unit regexp 
    | Void : 'a regexp
    | Cat : 'a regexp * 'b regexp -> ('a * 'b) regexp
    | Alt : 'a regexp * 'a regexp -> 'a regexp
    | Star : 'a regexp -> ('a list) regexp
    | Map : 'a regexp * ('a->'b) -> 'b regexp

  let ch (c:char) : char regexp = Char c
  let eps : unit regexp = Eps
  let void : 'a regexp = Void

  let (%) (r:'a regexp) (f:'a->'b) : 'b regexp = 
    match r with 
      | Void -> Void
      | Map(r,g) -> Map(r,fun x -> f(g x))
      | r -> Map (r,f)

  let (++) (r1:'a regexp) (r2:'a regexp) : 'a regexp = 
    match r1, r2 with 
      | Void, r2 -> r2
      | r1, Void -> r1
      | r1, r2 -> Alt(r1,r2)

  let rec ($) : type a b. (a regexp) -> (b regexp) -> (a * b) regexp = 
    fun r1 r2 -> 
      match r1, r2 with 
        | Void, _ -> Void
        | _, Void -> Void
        | Eps, r -> r % (fun x -> ((),x))
        | r, Eps -> r % (fun x -> (x,()))
        | Map (r1,f), r2 -> (r1 $ r2) % (function (x,y) -> (f x,y))
        | r1, Map (r2,f) -> (r1 $ r2) % (function (x,y) -> (x,f y))
        | r1, r2 -> Cat (r1,r2)

  let star (r: 'a regexp) : 'a list regexp = Star r

  (* [extract_null r] returns all of the values associated with the empty
     string via r. *)
  let rec extract_null : type s. s regexp -> s list = 
   function 
     | Char c -> []
     | Eps -> [()]
     | Void -> []
     | Alt (r1,r2) -> (extract_null r1) @ (extract_null r2)
     | Cat (r1,r2) -> 
         let v1s = extract_null r1 in 
         let v2s = extract_null r2 in 
           List.flatten (List.map (fun x -> List.map (fun y -> (x,y)) v2s) v1s)
     | Star r -> [[]]
     | Map (r,f) -> List.map f (extract_null r)

  (* [null r] returns a regular expression [r'] such that 
     [r'] accepts string [s] and produces value [v] only when
     [r] accepts [s] and produces [v], and [s] is the empty 
     string. *)
  let rec null : type s . s regexp -> s regexp = 
    function 
      | Char c -> void
      | Eps -> eps
      | Void -> void
      | Alt (r1,r2) -> (null r1) ++ (null r2)
      | Map (r,f) -> (null r) % f
      | Cat (r1,r2) -> (null r1) $ (null r2)
      | Star r -> eps % (fun x -> [])

  (* [deriv r c] produces a regexp [r'] such that [r'] accepts
     [s] and produces [v] only when [r] accepts [c::s] and produces
     [v]. *)
  let rec deriv : type s . s regexp -> char -> s regexp = 
    fun r c -> 
      match r with 
        | Char c' -> if c = c' then eps % (fun _ -> c) else void
        | Eps -> void
        | Void -> void
        | Alt (r1,r2) -> (deriv r1 c) ++ (deriv r2 c)
        | Map (r,f) -> (deriv r c) % f
        | Star r -> ((deriv r c) $ (star r)) % cons
        | Cat (r1,r2) -> 
            ((deriv r1 c) $ r2) ++ ((null r1) $ (deriv r2 c))

  (* [derivs r s] generalizes [deriv] from a single character to
     a list of characters. *)
  let rec derivs (r:'a regexp) (cs:char list) : 'a regexp = 
    List.fold_left (fun r c -> deriv r c) r cs

  let lex (r:'a regexp) (s:string) : 'a list = 
    extract_null (derivs r (explode s))
end

module ExtendedLex2 = ExtendLex(Lex2)

