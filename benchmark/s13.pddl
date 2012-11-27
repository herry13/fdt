(define (problem p1)
(:domain ServiceReference)
(:objects
	s1 - service
	c1 - secondary_client
	c2 - secondary_client
	mc1 - primary_client
)

(:init
	(dummy)
)

(:goal (and
	(forall (?c - client)
		(exists (?s - service) (refer ?c ?s)))
))

(:constraints (and
	(forall (?c - secondary_client)
		(sometime-before (refer ?c s1) (refer mc1 s1))
	)
))

)
