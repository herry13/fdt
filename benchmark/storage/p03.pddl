; Map of the Depots:               
; 0*0=*11 22   
;         2*   
;-----------   
; 0: depot0 area
; 1: depot1 area
; 2: depot2 area
; *: Depot access point
; =: Transit area

(define (problem storage-3)
(:domain Storage-PropositionalPreferences)
(:objects
	depot0-1-1 depot0-1-2 depot0-1-3 depot1-1-1 depot1-1-2 depot1-1-3 depot2-1-1 depot2-1-2 depot2-2-1 depot2-2-2 container-0-0 container-0-1 container-0-2 - storearea
	hoist0 - hoist
	crate0 crate1 crate2 - crate
	container0 - container
	depot0 depot1 depot2 - depot
	loadarea transit0 - transitarea)

(:init
	(connected depot0-1-1 depot0-1-2)
	(connected depot0-1-2 depot0-1-3)
	(connected depot0-1-2 depot0-1-1)
	(connected depot0-1-3 depot0-1-2)
	(connected depot1-1-1 depot1-1-2)
	(connected depot1-1-2 depot1-1-3)
	(connected depot1-1-2 depot1-1-1)
	(connected depot1-1-3 depot1-1-2)
	(connected depot2-1-1 depot2-2-1)
	(connected depot2-1-1 depot2-1-2)
	(connected depot2-1-2 depot2-2-2)
	(connected depot2-1-2 depot2-1-1)
	(connected depot2-2-1 depot2-1-1)
	(connected depot2-2-1 depot2-2-2)
	(connected depot2-2-2 depot2-1-2)
	(connected depot2-2-2 depot2-2-1)
	(connected transit0 depot0-1-3)
	(connected transit0 depot1-1-1)
	(in depot0-1-1 depot0)
	(in depot0-1-2 depot0)
	(in depot0-1-3 depot0)
	(in depot1-1-1 depot1)
	(in depot1-1-2 depot1)
	(in depot1-1-3 depot1)
	(in depot2-1-1 depot2)
	(in depot2-1-2 depot2)
	(in depot2-2-1 depot2)
	(in depot2-2-2 depot2)
	(on crate0 container-0-0)
	(on crate1 container-0-1)
	(on crate2 container-0-2)
	(in crate0 container0)
	(in crate1 container0)
	(in crate2 container0)
	(in container-0-0 container0)
	(in container-0-1 container0)
	(in container-0-2 container0)
	(connected loadarea container-0-0) 
	(connected container-0-0 loadarea)
	(connected loadarea container-0-1) 
	(connected container-0-1 loadarea)
	(connected loadarea container-0-2) 
	(connected container-0-2 loadarea)  
	(connected depot0-1-2 loadarea)
	(connected loadarea depot0-1-2)
	(connected depot1-1-1 loadarea)
	(connected loadarea depot1-1-1)
	(connected depot2-2-2 loadarea)
	(connected loadarea depot2-2-2)  
	(clear depot0-1-3)
	(clear depot0-1-2)
	(clear depot1-1-1)
	(clear depot1-1-2)
	(clear depot1-1-3)
	(clear depot2-1-1)
	(clear depot2-1-2)
	(clear depot2-2-1)
	(clear depot2-2-2)  
	(at hoist0 depot0-1-1)
	(available hoist0)
	(compatible crate0 crate1)
	(compatible crate1 crate0)
	(compatible crate0 crate2)
	(compatible crate2 crate0)
	(compatible crate1 crate2)
	(compatible crate2 crate1))

(:goal (and
;;--- start of goal preferences ---;;
	(clear depot0-1-2)
	(clear depot1-1-1)
	(clear depot1-1-2)
	(clear depot2-2-2)
	(clear depot2-1-2)
	(clear depot2-2-1)
	(forall (?c - crate) (exists (?d - depot) (and (in ?c ?d) (not (= ?d depot1)))))
	(forall (?c - crate) (exists (?d - depot) (and (in ?c ?d) (not (= ?d depot2)))))
;;--- end of goal preferences ---;;
))

(:constraints (and
	(forall (?c1 ?c2 - crate ?s1 ?s2 - storearea) (always (imply (and (on ?c1 ?s1) (on ?c2 ?s2) (not (= ?c1 ?c2)) (connected ?s1 ?s2)) (compatible ?c1 ?c2))))
	(forall (?c1 ?c2 - crate ?d - depot) (always (imply (and (in ?c1 ?d) (in ?c2 ?d) (not (= ?c1 ?c2))) (compatible ?c1 ?c2))))
	(forall (?c - crate) (at-most-once (exists (?h - hoist) (lifting ?h ?c))))
	(forall (?h - hoist) (sometime (exists (?c - crate) (lifting ?h ?c))))
	(sometime-before (exists (?d1 - depot) (in crate0 ?d1)) (exists (?d2 - depot) (in crate1 ?d2)))
	(sometime-before (exists (?d1 - depot) (in crate0 ?d1)) (exists (?d2 - depot) (in crate2 ?d2)))
))
)
