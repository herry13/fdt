(define (problem p-2-2-2)
(:domain CloudBurst)
(:objects cloud1 - cloud
cloud2 - cloud
ws0 - webservice
vm-ws0 - vm
app0-0-0 - appservice
vm-app0-0-0 - vm
app0-0-1 - appservice
vm-app0-0-1 - vm
app0-1-0 - appservice
vm-app0-1-0 - vm
app0-1-1 - appservice
vm-app0-1-1 - vm
ws1 - webservice
vm-ws1 - vm
app1-0-0 - appservice
vm-app1-0-0 - vm
app1-0-1 - appservice
vm-app1-0-1 - vm
app1-1-0 - appservice
vm-app1-1-0 - vm
app1-1-1 - appservice
vm-app1-1-1 - vm
pc-0 - client
pc-1 - client
)
(:init 
(running ws0)
(is_in ws0 vm-ws0)
(running vm-ws0)
(in_cloud vm-ws0 cloud1)
(running app0-0-0)
(is_in app0-0-0 vm-app0-0-0)
(running vm-app0-0-0)
(in_cloud vm-app0-0-0 cloud1)
(running app0-0-1)
(is_in app0-0-1 vm-app0-0-1)
(running vm-app0-0-1)
(in_cloud vm-app0-0-1 cloud1)
(running app0-1-0)
(is_in app0-1-0 vm-app0-1-0)
(running vm-app0-1-0)
(in_cloud vm-app0-1-0 cloud1)
(running app0-1-1)
(is_in app0-1-1 vm-app0-1-1)
(running vm-app0-1-1)
(in_cloud vm-app0-1-1 cloud1)
(web_depend_app ws0 app0-0-0)
(web_depend_app ws0 app0-0-1)
(app_depend_app app0-0-0 app0-1-0)
(app_depend_app app0-0-1 app0-1-1)
(is_in ws1 vm-ws1)
(in_cloud vm-ws1 cloud1)
(is_in app1-0-0 vm-app1-0-0)
(in_cloud vm-app1-0-0 cloud1)
(is_in app1-0-1 vm-app1-0-1)
(in_cloud vm-app1-0-1 cloud1)
(is_in app1-1-0 vm-app1-1-0)
(in_cloud vm-app1-1-0 cloud1)
(is_in app1-1-1 vm-app1-1-1)
(in_cloud vm-app1-1-1 cloud1)
(web_depend_app ws1 app1-0-0)
(web_depend_app ws1 app1-0-1)
(app_depend_app app1-0-0 app1-1-0)
(app_depend_app app1-0-1 app1-1-1)
(refer pc-0 ws0)
(refer pc-1 ws0)
)
(:goal (and
(in_cloud vm-ws0 cloud2)
(in_cloud vm-app0-0-0 cloud2)
(in_cloud vm-app0-0-1 cloud2)
(in_cloud vm-app0-1-0 cloud2)
(in_cloud vm-app0-1-1 cloud2)
(in_cloud vm-ws1 cloud1)
(not (running vm-ws1))
(in_cloud vm-app1-0-0 cloud1)
(not (running vm-app1-0-0))
(in_cloud vm-app1-0-1 cloud1)
(not (running vm-app1-0-1))
(in_cloud vm-app1-1-0 cloud1)
(not (running vm-app1-1-0))
(in_cloud vm-app1-1-1 cloud1)
(not (running vm-app1-1-1))
(refer pc-0 ws0)
(refer pc-1 ws0)
))
)