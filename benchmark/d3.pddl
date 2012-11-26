(define (domain ServiceReference)
(:requirements :strips :typing :adl) ; :constraints)  
(:types client service - object)

(:predicates (is_run ?s - service)
		(refer ?c - client ?s - service)
		(satisfied-global))

(:action start-service
 :parameters (?s - service)
 :precondition (and (not (is_run ?s))
		(satisfied-global))
 :effect (and (is_run ?s)
		(not (satisfied-global))))

(:action stop-service
 :parameters (?s - service)
 :precondition (and (is_run ?s)
		(satisfied-global))
 :effect (and (not (is_run ?s))
		(not (satisfied-global))))

(:action change_ref
 :parameters (?c - client ?from ?to - service)
 :precondition (and (refer ?c ?from)
		(not (refer ?c ?to)) (satisfied-global))
 :effect (and (not (refer ?c ?from))
		(refer ?c ?to)
		(not (satisfied-global))))

(:action verify-global
 :parameters ()
 :precondition (and (not (satisfied-global))
		(forall (?x - client ?y - service)
			(imply (refer ?x ?y) (is_run ?y))))
 :effect (and (satisfied-global)))

)
