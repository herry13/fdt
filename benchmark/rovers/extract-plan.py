#!/usr/bin/env python

import commands
import os
import shutil

from summarize import *

def move_files(files, target_dir):
    if not os.path.isdir(target_dir):
        os.makedirs(target_dir)
    for item in files:
        shutil.move(item, target_dir)

def filter_problems(has_plans, no_solutions):
    print("Move solved problems...")
    files = [problemdir + "/" + filename for filename in has_plans]
    target_dir = currentdir + '/solved'
    move_files(files, target_dir)
    
    print("Move no solution problems...")
    files = [problemdir + "/" + filename for filename in no_solutions]
    target_dir = currentdir + '/no-solution'
    move_files(files, target_dir)

def extract_plan(problems, log_dir, target_dir):
    if not os.path.isdir(target_dir):
        os.makedirs(target_dir)
    for item in problems:
        infile = log_dir + "/" + item + "-out.log"
        in_plan = False
        plan = ""
        for line in open(infile, 'r'):
            if not in_plan and line[0:7] == "-- plan":
                in_plan = True
                continue
            if in_plan:
                plan += line
        parts = item.split(".", 2)
        outfile = target_dir + "/" + parts[0] + ".plan"
        f = open(outfile, 'w')
        f.write(plan)
        f.close()
        print("Extracted plan from: " + infile)
    print("Total extracted plans: " + str(len(problems)))

def main():
    problems, processed, no_solutions, has_plans, timeouts = evaluate_problems()
    print_stats(problems, processed, no_solutions, has_plans, timeouts)

    log_dir = "random-log"
    target_dir = "random-plans"
    extract_plan(has_plans, log_dir, target_dir)

if __name__ == "__main__":
    main()
