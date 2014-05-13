
(define (problem os-softpreferences-shawinstances-24)
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
         (waiting o1) (includes o1 p4) (includes o1 p10) (includes o1 p12)
         (includes o1 p17) (includes o1 p19) (includes o1 p20) (waiting o2)
         (includes o2 p1) (includes o2 p5) (includes o2 p9) (includes o2 p10)
         (includes o2 p15) (includes o2 p16) (includes o2 p17) (waiting o3)
         (includes o3 p7) (includes o3 p11) (includes o3 p12) (includes o3 p14)
         (includes o3 p19) (waiting o4) (includes o4 p2) (waiting o5)
         (includes o5 p8) (includes o5 p14) (includes o5 p15) (includes o5 p16)
         (waiting o6) (includes o6 p2) (includes o6 p4) (includes o6 p8)
         (includes o6 p13) (includes o6 p18) (waiting o7) (includes o7 p3)
         (includes o7 p4) (includes o7 p18) (waiting o8) (includes o8 p2)
         (includes o8 p6) (includes o8 p11) (includes o8 p13) (waiting o9)
         (includes o9 p5) (includes o9 p14) (includes o9 p16) (includes o9 p17)
         (waiting o10) (includes o10 p2) (includes o10 p5) (includes o10 p8)
         (includes o10 p19) (waiting o11) (includes o11 p1) (includes o11 p2)
         (includes o11 p4) (includes o11 p5) (includes o11 p9)
         (includes o11 p11) (includes o11 p14) (includes o11 p15)
         (includes o11 p17) (includes o11 p18) (includes o11 p19)
         (includes o11 p20) (waiting o12) (includes o12 p1) (includes o12 p3)
         (includes o12 p4) (includes o12 p7) (includes o12 p9)
         (includes o12 p10) (includes o12 p12) (includes o12 p17)
         (includes o12 p18) (includes o12 p20) (waiting o13) (includes o13 p3)
         (includes o13 p9) (includes o13 p15) (waiting o14) (includes o14 p1)
         (includes o14 p3) (includes o14 p9) (includes o14 p11)
         (includes o14 p16) (includes o14 p20) (waiting o15) (includes o15 p1)
         (includes o15 p5) (includes o15 p8) (includes o15 p9)
         (includes o15 p11) (includes o15 p13) (includes o15 p14)
         (includes o15 p19) (includes o15 p20) (waiting o16) (includes o16 p5)
         (includes o16 p8) (includes o16 p9) (includes o16 p13)
         (includes o16 p14) (includes o16 p15) (includes o16 p16)
         (includes o16 p17) (includes o16 p18) (waiting o17) (includes o17 p5)
         (includes o17 p6) (includes o17 p7) (includes o17 p9)
         (includes o17 p14) (includes o17 p16) (includes o17 p17)
         (includes o17 p19) (waiting o18) (includes o18 p6) (includes o18 p7)
         (includes o18 p10) (includes o18 p12) (waiting o19) (includes o19 p3)
         (includes o19 p8) (includes o19 p11) (includes o19 p13)
         (includes o19 p15) (includes o19 p18) (includes o19 p20) (waiting o20)
         (includes o20 p1) (includes o20 p2) (includes o20 p4)
         (includes o20 p7) (includes o20 p8) (includes o20 p11)
         (includes o20 p13) (includes o20 p16) (includes o20 p17))
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
               (delivered o1 p4)
               (delivered o1 p10)
               (delivered o1 p12)
               (delivered o1 p17)
               (delivered o1 p19)
               (delivered o1 p20)
               (delivered o2 p1)
               (delivered o2 p5)
               (delivered o2 p9)
               (delivered o2 p10)
               (delivered o2 p15)
               (delivered o2 p16)
               (delivered o2 p17)
               (delivered o3 p7)
               (delivered o3 p11)
               (delivered o3 p12)
               (delivered o3 p14)
               (delivered o3 p19)
               (delivered o4 p2)
               (delivered o5 p8)
               (delivered o5 p14)
               (delivered o5 p15)
               (delivered o5 p16)
               (delivered o6 p2)
               (delivered o6 p4)
               (delivered o6 p8)
               (delivered o6 p13)
               (delivered o6 p18)
               (delivered o7 p3)
               (delivered o7 p4)
               (delivered o7 p18)
               (delivered o8 p2)
               (delivered o8 p6)
               (delivered o8 p11)
               (delivered o8 p13)
               (delivered o9 p5)
               (delivered o9 p14)
               (delivered o9 p16)
               (delivered o9 p17)
               (delivered o10 p2)
               (delivered o10 p5)
               (delivered o10 p8)
               (delivered o10 p19)
               (delivered o11 p1)
               (delivered o11 p2)
               (delivered o11 p4)
               (delivered o11 p5)
               (delivered o11 p9)
               (delivered o11 p11)
               (delivered o11 p14)
               (delivered o11 p15)
               (delivered o11 p17)
               (delivered o11 p18)
               (delivered o11 p19)
               (delivered o11 p20)
               (delivered o12 p1)
               (delivered o12 p3)
               (delivered o12 p4)
               (delivered o12 p7)
               (delivered o12 p9)
               (delivered o12 p10)
               (delivered o12 p12)
               (delivered o12 p17)
               (delivered o12 p18)
               (delivered o12 p20)
               (delivered o13 p3)
               (delivered o13 p9)
               (delivered o13 p15)
               (delivered o14 p1)
               (delivered o14 p3)
               (delivered o14 p9)
               (delivered o14 p11)
               (delivered o14 p16)
               (delivered o14 p20)
               (delivered o15 p1)
               (delivered o15 p5)
               (delivered o15 p8)
               (delivered o15 p9)
               (delivered o15 p11)
               (delivered o15 p13)
               (delivered o15 p14)
               (delivered o15 p19)
               (delivered o15 p20)
               (delivered o16 p5)
               (delivered o16 p8)
               (delivered o16 p9)
               (delivered o16 p13)
               (delivered o16 p14)
               (delivered o16 p15)
               (delivered o16 p16)
               (delivered o16 p17)
               (delivered o16 p18)
               (delivered o17 p5)
               (delivered o17 p6)
               (delivered o17 p7)
               (delivered o17 p9)
               (delivered o17 p14)
               (delivered o17 p16)
               (delivered o17 p17)
               (delivered o17 p19)
               (delivered o18 p6)
               (delivered o18 p7)
               (delivered o18 p10)
               (delivered o18 p12)
               (delivered o19 p3)
               (delivered o19 p8)
               (delivered o19 p11)
               (delivered o19 p13)
               (delivered o19 p15)
               (delivered o19 p18)
               (delivered o19 p20)
               (delivered o20 p1)
               (delivered o20 p2)
               (delivered o20 p4)
               (delivered o20 p7)
               (delivered o20 p8)
               (delivered o20 p11)
               (delivered o20 p13)
               (delivered o20 p16)
               (delivered o20 p17)
;;--- end of goal preferences ---;;
        ))
        (:constraints (and 
               (always (not (stacks-in-use n1)))
               (always (not (stacks-in-use n2)))
               (always (not (stacks-in-use n3)))
               (always (not (stacks-in-use n4)))
               (always (not (stacks-in-use n5)))
               (always (not (stacks-in-use n6)))
               (always (not (stacks-in-use n7)))
               (always (not (stacks-in-use n8)))
               (always (not (stacks-in-use n9)))
               (always (not (stacks-in-use n10)))
               (always (not (stacks-in-use n11)))
               (always (not (stacks-in-use n12)))
               (always (not (stacks-in-use n13)))
               (always (not (stacks-in-use n14)))
               (always (not (stacks-in-use n15)))
               (always (not (stacks-in-use n16)))
               (always (not (stacks-in-use n17)))
               (always (not (stacks-in-use n18)))
               (always (not (stacks-in-use n19)))
               (always (not (stacks-in-use n20)))
        ))
        (:metric minimize (total-time))
)
