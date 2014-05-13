; Goal preferences: 58
; Trajectories: 6


(define (problem os-softpreferences-nwrssmaller4-3)
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
         (stacks-in-use n0) (waiting o1) (includes o1 p2) (includes o1 p9)
         (includes o1 p10) (includes o1 p12) (includes o1 p23)
         (includes o1 p24) (waiting o2) (includes o2 p3) (includes o2 p8)
         (includes o2 p14) (includes o2 p17) (includes o2 p18)
         (includes o2 p25) (waiting o3) (includes o3 p5) (includes o3 p7)
         (includes o3 p13) (includes o3 p16) (includes o3 p21)
         (includes o3 p22) (waiting o4) (includes o4 p2) (includes o4 p4)
         (includes o4 p12) (includes o4 p17) (includes o4 p19)
         (includes o4 p25) (waiting o5) (includes o5 p1) (includes o5 p9)
         (includes o5 p10) (includes o5 p12) (includes o5 p19)
         (includes o5 p23) (waiting o6) (includes o6 p6) (includes o6 p7)
         (includes o6 p13) (includes o6 p15) (includes o6 p16)
         (includes o6 p21) (waiting o7) (includes o7 p1) (includes o7 p10)
         (includes o7 p15) (includes o7 p16) (includes o7 p22)
         (includes o7 p23) (waiting o8) (includes o8 p6) (includes o8 p7)
         (includes o8 p13) (includes o8 p15) (includes o8 p16)
         (includes o8 p21) (waiting o9) (includes o9 p5) (includes o9 p6)
         (includes o9 p7) (includes o9 p11) (includes o9 p13) (includes o9 p15)
         (waiting o10) (includes o10 p5) (includes o10 p9) (includes o10 p15)
         (includes o10 p16) (includes o10 p22) (includes o10 p23) (waiting o11)
         (includes o11 p4) (includes o11 p8) (includes o11 p14)
         (includes o11 p17) (includes o11 p20) (includes o11 p25) (waiting o12)
         (includes o12 p1) (includes o12 p5) (includes o12 p7)
         (includes o12 p15) (includes o12 p21) (includes o12 p22) (waiting o13)
         (includes o13 p1) (includes o13 p9) (includes o13 p10)
         (includes o13 p16) (includes o13 p22) (includes o13 p24) (waiting o14)
         (includes o14 p4) (includes o14 p8) (includes o14 p10)
         (includes o14 p12) (includes o14 p19) (includes o14 p24) (waiting o15)
         (includes o15 p2) (includes o15 p4) (includes o15 p8)
         (includes o15 p12) (includes o15 p17) (includes o15 p18))
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
              (delivered o1 p23)
              (delivered o10 p16)
              (delivered o4 p19)
              (delivered o10 p9)
              (delivered o7 p23)
              (delivered o15 p8)
              (delivered o2 p18)
              (delivered o8 p21)
              (delivered o11 p4)
              (delivered o8 p13)
              (delivered o5 p12)
              (delivered o12 p5)
              (delivered o6 p6)
              (delivered o4 p12)
              (delivered o4 p25)
              (delivered o14 p10)
              (delivered o12 p1)
              (delivered o13 p24)
              (delivered o11 p17)
              (delivered o7 p10)
              (delivered o2 p25)
              (delivered o9 p13)
              (delivered o3 p22)
              (delivered o8 p7)
              (delivered o11 p8)
              (delivered o1 p9)
              (delivered o13 p1)
              (delivered o10 p15)
              (delivered o9 p7)
              (delivered o15 p17)
              (delivered o5 p19)
              (delivered o4 p17)
              (delivered o10 p5)
              (delivered o4 p4)
              (delivered o4 p2)
              (delivered o15 p4)
              (delivered o3 p21)
              (delivered o15 p18)
              (delivered o6 p7)
              (delivered o1 p24)
              (delivered o14 p8)
              (delivered o3 p13)
              (delivered o12 p21)
              (delivered o7 p16)
              (delivered o15 p12)
              (delivered o7 p22)
              (delivered o2 p3)
              (delivered o12 p15)
              (delivered o5 p9)
              (delivered o11 p25)
              (delivered o6 p13)
              (delivered o12 p22)
              (delivered o6 p15)
              (delivered o3 p5)
              (delivered o14 p24)
              (delivered o9 p5)
              (delivered o7 p1)
              (delivered o8 p6)
;;--- end of goal preferences ---;;
        (:constraints (and
              (always (not (stacks-in-use n9)))
              (always (not (stacks-in-use n6)))
              (always (not (stacks-in-use n14)))
              (always (not (stacks-in-use n10)))
              (always (not (stacks-in-use n8)))
              (always (not (stacks-in-use n7)))
        ))
        ))
        (:metric minimize (total-time))
)
