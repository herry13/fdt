#!/bin/bash

DOMAIN="domain.pddl"
PROBLEM_DIR="random"
OUTPUT_DIR="result"

PLANNER="../../plan"
OPTIONS="ff"

VAL="../../VAL/validate"

CLEANUP="../../cleanup"

mkdir -p $OUTPUT_DIR

rm -f planner-all.log

for file in $PROBLEM_DIR/*; do
   echo -n "Processing $file..."

   echo "------ Problem: $file ------" >> planner-all.log

	$PLANNER $DOMAIN $file $OPTIONS > planner.log

   filename=$(basename "$file")
   filename="${filename%.*}"

   #valid=""
   #if [[ -f sas_plan ]]; then
   #   valid=$("$VAL $DOMAIN $file sas_plan | grep 'Plan valid'")
   #   echo $valid
   #fi

   #if [ -n "$valid" ]; then
   if [[ -f sas_plan ]]; then
      echo -n "plan found..."
      sed -i.old '/(verify_always )/d' sas_plan

      # save outputs
      mv -f output.sas $OUTPUT_DIR/$filename-output.sas 2>/dev/null
      mv -f output $OUTPUT_DIR/$filename-output 2>/dev/null
      mv -f elapsed.time $OUTPUT_DIR/$filename-elapsed.time 2>/dev/null
      mv -f plan_number_and_cost $OUTPUT_DIR/$filename-plan_number_and_cost 2>/dev/null
      mv -f sas_plan $OUTPUT_DIR/$filename-sas_plan 2>/dev/null

      NUM=1
      while [[ -e sas_plan.$NUM ]]; do
         mv -f sas_plan.$NUM $OUTPUT_DIR/$filename-sas_plan.$NUM
         NUM=$((NUM + 1))
      done
   fi

   echo planner.log >> planner-all.log
   mv -f planner.log $OUTPUT_DIR/$filename-planner.log 2>/dev/null

   # cleanup
   $CLEANUP

   echo "[OK]"
done
