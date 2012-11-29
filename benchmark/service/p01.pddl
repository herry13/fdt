(define (problem p1)
(:domain ServiceReference)
(:objects
	a - service
	b - service
	c - client)

(:init
	(is_run a)
	(refer c a))

(:goal (and (not (is_run a))
))

(:constraints (and
	(always (and (refer c b)))
))

)
