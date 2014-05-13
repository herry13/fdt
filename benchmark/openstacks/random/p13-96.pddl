; Goal preferences: 185
; Trajectories: 13


(define (problem os-softpreferences-nrwslarger4-3)
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
         product p23 - product p24 - product p25 - product p26 - product p27 -
         product p28 - product p29 - product p30 - product p31 - product p32 -
         product p33 - product p34 - product p35 - product p36 - product p37 -
         product p38 - product p39 - product p40 - product p41 - product p42 -
         product p43 - product p44 - product p45 - product p46 - product p47 -
         product p48 - product p49 - product p50 - product p51 - product p52 -
         product p53 - product p54 - product p55 - product p56 - product p57 -
         product p58 - product p59 - product p60 - product)
        (:init (next-count n0 n1) (next-count n1 n2) (next-count n2 n3)
         (next-count n3 n4) (next-count n4 n5) (next-count n5 n6)
         (next-count n6 n7) (next-count n7 n8) (next-count n8 n9)
         (next-count n9 n10) (next-count n10 n11) (next-count n11 n12)
         (next-count n12 n13) (next-count n13 n14) (next-count n14 n15)
         (next-count n15 n16) (next-count n16 n17) (next-count n17 n18)
         (next-count n18 n19) (next-count n19 n20) (next-count n20 n21)
         (next-count n21 n22) (next-count n22 n23) (next-count n23 n24)
         (next-count n24 n25) (stacks-in-use n0) (waiting o1) (includes o1 p4)
         (includes o1 p16) (includes o1 p19) (includes o1 p21)
         (includes o1 p46) (includes o1 p51) (includes o1 p53)
         (includes o1 p56) (waiting o2) (includes o2 p11) (includes o2 p20)
         (includes o2 p21) (includes o2 p26) (includes o2 p28)
         (includes o2 p46) (includes o2 p49) (includes o2 p59) (waiting o3)
         (includes o3 p4) (includes o3 p8) (includes o3 p19) (includes o3 p21)
         (includes o3 p25) (includes o3 p46) (includes o3 p53)
         (includes o3 p56) (waiting o4) (includes o4 p4) (includes o4 p8)
         (includes o4 p21) (includes o4 p23) (includes o4 p25)
         (includes o4 p29) (includes o4 p53) (includes o4 p56) (waiting o5)
         (includes o5 p4) (includes o5 p21) (includes o5 p24) (includes o5 p25)
         (includes o5 p27) (includes o5 p35) (includes o5 p43)
         (includes o5 p46) (waiting o6) (includes o6 p5) (includes o6 p15)
         (includes o6 p17) (includes o6 p18) (includes o6 p30)
         (includes o6 p39) (includes o6 p42) (waiting o7) (includes o7 p1)
         (includes o7 p2) (includes o7 p6) (includes o7 p7) (includes o7 p17)
         (includes o7 p40) (includes o7 p41) (includes o7 p47)
         (includes o7 p48) (includes o7 p54) (waiting o8) (includes o8 p16)
         (includes o8 p19) (includes o8 p25) (includes o8 p26)
         (includes o8 p27) (includes o8 p28) (includes o8 p49)
         (includes o8 p53) (waiting o9) (includes o9 p3) (includes o9 p6)
         (includes o9 p14) (includes o9 p18) (includes o9 p36)
         (includes o9 p37) (includes o9 p42) (includes o9 p47)
         (includes o9 p50) (includes o9 p54) (includes o9 p57) (waiting o10)
         (includes o10 p9) (includes o10 p12) (includes o10 p21)
         (includes o10 p24) (includes o10 p25) (includes o10 p29)
         (includes o10 p33) (includes o10 p35) (includes o10 p53)
         (includes o10 p56) (waiting o11) (includes o11 p5) (includes o11 p11)
         (includes o11 p18) (includes o11 p30) (includes o11 p42)
         (includes o11 p45) (includes o11 p58) (includes o11 p59) (waiting o12)
         (includes o12 p8) (includes o12 p9) (includes o12 p24)
         (includes o12 p27) (includes o12 p34) (includes o12 p56) (waiting o13)
         (includes o13 p3) (includes o13 p6) (includes o13 p11)
         (includes o13 p13) (includes o13 p14) (includes o13 p18)
         (includes o13 p22) (includes o13 p30) (includes o13 p39)
         (includes o13 p41) (includes o13 p45) (includes o13 p47)
         (includes o13 p50) (includes o13 p52) (includes o13 p54)
         (includes o13 p58) (waiting o14) (includes o14 p2) (includes o14 p6)
         (includes o14 p7) (includes o14 p13) (includes o14 p14)
         (includes o14 p22) (includes o14 p41) (includes o14 p44)
         (includes o14 p57) (includes o14 p60) (waiting o15) (includes o15 p4)
         (includes o15 p9) (includes o15 p21) (includes o15 p23)
         (includes o15 p24) (includes o15 p27) (includes o15 p33)
         (includes o15 p38) (includes o15 p53) (waiting o16) (includes o16 p16)
         (includes o16 p25) (includes o16 p31) (includes o16 p35)
         (includes o16 p46) (includes o16 p49) (includes o16 p51)
         (includes o16 p59) (waiting o17) (includes o17 p4) (includes o17 p8)
         (includes o17 p12) (includes o17 p23) (includes o17 p24)
         (includes o17 p29) (includes o17 p33) (includes o17 p43) (waiting o18)
         (includes o18 p11) (includes o18 p16) (includes o18 p19)
         (includes o18 p26) (includes o18 p31) (includes o18 p45)
         (includes o18 p46) (includes o18 p59) (waiting o19) (includes o19 p1)
         (includes o19 p2) (includes o19 p3) (includes o19 p5)
         (includes o19 p14) (includes o19 p17) (includes o19 p32)
         (includes o19 p36) (includes o19 p37) (includes o19 p40)
         (includes o19 p41) (waiting o20) (includes o20 p1) (includes o20 p2)
         (includes o20 p6) (includes o20 p22) (includes o20 p32)
         (includes o20 p36) (includes o20 p37) (includes o20 p47)
         (includes o20 p52) (includes o20 p57) (waiting o21) (includes o21 p15)
         (includes o21 p26) (includes o21 p30) (includes o21 p31)
         (includes o21 p42) (includes o21 p45) (includes o21 p49)
         (includes o21 p58) (waiting o22) (includes o22 p4) (includes o22 p8)
         (includes o22 p9) (includes o22 p12) (includes o22 p23)
         (includes o22 p24) (includes o22 p33) (includes o22 p38) (waiting o23)
         (includes o23 p4) (includes o23 p21) (includes o23 p24)
         (includes o23 p25) (includes o23 p27) (includes o23 p29)
         (includes o23 p35) (includes o23 p43) (includes o23 p46)
         (includes o23 p55) (waiting o24) (includes o24 p11) (includes o24 p15)
         (includes o24 p26) (includes o24 p28) (includes o24 p30)
         (includes o24 p31) (includes o24 p32) (includes o24 p45)
         (includes o24 p49) (waiting o25) (includes o25 p9) (includes o25 p19)
         (includes o25 p21) (includes o25 p27) (includes o25 p28)
         (includes o25 p35) (includes o25 p46) (includes o25 p56))
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
              (delivered o6 p17)
              (delivered o9 p14)
              (delivered o8 p16)
              (delivered o4 p4)
              (delivered o16 p16)
              (delivered o2 p59)
              (delivered o15 p38)
              (delivered o24 p49)
              (delivered o24 p15)
              (delivered o6 p30)
              (delivered o4 p21)
              (delivered o18 p19)
              (delivered o11 p59)
              (delivered o12 p27)
              (delivered o8 p28)
              (delivered o13 p45)
              (delivered o1 p19)
              (delivered o18 p46)
              (delivered o17 p33)
              (delivered o4 p53)
              (delivered o2 p21)
              (delivered o3 p19)
              (delivered o15 p4)
              (delivered o23 p27)
              (delivered o11 p18)
              (delivered o16 p59)
              (delivered o1 p46)
              (delivered o13 p39)
              (delivered o20 p6)
              (delivered o12 p56)
              (delivered o18 p59)
              (delivered o16 p51)
              (delivered o21 p42)
              (delivered o13 p3)
              (delivered o22 p24)
              (delivered o14 p57)
              (delivered o5 p25)
              (delivered o14 p14)
              (delivered o23 p4)
              (delivered o23 p35)
              (delivered o9 p54)
              (delivered o18 p45)
              (delivered o16 p31)
              (delivered o1 p21)
              (delivered o19 p37)
              (delivered o7 p6)
              (delivered o25 p35)
              (delivered o6 p5)
              (delivered o24 p31)
              (delivered o13 p50)
              (delivered o23 p43)
              (delivered o3 p46)
              (delivered o22 p8)
              (delivered o12 p9)
              (delivered o11 p45)
              (delivered o19 p1)
              (delivered o12 p34)
              (delivered o6 p42)
              (delivered o10 p12)
              (delivered o12 p24)
              (delivered o11 p30)
              (delivered o19 p17)
              (delivered o14 p41)
              (delivered o2 p28)
              (delivered o24 p28)
              (delivered o7 p40)
              (delivered o2 p11)
              (delivered o18 p16)
              (delivered o10 p53)
              (delivered o22 p23)
              (delivered o23 p46)
              (delivered o7 p1)
              (delivered o9 p50)
              (delivered o20 p52)
              (delivered o19 p36)
              (delivered o5 p21)
              (delivered o11 p5)
              (delivered o7 p47)
              (delivered o13 p58)
              (delivered o21 p49)
              (delivered o25 p9)
              (delivered o13 p47)
              (delivered o25 p19)
              (delivered o14 p2)
              (delivered o19 p14)
              (delivered o11 p42)
              (delivered o2 p26)
              (delivered o18 p31)
              (delivered o17 p24)
              (delivered o7 p7)
              (delivered o19 p2)
              (delivered o11 p58)
              (delivered o15 p24)
              (delivered o21 p26)
              (delivered o13 p41)
              (delivered o11 p11)
              (delivered o25 p27)
              (delivered o19 p3)
              (delivered o20 p32)
              (delivered o1 p16)
              (delivered o1 p4)
              (delivered o17 p8)
              (delivered o13 p11)
              (delivered o16 p49)
              (delivered o13 p52)
              (delivered o14 p44)
              (delivered o7 p41)
              (delivered o24 p32)
              (delivered o13 p22)
              (delivered o17 p23)
              (delivered o2 p49)
              (delivered o4 p8)
              (delivered o24 p30)
              (delivered o14 p60)
              (delivered o13 p14)
              (delivered o10 p33)
              (delivered o22 p33)
              (delivered o2 p20)
              (delivered o22 p12)
              (delivered o12 p8)
              (delivered o21 p45)
              (delivered o6 p18)
              (delivered o4 p23)
              (delivered o8 p19)
              (delivered o16 p25)
              (delivered o22 p9)
              (delivered o7 p17)
              (delivered o18 p11)
              (delivered o24 p26)
              (delivered o23 p25)
              (delivered o10 p29)
              (delivered o8 p49)
              (delivered o6 p39)
              (delivered o16 p46)
              (delivered o19 p5)
              (delivered o23 p29)
              (delivered o10 p9)
              (delivered o7 p48)
              (delivered o9 p18)
              (delivered o10 p21)
              (delivered o23 p55)
              (delivered o3 p25)
              (delivered o1 p51)
              (delivered o19 p32)
              (delivered o2 p46)
              (delivered o7 p2)
              (delivered o9 p37)
              (delivered o5 p4)
              (delivered o4 p29)
              (delivered o15 p23)
              (delivered o17 p12)
              (delivered o5 p27)
              (delivered o9 p42)
              (delivered o16 p35)
              (delivered o13 p18)
              (delivered o23 p24)
              (delivered o15 p9)
              (delivered o21 p31)
              (delivered o13 p6)
              (delivered o17 p29)
              (delivered o14 p7)
              (delivered o25 p28)
              (delivered o1 p53)
              (delivered o25 p56)
              (delivered o20 p22)
              (delivered o15 p27)
              (delivered o8 p53)
              (delivered o8 p25)
              (delivered o5 p35)
              (delivered o3 p21)
              (delivered o3 p56)
              (delivered o18 p26)
              (delivered o20 p37)
              (delivered o21 p15)
              (delivered o3 p8)
              (delivered o3 p4)
              (delivered o8 p26)
              (delivered o9 p3)
              (delivered o15 p53)
              (delivered o9 p6)
              (delivered o4 p56)
              (delivered o17 p43)
              (delivered o25 p21)
              (delivered o23 p21)
              (delivered o19 p41)
;;--- end of goal preferences ---;;
        (:constraints (and
              (always (not (stacks-in-use n11)))
              (always (not (stacks-in-use n20)))
              (always (not (stacks-in-use n21)))
              (always (not (stacks-in-use n15)))
              (always (not (stacks-in-use n1)))
              (always (not (stacks-in-use n10)))
              (always (not (stacks-in-use n2)))
              (always (not (stacks-in-use n24)))
              (always (not (stacks-in-use n8)))
              (always (not (stacks-in-use n6)))
              (always (not (stacks-in-use n18)))
              (always (not (stacks-in-use n5)))
              (always (not (stacks-in-use n25)))
        ))
        ))
        (:metric minimize (total-time))
)
