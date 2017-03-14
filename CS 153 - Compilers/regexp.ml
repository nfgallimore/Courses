(* This file demonstrates how you might do matching of regular expressions
   in three different ways.
*)

(* explode a string into a list of characters *)
let explode(s:string) : char list = 
  let rec loop i cs = 
    if i < 0 then cs else 
      loop (i - 1) ((String.get s i)::cs)
  in 
    loop (String.length s - 1) []
;;

(********************************************************)
(* An interface for building and matching basic regular *) 
(* expressions                                          *)
(********************************************************)
module type REGEXP = 
sig
  type regexp

  (* matches only the empty list of chars *)
  val eps : regexp
  (* never matches *)
  val void : regexp
  (* [ch c] only matches the string ["c"] *)
  val ch : char -> regexp
  (* [r1 ++ r2] matches [s] if [r1] matches [s] or [r2] matches [s] *)
  val (++) : regexp -> regexp -> regexp
  (* [r1 $ r2] matches [s] if [s = s1 @ s2] and [r1] matches s1 and
     [r2] matches [s2]. *)
function plot_bigauss1(N)
  
  A = randn([2 2]);
  S = A*A'
  cS = chol(S);
  
  X = randn([2 N]);
  Y = cS'*X;
  
  plot(X(1,:), X(2,:), 'o');
  xlim([-6 6]);
  ylim([-6 6]);
 
  pause;

  hold on;
  plot([X(1,:) ; Y(1,:)], [X(2,:) ; Y(2,:)], 'k-');
  plot(Y(1,:), Y(2,:), 'rx');
  xlim([-6 6]);
  ylim([-6 6]);
  
  hold off;
  
  pause;

  plot(Y(1,:), Y(2,:), 'rx');
  xlim([-6 6]);
  ylim([-6 6]);
  
endfunction plot_bigauss1(N)
  
  A = randn([2 2]);
  S = A*A'
  cS = chol(S);
  
  X = randn([2 N]);
  Y = cS'*X;
  
  plot(X(1,:), X(2,:), 'o');
  xlim([-6 6]);
  ylim([-6 6]);
 
  pause;

  hold on;
  plot([X(1,:) ; Y(1,:)], [X(2,:) ; Y(2,:)], 'k-');
  plot(Y(1,:), Y(2,:), 'rx');
  xlim([-6 6]);
  ylim([-6 6]);
  
  hold off;
  
  pause;

  plot(Y(1,:), Y(2,:), 'rx');
  xlim([-6 6]);
  ylim([-6 6]);
  
endfunction plot_bigauss1(N)
  
  A = randn([2 2]);
  S = A*A'
  cS = chol(S);
  
  X = randn([2 N]);
  Y = cS'*X;
  
  plot(X(1,:), X(2,:), 'o');
  xlim([-6 6]);
  ylim([-6 6]);
 
  pause;

  hold on;
  plot([X(1,:) ; Y(1,:)], [X(2,:) ; Y(2,:)], 'k-');
  plot(Y(1,:), Y(2,:), 'rx');
  xlim([-6 6]);
  ylim([-6 6]);
  
  hold off;
  
  pause;

  plot(Y(1,:), Y(2,:), 'rx');
  xlim([-6 6]);
  ylim([-6 6]);
  
endfunction plot_bigauss1(N)
  
  A = randn([2 2]);
  S = A*A'
  cS = chol(S);
  
  X = randn([2 N]);
  Y = cS'*X;
  
  plot(X(1,:), X(2,:), 'o');
  xlim([-6 6]);
  ylim([-6 6]);
 
  pause;

  hold on;
  plot([X(1,:) ; Y(1,:)], [X(2,:) ; Y(2,:)], 'k-');
  plot(Y(1,:), Y(2,:), 'rx');
  xlim([-6 6]);
  ylim([-6 6]);
  
  hold off;
  
  pause;

  plot(Y(1,:), Y(2,:), 'rx');
  xlim([-6 6]);
  ylim([-6 6]);
  
endfunction plot_bigauss1(N)
  
  A = randn([2 2]);
  S = A*A'
  cS = chol(S);
  
  X = randn([2 N]);
  Y = cS'*X;
  
  plot(X(1,:), X(2,:), 'o');
  xlim([-6 6]);
  ylim([-6 6]);
 
  pause;

  hold on;
  plot([X(1,:) ; Y(1,:)], [X(2,:) ; Y(2,:)], 'k-');
  plot(Y(1,:), Y(2,:), 'rx');
  xlim([-6 6]);
  ylim([-6 6]);
  
  hold off;
  
  pause;

  plot(Y(1,:), Y(2,:), 'rx');
  xlim([-6 6]);
  ylim([-6 6]);
  
