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
	(sometime-before (refer c1 s1) (refer mc1 s1))
	(sometime-before (refer c2 s1) (refer mc1 s1))
))

)
