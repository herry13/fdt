#!/usr/bin/env python

import commands
import os
import shutil

from summary import *

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

def main():
    problems, processed, no_solutions, has_plans, timeouts = evaluate_problems()
    print_stats(problems, processed, no_solutions, has_plans, timeouts)
    filter_problems(has_plans, no_solutions)

if __name__ == "__main__":
    main()