endfunction plot_bigauss1(N)
  
  A = randn([2 2]);
  S = A*A'
  cS = chol(S);
  
  X = randn([2 N]);
  Y = cS'*X;
  
  plot(X(1,:), X(2,:), 'o');
  xlim([-6 6]);
  ylim([-6 6]);
 
  pause;

  hold on;
  plot([X(1,:) ; Y(1,:)], [X(2,:) ; Y(2,:)], 'k-');
  plot(Y(1,:), Y(2,:), 'rx');
  xlim([-6 6]);
  ylim([-6 6]);
  
  hold off;
  
  pause;

  plot(Y(1,:), Y(2,:), 'rx');
  xlim([-6 6]);
  ylim([-6 6]);
  
endfunction plot_bigauss1(N)
  
  A = randn([2 2]);
  S = A*A'
  cS = chol(S);
  
  X = randn([2 N]);
  Y = cS'*X;
  
  plot(X(1,:), X(2,:), 'o');
  xlim([-6 6]);
  ylim([-6 6]);
 
  pause;

  hold on;
  plot([X(1,:) ; Y(1,:)], [X(2,:) ; Y(2,:)], 'k-');
  plot(Y(1,:), Y(2,:), 'rx');
  xlim([-6 6]);
  ylim([-6 6]);
  
  hold off;
  
  pause;

  plot(Y(1,:), Y(2,:), 'rx');
  xlim([-6 6]);
  ylim([-6 6]);
  
endfunction plot_bigauss1(N)
  
  A = randn([2 2]);
  S = A*A'
  cS = chol(S);
  
  X = randn([2 N]);
  Y = cS'*X;
  
  plot(X(1,:), X(2,:), 'o');
  xlim([-6 6]);
  ylim([-6 6]);
 
  pause;

  hold on;
  plot([X(1,:) ; Y(1,:)], [X(2,:) ; Y(2,:)], 'k-');
  plot(Y(1,:), Y(2,:), 'rx');
  xlim([-6 6]);
  ylim([-6 6]);
  
  hold off;
  
  pause;

  plot(Y(1,:), Y(2,:), 'rx');
  xlim([-6 6]);
  ylim([-6 6]);
  
endfunction plot_bigauss1(N)
  
  A = randn([2 2]);
  S = A*A'
  cS = chol(S);
  
  X = randn([2 N]);
  Y = cS'*X;
  
  plot(X(1,:), X(2,:), 'o');
  xlim([-6 6]);
  ylim([-6 6]);
 
  pause;

  hold on;
  plot([X(1,:) ; Y(1,:)], [X(2,:) ; Y(2,:)], 'k-');
  plot(Y(1,:), Y(2,:), 'rx');
  xlim([-6 6]);
  ylim([-6 6]);
  
  hold off;
  
  pause;

  plot(Y(1,:), Y(2,:), 'rx');
  xlim([-6 6]);
  ylim([-6 6]);
  
endfunction plot_bigauss1(N)
  
  A = randn([2 2]);
  S = A*A'
  cS = chol(S);
  
  X = randn([2 N]);
  Y = cS'*X;
  
  plot(X(1,:), X(2,:), 'o');
  xlim([-6 6]);
  ylim([-6 6]);
 
  pause;

  hold on;
  plot([X(1,:) ; Y(1,:)], [X(2,:) ; Y(2,:)], 'k-');
  plot(Y(1,:), Y(2,:), 'rx');
  xlim([-6 6]);
  ylim([-6 6]);
  
  hold off;
  
  pause;

  plot(Y(1,:), Y(2,:), 'rx');
  xlim([-6 6]);
  ylim([-6 6]);
  
end  val ($) : regexp -> regexp -> regexp
  (* [star r] matches [s] if [eps ++ r $ (star r)] matches [s] *)
  val star : regexp -> regexp

  val matches : regexp -> string -> bool
end ;;

