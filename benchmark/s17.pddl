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
		(exists (?s - service)
			(forall (?x - client) (refer ?x ?s))
		)
	)

	(forall (?x - client ?s - service)
		(always (imply (refer ?x ?s) (is_run ?s)))
	)
))

)
