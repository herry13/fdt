(define (domain CloudBurst)
(:requirements :strips :typing :adl :constraints)  
(:types client runnable cloud - object
	service vm - runnable
	webservice appservice dbservice - service
)

(:predicates (running ?s - runnable)
		(refer ?c - client ?s - webservice)
		(web_depend_app ?w - webservice ?a - appservice)
		(app_depend_db ?a - appservice ?d - dbservice)
		(is_in ?s - service ?v - vm)
		(in_cloud ?v - vm ?cl - cloud))

(:action migrate-vm
 :parameters (?v - vm ?from ?to - cloud)
 :precondition (and (not (running ?v)) (in_cloud ?v ?from) (not (in_cloud ?v ?to)))
 :effect (and (not (in_cloud ?v ?from)) (in_cloud ?v ?to)))

(:action start-runnable
 :parameters (?s - runnable)
 :precondition (and (not (running ?s)))
 :effect (and (running ?s)))

(:action stop-runnable
 :parameters (?s - runnable)
 :precondition (and (running ?s))
 :effect (and (not (running ?s))))

(:action change_ref
 :parameters (?c - client ?from ?to - webservice)
 :precondition (and (refer ?c ?from) (not (refer ?c ?to)))
 :effect (and (not (refer ?c ?from)) (refer ?c ?to)))

) 
