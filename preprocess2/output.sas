begin_version
3
end_version
begin_metric
0
end_metric
15
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
-1
2
Atom is_run(s3)
<none of those>
end_variable
begin_variable
var4
1
2
Atom new-axiom@0(c1)
<none of those>
end_variable
begin_variable
var5
1
2
Atom new-axiom@0(c2)
<none of those>
end_variable
begin_variable
var6
1
2
Atom new-axiom@1()
<none of those>
end_variable
begin_variable
var7
-1
2
Atom refer(c1, s1)
<none of those>
end_variable
begin_variable
var8
-1
2
Atom refer(c1, s2)
<none of those>
end_variable
begin_variable
var9
-1
2
Atom refer(c1, s3)
<none of those>
end_variable
begin_variable
var10
-1
2
Atom refer(c2, s1)
<none of those>
end_variable
begin_variable
var11
-1
2
Atom refer(c2, s2)
<none of those>
end_variable
begin_variable
var12
-1
2
Atom refer(c2, s3)
<none of those>
end_variable
begin_variable
var13
-1
2
Atom sometime-0()
<none of those>
end_variable
begin_variable
var14
-1
2
Atom sometime_before_2-0()
<none of those>
end_variable
0
begin_state
1
0
0
1
0
0
0
0
1
1
0
1
1
1
1
end_state
begin_goal
4
0 0
1 1
6 1
13 0
end_goal
26
begin_operator
redirect_from_to c1 s1 s2
0
3
0 0 0 1
0 7 0 1
0 8 1 0
0
end_operator
begin_operator
redirect_from_to c1 s1 s3
0
3
0 0 0 1
0 7 0 1
0 9 1 0
0
end_operator
begin_operator
redirect_from_to c1 s2 s1
0
3
0 0 0 1
0 7 1 0
0 8 0 1
0
end_operator
begin_operator
redirect_from_to c1 s2 s3
0
3
0 0 0 1
0 8 0 1
0 9 1 0
0
end_operator
begin_operator
redirect_from_to c1 s3 s1
0
3
0 0 0 1
0 7 1 0
0 9 0 1
0
end_operator
begin_operator
redirect_from_to c1 s3 s2
0
3
0 0 0 1
0 8 1 0
0 9 0 1
0
end_operator
begin_operator
redirect_from_to c2 s1 s2
0
3
0 0 0 1
0 10 0 1
0 11 1 0
0
end_operator
begin_operator
redirect_from_to c2 s1 s3
0
3
0 0 0 1
0 10 0 1
0 12 1 0
0
end_operator
begin_operator
redirect_from_to c2 s2 s1
0
3
0 0 0 1
0 10 1 0
0 11 0 1
0
end_operator
begin_operator
redirect_from_to c2 s2 s3
0
3
0 0 0 1
0 11 0 1
0 12 1 0
0
end_operator
begin_operator
redirect_from_to c2 s3 s1
0
3
0 0 0 1
0 10 1 0
0 12 0 1
0
end_operator
begin_operator
redirect_from_to c2 s3 s2
0
3
0 0 0 1
0 11 1 0
0 12 0 1
0
end_operator
begin_operator
set_refer_to c1 s1
1
4 1
2
0 0 0 1
0 7 -1 0
0
end_operator
begin_operator
set_refer_to c1 s2
1
4 1
2
0 0 0 1
0 8 -1 0
0
end_operator
begin_operator
set_refer_to c1 s3
1
4 1
2
0 0 0 1
0 9 -1 0
0
end_operator
begin_operator
set_refer_to c2 s1
1
5 1
2
0 0 0 1
0 10 -1 0
0
end_operator
begin_operator
set_refer_to c2 s2
1
5 1
2
0 0 0 1
0 11 -1 0
0
end_operator
begin_operator
set_refer_to c2 s3
1
5 1
2
0 0 0 1
0 12 -1 0
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
start-service s3
0
2
0 0 0 1
0 3 1 0
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
stop-service s3
0
2
0 0 0 1
0 3 0 1
0
end_operator
begin_operator
verify_always 
1
1 0
3
0 0 -1 0
1 1 1 13 -1 0
1 2 1 14 -1 0
0
end_operator
begin_operator
verify_always 
1
14 0
2
0 0 -1 0
1 1 1 13 -1 0
0
end_operator
30
begin_rule
3
1 0
2 0
3 0
6 0 1
end_rule
begin_rule
6
1 0
2 0
7 1
8 1
9 1
12 1
6 0 1
end_rule
begin_rule
6
1 0
2 0
7 1
9 1
11 1
12 1
6 0 1
end_rule
begin_rule
5
1 0
2 0
7 1
9 1
12 1
6 0 1
end_rule
begin_rule
6
1 0
2 0
8 1
9 1
10 1
12 1
6 0 1
end_rule
begin_rule
5
1 0
2 0
8 1
9 1
12 1
6 0 1
end_rule
begin_rule
6
1 0
2 0
9 1
10 1
11 1
12 1
6 0 1
end_rule
begin_rule
5
1 0
2 0
9 1
10 1
12 1
6 0 1
end_rule
begin_rule
5
1 0
2 0
9 1
11 1
12 1
6 0 1
end_rule
begin_rule
4
1 0
2 0
9 1
12 1
6 0 1
end_rule
begin_rule
6
1 0
3 0
7 1
8 1
9 1
11 1
6 0 1
end_rule
begin_rule
5
1 0
3 0
7 1
8 1
11 1
6 0 1
end_rule
begin_rule
6
1 0
3 0
7 1
8 1
11 1
12 1
6 0 1
end_rule
begin_rule
6
1 0
3 0
8 1
9 1
10 1
11 1
6 0 1
end_rule
begin_rule
5
1 0
3 0
8 1
9 1
11 1
6 0 1
end_rule
begin_rule
5
1 0
3 0
8 1
10 1
11 1
6 0 1
end_rule
begin_rule
6
1 0
3 0
8 1
10 1
11 1
12 1
6 0 1
end_rule
begin_rule
4
1 0
3 0
8 1
11 1
6 0 1
end_rule
begin_rule
5
1 0
3 0
8 1
11 1
12 1
6 0 1
end_rule
begin_rule
6
1 0
7 1
8 1
9 1
11 1
12 1
6 0 1
end_rule
begin_rule
6
1 0
8 1
9 1
10 1
11 1
12 1
6 0 1
end_rule
begin_rule
5
1 0
8 1
9 1
11 1
12 1
6 0 1
end_rule
begin_rule
4
2 0
3 0
7 1
10 1
6 0 1
end_rule
begin_rule
6
2 0
7 1
8 1
9 1
10 1
12 1
6 0 1
end_rule
begin_rule
6
2 0
7 1
9 1
10 1
11 1
12 1
6 0 1
end_rule
begin_rule
5
2 0
7 1
9 1
10 1
12 1
6 0 1
end_rule
begin_rule
5
3 0
7 1
8 1
10 1
11 1
6 0 1
end_rule
begin_rule
3
7 1
8 1
9 1
4 0 1
end_rule
begin_rule
6
7 1
8 1
9 1
10 1
11 1
12 1
6 0 1
end_rule
begin_rule
3
10 1
11 1
12 1
5 0 1
end_rule
