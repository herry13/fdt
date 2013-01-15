(define (domain CloudBurst)
(:requirements :strips :typing :adl)  
(:types client runnable cloud - object
	service vm - runnable
	webservice appservice - service
)

(:predicates (running ?s - runnable)
		(refer ?c - client ?s - webservice)
		(web_depend_app ?w - webservice ?a - appservice)
      (app_depend_app ?a1 - appservice ?a2 - appservice)
		(is_in ?s - service ?v - vm)
		(in_cloud ?v - vm ?cl - cloud))

(:action migrate-vm
 :parameters (?v - vm ?from ?to - cloud)
 :precondition (and (not (running ?v)) (in_cloud ?v ?from) (not (in_cloud ?v ?to)))
 :effect (and (not (in_cloud ?v ?from)) (in_cloud ?v ?to)))

;(:action start-runnable
; :parameters (?s - runnable)
; :precondition (and (not (running ?s)))
; :effect (and (running ?s)))

(:action start-vm
 :parameters (?v - vm)
 :precondition (and (not (running ?v)))
 :effect (and (running ?v)))

(:action start-webservice
 :parameters (?ws - webservice ?v - vm)
 :precondition (and (forall (?app - appservice) (imply (web_depend_app ?ws ?app) (running ?app)))
                    (is_in ?ws ?v) (running ?v))
 :effect (and (running ?ws)))

(:action start-appservice
 :parameters (?app - appservice ?v - vm)
 :precondition (and (forall (?app2 - appservice) (imply (app_depend_app ?app ?app2) (running ?app2)))
                    (is_in ?app ?v) (running ?v))
 :effect (and (running ?app)))

;(:action stop-runnable
; :parameters (?s - runnable)
; :precondition (and (running ?s))
; :effect (and (not (running ?s))))

(:action stop-vm
 :parameters (?v - vm)
 :precondition (and (forall (?s - service) (imply (is_in ?s ?v) (not (running ?s)))))
 :effect (and (not (running ?v))))

(:action stop-webservice
 :parameters (?ws - webservice)
 :precondition (and (forall (?c - client) (not (refer ?c ?ws))))
 :effect (and (not (running ?ws))))

(:action stop-appservice
 :parameters (?app - appservice)
 :precondition (and (forall (?ws - webservice) (imply (web_depend_app ?ws ?app) (not (running ?ws))))
                    (forall (?app2 - appservice) (imply (app_depend_app ?app2 ?app) (not (running ?app2)))))
 :effect (and (not (running ?app))))

(:action change_ref
 :parameters (?c - client ?from ?to - webservice)
 :precondition (and (refer ?c ?from) (not (refer ?c ?to)) (running ?to))
 :effect (and (not (refer ?c ?from)) (refer ?c ?to)))

) 
