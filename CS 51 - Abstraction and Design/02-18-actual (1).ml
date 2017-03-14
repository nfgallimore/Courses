(* Lecture 7 (02/18): abstract data types *)

(*

* The reality of development

  - We rarely know the *right* algorithms and data structures when we
    start

  - We often have to go back and change things:

    - Requirements change

    - Performance is unpredictable

* The reality of development

  CHANGE.

* How can we prepare for change?

  - Use a high-level language

  - Reuse code

  - Data and algorithm *abstraction*

* Data abstraction

  - Don't code in terms of concrete representation

  - Design using high-level abstractions that fit the problem

  - Use a well-defined interface

* Example

  - A scalable search engine: maps words to URLs where they appear
    and lets us query

  - What data structures do we need?

*)

open Core.Std

(* Represent URLs as strings *)
type url = string

(* Queries include single words, conjuctions, and disjunctions *)
type query = Word of string
           | And of query * query
           | Or of query * query

(* To intersect two sorted lists, yielding a sorted list *)
let rec intersect_lists (xs : 'a list) (ys : 'a list) : 'a list =
  match xs, ys with
  | x :: xs', y :: ys' ->
     if x < y then intersect_lists xs' ys
     else if y < x then intersect_lists xs ys'
     else x :: intersect_lists xs' ys'
  | _ -> []

assert( intersect_lists [] [1; 2; 3] = [] )
assert( intersect_lists [1; 2; 3] [] = [] )
assert( intersect_lists [1; 3; 5] [2; 4; 6] = [] )
assert( intersect_lists [1; 3; 5] [1; 2; 3; 4] = [1; 3] )

(* To union two sorted lists, yielding a sorted list *)
let rec union_lists (xs : 'a list) (ys : 'a list) : 'a list =
  match xs, ys with
  | [], _ -> ys
  | _, [] -> xs
  | x :: xs', y :: ys' ->
     if x < y then x :: union_lists xs' ys
     else if y < x then y :: union_lists xs ys'
     else x :: union_lists xs' ys'

assert( union_lists [] [1; 2; 3] = [1; 2; 3] )
assert( union_lists [1; 2; 3] [] = [1; 2; 3] )
assert( union_lists [1; 3; 5] [2; 4; 6] = [1; 2; 3; 4; 5; 6] )
assert( union_lists [1; 3; 5] [1; 2; 3; 4] = [1; 2; 3; 4; 5] )


(* Run the given query against the given search index *)
let rec eval (q : query) (ix : (string * url list) list) : url list =
  match q with
  | Word s -> (match List.find ix ~f:(fun (key, _) -> key = s) with
               | None -> []
               | Some (_, urls) -> urls)
  | And(q1, q2) -> intersect_lists (eval q1 ix) (eval q2 ix)
  | Or(q1, q2) -> union_lists (eval q1 ix) (eval q2 ix)

(* Run the given query against the given search index *)
let rec eval (q : query) (ix : (string, url list) Hashtbl.t) : url list =
  match q with
  | Word s -> Option.value ~default:[] (Hashtbl.find ix s)
  | And(q1, q2) -> intersect_lists (eval q1 ix) (eval q2 ix)
  | Or(q1, q2) -> union_lists (eval q1 ix) (eval q2 ix)

(* ... *)

module UrlSet = Set.Make(String)
module Dict = Map.Make(String)

(* Run the given query against the given search index *)
let rec eval (q : query) (ix : UrlSet.t Dict.t) : UrlSet.t =
  match q with
  | Word s -> Option.value ~default:UrlSet.empty (Dict.find ix s)
  | And(q1, q2) -> UrlSet.inter (eval q1 ix) (eval q2 ix)
  | Or(q1, q2) -> UrlSet.union (eval q1 ix) (eval q2 ix)


(** Stacks *)

(*
   {} -- the empty stack

   push 4 {}  =  { 4 }
   push 3 { 4 }  =  { 3 4 }
   push 2 { 3 4 } = { 2 3 4 }
   push 6 { 3 4 } = { 6 3 4 }

   is_empty {}  =  true
   is_empty { 3 }  =  false

   top { 3 4 }  =  3
   top { 2 3 4 } = 2
   top { }  =  ERROR!

   pop { 2 3 4 }  =  { 3 4 }
   pop { 4 }  =  { }
   pop { }  =  ERROR!
 *)

(* A signature for int stacks *)
module type INT_STACK =
  sig
    (* The type of stacks *)
    type t

    (* Thrown when we try to top or pop an empty stack *)
    exception Empty

    (* The empty stack [constructor] *)
    val empty : t

    (* Is a stack empty? [observer] *)
    val is_empty : t -> bool

    (* Push an int onto a stack [constructor] *)
    val push : int -> t -> t

    (* Get the top of the stack [observer] *)
    (* throws Empty *)
    val top : t -> int

    (* Get the rest of the stack after the top is popped [observer] *)
    (* throws Empty *)
    val pop : t -> t
  end

module ListIntStack : INT_STACK =
  struct
    type t = int list
    (* Represent the stack { z1 ... zk } as the list [z1; ...; zk] *)

    exception Empty

    let empty = []

    let is_empty = List.is_empty

    let push z stack = z :: stack

    let top stack =
      match stack with
      | z :: _ -> z
      | _ -> raise Empty

    let pop stack =
      match stack with
      | _ :: stack' -> stack'
      | _ -> raise Empty
  end

module type UNSIGNED_BIGNUM =
  sig
    (* This the abstract type of unsigned bignums (naturals) *)
    type t

    val from_int : int -> t
    val to_int : t -> int
    val plus : t -> t -> t
    val monus : t -> t -> t
    val times : t -> t -> t
    val le : t -> t -> bool
  end

module UnaryBignum : UNSIGNED_BIGNUM =
  struct
    (* Peano numerals *)
    type t = Zero
           | Succ of t

    let rec from_int n =
      if n = 0 then Zero
      else Succ (from_int (n - 1))

    let rec to_int bn =
      match bn with
      | Zero -> 0
      | Succ bn' -> to_int bn' + 1

    let rec plus bn1 bn2 =
      match bn1 with
      | Zero -> bn2
      | Succ bn1' -> Succ (plus bn1' bn2)

    let monus _ _ = failwith "not implemented"
    let times _ _ = failwith "not implemented"
    let le _ _ = failwith "not implemented"
  end

module RadixBignum : UNSIGNED_BIGNUM =
  struct
    let base = 1000
    type t = int list

    let to_int _ = failwith "unimplemented"
    let from_int _ = failwith "unimplemented"
    let plus _ _ = failwith "unimplemented"
    let monus _ _ = failwith "unimplemented"
    let times _ _ = failwith "unimplemented"
    let le _ _ = failwith "unimplemented"
  end

module Bignum = RadixBignum

(*
let plus_three (x : int) : int =
  Bignum.to_int (Bignum.plus (Bignum.Succ (Bignum.Succ (Bignum.Succ Bignum.Zero)))
                             (Bignum.from_int x))
 *)

let silly_plus (x : int) (y : int) : int =
  Bignum.to_int (Bignum.plus (Bignum.from_int x)
                             (Bignum.from_int y))
