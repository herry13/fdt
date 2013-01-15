#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import sys
import optparse
import math
import string
from rpy import r

SASDirectory = "sas"

def get_problem_label(problem):
    problem = problem.split(" ")[2]
    problem = problem.split(".")[0]
    return problem

def parse_input(infile, data):
    f = open(infile)
    line = f.readline()
    while line and line[0:3] == "===":
        problem = get_problem_label(line)
        dat = {"problem": problem}
        dat["translate"] = get_translate_time(problem)
        line = f.readline().strip()
        while line and line[0:3] != "===":
            if len(line) <= 0:
                break
            parts = line.split(" ")
            label = parts[0][0:(len(parts[0])-1)]
            if parts[1] == "valid":
                dat[label] = parts[2]
            else:
                dat[label] = parts[1]
            line = f.readline().strip()
        data.append(dat)

def get_translate_time(problem):
    infile = SASDirectory + "/" + problem + ".pddl-out.log"
    f = open(infile)
    lines = f.readlines();
    data = lines[len(lines)-1].split(" ")
    return data[1][1:-1]

def save_to_csv(outfile, data):
    f = open(outfile, 'w')
    items = ["problem", "translate"]
    first = True
    for item in items:
        if first:
            first = False
        else:
            f.write(",")
        f.write(item)

    for k, v in data[0].iteritems():
        if k not in items:
            f.write("," + k)
            items.append(k)
    f.write("\n")

    for dat in data:
        line = ""
        for k in items:
            line += dat[k] + ","
        f.write(line[0:len(line)-1] + "\n")

def get_y_step(max_value):
    base = 500
    yield base
    yield int(math.ceil(max_value / base))

def plot(outfile, data, out_format='png'):
    w = int(round(len(data)/4.0))

    if out_format == 'png':
        r.png(outfile, width=w*100, height=1000, res=72)
    elif out_format == 'pdf':
        r.pdf(outfile, width=w, height=10)
    else:
        raise Exception('Unrecognised format: ' + str(out_format))

    print("total: " + str(len(data)))

    series = []
    points = {'translate': [], 'preprocessing': []}

    for dat in data:
        points['translate'].append(float(dat['translate']))
        points['preprocessing'].append(float(dat['preprocessing']))

    xlabels = []
    for k, v in data[0].iteritems():
        if k not in ["problem", 'translate', 'preprocessing']:
            series.append(k)
            points[k] = []

    index = 0
    for dat in data:
        for k in series:
            if dat[k] != 'no-plan':
                points[k].append(float(dat[k]) + \
                                 points['translate'][index] + \
                                 points['preprocessing'][index])
            else:
                points[k].append(-1000)
        xlabels.append(dat['problem'])
        index += 1

    max_value = max(iter([max(iter(points[k]))  for k in series]))
    yrange = (0, max_value)
    legend_labels = []

    x = [i for i in range(1,len(points['translate'])+1)]
    y = [-1000 for i in x]
    r.par(mar=(7,5,4,2))
    r.plot(x, y, main='', xlab="", ylab='',
           xaxt='n', yaxt='n', pch=0, ylim=yrange,
           mgp=(5,1,0))
    r.mtext("Problem", side=1, line=5)
    r.mtext("CPU Time (s)", side=2, line=3)

    pch_start = 1
    pch_index = pch_start
    # plotting "translate"
    #r.plot(x, points['translate'], main='',
    #       xlab='', ylab='Time (s)',
    #       xaxt='n', yaxt='n',
    #       pch=0, ylim=yrange)
    #legend_labels.append('translate')
    r.lines(x, points['translate'], lty=1)
    
    # preprocessing -- Removed since it's insignificant
    #r.points(x, points['preprocessing'], pch=pch_index)
    #pch_index =+ 1

    # planner output
    for k in series:
        if k != 'translate' and k != 'preporcessing':
            r.points(x, points[k], pch=pch_index)
            pch_index += 1
            legend_labels.append("FD+" + k.upper())

    # put x-axis labels
    for i in range(0, len(xlabels)):
        r.axis(side=1, at=i+1, labels=xlabels[i], las=2)

    # put y-axis labels
    base, step = get_y_step(max_value)
    print("base: " + str(base) + " -- step: " + str(step))
    y = base
    for i in range(0, step):
        r.axis(side=2, at=y, labels=str(y), las=2)
        y += base

    # legend
    r.legend(1, max_value, legend_labels, pch=[i for i in range(pch_start, pch_index)])

    r.dev_off()

def parse_options():
    parser = optparse.OptionParser(usage="Usage %prog [options] <file1> [file2] ...")
    parser.add_option("-o", "--output", dest="outfile", default="summary.png",
                      help="The output file. ('summary.png' or 'summary.csv'")
    parser.add_option("-f", "--format", dest="format", default="png",
                      help="Output format: png or csv")
    options, args = parser.parse_args()
    if len(args) <= 0:
        parser.error("Incorrect number of arguments!")

    if options.format == "csv" and options.outfile == "summary.png":
        options.outfile = "summary.csv"
    elif options.format == "pdf" and options.outfile == "summary.png":
        options.outfile = "summary.pdf"

    return options, args

def main():
    options, args = parse_options();
    data = []
    for infile in args:
        parse_input(infile, data)
    if options.format == "png" or options.format == "pdf":
        plot(options.outfile, data, options.format)
    elif options.format == "csv":
        save_to_csv(options.outfile, data)
    else:
        print(str(data))

if __name__ == "__main__":
    main()
