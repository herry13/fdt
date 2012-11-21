(define (problem p1)
(:domain ServiceReference)
(:objects
	a - service
	b - service
	c1 - client
	c2 - client)

(:init
	(satisfied-global)
	(is_run a)
	(refer c1 a)
	(refer c2 a))

(:goal (and (not (is_run a))
	(refer c2 b)
	(refer c1 b)
	(satisfied-global)))

;(:constraints (and
;	(forall (?x - client ?y - service)
;		(always (imply (refer ?x ?y) (is_run ?y))))))

)
