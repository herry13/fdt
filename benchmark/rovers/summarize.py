#!/usr/bin/env python

import commands
import os
import shutil

def evaluate_problems():
    problemdir = 'random'
    logdir = 'random-log'
    
    currentdir = os.getcwd()
    problemdir = currentdir + '/' + problemdir
    logdir = currentdir + '/' + logdir
    
    problems = commands.getoutput('cd ' + problemdir + '; ls *.pddl')
    problems = problems.split("\n")
    yield problems
    
    processed = commands.getoutput('cd ' + logdir + '; ls | gawk -F "-out" \'{print $1}\'')
    processed = processed.split("\n")
    yield processed

    no_solutions = commands.getoutput('cd ' + logdir + '; grep -n \'no solution\' *.log | gawk -F "-out" \'{print $1}\'')
    if no_solutions.strip() == '':
        no_solutions = []
    else:
        no_solutions = no_solutions.split("\n")
    yield no_solutions
    
    has_plans = commands.getoutput('cd ' + logdir + '; grep -n \'plan ---\' *.log | gawk -F "-out" \'{print $1}\'')
    if has_plans.strip() == '':
        has_plans = []
    else:
        has_plans = has_plans.split("\n")
    yield has_plans
    
    timeouts = []
    for item in processed:
        if (item not in no_solutions) and (item not in has_plans):
            timeouts.append(item)
    yield timeouts

def print_stats(problems, processed, no_solutions, has_plans, timeouts):
    print("Problems:     " + str(len(problems)))
    print("Evaluated:    " + str(len(processed)) + " (%2f percents)" % ((len(processed)*100.0)/len(problems)))
    print("No solutions: " + str(len(no_solutions)))
    
    print("Has plans:    " + str(len(has_plans)))
    print(str(has_plans))
    
    print("Timeouts:     " + str(len(timeouts)))
    print(str(timeouts))

def main():
    problems, processed, no_solutions, has_plans, timeouts = evaluate_problems()
    print_stats(problems, processed, no_solutions, has_plans, timeouts)

if __name__ == "__main__":
    main()
