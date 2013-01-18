(define (problem cb-p03)
(:domain CloudBurst)
(:objects
	cloud1 - cloud
	cloud2 - cloud

	ws1 - webservice
	app11 - appservice
	app12 - appservice
	app13 - appservice
	db11 - dbservice
	db12 - dbservice
	db13 - dbservice
	vm-ws1 - vm
	vm-app11 - vm
	vm-app12 - vm
	vm-app13 - vm
	vm-db11 - vm
	vm-db12 - vm
	vm-db13 - vm

	ws2 - webservice
	app21 - appservice
	app22 - appservice
	app23 - appservice
	db21 - dbservice
	db22 - dbservice
	db23 - dbservice
	vm-ws2 - vm
	vm-app21 - vm
	vm-app22 - vm
	vm-app23 - vm
	vm-db21 - vm
	vm-db22 - vm
	vm-db23 - vm

	c1 - client
	c2 - client
	c3 - client
	c4 - client
	c5 - client
	c6 - client
)

(:init
	(running ws1)
	(running app11)
	(running app12)
	(running app13)
	(running db11)
	(running db12)
	(running db13)
	(running vm-ws1)
	(running vm-app11)
	(running vm-app12)
	(running vm-app13)
	(running vm-db11)
	(running vm-db12)
	(running vm-db13)
	(web_depend_app ws1 app11)
	(web_depend_app ws1 app12)
	(web_depend_app ws1 app13)
	(app_depend_db app11 db11)
	(app_depend_db app12 db12)
	(app_depend_db app13 db13)
	(is_in ws1 vm-ws1)
	(is_in app11 vm-app11)
	(is_in app12 vm-app12)
	(is_in app13 vm-app13)
	(is_in db11 vm-db11)
	(is_in db12 vm-db12)
	(is_in db13 vm-db13)
	(in_cloud vm-ws1 cloud1)
	(in_cloud vm-app11 cloud1)
	(in_cloud vm-app12 cloud1)
	(in_cloud vm-app13 cloud1)
	(in_cloud vm-db11 cloud1)
	(in_cloud vm-db12 cloud1)
	(in_cloud vm-db13 cloud1)

	(web_depend_app ws2 app21)
	(web_depend_app ws2 app22)
	(web_depend_app ws2 app23)
	(app_depend_db app21 db21)
	(app_depend_db app22 db22)
	(app_depend_db app23 db23)
	(is_in ws2 vm-ws2)
	(is_in app21 vm-app21)
	(is_in app22 vm-app22)
	(is_in app23 vm-app23)
	(is_in db21 vm-db21)
	(is_in db22 vm-db22)
	(is_in db23 vm-db23)
	(in_cloud vm-ws2 cloud1)
	(in_cloud vm-app21 cloud1)
	(in_cloud vm-app22 cloud1)
	(in_cloud vm-app23 cloud1)
	(in_cloud vm-db21 cloud1)
	(in_cloud vm-db22 cloud1)
	(in_cloud vm-db23 cloud1)

	(refer c1 ws1)
	(refer c2 ws1)
	(refer c3 ws1)
	(refer c4 ws1)
	(refer c5 ws1)
	(refer c6 ws1)
)

(:goal (and
	(refer c1 ws1)
	(refer c2 ws1)
	(refer c3 ws1)
	(refer c4 ws1)
	(refer c5 ws1)
	(refer c6 ws1)

	(in_cloud vm-ws1 cloud2)
	(in_cloud vm-app11 cloud2)
	(in_cloud vm-app12 cloud2)
	(in_cloud vm-app13 cloud2)
	(in_cloud vm-db11 cloud2)
	(in_cloud vm-db12 cloud2)
	(in_cloud vm-db13 cloud2)

	(not (running vm-ws2))
	(not (running vm-app21))
	(not (running vm-app22))
	(not (running vm-app23))
	(not (running vm-db21))
	(not (running vm-db22))
	(not (running vm-db23))
))

(:constraints (and
	(forall (?s - service)
		(always
			(exists (?v - vm)
				(and (is_in ?s ?v)
					(imply (running ?s) (running ?v))))))

	(forall (?w - webservice ?a - appservice)
		(always
			(imply
				(and (web_depend_app ?w ?a) (running ?w))
				(running ?a))))

	(forall (?a - appservice ?d - dbservice)
		(always
			(imply
				(and (app_depend_db ?a ?d) (running ?a))
				(running ?d))))

	(forall (?c - client ?w - webservice)
		(always (imply (refer ?c ?w) (running ?w))))
))

)
