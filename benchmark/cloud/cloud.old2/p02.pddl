(define (problem cb-p02)
(:domain CloudBurst)
(:objects
	cloud1 - cloud
	cloud2 - cloud

	ws1 - webservice
	app11 - appservice
	app12 - appservice
	db11 - dbservice
	db12 - dbservice
	vm-ws1 - vm
	vm-app11 - vm
	vm-db11 - vm
	vm-app12 - vm
	vm-db12 - vm

	ws2 - webservice
	app21 - appservice
	app22 - appservice
	db21 - dbservice
	db22 - dbservice
	vm-ws2 - vm
	vm-app21 - vm
	vm-db21 - vm
	vm-app22 - vm
	vm-db22 - vm

	c1 - client
	c2 - client
	c3 - client
	c4 - client
)

(:init
	(running ws1)
	(running app11)
	(running db11)
	(running app12)
	(running db12)
	(running vm-ws1)
	(running vm-app11)
	(running vm-db11)
	(running vm-app12)
	(running vm-db12)
	(depend ws1 app11)
	(depend ws1 app12)
	(depend app11 db11)
	(depend app12 db12)
	(is_in ws1 vm-ws1)
	(is_in app11 vm-app11)
	(is_in db11 vm-db11)
	(is_in app12 vm-app12)
	(is_in db12 vm-db12)
	(in_cloud vm-ws1 cloud1)
	(in_cloud vm-app11 cloud1)
	(in_cloud vm-db11 cloud1)
	(in_cloud vm-app12 cloud1)
	(in_cloud vm-db12 cloud1)


	(depend ws2 app21)
	(depend app21 db21)
	(depend ws2 app22)
	(depend app22 db22)
	(is_in ws2 vm-ws2)
	(is_in app21 vm-app21)
	(is_in db21 vm-db21)
	(is_in app22 vm-app22)
	(is_in db22 vm-db22)
	(in_cloud vm-ws2 cloud1)
	(in_cloud vm-app21 cloud1)
	(in_cloud vm-db21 cloud1)
	(in_cloud vm-app22 cloud1)
	(in_cloud vm-db22 cloud1)

	(refer c1 ws1)
	(refer c2 ws1)
	(refer c3 ws1)
	(refer c4 ws1)
)

(:goal (and
	(refer c1 ws1)
	(refer c2 ws1)
	(refer c3 ws1)
	(refer c4 ws1)

	(in_cloud vm-ws1 cloud2)
	(in_cloud vm-app11 cloud2)
	(in_cloud vm-db11 cloud2)
	(in_cloud vm-app12 cloud2)
	(in_cloud vm-db12 cloud2)

	(not (running vm-ws2))
	(not (running vm-app21))
	(not (running vm-db21))
	(not (running vm-app22))
	(not (running vm-db22))
))

(:constraints (and
	(forall (?s - service ?v - vm)
		(always (imply (and (is_in ?s ?v) (running ?s)) (running ?v))))
	(forall (?s1 ?s2 - service)
		(always (imply (and (depend ?s1 ?s2) (running ?s1)) (running ?s2))))
	(forall (?c - client ?w - webservice)
		(always (imply (refer ?c ?w) (running ?w))))))

)
