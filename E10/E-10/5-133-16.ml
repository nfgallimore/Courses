let check (answer : float) =
	let soln t = t *. (exp (0.03 *. t) in
	let t = 1200. in print(soln t) 
	assert(1200.0 *. (exp (0.03 *. t)) = answer)
;;