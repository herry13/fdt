#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import optparse
import sys
import os
import random

'''
def process_input(infile):
    print("Proses input file: " + infile)
    header = ""
    footer = ""
    constraints = {}
    goal_prefs = []

    in_constraints = False
    in_goal_prefs = False
    in_header = True
    total = 0
    for line in open(infile, 'r'):
        line = line.strip()
        if line[0:14] == "(:constraints ":
            in_constraints = True
            continue
        if line == ";;--- start of goal preferences ---;;":
            in_goal_prefs = True
            continue
        if line == ";;--- end of goal preferences ---;;":
            in_goal_prefs = False
            continue
        if in_constraints and line == "))":
            in_constraints = in_goal_prefs = in_header = False
            continue
        if not in_constraints or not in_goal_prefs:
            if in_header:
                header += line + "\n"
            else:
                footer += line + "\n"
        if in_constraints:
            parts = line.split(" ", 2)
            if parts[0] == '(preference':
                parts = parts[1].split(" ", 2)
                last = len(parts[1]) - 1
                line = parts[1][0:last]
                parts = line.split(" ", 2)
            key = parts[0][1:].strip()
            if key not in constraints:
                constraints[key] = []
            constraints[key].append(line)
            total += 1
        if in_goal_prefs:
            goal_prefs.append(line)
    yield header
    yield footer
    print("Total constraints: " + str(total))
    print("Total goal preferences: " + str(len(goal_prefs)))
    yield constraints

def generate_combination_problems(options, header, footer, constraints, outfile):
    print("Generate combinations...")
    for key in constraints:
        print(key + ": " + str(len(constraints[key])))

def generate_random_problems(header, footer, constraints, outfile, total):
    print("Generate random problems...")
    fname, ext = outfile.split(".", 2)
    values = []
    for val in constraints.itervalues():
        values.extend(val)
    constraints = set(values)
    total_constraints = len(values)
    for i in range(0, int(total)):
        selected = random.sample(values, random.randint(1, total_constraints))
        pddl = "; " + str(len(selected)) + " constraints\n"
        pddl += header + "\n"
        pddl += "(:constraints (and\n"
        for item in selected:
            pddl += item + "\n"
        pddl += "))\n"
        pddl += footer
        target_file = fname + "-" + str(i) + ".pddl"
        print("create file: " + target_file + " (" + str(len(selected)) + " constraints)")
        f = open(target_file, 'w')
        f.write(pddl)
        f.close()
    print("...Finish!")
'''

def parse(infile):
    print("Parsing input file: " + infile)
    prefix = infix = suffix = ""
    trajectories = []
    goal_prefs = []

    mode = 0 # 0=normal, 1=goal-prefs, 2=trajectory
    part = 0
    for line in open(infile, 'r'):
        stmt = line.strip()
        if stmt == ";;--- start of goal preferences ---;;" and mode != 1:
            # goal-prefs
            mode = part = 1
            prefix += line
            continue
        elif stmt[0:14] == "(:constraints " and mode != 2:
            # trajectory
            mode = part = 2
            infix += line
            continue
        elif stmt == ";;--- end of goal preferences ---;;" or stmt == "))":
            mode = 0

        if mode == 1:
            goal_prefs.append(line)
        elif mode == 2:
            trajectories.append(line)
        elif part == 0:
            prefix += line
        elif part == 1:
            infix += line
        else:
            suffix += line
    print("Total trajectory constraints: " + str(len(trajectories)))
    #print(str(trajectories))
    print("Total goal preferences: " + str(len(goal_prefs)))
    #print(str(goal_prefs))
    yield prefix
    yield infix
    yield suffix
    yield goal_prefs
    yield trajectories

def generate_random_problems(infile, total):
    prefix, infix, suffix, goal_prefs, trajectories = parse(infile)
    print("Generating " + str(total) + " random problems...")
    fname, ext = infile.split(".", 2)
    for i in range(1, total+1):
        goal = random.sample(goal_prefs, random.randint(1, len(goal_prefs)))
        traj = random.sample(trajectories, random.randint(1, len(trajectories)))
        pddl = "; Goal preferences: " + str(len(goal)) + "\n; Trajectories: " + str(len(traj)) + "\n\n"
        pddl += prefix + ("".join(goal)) + infix + ("".join(traj)) + suffix
        num = str(i)
        for i in range(0, 3-len(num)):
            num = "0" + num
        outfile = fname + "-" + num + ".pddl"
        with open(outfile, 'w') as f:
            f.write(pddl)
    print("...finished!")

def parse_options():
    parser = optparse.OptionParser(usage="Usage: %prog <input.pddl>")
    parser.add_option("-p", "--percentage", dest="percentage", default=None,
                      help="Minimum percentage of total constraint of each class (Default: None)")
    parser.add_option("-i", "--increase", dest="increment", default=False,
                      help="Increase the number of constraint step-by-step? (Default: FALSE)")
    parser.add_option("-r", "--random", dest="total_random", default=10,
                      help="Total generated random problems")
    options, args = parser.parse_args()
    sys.argv = [sys.argv[0]] + args

    if len(args) < 1:
        parser.error("incorrent number of arguments")
    return options, args[0]

def main():
    options, infile = parse_options()
    generate_random_problems(infile, int(options.total_random))

    '''header, footer, constraints = process_input(infile)
    if options.percentage == None:
        generate_random_problems(header, footer, constraints, infile, options.total_random)
    #generate_combination_problems(header, footer, constraints, infile)'''

if __name__ == "__main__":
    main()
