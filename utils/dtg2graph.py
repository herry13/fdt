#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

# Required Ubuntu packages:
# - graphviz
# - libgv-python
# - python-pygraphviz
#
# Required python lib (install using command: "easy_install <package-name>"):
# - pyparsing
#
# TODO:
# - Add a casual-link between two indirect-connected variables.
#   "v1" and "v2" are indirect-connected if there is an axiom x where v1->x->v2
# - Remove derived-variables to simplify the casual graphs.
# - Create sub-group of variables:
#   - "v1" and "v2" are in the same group iff v1->v2 and v2->v1
# - If there are two or more groups, then:
#   - Sort the groups based on the casual-links between the groups.
#   - Solve the group that does not have precondition from other groups, then
#     iteratively solve other groups in the lower level

# import graphviz
import sys
import gv
import optparse

# import pygraph
from pygraph.classes.graph import graph
from pygraph.classes.digraph import digraph
from pygraph.readwrite.dot import write

INCLUDE_ALWAYS = False
INCLUDE_DERIVED_VARIABLE = True

# TODO -- parse the variable one-by-one
class Variable:
    def __init__(self, index):
        self.index = index
        self.name = ""
        self.ranges = 0
        self.axiom_layer = -1
        self.is_always = False

    def isderived(self):
        return (self.axiom_layer >= 0)

    def get_label(self):
        if self.isderived():
            return "(" + self.name + ")"
        return self.name

    def parse(self, instream):
        line = instream.readline().strip()
        if line == "begin_variable":
            self.name = instream.readline().strip()
            self.axiom_layer = int(instream.readline().strip())
            self.ranges = int(instream.readline().strip())
            while line and line != "end_variable":
                line = instream.readline().strip()
                if line == "Atom always()":
                    self.is_always = True
                    print(self.name + " is always")
        else:
            raise Exception('Magic keyword "begin_variable" is not found')
            
class CasualGraph:
    def __init__(self, variable):
        self.variable = variable
        self.causals = []

    def add_causal(self, variable, value):
        self.causals.append((variable, value))

    def parse(self, instream, variables):
        self.total = int(instream.readline().strip())
        for i in range(0, self.total):
            dat = instream.readline().strip().split(' ')
            self.add_causal(variables[int(dat[0])], int(dat[1]))

class SAS:
    def __init__(self):
        self.variables = []
        self.causal_graphs = []

def create_dtg_graph(sas):
    # TODO -- create DTGs graph
    gr = digraph()

    for var in sas.variables:
        gr.add_node(var.get_label())

    for cg in sas.causal_graphs:
        if cg.variable.is_always and not INCLUDE_ALWAYS:
            '''skip "always" variable'''
        elif cg.variable.isderived() and not INCLUDE_DERIVED_VARIABLE:
            ''' skip '''
        else:
            '''if not cg.variable.isderived():
                print(str(cg.variable.index) + ": " + cg.variable.name + " => " + str(cg.variable.isderived()))'''
            for causal in cg.causals:
                if causal[0].is_always and not INCLUDE_ALWAYS:
                    ''' skip '''
                elif causal[0].isderived() and not INCLUDE_DERIVED_VARIABLE:
                    ''' skip '''
                else:
                    #gr.add_edge((causal[0].get_label(), cg.variable.get_label()))
                    gr.add_edge((cg.variable.get_label(), causal[0].get_label()))

    return gr

def save_graph(graph, outfile):
    dot = write(graph)
    gvv = gv.readstring(dot)
    gv.layout(gvv, 'dot')
    gv.render(gvv, 'png', outfile)

def parse_sas(infile):
    # TODO -- parse SAS file, return SAS object
    ''' '''
    sas = SAS()
    f = open(infile)
    line = f.readline()
    while line and line != "end_metric":
        line = f.readline().strip()
    ### variables
    total_variable = int(f.readline())
    for i in range(0, total_variable):
        var = Variable(i)
        var.parse(f)
        sas.variables.append(var)
    ### mutexes
    total_mutex = int(f.readline().strip())
    for i in range(0, total_mutex):
        f.readline()
    ### state
    line = f.readline().strip()
    while line and line != "end_state":
        line = f.readline().strip()
    ### goal
    line = f.readline().strip()
    while line and line != "end_goal":
        line = f.readline().strip()
    ### operators
    total_operator = int(f.readline().strip())
    for i in range(0, total_operator):
        line = f.readline().strip()
        while line and line != "end_operator":
            line = f.readline().strip()
    ### axioms
    total_axiom = int(f.readline().strip())
    for i in range(0, total_axiom):
        line = f.readline().strip()
        while line and line != "end_rule":
            line = f.readline().strip()
    ### SG or DTG
    line = f.readline().strip()
    while line and line != "begin_CG":
        if line == "begin_SG":
            while line and line != "end_SG":
                line = f.readline().strip()
        elif line == "begin_DTG":
            while line and line != "end_DTG":
                line = f.readline().strip()
        line = f.readline().strip()
    ### CG (causal graph)
    for i in range(0, len(sas.variables)):
        cg = CasualGraph(sas.variables[i])
        cg.parse(f, sas.variables)
        sas.causal_graphs.append(cg)
    return sas

def parse_options():
    parser = optparse.OptionParser(usage="Usage: %prog [options]")
    parser.add_option("-i", "--input", dest="infile", default="output",
                      help='SAS (input) file. Default: "./output"')
    parser.add_option("-o", "--output", dest="outfile", default="dtg.png",
                      help='Graph (output) file. Default: "./dtg.png"')
    options, args = parser.parse_args()
    return options

def main():
    options = parse_options()
    sas = parse_sas(options.infile)
    graph = create_dtg_graph(sas)
    save_graph(graph, options.outfile)


if __name__ == "__main__":
    main()
