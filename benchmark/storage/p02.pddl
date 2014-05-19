; Map of the Depots:           
; 00*=11   
;     *1   
;-------   
; 0: depot0 area
; 1: depot1 area
; *: Depot access point
; =: Transit area

(define (problem storage-2)
(:domain Storage-PropositionalPreferences)
(:objects
	depot0-1-1 depot0-1-2 depot0-1-3 depot1-1-1 depot1-1-2 depot1-2-1 depot1-2-2 container-0-0 container-0-1 - storearea
	hoist0 - hoist
	crate0 crate1 - crate
	container0 - container
	depot0 depot1 - depot
	loadarea transit0 - transitarea)

(:init
	(connected depot0-1-1 depot0-1-2)
	(connected depot0-1-2 depot0-1-3)
	(connected depot0-1-2 depot0-1-1)
	(connected depot0-1-3 depot0-1-2)
	(connected depot1-1-1 depot1-2-1)
	(connected depot1-1-1 depot1-1-2)
	(connected depot1-1-2 depot1-2-2)
	(connected depot1-1-2 depot1-1-1)
	(connected depot1-2-1 depot1-1-1)
	(connected depot1-2-1 depot1-2-2)
	(connected depot1-2-2 depot1-1-2)
	(connected depot1-2-2 depot1-2-1)
	(connected transit0 depot0-1-3)
	(connected transit0 depot1-1-1)
	(in depot0-1-1 depot0)
	(in depot0-1-2 depot0)
	(in depot0-1-3 depot0)
	(in depot1-1-1 depot1)
	(in depot1-1-2 depot1)
	(in depot1-2-1 depot1)
	(in depot1-2-2 depot1)
	(on crate0 container-0-0)
	(on crate1 container-0-1)
	(in crate0 container0)
	(in crate1 container0)
	(in container-0-0 container0)
	(in container-0-1 container0)
	(connected loadarea container-0-0) 
	(connected container-0-0 loadarea)
	(connected loadarea container-0-1) 
	(connected container-0-1 loadarea)  
	(connected depot0-1-3 loadarea)
	(connected loadarea depot0-1-3)
	(connected depot1-2-1 loadarea)
	(connected loadarea depot1-2-1)  
	(clear depot0-1-1)
	(clear depot0-1-2)
	(clear depot0-1-3)
	(clear depot1-1-1)
	(clear depot1-2-2)
	(clear depot1-2-1)  
	(at hoist0 depot1-1-2)
	(available hoist0)
	(compatible crate0 crate1)
	(compatible crate1 crate0))

(:goal (and
;;--- start of goal preferences ---;;
	(clear depot0-1-3)
	(clear depot0-1-2)
	(clear depot1-2-1)
	(clear depot1-1-1)
	(clear depot1-2-2)
	(forall (?c - crate) (exists (?d - depot) (and (in ?c ?d) (not (= ?d depot1)))))
;;--- end of goal preferences ---;;
))
(:constraints (and
	(forall (?c1 ?c2 - crate ?s1 ?s2 - storearea) (always (imply (and (on ?c1 ?s1) (on ?c2 ?s2) (not (= ?c1 ?c2)) (connected ?s1 ?s2)) (compatible ?c1 ?c2))))
	(forall (?c1 ?c2 - crate ?d - depot) (always (imply (and (in ?c1 ?d) (in ?c2 ?d) (not (= ?c1 ?c2))) (compatible ?c1 ?c2))))
	(forall (?c - crate) (at-most-once (exists (?h - hoist) (lifting ?h ?c))))
	(forall (?h - hoist) (sometime (exists (?c - crate) (lifting ?h ?c))))
	(sometime-before (exists (?d1 - depot) (in crate0 ?d1)) (exists (?d2 - depot) (in crate1 ?d2)))
))
)
