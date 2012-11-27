#!/bin/bash

#DOMAIN="benchmark/cloudburst.pddl"
#PROBLEM="benchmark/cb-p02.pddl"

DOMAIN=benchmark/service.pddl
PROBLEM=benchmark/s16.pddl

rm sas_plan

#./plan $DOMAIN $PROBLEM --heuristic "hff=ff()" --search "lazy_greedy(hff, preferred=hff)"
#./plan $DOMAIN $PROBLEM --search "lazy_greedy(cg(), preferred=cg())"

### FF
#./plan $DOMAIN $PROBLEM --heuristic "hff=ff()" --search "lazy_greedy(hff, preferred=hff)"

### CG
#./plan $DOMAIN $PROBLEM --heuristic "hcg=cg()" --search "lazy_greedy(hcg, preferred=hcg)"

### Landmark
./plan $DOMAIN $PROBLEM --landmarks "lm=lm_rhw(conjunctive_landmarks=true, disjunctive_landmarks=true)" --heuristic "hlm=lmcount(lm, admissible=false, optimal=false, pref=false)" --search "lazy_greedy(hlm, preferred=hlm)"

#./plan $DOMAIN $PROBLEM --heuristic "hlm,hff=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=2,cost_type=2))" --search "iterated([lazy_greedy([hff,hlm],preferred=[hff,hlm]),lazy_wastar([hff,hlm],preferred=[hff,hlm],w=5),lazy_wastar([hff,hlm],preferred=[hff,hlm],w=3),lazy_wastar([hff,hlm],preferred=[hff,hlm],w=2),lazy_wastar([hff,hlm],preferred=[hff,hlm],w=1)])"

#./plan $DOMAIN $PROBLEM $1


# postprocessing
if [ -e "sas_plan" ]; then
	sed -i '/\(verify_.* \)/d' sas_plan
	cat sas_plan
   echo ""
   ./VAL/validate $DOMAIN $PROBLEM sas_plan
fi
