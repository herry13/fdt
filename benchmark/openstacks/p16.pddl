
(define (problem os-softpreferences-wbop_30_30-20)
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
         (stacks-in-use n0) (waiting o1) (includes o1 p18) (includes o1 p19)
         (includes o1 p21) (waiting o2) (includes o2 p7) (includes o2 p19)
         (includes o2 p24) (waiting o3) (includes o3 p3) (includes o3 p10)
         (includes o3 p18) (waiting o4) (includes o4 p6) (includes o4 p11)
         (includes o4 p21) (waiting o5) (includes o5 p13) (includes o5 p17)
         (includes o5 p25) (waiting o6) (includes o6 p3) (includes o6 p10)
         (includes o6 p22) (waiting o7) (includes o7 p11) (includes o7 p27)
         (includes o7 p28) (waiting o8) (includes o8 p6) (includes o8 p11)
         (includes o8 p17) (waiting o9) (includes o9 p16) (includes o9 p22)
         (includes o9 p26) (waiting o10) (includes o10 p5) (includes o10 p19)
         (includes o10 p27) (waiting o11) (includes o11 p1) (includes o11 p14)
         (includes o11 p29) (waiting o12) (includes o12 p4) (includes o12 p13)
         (includes o12 p17) (waiting o13) (includes o13 p9) (includes o13 p22)
         (includes o13 p25) (waiting o14) (includes o14 p7) (includes o14 p9)
         (includes o14 p23) (waiting o15) (includes o15 p8) (includes o15 p15)
         (includes o15 p28) (waiting o16) (includes o16 p1) (includes o16 p2)
         (includes o16 p29) (waiting o17) (includes o17 p9) (includes o17 p26)
         (includes o17 p28) (waiting o18) (includes o18 p3) (includes o18 p6)
         (includes o18 p15) (waiting o19) (includes o19 p12) (includes o19 p14)
         (includes o19 p20) (waiting o20) (includes o20 p7) (includes o20 p24)
         (includes o20 p30) (waiting o21) (includes o21 p2) (includes o21 p13)
         (includes o21 p20) (waiting o22) (includes o22 p5) (includes o22 p10)
         (includes o22 p23) (waiting o23) (includes o23 p5) (includes o23 p23)
         (includes o23 p24) (waiting o24) (includes o24 p12) (includes o24 p14)
         (includes o24 p21) (waiting o25) (includes o25 p1) (includes o25 p2)
         (includes o25 p27) (waiting o26) (includes o26 p16) (includes o26 p26)
         (includes o26 p30) (waiting o27) (includes o27 p4) (includes o27 p16)
         (includes o27 p30) (waiting o28) (includes o28 p8) (includes o28 p12)
         (includes o28 p20) (waiting o29) (includes o29 p8) (includes o29 p18)
         (includes o29 p29) (waiting o30) (includes o30 p4) (includes o30 p15)
         (includes o30 p25))
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
              (delivered o1 p18)
              (and (delivered o1 p19) (delivered o1 p18))
              (and (delivered o1 p21) (delivered o1 p19) (delivered o1 p18))
              (delivered o2 p7)
              (and (delivered o2 p19) (delivered o2 p7))
              (and (delivered o2 p24) (delivered o2 p19) (delivered o2 p7))
              (delivered o3 p3)
              (and (delivered o3 p10) (delivered o3 p3))
              (and (delivered o3 p18) (delivered o3 p10) (delivered o3 p3))
              (delivered o4 p6)
              (and (delivered o4 p11) (delivered o4 p6))
              (and (delivered o4 p21) (delivered o4 p11) (delivered o4 p6))
              (delivered o5 p13)
              (and (delivered o5 p17) (delivered o5 p13))
              (and (delivered o5 p25) (delivered o5 p17) (delivered o5 p13))
              (delivered o6 p3)
              (and (delivered o6 p10) (delivered o6 p3))
              (and (delivered o6 p22) (delivered o6 p10) (delivered o6 p3))
              (delivered o7 p11)
              (and (delivered o7 p27) (delivered o7 p11))
              (and (delivered o7 p28) (delivered o7 p27) (delivered o7 p11))
              (delivered o8 p6)
              (and (delivered o8 p11) (delivered o8 p6))
              (and (delivered o8 p17) (delivered o8 p11) (delivered o8 p6))
              (delivered o9 p16)
              (and (delivered o9 p22) (delivered o9 p16))
              (and (delivered o9 p26) (delivered o9 p22) (delivered o9 p16))
              (delivered o10 p5)
              (and (delivered o10 p19) (delivered o10 p5))
              (and (delivered o10 p27) (delivered o10 p19) (delivered o10 p5))
              (delivered o11 p1)
              (and (delivered o11 p14) (delivered o11 p1))
              (and (delivered o11 p29) (delivered o11 p14) (delivered o11 p1))
              (delivered o12 p4)
              (and (delivered o12 p13) (delivered o12 p4))
              (and (delivered o12 p17) (delivered o12 p13) (delivered o12 p4))
              (delivered o13 p9)
              (and (delivered o13 p22) (delivered o13 p9))
              (and (delivered o13 p25) (delivered o13 p22) (delivered o13 p9))
              (delivered o14 p7)
              (and (delivered o14 p9) (delivered o14 p7))
              (and (delivered o14 p23) (delivered o14 p9) (delivered o14 p7))
              (delivered o15 p8)
              (and (delivered o15 p15) (delivered o15 p8))
              (and (delivered o15 p28) (delivered o15 p15) (delivered o15 p8))
              (delivered o16 p1)
              (and (delivered o16 p2) (delivered o16 p1))
              (and (delivered o16 p29) (delivered o16 p2) (delivered o16 p1))
              (delivered o17 p9)
              (and (delivered o17 p26) (delivered o17 p9))
              (and (delivered o17 p28) (delivered o17 p26) (delivered o17 p9))
              (delivered o18 p3)
              (and (delivered o18 p6) (delivered o18 p3))
              (and (delivered o18 p15) (delivered o18 p6) (delivered o18 p3))
              (delivered o19 p12)
              (and (delivered o19 p14) (delivered o19 p12))
              (and (delivered o19 p20) (delivered o19 p14) (delivered o19 p12))
              (delivered o20 p7)
              (and (delivered o20 p24) (delivered o20 p7))
              (and (delivered o20 p30) (delivered o20 p24) (delivered o20 p7))
              (delivered o21 p2)
              (and (delivered o21 p13) (delivered o21 p2))
              (and (delivered o21 p20) (delivered o21 p13) (delivered o21 p2))
              (delivered o22 p5)
              (and (delivered o22 p10) (delivered o22 p5))
              (and (delivered o22 p23) (delivered o22 p10) (delivered o22 p5))
              (delivered o23 p5)
              (and (delivered o23 p23) (delivered o23 p5))
              (and (delivered o23 p24) (delivered o23 p23) (delivered o23 p5))
              (delivered o24 p12)
              (and (delivered o24 p14) (delivered o24 p12))
              (and (delivered o24 p21) (delivered o24 p14) (delivered o24 p12))
              (delivered o25 p1)
              (and (delivered o25 p2) (delivered o25 p1))
              (and (delivered o25 p27) (delivered o25 p2) (delivered o25 p1))
              (delivered o26 p16)
              (and (delivered o26 p26) (delivered o26 p16))
              (and (delivered o26 p30) (delivered o26 p26) (delivered o26 p16))
              (delivered o27 p4)
              (and (delivered o27 p16) (delivered o27 p4))
              (and (delivered o27 p30) (delivered o27 p16) (delivered o27 p4))
              (delivered o28 p8)
              (and (delivered o28 p12) (delivered o28 p8))
              (and (delivered o28 p20) (delivered o28 p12) (delivered o28 p8))
              (delivered o29 p8)
              (and (delivered o29 p18) (delivered o29 p8))
              (and (delivered o29 p29) (delivered o29 p18) (delivered o29 p8))
              (delivered o30 p4)
              (and (delivered o30 p15) (delivered o30 p4))
              (and (delivered o30 p25) (delivered o30 p15) (delivered o30 p4))
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
              (always (not (stacks-in-use n21)))
              (always (not (stacks-in-use n22)))
              (always (not (stacks-in-use n23)))
              (always (not (stacks-in-use n24)))
              (always (not (stacks-in-use n25)))
              (always (not (stacks-in-use n26)))
              (always (not (stacks-in-use n27)))
              (always (not (stacks-in-use n28)))
              (always (not (stacks-in-use n29)))
              (always (not (stacks-in-use n30)))
        ))
)
