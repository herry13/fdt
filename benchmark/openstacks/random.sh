#!/bin/bash

DEST="random"
BUILDER="./builder.py"
TOTAL=2

PROBLEMS[0]="p01.pddl"
PROBLEMS[1]="p02.pddl"
PROBLEMS[2]="p03.pddl"
PROBLEMS[3]="p04.pddl"
PROBLEMS[4]="p05.pddl"
PROBLEMS[5]="p06.pddl"
PROBLEMS[6]="p07.pddl"
PROBLEMS[7]="p08.pddl"
PROBLEMS[8]="p09.pddl"
PROBLEMS[9]="p10.pddl"
PROBLEMS[10]="p11.pddl"
PROBLEMS[11]="p12.pddl"
PROBLEMS[12]="p13.pddl"
PROBLEMS[13]="p14.pddl"
PROBLEMS[14]="p15.pddl"
PROBLEMS[15]="p16.pddl"
PROBLEMS[16]="p17.pddl"
PROBLEMS[17]="p18.pddl"
PROBLEMS[18]="p19.pddl"
PROBLEMS[19]="p20.pddl"

mkdir -p $DEST
for PROBLEM in "${PROBLEMS[@]}"; do
	$BUILDER -r $TOTAL $PROBLEM
done
mv *-*.pddl $DEST
