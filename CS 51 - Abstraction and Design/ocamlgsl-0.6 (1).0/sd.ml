let stddev l =
  let n, sx, sx2 =
    List.fold_left
      (fun (n, sx, sx2) x -> succ n, sx +. x, sx2 +. sqr x)
      (0, 0., 0.) l
  in
  sqrt ((sx2 -. sqr sx /. float n) /. float n)
 