(*********************************************************************)
(* Given an implementation of [REGEXP], builds an extended set of    *)
(* regular expressions, including forms for the tokens in our little *)
(* fragment of ML.                                                   *)
(*********************************************************************)
module ExtendRegexp(R : REGEXP) = 
struct
  include R

  (* options *)
  let opt (r:regexp) : regexp = eps ++ r

  (* one or more *)
  let plus (r:regexp) : regexp = r $ (star r)

  (* alts [r1;r2;...;rn] = r1 ++ r2 ++ ... ++ rn *)
  let alts (rs: regexp list) : regexp = 
    List.fold_right (++) rs void 

  (* cats [r1;r2;...;rn] = r1 $ r2 $ ... $ rn *)
  let cats (rs: regexp list) : regexp = 
    List.fold_right ($) rs eps

  (* converts an integer digit 0,1,2,...,9 into a character regexp
     ch '0', ch '1', ..., ch '9'. *)
  let digit2char(i:int) : regexp = 
    ch (char_of_int (i + (int_of_char '0')))

  (* matches any digit *)
  let digit = alts (List.map digit2char [0;1;2;3;4;5;6;7;8;9])

  (* matches any natural number *)
  let natural = plus digit

  (* matches any integer *)
  let integer = natural ++ ((ch '-') $ natural)

  (* Generate a list of numbers [i,i+1,...,stop] -- assumes i <= stop *)
  let rec gen(i:int)(stop:int) : int list = 
    if i > stop then [] else i::(gen (i+1) stop)

  (* Matches any lower case letter *)
  let lc_alpha =
    let chars = List.map char_of_int (gen (int_of_char 'a') (int_of_char 'z')) in
      alts (List.map ch chars)

  (* Matches any upper case letter *)
  let uc_alpha = 
    let chars = List.map char_of_int (gen (int_of_char 'A') (int_of_char 'Z')) in
      alts (List.map ch chars)

  (* Matches an identifier a la Ocaml:  must start with a lower case letter, 
     followed by 1 or more letters (upper or lower case), an underscore, or a digit. *)
  let identifier = 
    lc_alpha $ star (lc_alpha ++ uc_alpha ++ ch '_' ++ digit)

  (* keyword s only matches the string s *)
  let keyword(s:string) : regexp = cats (List.map ch (explode s))

  (* here are the regexps for our little ML language *)
  let token_regexps = [
    integer ; 
    identifier ; 
    keyword "let" ; 
    keyword "in" ;
    ch '+' ; 
    ch '*' ; 
    ch '-' ; 
    ch '/' ; 
    ch '(' ; 
    ch ')' ;
    ch '=' ; 
  ]

  (* so we can define a regexp to match any legal token *)
  let token = alts token_regexps ;;
  
  (* white space *)
  let ws = ch ' ' ++ ch '\n' ++ ch '\r' ++ ch '\t' 

  (* document -- zero or more tokens separated by one or more white spaces *)
  let doc = 
    cats [star ws ; 
          star (token $ (plus ws)) ;
          opt token ;
         ] ;;
end

