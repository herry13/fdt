(define (problem p1)
(:domain ServiceReference)
(:objects
	s1 - service
	s2 - service
	pc1 - client
	pc2 - client)

(:init
	(is_run s1)
	(refer pc1 s1)
	(refer pc2 s1)
)

(:goal (and
	(not (is_run s1))
))

(:constraints (and
	(always
		(and
			(or
				(and (refer pc1 s1) (is_run s1))
				(and (refer pc1 s2) (is_run s2))
			)
			(or
				(and (refer pc2 s1) (is_run s1))
				(and (refer pc2 s2) (is_run s2))
			)
		)
	)
))

)
