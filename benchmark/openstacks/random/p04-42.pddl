; Goal preferences: 5
; Trajectories: 7


(define (problem os-softpreferences-nwrssmaller4-4)
        (:domain openstacks-softpreferences)
        (:objects n0 - count n1 - count n2 - count n3 - count n4 - count n5 -
         count n6 - count n7 - count n8 - count n9 - count n10 - count n11 -
         count n12 - count n13 - count n14 - count n15 - count o1 - order o2 -
         order o3 - order o4 - order o5 - order o6 - order o7 - order o8 -
         order o9 - order o10 - order o11 - order o12 - order o13 - order o14 -
         order o15 - order p1 - product p2 - product p3 - product p4 - product
         p5 - product p6 - product p7 - product p8 - product p9 - product p10 -
         product p11 - product p12 - product p13 - product p14 - product p15 -
         product p16 - product p17 - product p18 - product p19 - product p20 -
         product p21 - product p22 - product p23 - product p24 - product p25 -
         product)
        (:init (next-count n0 n1) (next-count n1 n2) (next-count n2 n3)
         (next-count n3 n4) (next-count n4 n5) (next-count n5 n6)
         (next-count n6 n7) (next-count n7 n8) (next-count n8 n9)
         (next-count n9 n10) (next-count n10 n11) (next-count n11 n12)
         (next-count n12 n13) (next-count n13 n14) (next-count n14 n15)
         (stacks-in-use n0) (waiting o1) (includes o1 p1) (includes o1 p5)
         (includes o1 p7) (includes o1 p11) (includes o1 p12) (includes o1 p13)
         (includes o1 p24) (includes o1 p25) (waiting o2) (includes o2 p2)
         (includes o2 p3) (includes o2 p5) (includes o2 p6) (includes o2 p8)
         (includes o2 p23) (waiting o3) (includes o3 p1) (includes o3 p2)
         (includes o3 p6) (includes o3 p8) (includes o3 p10) (includes o3 p23)
         (waiting o4) (includes o4 p9) (includes o4 p11) (includes o4 p14)
         (includes o4 p17) (includes o4 p18) (includes o4 p21) (waiting o5)
         (includes o5 p7) (includes o5 p9) (includes o5 p15) (includes o5 p17)
         (includes o5 p18) (includes o5 p21) (includes o5 p25) (waiting o6)
         (includes o6 p4) (includes o6 p16) (includes o6 p17) (includes o6 p18)
         (includes o6 p19) (includes o6 p21) (waiting o7) (includes o7 p2)
         (includes o7 p3) (includes o7 p6) (includes o7 p13) (includes o7 p22)
         (includes o7 p24) (waiting o8) (includes o8 p2) (includes o8 p3)
         (includes o8 p10) (includes o8 p22) (includes o8 p23)
         (includes o8 p24) (waiting o9) (includes o9 p3) (includes o9 p8)
         (includes o9 p10) (includes o9 p12) (includes o9 p13)
         (includes o9 p20) (includes o9 p23) (includes o9 p24) (waiting o10)
         (includes o10 p4) (includes o10 p14) (includes o10 p15)
         (includes o10 p17) (includes o10 p19) (includes o10 p21) (waiting o11)
         (includes o11 p2) (includes o11 p7) (includes o11 p9)
         (includes o11 p11) (includes o11 p12) (includes o11 p15)
         (includes o11 p17) (includes o11 p23) (waiting o12) (includes o12 p3)
         (includes o12 p4) (includes o12 p9) (includes o12 p14)
         (includes o12 p15) (includes o12 p16) (includes o12 p18)
         (includes o12 p21) (includes o12 p22) (waiting o13) (includes o13 p4)
         (includes o13 p14) (includes o13 p15) (includes o13 p17)
         (includes o13 p19) (includes o13 p21) (waiting o14) (includes o14 p9)
         (includes o14 p11) (includes o14 p12) (includes o14 p15)
         (includes o14 p20) (includes o14 p25) (waiting o15) (includes o15 p7)
         (includes o15 p12) (includes o15 p20) (includes o15 p22)
         (includes o15 p24) (includes o15 p25))
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
;;--- start of goal preferences ---;;
              (delivered o1 p13)
              (delivered o5 p7)
              (delivered o9 p24)
              (delivered o13 p17)
              (delivered o14 p20)
;;--- end of goal preferences ---;;
        (:constraints (and 
              (always (not (stacks-in-use n15)))
              (always (not (stacks-in-use n4)))
              (always (not (stacks-in-use n5)))
              (always (not (stacks-in-use n8)))
              (always (not (stacks-in-use n14)))
              (always (not (stacks-in-use n13)))
              (always (not (stacks-in-use n7)))
        ))
        ))
        (:metric minimize (total-time))
)
