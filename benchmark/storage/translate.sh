#!/bin/bash

DOMAIN="domain.pddl"
PROBLEM_DIR="random"
OUTPUT_DIR="sas"
PYTHON="python2.7"
TRANSLATOR="$PYTHON ../../translate.2/translate.py"

mkdir -p $OUTPUT_DIR

rm -f translate-all.log

for file in $PROBLEM_DIR/*; do
   echo -n "Processing $file..."
   echo "------ Problem: $file ------" >> translate-all.log

   filename=$(basename "$file")
   filename="${filename%.*}"
   timefile="$OUTPUT_DIR/$filename-translate.time"

	command time --output="$timefile" --format="%U" nice $TRANSLATOR $DOMAIN $file > translate.log

   # save outputs
   mv -f output.sas $OUTPUT_DIR/$filename-output.sas 2>/dev/null

   echo translate.log >> translate-all.log
   mv -f translate.log $OUTPUT_DIR/$filename-translate.log 2>/dev/null

   # cleanup
   $CLEANUP

   echo "[OK]"
done
