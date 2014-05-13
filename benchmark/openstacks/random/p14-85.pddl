; Goal preferences: 17
; Trajectories: 3


(define (problem os-softpreferences-sp4-1)
        (:domain openstacks-softpreferences)
        (:objects n0 - count n1 - count n2 - count n3 - count n4 - count n5 -
         count n6 - count n7 - count n8 - count n9 - count n10 - count n11 -
         count n12 - count n13 - count n14 - count n15 - count n16 - count n17
         - count n18 - count n19 - count n20 - count n21 - count n22 - count
         n23 - count n24 - count n25 - count o1 - order o2 - order o3 - order
         o4 - order o5 - order o6 - order o7 - order o8 - order o9 - order o10
         - order o11 - order o12 - order o13 - order o14 - order o15 - order
         o16 - order o17 - order o18 - order o19 - order o20 - order o21 -
         order o22 - order o23 - order o24 - order o25 - order p1 - product p2
         - product p3 - product p4 - product p5 - product p6 - product p7 -
         product p8 - product p9 - product p10 - product p11 - product p12 -
         product p13 - product p14 - product p15 - product p16 - product p17 -
         product p18 - product p19 - product p20 - product p21 - product p22 -
         product p23 - product p24 - product p25 - product)
        (:init (next-count n0 n1) (next-count n1 n2) (next-count n2 n3)
         (next-count n3 n4) (next-count n4 n5) (next-count n5 n6)
         (next-count n6 n7) (next-count n7 n8) (next-count n8 n9)
         (next-count n9 n10) (next-count n10 n11) (next-count n11 n12)
         (next-count n12 n13) (next-count n13 n14) (next-count n14 n15)
         (next-count n15 n16) (next-count n16 n17) (next-count n17 n18)
         (next-count n18 n19) (next-count n19 n20) (next-count n20 n21)
         (next-count n21 n22) (next-count n22 n23) (next-count n23 n24)
         (next-count n24 n25) (stacks-in-use n0) (waiting o1) (includes o1 p3)
         (includes o1 p11) (includes o1 p12) (includes o1 p22)
         (includes o1 p24) (waiting o2) (includes o2 p7) (includes o2 p12)
         (waiting o3) (includes o3 p25) (waiting o4) (includes o4 p8)
         (includes o4 p12) (includes o4 p15) (includes o4 p16)
         (includes o4 p21) (includes o4 p22) (includes o4 p25) (waiting o5)
         (includes o5 p11) (includes o5 p23) (waiting o6) (includes o6 p13)
         (waiting o7) (includes o7 p7) (includes o7 p14) (includes o7 p17)
         (includes o7 p20) (includes o7 p22) (waiting o8) (includes o8 p5)
         (includes o8 p12) (waiting o9) (includes o9 p2) (includes o9 p21)
         (includes o9 p22) (waiting o10) (includes o10 p20) (includes o10 p22)
         (waiting o11) (includes o11 p7) (includes o11 p18) (waiting o12)
         (includes o12 p9) (includes o12 p21) (waiting o13) (includes o13 p1)
         (includes o13 p19) (includes o13 p24) (waiting o14) (includes o14 p21)
         (includes o14 p23) (waiting o15) (includes o15 p4) (includes o15 p25)
         (waiting o16) (includes o16 p12) (waiting o17) (includes o17 p5)
         (includes o17 p18) (includes o17 p19) (includes o17 p23) (waiting o18)
         (includes o18 p20) (waiting o19) (includes o19 p5) (includes o19 p9)
         (includes o19 p22) (waiting o20) (includes o20 p6) (includes o20 p9)
         (waiting o21) (includes o21 p2) (waiting o22) (includes o22 p9)
         (includes o22 p19) (includes o22 p20) (includes o22 p22) (waiting o23)
         (includes o23 p22) (includes o23 p23) (waiting o24) (includes o24 p10)
         (includes o24 p17) (includes o24 p18) (waiting o25) (includes o25 p10)
         (includes o25 p13) (includes o25 p17))
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
              (shipped o21)
              (shipped o22)
              (shipped o23)
              (shipped o24)
              (shipped o25)
;;--- start of goal preferences ---;;
              (delivered o4 p15)
              (delivered o4 p12)
              (delivered o4 p8)
              (delivered o7 p17)
              (delivered o4 p25)
              (delivered o19 p5)
              (delivered o5 p11)
              (delivered o22 p9)
              (delivered o22 p20)
              (delivered o23 p22)
              (delivered o1 p22)
              (delivered o3 p25)
              (delivered o13 p1)
              (delivered o22 p22)
              (delivered o13 p24)
              (delivered o12 p9)
              (delivered o25 p17)
;;--- end of goal preferences ---;;
        (:constraints (and
              (always (not (stacks-in-use n19)))
              (always (not (stacks-in-use n9)))
              (always (not (stacks-in-use n7)))
        ))
        ))
        (:metric minimize (total-time))
)
