#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import optparse
import sys
import os
import random

def process_input(infile):
    print("Proses input file: " + infile)
    header = ""
    footer = ""
    constraints = {}

    in_constraints = False
    in_header = True
    total = 0
    for line in open(infile, 'r'):
        line = line.strip()
        if line[0:14] == "(:constraints ":
            in_constraints = True
            continue
        if in_constraints and line == "))":
            in_constraints = in_header = False
            continue
        if not in_constraints:
            if in_header:
                header += line + "\n"
            else:
                footer += line + "\n"
        if in_constraints:
            parts = line.split(" ", 2)
            key = parts[0][1:].strip()
            if key not in constraints:
                constraints[key] = []
            constraints[key].append(line)
            total += 1
    yield header
    yield footer
    print("Total constraints: " + str(total))
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
    for i in range(0, total):
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

    header, footer, constraints = process_input(infile)
    if options.percentage == None:
        generate_random_problems(header, footer, constraints, infile, options.total_random)
    #generate_combination_problems(header, footer, constraints, infile)

if __name__ == "__main__":
    main()
