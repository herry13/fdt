; Goal preferences: 69
; Trajectories: 14


(define (problem os-softpreferences-wbop_20_20-21)
        (:domain openstacks-softpreferences)
        (:objects n0 - count n1 - count n2 - count n3 - count n4 - count n5 -
         count n6 - count n7 - count n8 - count n9 - count n10 - count n11 -
         count n12 - count n13 - count n14 - count n15 - count n16 - count n17
         - count n18 - count n19 - count n20 - count o1 - order o2 - order o3 -
         order o4 - order o5 - order o6 - order o7 - order o8 - order o9 -
         order o10 - order o11 - order o12 - order o13 - order o14 - order o15
         - order o16 - order o17 - order o18 - order o19 - order o20 - order p1
         - product p2 - product p3 - product p4 - product p5 - product p6 -
         product p7 - product p8 - product p9 - product p10 - product p11 -
         product p12 - product p13 - product p14 - product p15 - product p16 -
         product p17 - product p18 - product p19 - product p20 - product)
        (:init (next-count n0 n1) (next-count n1 n2) (next-count n2 n3)
         (next-count n3 n4) (next-count n4 n5) (next-count n5 n6)
         (next-count n6 n7) (next-count n7 n8) (next-count n8 n9)
         (next-count n9 n10) (next-count n10 n11) (next-count n11 n12)
         (next-count n12 n13) (next-count n13 n14) (next-count n14 n15)
         (next-count n15 n16) (next-count n16 n17) (next-count n17 n18)
         (next-count n18 n19) (next-count n19 n20) (stacks-in-use n0)
         (waiting o1) (includes o1 p11) (includes o1 p13) (includes o1 p16)
         (includes o1 p19) (waiting o2) (includes o2 p7) (includes o2 p9)
         (includes o2 p12) (includes o2 p18) (waiting o3) (includes o3 p2)
         (includes o3 p3) (includes o3 p6) (includes o3 p16) (waiting o4)
         (includes o4 p1) (includes o4 p3) (includes o4 p14) (includes o4 p15)
         (waiting o5) (includes o5 p1) (includes o5 p6) (includes o5 p13)
         (includes o5 p15) (waiting o6) (includes o6 p1) (includes o6 p8)
         (includes o6 p16) (includes o6 p19) (waiting o7) (includes o7 p1)
         (includes o7 p3) (includes o7 p9) (includes o7 p11) (waiting o8)
         (includes o8 p4) (includes o8 p10) (includes o8 p18) (includes o8 p20)
         (waiting o9) (includes o9 p4) (includes o9 p8) (includes o9 p14)
         (includes o9 p19) (waiting o10) (includes o10 p2) (includes o10 p4)
         (includes o10 p6) (includes o10 p17) (waiting o11) (includes o11 p10)
         (includes o11 p12) (includes o11 p17) (includes o11 p19) (waiting o12)
         (includes o12 p7) (includes o12 p13) (includes o12 p15)
         (includes o12 p20) (waiting o13) (includes o13 p7) (includes o13 p10)
         (includes o13 p12) (includes o13 p20) (waiting o14) (includes o14 p5)
         (includes o14 p8) (includes o14 p11) (includes o14 p18) (waiting o15)
         (includes o15 p3) (includes o15 p4) (includes o15 p5)
         (includes o15 p16) (waiting o16) (includes o16 p9) (includes o16 p13)
         (includes o16 p15) (includes o16 p18) (waiting o17) (includes o17 p2)
         (includes o17 p5) (includes o17 p14) (includes o17 p17) (waiting o18)
         (includes o18 p6) (includes o18 p8) (includes o18 p9)
         (includes o18 p11) (waiting o19) (includes o19 p7) (includes o19 p12)
         (includes o19 p14) (includes o19 p20) (waiting o20) (includes o20 p2)
         (includes o20 p5) (includes o20 p10) (includes o20 p17))
        (:goal
         (and (shipped o1)
              (shipped o2)
              (shipped o3)
              (shipped o4)
              (shipped o5)
              (shipped o6)
              (shipped o7)
              (shipped o8)
              (shipped o9)
              (shipped o10)
              (shipped o11)
              (shipped o12)
              (shipped o13)
              (shipped o14)
              (shipped o15)
              (shipped o16)
              (shipped o17)
              (shipped o18)
              (shipped o19)
              (shipped o20)
;;--- start of goal preferences ---;;
              (delivered o4 p1)
              (delivered o13 p7)
              (and (delivered o13 p12) (delivered o13 p10) (delivered o13 p7))
              (and (delivered o13 p10) (delivered o13 p7))
              (delivered o20 p2)
              (and (delivered o11 p12) (delivered o11 p10))
              (delivered o1 p11)
              (and (delivered o3 p3) (delivered o3 p2))
              (and (delivered o8 p10) (delivered o8 p4))
              (and (delivered o4 p14) (delivered o4 p3) (delivered o4 p1))
              (and (delivered o9 p8) (delivered o9 p4))
              (delivered o7 p1)
              (and (delivered o7 p3) (delivered o7 p1))
              (and (delivered o6 p19) (delivered o6 p16) (delivered o6 p8) (delivered o6 p1))
              (and (delivered o20 p10) (delivered o20 p5) (delivered o20 p2))
              (and (delivered o2 p9) (delivered o2 p7))
              (and (delivered o16 p18) (delivered o16 p15) (delivered o16 p13) (delivered o16 p9))
              (delivered o16 p9)
              (and (delivered o12 p15) (delivered o12 p13) (delivered o12 p7))
              (and (delivered o3 p6) (delivered o3 p3) (delivered o3 p2))
              (and (delivered o11 p19) (delivered o11 p17) (delivered o11 p12) (delivered o11 p10))
              (and (delivered o14 p11) (delivered o14 p8) (delivered o14 p5))
              (and (delivered o6 p16) (delivered o6 p8) (delivered o6 p1))
              (and (delivered o4 p15) (delivered o4 p14) (delivered o4 p3) (delivered o4 p1))
              (delivered o10 p2)
              (and (delivered o12 p13) (delivered o12 p7))
              (and (delivered o15 p5) (delivered o15 p4) (delivered o15 p3))
              (and (delivered o6 p8) (delivered o6 p1))
              (and (delivered o16 p13) (delivered o16 p9))
              (and (delivered o18 p8) (delivered o18 p6))
              (and (delivered o17 p5) (delivered o17 p2))
              (delivered o9 p4)
              (and (delivered o19 p12) (delivered o19 p7))
              (and (delivered o20 p5) (delivered o20 p2))
              (and (delivered o17 p17) (delivered o17 p14) (delivered o17 p5) (delivered o17 p2))
              (and (delivered o1 p16) (delivered o1 p13) (delivered o1 p11))
              (delivered o19 p7)
              (and (delivered o10 p4) (delivered o10 p2))
              (and (delivered o11 p17) (delivered o11 p12) (delivered o11 p10))
              (and (delivered o10 p17) (delivered o10 p6) (delivered o10 p4) (delivered o10 p2))
              (and (delivered o9 p19) (delivered o9 p14) (delivered o9 p8) (delivered o9 p4))
              (delivered o14 p5)
              (and (delivered o5 p13) (delivered o5 p6) (delivered o5 p1))
              (delivered o15 p3)
              (and (delivered o2 p18) (delivered o2 p12) (delivered o2 p9) (delivered o2 p7))
              (delivered o8 p4)
              (and (delivered o8 p18) (delivered o8 p10) (delivered o8 p4))
              (and (delivered o18 p11) (delivered o18 p9) (delivered o18 p8) (delivered o18 p6))
              (delivered o2 p7)
              (and (delivered o14 p18) (delivered o14 p11) (delivered o14 p8) (delivered o14 p5))
              (and (delivered o16 p15) (delivered o16 p13) (delivered o16 p9))
              (and (delivered o7 p11) (delivered o7 p9) (delivered o7 p3) (delivered o7 p1))
              (and (delivered o19 p20) (delivered o19 p14) (delivered o19 p12) (delivered o19 p7))
              (delivered o6 p1)
              (and (delivered o1 p13) (delivered o1 p11))
              (delivered o18 p6)
              (and (delivered o1 p19) (delivered o1 p16) (delivered o1 p13) (delivered o1 p11))
              (and (delivered o4 p3) (delivered o4 p1))
              (and (delivered o2 p12) (delivered o2 p9) (delivered o2 p7))
              (and (delivered o12 p20) (delivered o12 p15) (delivered o12 p13) (delivered o12 p7))
              (delivered o3 p2)
              (and (delivered o7 p9) (delivered o7 p3) (delivered o7 p1))
              (and (delivered o14 p8) (delivered o14 p5))
              (and (delivered o8 p20) (delivered o8 p18) (delivered o8 p10) (delivered o8 p4))
              (delivered o12 p7)
              (and (delivered o13 p20) (delivered o13 p12) (delivered o13 p10) (delivered o13 p7))
              (and (delivered o5 p6) (delivered o5 p1))
              (and (delivered o10 p6) (delivered o10 p4) (delivered o10 p2))
              (and (delivered o20 p17) (delivered o20 p10) (delivered o20 p5) (delivered o20 p2))
;;--- end of goal preferences ---;;
        (:constraints (and
              (always (not (stacks-in-use n17)))
              (always (not (stacks-in-use n1)))
              (always (not (stacks-in-use n5)))
              (always (not (stacks-in-use n14)))
              (always (not (stacks-in-use n20)))
              (always (not (stacks-in-use n2)))
              (always (not (stacks-in-use n15)))
              (always (not (stacks-in-use n7)))
              (always (not (stacks-in-use n18)))
              (always (not (stacks-in-use n9)))
              (always (not (stacks-in-use n8)))
              (always (not (stacks-in-use n19)))
              (always (not (stacks-in-use n16)))
              (always (not (stacks-in-use n13)))
        ))
        ))
        (:metric minimize (total-time))
)
