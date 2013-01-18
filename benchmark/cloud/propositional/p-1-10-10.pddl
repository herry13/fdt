(define (problem p-1-10-10)
(:domain CloudBurst)
(:objects cloud1 - cloud
cloud2 - cloud
ws0 - webservice
vm-ws0 - vm
app0-0-0 - appservice
vm-app0-0-0 - vm
app0-0-1 - appservice
vm-app0-0-1 - vm
app0-0-2 - appservice
vm-app0-0-2 - vm
app0-0-3 - appservice
vm-app0-0-3 - vm
app0-0-4 - appservice
vm-app0-0-4 - vm
app0-0-5 - appservice
vm-app0-0-5 - vm
app0-0-6 - appservice
vm-app0-0-6 - vm
app0-0-7 - appservice
vm-app0-0-7 - vm
app0-0-8 - appservice
vm-app0-0-8 - vm
app0-0-9 - appservice
vm-app0-0-9 - vm
ws1 - webservice
vm-ws1 - vm
app1-0-0 - appservice
vm-app1-0-0 - vm
app1-0-1 - appservice
vm-app1-0-1 - vm
app1-0-2 - appservice
vm-app1-0-2 - vm
app1-0-3 - appservice
vm-app1-0-3 - vm
app1-0-4 - appservice
vm-app1-0-4 - vm
app1-0-5 - appservice
vm-app1-0-5 - vm
app1-0-6 - appservice
vm-app1-0-6 - vm
app1-0-7 - appservice
vm-app1-0-7 - vm
app1-0-8 - appservice
vm-app1-0-8 - vm
app1-0-9 - appservice
vm-app1-0-9 - vm
pc-0 - client
pc-1 - client
pc-2 - client
pc-3 - client
pc-4 - client
pc-5 - client
pc-6 - client
pc-7 - client
pc-8 - client
pc-9 - client
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
(running app0-0-2)
(is_in app0-0-2 vm-app0-0-2)
(running vm-app0-0-2)
(in_cloud vm-app0-0-2 cloud1)
(running app0-0-3)
(is_in app0-0-3 vm-app0-0-3)
(running vm-app0-0-3)
(in_cloud vm-app0-0-3 cloud1)
(running app0-0-4)
(is_in app0-0-4 vm-app0-0-4)
(running vm-app0-0-4)
(in_cloud vm-app0-0-4 cloud1)
(running app0-0-5)
(is_in app0-0-5 vm-app0-0-5)
(running vm-app0-0-5)
(in_cloud vm-app0-0-5 cloud1)
(running app0-0-6)
(is_in app0-0-6 vm-app0-0-6)
(running vm-app0-0-6)
(in_cloud vm-app0-0-6 cloud1)
(running app0-0-7)
(is_in app0-0-7 vm-app0-0-7)
(running vm-app0-0-7)
(in_cloud vm-app0-0-7 cloud1)
(running app0-0-8)
(is_in app0-0-8 vm-app0-0-8)
(running vm-app0-0-8)
(in_cloud vm-app0-0-8 cloud1)
(running app0-0-9)
(is_in app0-0-9 vm-app0-0-9)
(running vm-app0-0-9)
(in_cloud vm-app0-0-9 cloud1)
(web_depend_app ws0 app0-0-0)
(web_depend_app ws0 app0-0-1)
(web_depend_app ws0 app0-0-2)
(web_depend_app ws0 app0-0-3)
(web_depend_app ws0 app0-0-4)
(web_depend_app ws0 app0-0-5)
(web_depend_app ws0 app0-0-6)
(web_depend_app ws0 app0-0-7)
(web_depend_app ws0 app0-0-8)
(web_depend_app ws0 app0-0-9)
(is_in ws1 vm-ws1)
(in_cloud vm-ws1 cloud1)
(is_in app1-0-0 vm-app1-0-0)
(in_cloud vm-app1-0-0 cloud1)
(is_in app1-0-1 vm-app1-0-1)
(in_cloud vm-app1-0-1 cloud1)
(is_in app1-0-2 vm-app1-0-2)
(in_cloud vm-app1-0-2 cloud1)
(is_in app1-0-3 vm-app1-0-3)
(in_cloud vm-app1-0-3 cloud1)
(is_in app1-0-4 vm-app1-0-4)
(in_cloud vm-app1-0-4 cloud1)
(is_in app1-0-5 vm-app1-0-5)
(in_cloud vm-app1-0-5 cloud1)
(is_in app1-0-6 vm-app1-0-6)
(in_cloud vm-app1-0-6 cloud1)
(is_in app1-0-7 vm-app1-0-7)
(in_cloud vm-app1-0-7 cloud1)
(is_in app1-0-8 vm-app1-0-8)
(in_cloud vm-app1-0-8 cloud1)
(is_in app1-0-9 vm-app1-0-9)
(in_cloud vm-app1-0-9 cloud1)
(web_depend_app ws1 app1-0-0)
(web_depend_app ws1 app1-0-1)
(web_depend_app ws1 app1-0-2)
(web_depend_app ws1 app1-0-3)
(web_depend_app ws1 app1-0-4)
(web_depend_app ws1 app1-0-5)
(web_depend_app ws1 app1-0-6)
(web_depend_app ws1 app1-0-7)
(web_depend_app ws1 app1-0-8)
(web_depend_app ws1 app1-0-9)
(refer pc-0 ws0)
(refer pc-1 ws0)
(refer pc-2 ws0)
(refer pc-3 ws0)
(refer pc-4 ws0)
(refer pc-5 ws0)
(refer pc-6 ws0)
(refer pc-7 ws0)
(refer pc-8 ws0)
(refer pc-9 ws0)
)
(:goal (and
(in_cloud vm-ws0 cloud2)
(in_cloud vm-app0-0-0 cloud2)
(in_cloud vm-app0-0-1 cloud2)
(in_cloud vm-app0-0-2 cloud2)
(in_cloud vm-app0-0-3 cloud2)
(in_cloud vm-app0-0-4 cloud2)
(in_cloud vm-app0-0-5 cloud2)
(in_cloud vm-app0-0-6 cloud2)
(in_cloud vm-app0-0-7 cloud2)
(in_cloud vm-app0-0-8 cloud2)
(in_cloud vm-app0-0-9 cloud2)
(in_cloud vm-ws1 cloud1)
(not (running vm-ws1))
(in_cloud vm-app1-0-0 cloud1)
(not (running vm-app1-0-0))
(in_cloud vm-app1-0-1 cloud1)
(not (running vm-app1-0-1))
(in_cloud vm-app1-0-2 cloud1)
(not (running vm-app1-0-2))
(in_cloud vm-app1-0-3 cloud1)
(not (running vm-app1-0-3))
(in_cloud vm-app1-0-4 cloud1)
(not (running vm-app1-0-4))
(in_cloud vm-app1-0-5 cloud1)
(not (running vm-app1-0-5))
(in_cloud vm-app1-0-6 cloud1)
(not (running vm-app1-0-6))
(in_cloud vm-app1-0-7 cloud1)
(not (running vm-app1-0-7))
(in_cloud vm-app1-0-8 cloud1)
(not (running vm-app1-0-8))
(in_cloud vm-app1-0-9 cloud1)
(not (running vm-app1-0-9))
(refer pc-0 ws0)
(refer pc-1 ws0)
(refer pc-2 ws0)
(refer pc-3 ws0)
(refer pc-4 ws0)
(refer pc-5 ws0)
(refer pc-6 ws0)
(refer pc-7 ws0)
(refer pc-8 ws0)
(refer pc-9 ws0)
))
)