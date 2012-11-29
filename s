#!/bin/bash

DIR=$(cd $(dirname "$0"); pwd)

DOMAIN=$1
PROBLEM=$2

if [ "$DOMAIN" == "" ]; then
	#DOMAIN="benchmark/cloudburst.pddl"
	#PROBLEM="benchmark/cb-p02.pddl"

	#DOMAIN="benchmark/rovers/domain.pddl"
	#PROBLEM="benchmark/rovers/p01.pddl"

	DOMAIN=benchmark/service.pddl
	PROBLEM=benchmark/s17.pddl
fi

if [ -e "sas_plan" ]; then
	rm sas_plan
fi

#./plan $DOMAIN $PROBLEM --heuristic "hff=ff()" --search "lazy_greedy(hff, preferred=hff)"
#./plan $DOMAIN $PROBLEM --search "lazy_greedy(cg(), preferred=cg())"

### FF
#./plan $DOMAIN $PROBLEM --heuristic "hff=ff()" --search "lazy_greedy(hff, preferred=hff)"

### CG
$DIR/plan $DOMAIN $PROBLEM --heuristic "hcg=cg(cost_type=1)" --search "lazy_greedy(hcg)"

### Landmark
#./plan $DOMAIN $PROBLEM --landmarks "lm=lm_rhw(conjunctive_landmarks=true, disjunctive_landmarks=true)" --heuristic "hlm=lmcount(lm, admissible=false, optimal=false, pref=false)" --search "lazy_greedy(hlm, preferred=hlm)"

#./plan $DOMAIN $PROBLEM --heuristic "hlm,hff=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=2,cost_type=2))" --search "iterated([lazy_greedy([hff,hlm],preferred=[hff,hlm]),lazy_wastar([hff,hlm],preferred=[hff,hlm],w=5),lazy_wastar([hff,hlm],preferred=[hff,hlm],w=3),lazy_wastar([hff,hlm],preferred=[hff,hlm],w=2),lazy_wastar([hff,hlm],preferred=[hff,hlm],w=1)])"

#./plan $DOMAIN $PROBLEM --heuristic "hlm,hff=lm_ff_syn(lm_rhw(reasonable_orders=true,lm_cost_type=2,cost_type=2))" --search "lazy_greedy([hff,hlm],preferred=[hff,hlm])"

#./plan $DOMAIN $PROBLEM $1


# postprocessing
if [ -e "sas_plan" ]; then
	sed -i '/\(verify_.* \)/d' sas_plan
	cat sas_plan
   echo ""
   $DIR/VAL/validate $DOMAIN $PROBLEM sas_plan
   #./VAL/validate -v $DOMAIN $PROBLEM sas_plan
fi
