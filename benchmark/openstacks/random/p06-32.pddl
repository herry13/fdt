; Goal preferences: 10
; Trajectories: 6


(define (problem os-softpreferences-wbop_20_20-14)
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
         (waiting o1) (includes o1 p16) (includes o1 p19) (includes o1 p20)
         (waiting o2) (includes o2 p4) (includes o2 p5) (includes o2 p8)
         (waiting o3) (includes o3 p6) (includes o3 p9) (includes o3 p15)
         (waiting o4) (includes o4 p8) (includes o4 p11) (includes o4 p13)
         (waiting o5) (includes o5 p5) (includes o5 p7) (includes o5 p17)
         (waiting o6) (includes o6 p2) (includes o6 p10) (includes o6 p12)
         (waiting o7) (includes o7 p2) (includes o7 p8) (includes o7 p16)
         (waiting o8) (includes o8 p9) (includes o8 p11) (includes o8 p18)
         (waiting o9) (includes o9 p1) (includes o9 p3) (includes o9 p7)
         (waiting o10) (includes o10 p2) (includes o10 p9) (includes o10 p20)
         (waiting o11) (includes o11 p6) (includes o11 p11) (includes o11 p18)
         (waiting o12) (includes o12 p4) (includes o12 p10) (includes o12 p14)
         (waiting o13) (includes o13 p6) (includes o13 p17) (includes o13 p18)
         (waiting o14) (includes o14 p10) (includes o14 p12) (includes o14 p19)
         (waiting o15) (includes o15 p1) (includes o15 p3) (includes o15 p4)
         (waiting o16) (includes o16 p7) (includes o16 p13) (includes o16 p15)
         (waiting o17) (includes o17 p3) (includes o17 p14) (includes o17 p17)
         (waiting o18) (includes o18 p1) (includes o18 p15) (includes o18 p19)
         (waiting o19) (includes o19 p5) (includes o19 p14) (includes o19 p16)
         (waiting o20) (includes o20 p12) (includes o20 p13)
         (includes o20 p20))
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
              (and (delivered o11 p11) (delivered o11 p6))
              (and (delivered o14 p19) (delivered o14 p12) (delivered o14 p10))
              (and (delivered o15 p4) (delivered o15 p3) (delivered o15 p1))
              (and (delivered o6 p12) (delivered o6 p10) (delivered o6 p2))
              (and (delivered o9 p7) (delivered o9 p3) (delivered o9 p1))
              (and (delivered o3 p15) (delivered o3 p9) (delivered o3 p6))
              (and (delivered o10 p9) (delivered o10 p2))
              (and (delivered o20 p13) (delivered o20 p12))
              (and (delivered o10 p20) (delivered o10 p9) (delivered o10 p2))
              (and (delivered o12 p10) (delivered o12 p4))
;;--- end of goal preferences ---;;
        (:constraints (and
              (always (not (stacks-in-use n19)))
              (always (not (stacks-in-use n18)))
              (always (not (stacks-in-use n11)))
              (always (not (stacks-in-use n16)))
              (always (not (stacks-in-use n4)))
              (always (not (stacks-in-use n20)))
        ))
        ))
        (:metric minimize (total-time))
)