(*************************************************************************)
(* Our first implementation of [REGEXP] with a relatively naive matcher. *)
(*************************************************************************)
module Regexp1 = 
struct
  (* we represent a regexp as a datatype *)
  type regexp = 
    | Char of char  
    | Eps           
    | Cat of regexp * regexp  
    | Void          
    | Alt of regexp * regexp
    | Star of regexp 

  let ch c = Char c
  let eps = Eps
  let void = Void
  let star r = Star r
  let (++) r1 r2 = Alt (r1,r2)
  let ($) r1 r2 = Cat (r1,r2)

  (* Now we define our matching procedure.  The function [rmatch] takes
     our regular expression [r] and list of characters [cs] to match.  It also 
     takes a continuation [k] which is a function that is intended to
     match the rest of the characters in the string, once we pull of the characters
     that match.  
     
     For instance, if [r] is [Cat(Char 'a', Char 'b')] and the string is ['a';'b']
     then we will first match [Char 'a'] against the ['a'], consuming it, and 
     continue by matching the [Char 'b'] against the ['b'] (and then continue
     with whatever else we are matching.
     
     At the top-level, we use a continuation that only matches the empty 
     list of characters.  This is called last, so we will succeed only if
     we match all of the characters in the list.

     Unfortunately, this approach has a bug in it.  Can you spot it?
  *)
  let rec match_partial (r:regexp) (cs:char list) (k: char list -> bool) : bool = 
    match r with 
      | Char c -> (match cs with 
                     | c' :: rest -> if c = c' then k rest else false
                     | _ -> false)
      | Eps -> k cs
      | Void -> false
      | Cat (r1, r2) -> match_partial r1 cs (fun cs' -> match_partial r2 cs' k)
      | Alt (r1, r2) -> match_partial r1 cs k || match_partial r2 cs k
      | Star r -> match_partial (eps ++ (r $ (star r))) cs k
  ;;
  
  let matches (r:regexp) (s:string) : bool = 
    match_partial r (explode s) (fun cs -> 
                                   match cs with 
                                     | [] -> true
                                     | _ -> false)

end

(* Now extend [Regexp1] using our functor. *)
module ExtendedRegexp1 = ExtendRegexp(Regexp1) 


(***************************************************************************)
(* Our second implementation of [REGEXP].  Here, we avoid a data structure *)
(* all together and represent a [regexp] as the corresponding matching     *)
(* function directly.                                                      *)
(***************************************************************************)
module Regexp2 = 
struct
  type regexp = char list -> (char list -> bool) -> bool

  let eps : regexp = fun cs k -> k cs 

  let void : regexp = fun cs k -> false 

  let ch (c:char) : regexp = 
    fun cs k -> (match cs with 
                   | c' :: rest -> if c = c' then k rest else false
                   | _ -> false)

  let (++) (r1:regexp) (r2:regexp) : regexp = 
      fun cs k -> (r1 cs k) || (r2 cs k)

  let ($) (r1:regexp) (r2:regexp) : regexp = 
    fun cs k -> r1 cs (fun cs' -> r2 cs' k)

  let rec star (r:regexp) : regexp = 
      fun cs k -> (eps ++ (r $ (star r))) cs k

  let matches (r:regexp) (s:string) : bool = 
    r (explode s) (fun cs -> 
                     match cs with 
                       | [] -> true
                       | _ -> false)
end

(* Extend [Regexp2] using our functor. *)
module ExtendedRegexp2 = ExtendRegexp(Regexp2) 

(*************************************************************)
(* Yet another implementation that is quite similar to the   *)
(* last one, except that instead of using a continuation, we *)
(* accumulate a set of lists of unconsumed characters.       *)
(*************************************************************)
module Regexp3 = 
struct
  type regexp = char list -> (char list) list

  let eps : regexp = fun cs -> [cs]
  let void : regexp = fun cs -> []
  let ch (c:char) : regexp = 
    fun cs -> (match cs with
                 | c'::rest -> if c = c' then [rest] else []
                 | _ -> [])

  let union (s1:char list list) (s2:char list list) : char list list = 
    List.fold_left (fun s cs -> if List.mem cs s then s else cs::s) s2 s1

  let (++) (r1:regexp) (r2:regexp) : regexp = 
    fun cs -> union (r1 cs) (r2 cs)

  let ($) (r1:regexp) (r2:regexp) : regexp = 
    fun cs -> 
      let s = r1 cs in 
        List.fold_left (fun s' cs' -> union (r2 cs') s') [] s

  let rec star (r:regexp) : regexp = fun cs -> (eps ++ (r $ star r)) cs

  let matches (r:regexp) (s:string) = 
    List.mem [] (r (explode s))
end

(* Extend [Regexp3] using our functor. *)
module ExtendedRegexp3 = ExtendRegexp(Regexp3)

(********************************************************************)
(* Our final approach for implementing [REGEXP].  This time, we use *)
(* the derivative technique sketched in the class notes.            *)
(********************************************************************)
module Regexp4 = 
struct
  (* a definition for regular expressions *)
  type regexp = 
    | Char of char  
    | Eps           
    | Cat of regexp * regexp 
    | Void          
    | Alt of regexp * regexp 
    | Star of regexp 
  ;;

  let ch = fun c -> Char c
  let eps = Eps
  let void = Void

  (* We now define some regexp constructors that optimize the
     regular expressions.  This will be useful in our derivative
     routine below... *)

  (* an optimized cat constructor *)
  let ($) (r1:regexp) (r2:regexp) : regexp = 
    match r1, r2 with 
      | Eps, _ -> r2
      | _, Eps -> r1
      | Void, _ -> Void
      | _, Void -> Void
      | _, _ -> Cat (r1, r2)

  (* an optimized alt constructor *)
  let (++) (r1:regexp) (r2:regexp) : regexp = 
    match r1, r2 with 
      | Void, _ -> r2
      | _, Void -> r1
      | _, _ -> if r1 = r2 then r1 else Alt (r1, r2)

  (* an optimized star *)
  let star (r:regexp) : regexp = 
    match r with 
      | Star r' -> Star r'
      | Void -> Void
      | Eps -> Eps
    | _ -> Star r

  (* returns Eps if r accepts [] and otherwise, returns Void. *)
  let rec null(r:regexp) : regexp = 
    match r with 
      | Char _ -> Void
      | Eps -> Eps
      | Cat (r1, r2) -> (null r1) $ (null r2)
      | Void