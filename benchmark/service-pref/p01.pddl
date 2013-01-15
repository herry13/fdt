(define (problem p1)
(:domain ServiceReference)
(:objects
	a - service
	b - service
	c1 - client
	c2 - client)

(:init
	(is_run a)
	(refer c1 a)
	(refer c2 a)
   (is_run b)
)

(:goal (and
	(not (is_run a))
))

(:constraints (and
	(forall (?x - client ?y - service)
		(preference p01
			(always (imply (refer ?x ?y) (is_run ?y)))))

   ;(forall (?s - service)
	;	(preference p02
	;		(sometime (not (is_run ?s)))))
))

(:metric minimize (+ (* 1 (is-violated p01))
                     ;(* 2 (is-violated p02))
))

)
