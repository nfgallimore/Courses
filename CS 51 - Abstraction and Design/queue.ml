module type QUEUE =
  sig
    type 'a t    (* The type of queues *)
	    
    (* Thrown on dequeue or front of empty *)
    exception Empty

    val empty : 'a t
    val enqueue : 'a -> 'a t -> 'a t
    val is_empty : 'a t -> bool
    val front : 'a t -> 'a
    val dequeue : 'a t -> 'a t

  end
    
module ListQueue : QUEUE =
  struct
    type 'a t = 'a list
		   
    exception Empty
   
    let empty = []
    let enqueue x q = q @ [x]
    let is_empty = List.is_empty
    let front = function
      | x :: _ -> x
      | _ -> raise Empty
    let dequeue = function
      | _ :: q' -> q'
      | _ -> raise Empty  
  end

module L = ListQueue;;

(* Example Usage *)

let q = L.empty ;;
let q1 = L.enqueue 3 q ;;
let q2 = L.enqueue 4 q1 ;;
let q3 = L.enqueue 5 q2 ;;
L.front q3 ;;
L.front (L.dequeue q3) ;;
L.front (L.dequeue (L.dequeue q3)) ;;
L.is_empty (L.dequeue (L.dequeue (L.dequeue q3))) ;;
L.front (L.dequeue (L.dequeue (L.dequeue q3))) ;;

