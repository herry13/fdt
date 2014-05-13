; Goal preferences: 150
; Trajectories: 20


(define (problem os-softpreferences-nrwslarger4-1)
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
         product p17 - product p18 - product p19 - product p20 - product p21 -
         product p22 - product p23 - product p24 - product p25 - product p26 -
         product p27 - product p28 - product p29 - product p30 - product)
        (:init (next-count n0 n1) (next-count n1 n2) (next-count n2 n3)
         (next-count n3 n4) (next-count n4 n5) (next-count n5 n6)
         (next-count n6 n7) (next-count n7 n8) (next-count n8 n9)
         (next-count n9 n10) (next-count n10 n11) (next-count n11 n12)
         (next-count n12 n13) (next-count n13 n14) (next-count n14 n15)
         (next-count n15 n16) (next-count n16 n17) (next-count n17 n18)
         (next-count n18 n19) (next-count n19 n20) (stacks-in-use n0)
         (waiting o1) (includes o1 p5) (includes o1 p6) (includes o1 p7)
         (includes o1 p8) (includes o1 p15) (includes o1 p24) (includes o1 p25)
         (includes o1 p29) (waiting o2) (includes o2 p2) (includes o2 p12)
         (includes o2 p14) (includes o2 p22) (includes o2 p23)
         (includes o2 p26) (includes o2 p27) (includes o2 p28) (waiting o3)
         (includes o3 p6) (includes o3 p11) (includes o3 p15) (includes o3 p24)
         (includes o3 p25) (includes o3 p29) (waiting o4) (includes o4 p3)
         (includes o4 p6) (includes o4 p8) (includes o4 p10) (includes o4 p14)
         (includes o4 p17) (includes o4 p26) (includes o4 p27) (waiting o5)
         (includes o5 p3) (includes o5 p7) (includes o5 p8) (includes o5 p17)
         (includes o5 p20) (includes o5 p23) (includes o5 p27)
         (includes o5 p30) (waiting o6) (includes o6 p4) (includes o6 p7)
         (includes o6 p14) (includes o6 p18) (includes o6 p20)
         (includes o6 p22) (includes o6 p26) (includes o6 p27) (waiting o7)
         (includes o7 p3) (includes o7 p5) (includes o7 p7) (includes o7 p11)
         (includes o7 p14) (includes o7 p15) (includes o7 p29)
         (includes o7 p30) (waiting o8) (includes o8 p5) (includes o8 p8)
         (includes o8 p15) (includes o8 p17) (includes o8 p25)
         (includes o8 p30) (waiting o9) (includes o9 p3) (includes o9 p13)
         (includes o9 p15) (includes o9 p24) (includes o9 p25)
         (includes o9 p29) (includes o9 p30) (waiting o10) (includes o10 p4)
         (includes o10 p9) (includes o10 p10) (includes o10 p16)
         (includes o10 p18) (includes o10 p21) (includes o10 p23)
         (includes o10 p28) (waiting o11) (includes o11 p2) (includes o11 p5)
         (includes o11 p8) (includes o11 p14) (includes o11 p15)
         (includes o11 p17) (includes o11 p25) (includes o11 p30) (waiting o12)
         (includes o12 p3) (includes o12 p7) (includes o12 p8)
         (includes o12 p11) (includes o12 p14) (includes o12 p15)
         (includes o12 p26) (includes o12 p30) (waiting o13) (includes o13 p2)
         (includes o13 p10) (includes o13 p18) (includes o13 p19)
         (includes o13 p20) (includes o13 p26) (includes o13 p27)
         (includes o13 p28) (waiting o14) (includes o14 p2) (includes o14 p3)
         (includes o14 p6) (includes o14 p7) (includes o14 p10)
         (includes o14 p14) (includes o14 p20) (includes o14 p22) (waiting o15)
         (includes o15 p5) (includes o15 p8) (includes o15 p11)
         (includes o15 p13) (includes o15 p24) (includes o15 p25) (waiting o16)
         (includes o16 p2) (includes o16 p6) (includes o16 p8)
         (includes o16 p14) (includes o16 p15) (includes o16 p17)
         (includes o16 p20) (includes o16 p30) (waiting o17) (includes o17 p2)
         (includes o17 p6) (includes o17 p7) (includes o17 p8)
         (includes o17 p11) (includes o17 p25) (includes o17 p27)
         (includes o17 p30) (waiting o18) (includes o18 p2) (includes o18 p7)
         (includes o18 p10) (includes o18 p14) (includes o18 p17)
         (includes o18 p18) (includes o18 p23) (includes o18 p26) (waiting o19)
         (includes o19 p1) (includes o19 p9) (includes o19 p10)
         (includes o19 p12) (includes o19 p20) (includes o19 p22)
         (includes o19 p26) (includes o19 p28) (waiting o20) (includes o20 p1)
         (includes o20 p18) (includes o20 p19) (includes o20 p20)
         (includes o20 p21) (includes o20 p22) (includes o20 p23)
         (includes o20 p28))
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
              (delivered o5 p30)
              (delivered o13 p20)
              (delivered o15 p25)
              (delivered o12 p15)
              (delivered o17 p6)
              (delivered o4 p17)
              (delivered o17 p25)
              (delivered o4 p3)
              (delivered o2 p26)
              (delivered o20 p21)
              (delivered o4 p8)
              (delivered o8 p15)
              (delivered o9 p30)
              (delivered o6 p14)
              (delivered o17 p30)
              (delivered o16 p8)
              (delivered o8 p5)
              (delivered o19 p28)
              (delivered o6 p27)
              (delivered o7 p14)
              (delivered o10 p9)
              (delivered o9 p29)
              (delivered o13 p19)
              (delivered o20 p23)
              (delivered o11 p5)
              (delivered o9 p24)
              (delivered o4 p10)
              (delivered o16 p14)
              (delivered o9 p3)
              (delivered o11 p14)
              (delivered o3 p11)
              (delivered o15 p24)
              (delivered o2 p22)
              (delivered o20 p28)
              (delivered o10 p21)
              (delivered o3 p29)
              (delivered o10 p23)
              (delivered o13 p2)
              (delivered o20 p19)
              (delivered o17 p11)
              (delivered o8 p17)
              (delivered o5 p27)
              (delivered o10 p28)
              (delivered o4 p14)
              (delivered o8 p25)
              (delivered o10 p16)
              (delivered o8 p30)
              (delivered o3 p15)
              (delivered o4 p26)
              (delivered o14 p20)
              (delivered o18 p18)
              (delivered o12 p26)
              (delivered o11 p25)
              (delivered o14 p7)
              (delivered o6 p20)
              (delivered o13 p18)
              (delivered o1 p29)
              (delivered o19 p1)
              (delivered o7 p5)
              (delivered o18 p26)
              (delivered o14 p2)
              (delivered o2 p14)
              (delivered o19 p9)
              (delivered o18 p23)
              (delivered o18 p7)
              (delivered o5 p8)
              (delivered o9 p25)
              (delivered o19 p22)
              (delivered o6 p7)
              (delivered o1 p7)
              (delivered o13 p10)
              (delivered o12 p3)
              (delivered o7 p11)
              (delivered o5 p7)
              (delivered o10 p10)
              (delivered o17 p7)
              (delivered o15 p13)
              (delivered o5 p23)
              (delivered o14 p14)
              (delivered o14 p22)
              (delivered o20 p22)
              (delivered o17 p27)
              (delivered o12 p14)
              (delivered o7 p7)
              (delivered o20 p20)
              (delivered o1 p8)
              (delivered o3 p6)
              (delivered o11 p17)
              (delivered o16 p20)
              (delivered o7 p29)
              (delivered o6 p18)
              (delivered o15 p11)
              (delivered o20 p1)
              (delivered o1 p6)
              (delivered o14 p3)
              (delivered o8 p8)
              (delivered o12 p11)
              (delivered o6 p4)
              (delivered o11 p2)
              (delivered o19 p12)
              (delivered o7 p3)
              (delivered o15 p5)
              (delivered o2 p23)
              (delivered o1 p5)
              (delivered o5 p3)
              (delivered o1 p15)
              (delivered o16 p30)
              (delivered o9 p15)
              (delivered o13 p26)
              (delivered o18 p17)
              (delivered o2 p27)
              (delivered o6 p22)
              (delivered o12 p7)
              (delivered o16 p17)
              (delivered o11 p15)
              (delivered o10 p18)
              (delivered o20 p18)
              (delivered o16 p15)
              (delivered o4 p6)
              (delivered o18 p10)
              (delivered o2 p28)
              (delivered o17 p2)
              (delivered o2 p2)
              (delivered o7 p15)
              (delivered o2 p12)
              (delivered o1 p25)
              (delivered o14 p6)
              (delivered o12 p30)
              (delivered o14 p10)
              (delivered o13 p28)
              (delivered o11 p8)
              (delivered o6 p26)
              (delivered o16 p2)
              (delivered o11 p30)
              (delivered o19 p10)
              (delivered o3 p24)
              (delivered o18 p2)
              (delivered o12 p8)
              (delivered o3 p25)
              (delivered o5 p20)
              (delivered o7 p30)
              (delivered o19 p26)
              (delivered o13 p27)
              (delivered o16 p6)
              (delivered o15 p8)
              (delivered o17 p8)
              (delivered o1 p24)
              (delivered o4 p27)
              (delivered o19 p20)
              (delivered o18 p14)
;;--- end of goal preferences ---;;
        (:constraints (and
              (always (not (stacks-in-use n6)))
              (always (not (stacks-in-use n8)))
              (always (not (stacks-in-use n19)))
              (always (not (stacks-in-use n7)))
              (always (not (stacks-in-use n18)))
              (always (not (stacks-in-use n13)))
              (always (not (stacks-in-use n20)))
              (always (not (stacks-in-use n5)))
              (always (not (stacks-in-use n3)))
              (always (not (stacks-in-use n10)))
              (always (not (stacks-in-use n16)))
              (always (not (stacks-in-use n12)))
              (always (not (stacks-in-use n17)))
              (always (not (stacks-in-use n14)))
              (always (not (stacks-in-use n15)))
              (always (not (stacks-in-use n4)))
              (always (not (stacks-in-use n9)))
              (always (not (stacks-in-use n1)))
              (always (not (stacks-in-use n2)))
              (always (not (stacks-in-use n11)))
        ))
        ))
        (:metric minimize (total-time))
)
