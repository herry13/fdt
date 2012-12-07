#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

# Required Ubuntu packages:
# - graphviz
# - libgv-python
# - python-pygraphviz
#
# Required python lib (using "easy_install <package-name>"):
# - pyparsing

# import graphviz
import sys
import gv
import optparse

# import pygraph
from pygraph.classes.graph import graph
from pygraph.classes.digraph import digraph
from pygraph.readwrite.dot import write


def create_dtg_graph(sas):
    # TODO -- create DTGs graph
    gr = digraph()
    gr.add_nodes(["A", "B", "C"])
    gr.add_nodes(["D", "E", "F"])
    
    gr.add_edge(("A", "B"))
    gr.add_edge(("B", "E"))
    gr.add_edge(("F", "C"))

    return gr

def save_graph(graph, outfile):
    dot = write(graph)
    gvv = gv.readstring(dot)
    gv.layout(gvv, 'dot')
    gv.render(gvv, 'png', outfile)

def parse_sas(infile):
    # TODO -- parse SAS file, return SAS object
    ''' '''
    return None

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
