(define (domain ServiceReference)
(:requirements :strips :typing :adl :constraints)  
(:types client service - object)

(:predicates (is_run ?s - service)
		(refer ?c - client ?s - service))

(:action start-service
 :parameters (?s - service)
 :precondition (and (not (is_run ?s)))
 :effect (and (is_run ?s)))

(:action stop-service
 :parameters (?s - service)
 :precondition (and (is_run ?s))
 :effect (and (not (is_run ?s))))

(:action change_ref
 :parameters (?c - client ?from ?to - service)
 :precondition (and (refer ?c ?from)
		(not (refer ?c ?to)))
 :effect (and (not (refer ?c ?from))
		(refer ?c ?to)))

) 
