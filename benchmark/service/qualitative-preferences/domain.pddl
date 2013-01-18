(define (domain ServiceReference)
(:requirements :strips :typing :adl :preferences :constraints)
(:types client service - object
	secondary_client primary_client - client)

(:predicates
	(dummy)
	(is_run ?s - service)
	(refer ?c - client ?s - service))

(:action start-service
 :parameters (?s - service)
 :precondition (and (not (is_run ?s)))
 :effect (and (is_run ?s)))

(:action stop-service
 :parameters (?s - service)
 :precondition (and (is_run ?s))
 :effect (and (not (is_run ?s))))

(:action redirect_from_to
 :parameters (?c - client ?from ?to - service)
 :precondition (and (refer ?c ?from) (not (refer ?c ?to)))
 :effect (and (not (refer ?c ?from))
		(refer ?c ?to)))

(:action set_refer_to
 :parameters (?c - client ?to - service)
 :precondition (forall (?s - service) (not (refer ?c ?s)))
 :effect (and (refer ?c ?to)))

) 
