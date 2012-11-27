(define (problem p1)
(:domain ServiceReference)
(:objects
	s1 - service
	s2 - service
	s3 - service
	c1 - client
	c2 - client)

(:init
	(is_run s1)
	(refer c1 s1)
	(refer c2 s1)
   (is_run s2)
)

(:goal (and
	(forall (?x - client ?y - service)
		(imply (refer ?x ?y) (is_run ?y)))
))

(:constraints (and

	(sometime (not (is_run s1)))

	(forall (?s - service)
	   (at-most-once (not (is_run ?s)))
	)

))

)
