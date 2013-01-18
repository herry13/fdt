(define (problem cb-p03)
(:domain CloudBurst)
(:objects
	cloud1 - cloud
	cloud2 - cloud

	ws1 - webservice
	app11 - appservice
	app12 - appservice
	app13 - appservice
	app14 - appservice
	db11 - dbservice
	db12 - dbservice
	db13 - dbservice
	db14 - dbservice
	vm-ws1 - vm
	vm-app11 - vm
	vm-app12 - vm
	vm-app13 - vm
	vm-app14 - vm
	vm-db11 - vm
	vm-db12 - vm
	vm-db13 - vm
	vm-db14 - vm

	ws2 - webservice
	app21 - appservice
	app22 - appservice
	app23 - appservice
	app24 - appservice
	db21 - dbservice
	db22 - dbservice
	db23 - dbservice
	db24 - dbservice
	vm-ws2 - vm
	vm-app22 - vm
	vm-app21 - vm
	vm-app23 - vm
	vm-app24 - vm
	vm-db22 - vm
	vm-db21 - vm
	vm-db23 - vm
	vm-db24 - vm

	c1 - client
	c2 - client
	c3 - client
	c4 - client
	c5 - client
	c6 - client
	c7 - client
	c8 - client
)

(:init
	(running ws1)
	(running app11)
	(running app12)
	(running app13)
	(running app14)
	(running db11)
	(running db12)
	(running db13)
	(running db14)
	(running vm-ws1)
	(running vm-app11)
	(running vm-app12)
	(running vm-app13)
	(running vm-app14)
	(running vm-db11)
	(running vm-db12)
	(running vm-db13)
	(running vm-db14)
	(web_depend_app ws1 app11)
	(web_depend_app ws1 app12)
	(web_depend_app ws1 app13)
	(web_depend_app ws1 app14)
	(app_depend_db app11 db11)
	(app_depend_db app12 db12)
	(app_depend_db app13 db13)
	(app_depend_db app14 db14)
	(is_in ws1 vm-ws1)
	(is_in app11 vm-app11)
	(is_in app12 vm-app12)
	(is_in app13 vm-app13)
	(is_in app14 vm-app14)
	(is_in db11 vm-db11)
	(is_in db12 vm-db12)
	(is_in db13 vm-db13)
	(is_in db14 vm-db14)
	(in_cloud vm-ws1 cloud1)
	(in_cloud vm-app11 cloud1)
	(in_cloud vm-app12 cloud1)
	(in_cloud vm-app13 cloud1)
	(in_cloud vm-app14 cloud1)
	(in_cloud vm-db11 cloud1)
	(in_cloud vm-db12 cloud1)
	(in_cloud vm-db13 cloud1)
	(in_cloud vm-db14 cloud1)

	(web_depend_app ws2 app21)
	(web_depend_app ws2 app22)
	(web_depend_app ws2 app23)
	(web_depend_app ws2 app24)
	(app_depend_db app21 db21)
	(app_depend_db app22 db22)
	(app_depend_db app23 db23)
	(app_depend_db app24 db24)
	(is_in ws2 vm-ws2)
	(is_in app21 vm-app21)
	(is_in app22 vm-app22)
	(is_in app23 vm-app23)
	(is_in app24 vm-app24)
	(is_in db21 vm-db21)
	(is_in db22 vm-db22)
	(is_in db23 vm-db23)
	(is_in db24 vm-db24)
	(in_cloud vm-ws2 cloud1)
	(in_cloud vm-app21 cloud1)
	(in_cloud vm-app22 cloud1)
	(in_cloud vm-app23 cloud1)
	(in_cloud vm-app24 cloud1)
	(in_cloud vm-db21 cloud1)
	(in_cloud vm-db22 cloud1)
	(in_cloud vm-db23 cloud1)
	(in_cloud vm-db24 cloud1)

	(refer c1 ws1)
	(refer c2 ws1)
	(refer c3 ws1)
	(refer c4 ws1)
	(refer c5 ws1)
	(refer c6 ws1)
	(refer c7 ws1)
	(refer c8 ws1)
)

(:goal (and
	(refer c1 ws1)
	(refer c2 ws1)
	(refer c3 ws1)
	(refer c4 ws1)
	(refer c5 ws1)
	(refer c6 ws1)
	(refer c7 ws1)
	(refer c8 ws1)

	(in_cloud vm-ws1 cloud2)
	(in_cloud vm-app11 cloud2)
	(in_cloud vm-app12 cloud2)
	(in_cloud vm-app13 cloud2)
	(in_cloud vm-app14 cloud2)
	(in_cloud vm-db11 cloud2)
	(in_cloud vm-db12 cloud2)
	(in_cloud vm-db13 cloud2)
	(in_cloud vm-db14 cloud2)

	(not (running vm-ws2))
	(not (running vm-app21))
	(not (running vm-app22))
	(not (running vm-app23))
	(not (running vm-app24))
	(not (running vm-db21))
	(not (running vm-db22))
	(not (running vm-db23))
	(not (running vm-db24))
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
