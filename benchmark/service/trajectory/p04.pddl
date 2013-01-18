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
		(always (imply (refer ?x ?y) (is_run ?y))))

   (sometime (not (is_run b)))

))

)
