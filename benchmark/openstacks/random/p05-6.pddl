; Goal preferences: 1
; Trajectories: 3


(define (problem os-softpreferences-wbop_20_20-12)
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
         (waiting o1) (includes o1 p2) (includes o1 p15) (includes o1 p18)
         (waiting o2) (includes o2 p3) (includes o2 p16) (includes o2 p19)
         (waiting o3) (includes o3 p7) (includes o3 p12) (includes o3 p14)
         (waiting o4) (includes o4 p1) (includes o4 p11) (includes o4 p20)
         (waiting o5) (includes o5 p6) (includes o5 p14) (includes o5 p20)
         (waiting o6) (includes o6 p13) (includes o6 p15) (includes o6 p19)
         (waiting o7) (includes o7 p5) (includes o7 p13) (includes o7 p16)
         (waiting o8) (includes o8 p7) (includes o8 p10) (includes o8 p17)
         (waiting o9) (includes o9 p3) (includes o9 p7) (includes o9 p8)
         (waiting o10) (includes o10 p4) (includes o10 p13) (includes o10 p20)
         (waiting o11) (includes o11 p9) (includes o11 p11) (includes o11 p17)
         (waiting o12) (includes o12 p8) (includes o12 p12) (includes o12 p18)
         (waiting o13) (includes o13 p1) (includes o13 p10) (includes o13 p18)
         (waiting o14) (includes o14 p15) (includes o14 p16) (includes o14 p17)
         (waiting o15) (includes o15 p2) (includes o15 p4) (includes o15 p14)
         (waiting o16) (includes o16 p5) (includes o16 p6) (includes o16 p9)
         (waiting o17) (includes o17 p2) (includes o17 p3) (includes o17 p6)
         (waiting o18) (includes o18 p8) (includes o18 p12) (includes o18 p19)
         (waiting o19) (includes o19 p1) (includes o19 p4) (includes o19 p10)
         (waiting o20) (includes o20 p5) (includes o20 p9) (includes o20 p11))
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
              (and (delivered o3 p14) (delivered o3 p12) (delivered o3 p7))
;;--- end of goal preferences ---;;
        (:constraints (and
              (always (not (stacks-in-use n11)))
              (always (not (stacks-in-use n6)))
              (always (not (stacks-in-use n7)))
        ))
        ))
        (:metric minimize (total-time))
)
