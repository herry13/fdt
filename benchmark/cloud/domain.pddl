(define (domain CloudBurst)
(:requirements :strips :typing :adl)
(:types client runnable cloud - object
	service vm - runnable
	webservice appservice dbservice - service
)

(:predicates (running ?s - runnable)
		(refer ?c - client ?s - webservice)
		(depend ?s1 ?s2 - service)
		(is_in ?s - service ?v - vm)
		(in_cloud ?v - vm ?cl - cloud)
		(satisfied-global))

(:action migrate-vm
 :parameters (?v - vm ?from ?to - cloud)
 :precondition (and (satisfied-global)
		(not (running ?v)) (in_cloud ?v ?from) (not (in_cloud ?v ?to)))
 :effect (and (not (satisfied-global))
		(not (in_cloud ?v ?from)) (in_cloud ?v ?to)))

(:action start-runnable
 :parameters (?s - runnable)
 :precondition (and (not (running ?s))
		(satisfied-global))
 :effect (and (running ?s)
		(not (satisfied-global))))

(:action stop-runnable
 :parameters (?s - runnable)
 :precondition (and (running ?s)
		(satisfied-global))
 :effect (and (not (running ?s))
		(not (satisfied-global))))

(:action change_ref
 :parameters (?c - client ?from ?to - webservice)
 :precondition (and (refer ?c ?from)
		(not (refer ?c ?to)) (satisfied-global))
 :effect (and (not (refer ?c ?from))
		(refer ?c ?to)
		(not (satisfied-global))))

(:action verify-global
 :parameters ()
 :precondition (and (not (satisfied-global))
		(forall (?s - service ?v - vm)
			(imply (and (is_in ?s ?v) (running ?s)) (running ?v)))
		(forall (?s1 ?s2 - service)
			(imply (and (depend ?s1 ?s2) (running ?s1)) (running ?s2)))
		(forall (?c - client ?w - webservice)
			(imply (refer ?c ?w) (running ?w))))
 :effect (and (satisfied-global)))

)
