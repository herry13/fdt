; Goal preferences: 29
; Trajectories: 17


(define (problem os-softpreferences-wbop_30_30-17)
        (:domain openstacks-softpreferences)
        (:objects n0 - count n1 - count n2 - count n3 - count n4 - count n5 -
         count n6 - count n7 - count n8 - count n9 - count n10 - count n11 -
         count n12 - count n13 - count n14 - count n15 - count n16 - count n17
         - count n18 - count n19 - count n20 - count n21 - count n22 - count
         n23 - count n24 - count n25 - count n26 - count n27 - count n28 -
         count n29 - count n30 - count o1 - order o2 - order o3 - order o4 -
         order o5 - order o6 - order o7 - order o8 - order o9 - order o10 -
         order o11 - order o12 - order o13 - order o14 - order o15 - order o16
         - order o17 - order o18 - order o19 - order o20 - order o21 - order
         o22 - order o23 - order o24 - order o25 - order o26 - order o27 -
         order o28 - order o29 - order o30 - order p1 - product p2 - product p3
         - product p4 - product p5 - product p6 - product p7 - product p8 -
         product p9 - product p10 - product p11 - product p12 - product p13 -
         product p14 - product p15 - product p16 - product p17 - product p18 -
         product p19 - product p20 - product p21 - product p22 - product p23 -
         product p24 - product p25 - product p26 - product p27 - product p28 -
         product p29 - product p30 - product)
        (:init (next-count n0 n1) (next-count n1 n2) (next-count n2 n3)
         (next-count n3 n4) (next-count n4 n5) (next-count n5 n6)
         (next-count n6 n7) (next-count n7 n8) (next-count n8 n9)
         (next-count n9 n10) (next-count n10 n11) (next-count n11 n12)
         (next-count n12 n13) (next-count n13 n14) (next-count n14 n15)
         (next-count n15 n16) (next-count n16 n17) (next-count n17 n18)
         (next-count n18 n19) (next-count n19 n20) (next-count n20 n21)
         (next-count n21 n22) (next-count n22 n23) (next-count n23 n24)
         (next-count n24 n25) (next-count n25 n26) (next-count n26 n27)
         (next-count n27 n28) (next-count n28 n29) (next-count n29 n30)
         (stacks-in-use n0) (waiting o1) (includes o1 p9) (includes o1 p20)
         (includes o1 p29) (waiting o2) (includes o2 p11) (includes o2 p12)
         (includes o2 p25) (waiting o3) (includes o3 p14) (includes o3 p25)
         (includes o3 p30) (waiting o4) (includes o4 p5) (includes o4 p18)
         (includes o4 p20) (waiting o5) (includes o5 p16) (includes o5 p27)
         (includes o5 p28) (waiting o6) (includes o6 p8) (includes o6 p17)
         (includes o6 p27) (waiting o7) (includes o7 p7) (includes o7 p14)
         (includes o7 p22) (waiting o8) (includes o8 p10) (includes o8 p18)
         (includes o8 p24) (waiting o9) (includes o9 p10) (includes o9 p12)
         (includes o9 p24) (waiting o10) (includes o10 p17) (includes o10 p21)
         (includes o10 p26) (waiting o11) (includes o11 p2) (includes o11 p4)
         (includes o11 p8) (waiting o12) (includes o12 p2) (includes o12 p10)
         (includes o12 p29) (waiting o13) (includes o13 p11) (includes o13 p19)
         (includes o13 p26) (waiting o14) (includes o14 p1) (includes o14 p3)
         (includes o14 p28) (waiting o15) (includes o15 p1) (includes o15 p7)
         (includes o15 p15) (waiting o16) (includes o16 p6) (includes o16 p13)
         (includes o16 p26) (waiting o17) (includes o17 p2) (includes o17 p15)
         (includes o17 p16) (waiting o18) (includes o18 p4) (includes o18 p12)
         (includes o18 p29) (waiting o19) (includes o19 p11) (includes o19 p14)
         (includes o19 p23) (waiting o20) (includes o20 p5) (includes o20 p13)
         (includes o20 p23) (waiting o21) (includes o21 p3) (includes o21 p9)
         (includes o21 p16) (waiting o22) (includes o22 p5) (includes o22 p17)
         (includes o22 p21) (waiting o23) (includes o23 p4) (includes o23 p22)
         (includes o23 p30) (waiting o24) (includes o24 p3) (includes o24 p9)
         (includes o24 p28) (waiting o25) (includes o25 p22) (includes o25 p27)
         (includes o25 p30) (waiting o26) (includes o26 p6) (includes o26 p20)
         (includes o26 p23) (waiting o27) (includes o27 p1) (includes o27 p7)
         (includes o27 p13) (waiting o28) (includes o28 p8) (includes o28 p19)
         (includes o28 p25) (waiting o29) (includes o29 p18) (includes o29 p21)
         (includes o29 p24) (waiting o30) (includes o30 p6) (includes o30 p15)
         (includes o30 p19))
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
              (shipped o26)
              (shipped o27)
              (shipped o28)
              (shipped o29)
              (shipped o30)
;;--- start of goal preferences ---;;
              (and (delivered o1 p29) (delivered o1 p20) (delivered o1 p9))
              (and (delivered o5 p27) (delivered o5 p16))
              (and (delivered o20 p23) (delivered o20 p13) (delivered o20 p5))
              (delivered o10 p17)
              (and (delivered o15 p7) (delivered o15 p1))
              (delivered o28 p8)
              (delivered o24 p3)
              (delivered o8 p10)
              (and (delivered o30 p19) (delivered o30 p15) (delivered o30 p6))
              (and (delivered o26 p20) (delivered o26 p6))
              (and (delivered o4 p20) (delivered o4 p18) (delivered o4 p5))
              (delivered o29 p18)
              (delivered o13 p11)
              (delivered o19 p11)
              (delivered o27 p1)
              (delivered o22 p5)
              (and (delivered o4 p18) (delivered o4 p5))
              (and (delivered o14 p3) (delivered o14 p1))
              (and (delivered o3 p30) (delivered o3 p25) (delivered o3 p14))
              (delivered o21 p3)
              (and (delivered o30 p15) (delivered o30 p6))
              (delivered o20 p5)
              (and (delivered o7 p14) (delivered o7 p7))
              (and (delivered o9 p24) (delivered o9 p12) (delivered o9 p10))
              (delivered o23 p4)
              (and (delivered o6 p17) (delivered o6 p8))
              (and (delivered o11 p4) (delivered o11 p2))
              (and (delivered o27 p13) (delivered o27 p7) (delivered o27 p1))
              (and (delivered o11 p8) (delivered o11 p4) (delivered o11 p2))
;;--- end of goal preferences ---;;
        (:constraints (and 
              (always (not (stacks-in-use n15)))
              (always (not (stacks-in-use n12)))
              (always (not (stacks-in-use n23)))
              (always (not (stacks-in-use n17)))
              (always (not (stacks-in-use n21)))
              (always (not (stacks-in-use n26)))
              (always (not (stacks-in-use n29)))
              (always (not (stacks-in-use n28)))
              (always (not (stacks-in-use n1)))
              (always (not (stacks-in-use n3)))
              (always (not (stacks-in-use n4)))
              (always (not (stacks-in-use n2)))
              (always (not (stacks-in-use n10)))
              (always (not (stacks-in-use n19)))
              (always (not (stacks-in-use n27)))
              (always (not (stacks-in-use n13)))
              (always (not (stacks-in-use n5)))
        ))
        ))
        (:metric minimize (total-time))
)
