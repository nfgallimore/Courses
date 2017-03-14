(*** CS 51 Problem Set 1 ***)
(*** January 31, 2014 ***)
(*** Nicholas Gallimore ***)

(* Sorry for taking so long on this, 
this version is a little sloppy because I'm trying to turn it in before 5:00, 
I'm debating whether or not it's worth it to take a THIRD late day to beautify this a bit and finish 2g. 
So please keep this in mind before dinging me on the comments *)

open Core.Std

let prob1a : string = let greet y = "Hello " ^ y in greet "World!";;

let prob1b : 'a list = [Some 4; Some 2; None; Some 3];;

let prob1c : 'a * bool = ((None, Some 42.0), true);;

(* The expression can't type check because it can return either a string or an int.
 We must make it of type ('a option * int option). *)
let prob1d : 'a list = [("CS", 51); ("CS", 50)];;

(* The expression was trying to compare a float to an int, which is invalid in ocaml. *)
let prob1e : float =
  let compare (x,y) = x < y in
  if compare (4., 3.9) then 4. else 2.;;


(*>* Problem 1f *>*)
let prob1f : (string * int) list =
  [("January", 0); ("February", 1); ("March", 0); ("April", 0);
   ("May", 0); ("June", 1); ("July", 0); ("August", 0);
   ("September", 3); ("October", 1); ("November", 2); ("December", 3)] ;;





(* Problem 2a *)

(* determines if list is in sorted order or reversed *)
let rec reversed lst : bool = 
  match lst with
  | [] | [_] -> true
  | x :: y :: tl ->
     if x < y then false 
     else reversed (y::tl)

let () = assert ((reversed [1; 2; 3]) = false);;
let () = assert ((reversed [-1; 2; 3; 100]) = false) ;;
let () = assert ((reversed [5; 4; 10]) = false) ;;
let () = assert ((reversed [0; -1; -2; -3]) = true) ;;
let () = assert ((reversed []) = true) ;;
let () = assert ((reversed [3; 2; -42; -100]) = true) ;;
let () = assert ((reversed [0]) = true) ;;




(* Problem 2b *)

(* inserts an element into a list *)
let rec insert element = function
  | [] -> [element]
  | head :: tail -> 
      if element < head then element :: head :: tail 
      else head :: insert element tail;;

(* sorts a list *)
let rec sort = function
  | [] -> []
  | x :: l -> insert x (sort l);;

(* appends a list to another list *)
let rec append l1 l2 =
  match l1 with
    [] -> l2
  | (a::l) -> a::append l l2;;

(* merges two lists, in sorted order *)
let merge l1 l2 =
  let list = append l1 l2 in sort list;;

let () = assert ((merge [1;2;3] [4;5;6;7]) = [1;2;3;4;5;6;7]);;
let () = assert ((merge [4;5;6;7] [1;2;3]) = [1;2;3;4;5;6;7]);;
let () = assert ((merge [4;5;6;7] [1;2;3]) = [1;2;3;4;5;6;7]);;
let () = assert ((merge [2;2;2;2] [1;2;3]) = [1;2;2;2;2;2;3]);;
let () = assert ((merge [1;2] [1;2]) = [1;1;2;2]);;
let () = assert ((merge [-1;2;3;100] [-1;5;1001]) = [-1;-1;2;3;5;100;1001]);;
let () = assert ((merge [] []) = []);;
let () = assert ((merge [1] []) = [1]);;
let () = assert ((merge [] [-1]) = [-1]);;
let () = assert ((merge [1] [-1]) = [-1;1]);;




(*>* Problem 2c *>*)

(* Unzips a list *)
let rec unzip list : int list * int list =
  match list with
  | [] -> ([], [])
  | (x, y) :: tail ->
     let (xs, ys) = unzip tail in (x::xs, y::ys);;

assert( unzip [(1, 2); (3, 4); (5, 6)] = ([1; 3; 5], [2; 4; 6]) )
assert( unzip [] = ([], []))





(*>* Problem 2d *>*)
let square (x : float) : float = x *. x

let rec sum lst : float =
  match lst with
  | [] -> 0.
  | hd :: tl -> hd +. sum tl
 
(* Calculates the distance from the mean of each
 element in a float list *)
let rec stdev lst m : float =
  match lst with
  | [] -> 0.
  | hd :: tl -> square (hd -. m) +. stdev tl m

(* Determines length of list *)
let rec length lst : float =
  match lst with
  | [] -> 0.
  | _ :: tl -> 1. +. length tl

(* Calculates mean *)
let mean lst : float =
  sum lst /. length lst

(* Squares the input *)
let square x = x *. x

(* Determines the variance, note this doesn't return a float option yet :(  *)
let variance lst : float =
  (1. /. ((length lst) -. 1.)) *.  stdev lst (mean lst);;

assert( variance [1.0; 2.0; 3.0; 4.0; 5.0] = 2.5 )
assert( variance [1.0] = 0. )






(*>* Problem 2e *>*)

(* Gets number of divisors n has *)
let divisors n =
  if n <= 0 then 0
  else 
    let rec sum d =
      if d = 0 then 0
	else if (n mod d) = 0 then 1 + sum (d-1)
	else sum (d-1)
      in sum (n-1);;

(* Determines if n has less than m divisors *)
let few_divisors n m : bool =
  if divisors n < m then true else false

assert( few_divisors 17 3 = true)






(*>* Problem 2f *>*)

(* Formats a string list by a separator value *)
let rec concat_list (sep : string) (lst : string list) : string =
  match lst with
  | [] -> ""
  | hd :: [] -> hd
  | hd :: tl -> (hd ^ sep) ^ (concat_list sep tl)

assert( concat_list ", " ["Greg"; "Anna"; "David"] = "Greg, Anna, David" )
assert( concat_list "..." ["Moo"; "Baaa"; "Quack"] = "Moo...Baaa...Quack" )
assert( concat_list ", " [] = "" )
assert( concat_list ", " ["Moo"] = "Moo" )



(*>* Problem 2g *>*)

(* removes all y elements from a list *)
let rec remelm y = function
  | [] -> []
  | x::xs -> if x = y then remelm y xs else x::(remelm y xs)

(* Aux function to help encode single char's *)
let encode_char (ch : char) (cnt : int) : (int * char) =
  (cnt, ch)

(* Searches a list for the number occurences of given ch *)
let rec freq (ch : char )(lst : char list)(cnt : int) =
  match lst with
  | [] -> 0
  | hd :: [] -> if hd = ch then (cnt+1) else cnt
  | hd :: tl -> if hd = ch then freq ch tl (cnt + 1)
		else freq ch tl cnt

(* Compresses a char list *)
let rec to_run_length (lst : char list) : ((int * char) list) =
  match lst with
  | [] -> []
  | hd :: [] -> encode_char hd 1 :: []
  | hd :: _ -> encode_char hd (freq hd lst 0) ::
		  (to_run_length (remelm hd lst))




(*>* Problem 3 *>*)

(* Challenge!

 * permutations lst should return a list containing every
 * permutation of lst. For example, one correct answer to
 * permutations [1; 2; 3] is
 * [[1; 2; 3]; [2; 1; 3]; [2; 3; 1]; [1; 3; 2]; [3; 1; 2]; [3; 2; 1]].

 * It doesn't matter what order the permutations appear in the returned list.
 * Note that if the input list is of length n then the answer should be of
 * length n!.

 * Hint:
 * One way to do this is to write an auxiliary function,
 * interleave : int -> int list -> int list list,
 * that yields all interleavings of its first argument into its second:
 * interleave 1 [2;3] = [ [1;2;3]; [2;1;3]; [2;3;1] ].
 * You may also find occasion for the library functions
 * List.map and List.concat. *)

(* The type signature for permuations is: *)
(* permutations : int list -> int list list *)
