begin_version
3
end_version
begin_metric
0
end_metric
26
begin_variable
var0
-1
2
Atom always()
<none of those>
end_variable
begin_variable
var1
-1
4
Atom at(rover0, waypoint0)
Atom at(rover0, waypoint1)
Atom at(rover0, waypoint2)
Atom at(rover0, waypoint3)
end_variable
begin_variable
var2
-1
2
Atom at_rock_sample(waypoint0)
Atom have_rock_analysis(rover0, waypoint0)
end_variable
begin_variable
var3
-1
2
Atom at_soil_sample(waypoint0)
Atom have_soil_analysis(rover0, waypoint0)
end_variable
begin_variable
var4
-1
2
Atom calibrated(camera0, rover0)
<none of those>
end_variable
begin_variable
var5
-1
2
Atom calibrated(camera1, rover0)
<none of those>
end_variable
begin_variable
var6
-1
2
Atom communicated_image_data(objective0, colour)
<none of those>
end_variable
begin_variable
var7
-1
2
Atom communicated_image_data(objective0, high_res)
<none of those>
end_variable
begin_variable
var8
-1
2
Atom communicated_image_data(objective0, low_res)
<none of those>
end_variable
begin_variable
var9
-1
2
Atom communicated_image_data(objective1, colour)
<none of those>
end_variable
begin_variable
var10
-1
2
Atom communicated_image_data(objective1, high_res)
<none of those>
end_variable
begin_variable
var11
-1
2
Atom communicated_image_data(objective1, low_res)
<none of those>
end_variable
begin_variable
var12
-1
2
Atom communicated_rock_data(waypoint0)
<none of those>
end_variable
begin_variable
var13
-1
2
Atom communicated_soil_data(waypoint0)
<none of those>
end_variable
begin_variable
var14
-1
2
Atom empty(rover0store)
Atom full(rover0store)
end_variable
begin_variable
var15
-1
2
Atom have_image(rover0, objective0, colour)
<none of those>
end_variable
begin_variable
var16
-1
2
Atom have_image(rover0, objective0, high_res)
<none of those>
end_variable
begin_variable
var17
-1
2
Atom have_image(rover0, objective0, low_res)
<none of those>
end_variable
begin_variable
var18
-1
2
Atom have_image(rover0, objective1, colour)
<none of those>
end_variable
begin_variable
var19
-1
2
Atom have_image(rover0, objective1, high_res)
<none of those>
end_variable
begin_variable
var20
-1
2
Atom have_image(rover0, objective1, low_res)
<none of those>
end_variable
begin_variable
var21
-1
2
Atom sometime-0()
<none of those>
end_variable
begin_variable
var22
-1
2
Atom sometime_before_2-0()
<none of those>
end_variable
begin_variable
var23
-1
2
Atom sometime_before_2-1()
<none of those>
end_variable
begin_variable
var24
-1
2
Atom sometime_before_2-2()
<none of those>
end_variable
begin_variable
var25
-1
2
Atom sometime_before_2-3()
<none of those>
end_variable
5
begin_mutex_group
4
1 0
1 1
1 2
1 3
end_mutex_group
begin_mutex_group
2
2 0
2 1
end_mutex_group
begin_mutex_group
2
3 0
3 1
end_mutex_group
begin_mutex_group
2
14 0
14 1
end_mutex_group
begin_mutex_group
2
14 0
14 1
end_mutex_group
begin_state
1
0
0
0
1
1
1
1
1
1
1
1
1
1
0
1
1
1
1
1
1
1
1
1
1
1
end_state
begin_goal
6
0 0
1 0
11 0
12 0
13 0
21 0
end_goal
70
begin_operator
calibrate rover0 camera0 objective0 waypoint0
1
1 0
2
0 0 0 1
0 4 -1 0
0
end_operator
begin_operator
calibrate rover0 camera1 objective1 waypoint0
1
1 0
2
0 0 0 1
0 5 -1 0
0
end_operator
begin_operator
calibrate rover0 camera1 objective1 waypoint1
1
1 1
2
0 0 0 1
0 5 -1 0
0
end_operator
begin_operator
calibrate rover0 camera1 objective1 waypoint2
1
1 2
2
0 0 0 1
0 5 -1 0
0
end_operator
begin_operator
communicate_image_data rover0 general objective0 colour waypoint0 waypoint1
2
1 0
15 0
2
0 0 0 1
0 6 -1 0
0
end_operator
begin_operator
communicate_image_data rover0 general objective0 colour waypoint2 waypoint1
2
1 2
15 0
2
0 0 0 1
0 6 -1 0
0
end_operator
begin_operator
communicate_image_data rover0 general objective0 colour waypoint3 waypoint1
2
1 3
15 0
2
0 0 0 1
0 6 -1 0
0
end_operator
begin_operator
communicate_image_data rover0 general objective0 high_res waypoint0 waypoint1
2
1 0
16 0
2
0 0 0 1
0 7 -1 0
0
end_operator
begin_operator
communicate_image_data rover0 general objective0 high_res waypoint2 waypoint1
2
1 2
16 0
2
0 0 0 1
0 7 -1 0
0
end_operator
begin_operator
communicate_image_data rover0 general objective0 high_res waypoint3 waypoint1
2
1 3
16 0
2
0 0 0 1
0 7 -1 0
0
end_operator
begin_operator
communicate_image_data rover0 general objective0 low_res waypoint0 waypoint1
2
1 0
17 0
2
0 0 0 1
0 8 -1 0
0
end_operator
begin_operator
communicate_image_data rover0 general objective0 low_res waypoint2 waypoint1
2
1 2
17 0
2
0 0 0 1
0 8 -1 0
0
end_operator
begin_operator
communicate_image_data rover0 general objective0 low_res waypoint3 waypoint1
2
1 3
17 0
2
0 0 0 1
0 8 -1 0
0
end_operator
begin_operator
communicate_image_data rover0 general objective1 colour waypoint0 waypoint1
2
1 0
18 0
2
0 0 0 1
0 9 -1 0
0
end_operator
begin_operator
communicate_image_data rover0 general objective1 colour waypoint2 waypoint1
2
1 2
18 0
2
0 0 0 1
0 9 -1 0
0
end_operator
begin_operator
communicate_image_data rover0 general objective1 colour waypoint3 waypoint1
2
1 3
18 0
2
0 0 0 1
0 9 -1 0
0
end_operator
begin_operator
communicate_image_data rover0 general objective1 high_res waypoint0 waypoint1
2
1 0
19 0
2
0 0 0 1
0 10 -1 0
0
end_operator
begin_operator
communicate_image_data rover0 general objective1 high_res waypoint2 waypoint1
2
1 2
19 0
2
0 0 0 1
0 10 -1 0
0
end_operator
begin_operator
communicate_image_data rover0 general objective1 high_res waypoint3 waypoint1
2
1 3
19 0
2
0 0 0 1
0 10 -1 0
0
end_operator
begin_operator
communicate_image_data rover0 general objective1 low_res waypoint0 waypoint1
2
1 0
20 0
2
0 0 0 1
0 11 -1 0
0
end_operator
begin_operator
communicate_image_data rover0 general objective1 low_res waypoint2 waypoint1
2
1 2
20 0
2
0 0 0 1
0 11 -1 0
0
end_operator
begin_operator
communicate_image_data rover0 general objective1 low_res waypoint3 waypoint1
2
1 3
20 0
2
0 0 0 1
0 11 -1 0
0
end_operator
begin_operator
communicate_rock_data rover0 general waypoint0 waypoint0 waypoint1
2
1 0
2 1
2
0 0 0 1
0 12 -1 0
0
end_operator
begin_operator
communicate_rock_data rover0 general waypoint0 waypoint2 waypoint1
2
1 2
2 1
2
0 0 0 1
0 12 -1 0
0
end_operator
begin_operator
communicate_rock_data rover0 general waypoint0 waypoint3 waypoint1
2
1 3
2 1
2
0 0 0 1
0 12 -1 0
0
end_operator
begin_operator
communicate_soil_data rover0 general waypoint0 waypoint0 waypoint1
2
1 0
3 1
2
0 0 0 1
0 13 -1 0
0
end_operator
begin_operator
communicate_soil_data rover0 general waypoint0 waypoint2 waypoint1
2
1 2
3 1
2
0 0 0 1
0 13 -1 0
0
end_operator
begin_operator
communicate_soil_data rover0 general waypoint0 waypoint3 waypoint1
2
1 3
3 1
2
0 0 0 1
0 13 -1 0
0
end_operator
begin_operator
drop rover0 rover0store
0
2
0 0 0 1
0 14 1 0
0
end_operator
begin_operator
navigate rover0 waypoint0 waypoint1
0
2
0 0 0 1
0 1 0 1
0
end_operator
begin_operator
navigate rover0 waypoint0 waypoint2
0
2
0 0 0 1
0 1 0 2
0
end_operator
begin_operator
navigate rover0 waypoint0 waypoint3
0
2
0 0 0 1
0 1 0 3
0
end_operator
begin_operator
navigate rover0 waypoint1 waypoint0
0
2
0 0 0 1
0 1 1 0
0
end_operator
begin_operator
navigate rover0 waypoint2 waypoint0
0
2
0 0 0 1
0 1 2 0
0
end_operator
begin_operator
navigate rover0 waypoint3 waypoint0
0
2
0 0 0 1
0 1 3 0
0
end_operator
begin_operator
sample_rock rover0 rover0store waypoint0
1
1 0
3
0 0 0 1
0 2 0 1
0 14 0 1
0
end_operator
begin_operator
sample_soil rover0 rover0store waypoint0
1
1 0
3
0 0 0 1
0 3 0 1
0 14 0 1
0
end_operator
begin_operator
take_image rover0 waypoint0 objective0 camera0 colour
1
1 0
3
0 0 0 1
0 4 0 1
0 15 -1 0
0
end_operator
begin_operator
take_image rover0 waypoint0 objective0 camera0 high_res
1
1 0
3
0 0 0 1
0 4 0 1
0 16 -1 0
0
end_operator
begin_operator
take_image rover0 waypoint0 objective0 camera0 low_res
1
1 0
3
0 0 0 1
0 4 0 1
0 17 -1 0
0
end_operator
begin_operator
take_image rover0 waypoint0 objective0 camera1 high_res
1
1 0
3
0 0 0 1
0 5 0 1
0 16 -1 0
0
end_operator
begin_operator
take_image rover0 waypoint0 objective1 camera0 colour
1
1 0
3
0 0 0 1
0 4 0 1
0 18 -1 0
0
end_operator
begin_operator
take_image rover0 waypoint0 objective1 camera0 high_res
1
1 0
3
0 0 0 1
0 4 0 1
0 19 -1 0
0
end_operator
begin_operator
take_image rover0 waypoint0 objective1 camera0 low_res
1
1 0
3
0 0 0 1
0 4 0 1
0 20 -1 0
0
end_operator
begin_operator
take_image rover0 waypoint0 objective1 camera1 high_res
1
1 0
3
0 0 0 1
0 5 0 1
0 19 -1 0
0
end_operator
begin_operator
take_image rover0 waypoint1 objective1 camera0 colour
1
1 1
3
0 0 0 1
0 4 0 1
0 18 -1 0
0
end_operator
begin_operator
take_image rover0 waypoint1 objective1 camera0 high_res
1
1 1
3
0 0 0 1
0 4 0 1
0 19 -1 0
0
end_operator
begin_operator
take_image rover0 waypoint1 objective1 camera0 low_res
1
1 1
3
0 0 0 1
0 4 0 1
0 20 -1 0
0
end_operator
begin_operator
take_image rover0 waypoint1 objective1 camera1 high_res
1
1 1
3
0 0 0 1
0 5 0 1
0 19 -1 0
0
end_operator
begin_operator
take_image rover0 waypoint2 objective1 camera0 colour
1
1 2
3
0 0 0 1
0 4 0 1
0 18 -1 0
0
end_operator
begin_operator
take_image rover0 waypoint2 objective1 camera0 high_res
1
1 2
3
0 0 0 1
0 4 0 1
0 19 -1 0
0
end_operator
begin_operator
take_image rover0 waypoint2 objective1 camera0 low_res
1
1 2
3
0 0 0 1
0 4 0 1
0 20 -1 0
0
end_operator
begin_operator
take_image rover0 waypoint2 objective1 camera1 high_res
1
1 2
3
0 0 0 1
0 5 0 1
0 19 -1 0
0
end_operator
begin_operator
verify_always 
3
1 0
3 0
20 1
5
0 0 -1 0
1 2 1 22 -1 0
1 4 0 23 -1 0
1 3 1 24 -1 0
1 2 1 25 -1 0
0
end_operator
begin_operator
verify_always 
4
1 0
3 0
20 1
22 0
4
0 0 -1 0
1 4 0 23 -1 0
1 3 1 24 -1 0
1 2 1 25 -1 0
0
end_operator
begin_operator
verify_always 
5
1 0
3 0
20 1
22 0
24 0
3
0 0 -1 0
1 4 0 23 -1 0
1 2 1 25 -1 0
0
end_operator
begin_operator
verify_always 
5
1 0
3 0
20 1
22 0
25 0
3
0 0 -1 0
1 4 0 23 -1 0
1 3 1 24 -1 0
0
end_operator
begin_operator
verify_always 
4
1 0
3 0
20 1
23 0
4
0 0 -1 0
1 2 1 22 -1 0
1 3 1 24 -1 0
1 2 1 25 -1 0
0
end_operator
begin_operator
verify_always 
5
1 0
3 0
20 1
23 0
24 0
3
0 0 -1 0
1 2 1 22 -1 0
1 2 1 25 -1 0
0
end_operator
begin_operator
verify_always 
5
1 0
3 0
20 1
23 0
25 0
3
0 0 -1 0
1 2 1 22 -1 0
1 3 1 24 -1 0
0
end_operator
begin_operator
verify_always 
4
1 0
3 0
20 1
24 0
4
0 0 -1 0
1 2 1 22 -1 0
1 4 0 23 -1 0
1 2 1 25 -1 0
0
end_operator
begin_operator
verify_always 
4
1 0
3 0
20 1
25 0
4
0 0 -1 0
1 2 1 22 -1 0
1 4 0 23 -1 0
1 3 1 24 -1 0
0
end_operator
begin_operator
verify_always 
5
1 0
3 0
22 0
24 0
25 0
2
0 0 -1 0
1 4 0 23 -1 0
0
end_operator
begin_operator
verify_always 
5
1 0
3 0
23 0
24 0
25 0
2
0 0 -1 0
1 2 1 22 -1 0
0
end_operator
begin_operator
verify_always 
4
1 0
3 0
24 0
25 0
3
0 0 -1 0
1 2 1 22 -1 0
1 4 0 23 -1 0
0
end_operator
begin_operator
verify_always 
4
1 0
20 1
22 0
23 0
3
0 0 -1 0
1 3 1 24 -1 0
1 2 1 25 -1 0
0
end_operator
begin_operator
verify_always 
5
1 0
20 1
22 0
23 0
24 0
2
0 0 -1 0
1 2 1 25 -1 0
0
end_operator
begin_operator
verify_always 
5
1 0
20 1
22 0
23 0
25 0
2
0 0 -1 0
1 3 1 24 -1 0
0
end_operator
begin_operator
verify_always 
5
1 0
22 0
23 0
24 0
25 0
1
0 0 -1 0
0
end_operator
begin_operator
verify_sometime-0 
1
4 0
1
0 21 -1 0
0
end_operator
0
