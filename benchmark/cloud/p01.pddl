(define (problem cb-p01)
(:domain CloudBurst)
(:objects
	cloud1 - cloud
	cloud2 - cloud
	vm1 - vm
	vm2 - vm
	vm3 - vm
	ws1 - webservice
	app1 - appservice
	db1 - dbservice
	vm4 - vm
	vm5 - vm
	vm6 - vm
	ws2 - webservice
	app2 - appservice
	db2 - dbservice
	c1 - client
	c2 - client)

(:init
	(satisfied-global)

	(running ws1)
	(running app1)
	(running db1)
	(depend ws1 app1)
	(depend app1 db1)
	(is_in ws1 vm1)
	(is_in app1 vm2)
	(is_in db1 vm3)
	(in_cloud vm1 cloud1)
	(in_cloud vm2 cloud1)
	(in_cloud vm3 cloud1)
	(running vm1)
	(running vm2)
	(running vm3)

	(depend ws2 app2)
	(depend app2 db2)
	(is_in ws2 vm4)
	(is_in app2 vm5)
	(is_in db2 vm6)
	(in_cloud vm4 cloud1)
	(in_cloud vm5 cloud1)
	(in_cloud vm6 cloud1)

	(refer c1 ws1)
	(refer c2 ws1)
)

(:goal (and
	(satisfied-global)
	(refer c1 ws1)
	(refer c2 ws1)
	(in_cloud vm1 cloud2)
	(in_cloud vm2 cloud2)
	(in_cloud vm3 cloud2)
	(not (running vm4))
	(not (running vm5))
	(not (running vm6))
))

)
