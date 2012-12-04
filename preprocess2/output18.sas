begin_version
3
end_version
begin_metric
0
end_metric
10
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
2
Atom is_run(s1)
<none of those>
end_variable
begin_variable
var2
-1
2
Atom is_run(s2)
<none of those>
end_variable
begin_variable
var3
1
2
Atom new-axiom@0(pc1)
<none of those>
end_variable
begin_variable
var4
1
2
Atom new-axiom@0(pc2)
<none of those>
end_variable
begin_variable
var5
1
2
Atom new-axiom@1()
<none of those>
end_variable
begin_variable
var6
-1
2
Atom refer(pc1, s1)
<none of those>
end_variable
begin_variable
var7
-1
2
Atom refer(pc1, s2)
<none of those>
end_variable
begin_variable
var8
-1
2
Atom refer(pc2, s1)
<none of those>
end_variable
begin_variable
var9
-1
2
Atom refer(pc2, s2)
<none of those>
end_variable
0
begin_state
1
0
1
0
0
1
0
1
0
1
end_state
begin_goal
1
5 0
end_goal
16
begin_operator
redirect_from_to pc1 s1 s2
0
3
0 0 0 1
0 6 0 1
0 7 1 0
0
end_operator
begin_operator
redirect_from_to pc1 s2 s1
0
3
0 0 0 1
0 6 1 0
0 7 0 1
0
end_operator
begin_operator
redirect_from_to pc2 s1 s2
0
3
0 0 0 1
0 8 0 1
0 9 1 0
0
end_operator
begin_operator
redirect_from_to pc2 s2 s1
0
3
0 0 0 1
0 8 1 0
0 9 0 1
0
end_operator
begin_operator
set_refer_to pc1 s1
1
3 1
2
0 0 0 1
0 6 -1 0
0
end_operator
begin_operator
set_refer_to pc1 s2
1
3 1
2
0 0 0 1
0 7 -1 0
0
end_operator
begin_operator
set_refer_to pc2 s1
1
4 1
2
0 0 0 1
0 8 -1 0
0
end_operator
begin_operator
set_refer_to pc2 s2
1
4 1
2
0 0 0 1
0 9 -1 0
0
end_operator
begin_operator
start-service s1
0
2
0 0 0 1
0 1 1 0
0
end_operator
begin_operator
start-service s2
0
2
0 0 0 1
0 2 1 0
0
end_operator
begin_operator
stop-service s1
0
2
0 0 0 1
0 1 0 1
0
end_operator
begin_operator
stop-service s2
0
2
0 0 0 1
0 2 0 1
0
end_operator
begin_operator
verify_always 
4
1 0
2 0
6 0
9 0
1
0 0 -1 0
0
end_operator
begin_operator
verify_always 
4
1 0
2 0
7 0
8 0
1
0 0 -1 0
0
end_operator
begin_operator
verify_always 
3
1 0
6 0
8 0
1
0 0 -1 0
0
end_operator
begin_operator
verify_always 
3
2 0
7 0
9 0
1
0 0 -1 0
0
end_operator
3
begin_rule
5
0 0
1 1
2 0
7 0
9 0
5 1 0
end_rule
begin_rule
2
6 1
7 1
3 0 1
end_rule
begin_rule
2
8 1
9 1
4 0 1
end_rule
