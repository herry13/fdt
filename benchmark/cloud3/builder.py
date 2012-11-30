#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import optparse
import sys

# CloudBurst problem generator
#
# Architecture: webservice => appservice => dbservice
#
# Parameters:
# 1) output file name
# 2) the number of clients
# 3) the number of application services for each layer
# 4) the number of application layers (default: 1)

PLANNER_TIMEOUT = "8h"

def get_header(name):
    header = "(problem " + str(name) + ''')
(:domain CloudBurst)'''
    return header

def get_objects(webs, clients):
    ''' '''
    objects = "(:objects "
    # clouds
    objects += "cloud1 - cloud\ncloud2 - cloud\n"

    for web in webs:
        objects += web[0] + " - webservice\n"
        objects += "vm-" + web[0] + " - vm\n"
        for layer in web[1:]:
            for app in layer:
                objects += app + " - appservice\n"
                objects += "vm-" + app + " - vm\n"

    for c in clients:
        objects += c + " - client\n"
        
    objects += ")"
    return objects

def get_init(webs, clients):
    init = "(:init \n"

    def generate_web_depend_app(web):
        dep = ""
        for app in web[1]:
            dep += "(web_depend_app " + web[0] + " " + app + ")\n"
        return dep

    def generate_app_depend_app(layers):
        dep = ""
        for i in range(1, len(layers)):
            for j in range(0, len(layers[i])):
                dep += "(app_depend_app " + layers[i-1][j] + " " + layers[i][j] + ")\n"
        return dep

    web = webs[0]
    init += "(running " + web[0] + ")\n"
    init += "(is_in " + web[0] + " vm-" + web[0] + ")\n"
    init += "(running vm-" + web[0] + ")\n"
    init += "(in_cloud vm-" + web[0] + " cloud1)\n"
    for layer in web[1:]:
        for app in layer:
            init += "(running " + app + ")\n"
            init += "(is_in " + app + " vm-" + app + ")\n"
            init += "(running vm-" + app + ")\n"
            init += "(in_cloud vm-" + app + " cloud1)\n"
    init += generate_web_depend_app(web)
    init += generate_app_depend_app(web[1:])

    web = webs[1]
    init += "(is_in " + web[0] + " vm-" + web[0] + ")\n"
    init += "(in_cloud vm-" + web[0] + " cloud1)\n"
    for layer in web[1:]:
        for app in layer:
            init += "(is_in " + app + " vm-" + app + ")\n"
            init += "(in_cloud vm-" + app + " cloud1)\n"
    init += generate_web_depend_app(web)
    init += generate_app_depend_app(web[1:])

    for c in clients:
        init += "(refer " + c + " " + webs[0][0] + ")\n"

    init += ")"
    return init

def get_goal(webs, clients):
    goal = "(:goal (and\n"

    web = webs[0]
    goal += "(in_cloud vm-" + web[0] + " cloud2)\n"
    for layer in web[1:]:
        for app in layer:
            goal += "(in_cloud vm-" + app + " cloud2)\n"

    web = webs[1]
    goal += "(in_cloud vm-" + web[0] + " cloud1)\n"
    goal += "(not (running vm-" + web[0] + "))\n"
    for layer in web[1:]:
        for app in layer:
            goal += "(in_cloud vm-" + app + " cloud1)\n"
            goal += "(not (running vm-" + app + "))\n"

    for c in clients:
        goal += "(refer " + c + " " + webs[0][0] + ")\n"

    goal += "))"
    return goal

def get_constraint(webs, clients):
    constraint = '''(:constraints (and
	(forall (?s - service)
		(always
			(exists (?v - vm)
				(and (is_in ?s ?v)
					(imply (running ?s) (running ?v))))))

	(forall (?w - webservice ?a - appservice)
		(always
			(imply
				(and (web_depend_app ?w ?a) (running ?w))
				(running ?a))))

	(forall (?a1 ?a2 - appservice)
		(always
			(imply
				(and (app_depend_app ?a1 ?a2) (running ?a1))
				(running ?a2))))

	(forall (?c - client ?w - webservice)
		(always (imply (refer ?c ?w) (running ?w))))
))'''
    return constraint

def get_pddl(name, webs, clients):
    pddl = "(define " + get_header(name) + "\n" + \
           get_objects(webs, clients) + "\n" + \
           get_init(webs, clients) + "\n" + \
           get_goal(webs, clients) + "\n" + \
           get_constraint(webs, clients) + "\n" + \
           ")"
    return pddl

def generate_problem(outfile, options):
    print("Generate..." + outfile)

    webs = []
    for i in range(0,2):
        web = []
        web.append("ws" + str(i))
        for j in range(0, int(options.total_applayers)):
            apps = []
            for k in range(0, int(options.total_appservices)):
                apps.append("app" + str(i) + "-" + str(j) + "-" + str(k))
            web.append(apps)
        webs.append(web)

    clients = []
    for i in range(0, int(options.total_clients)):
        clients.append("pc-" + str(i))

    name, ext = outfile.split(".")
    pddl = get_pddl(name, webs, clients)

    f = open(outfile, "w")
    f.write(pddl)
    f.close()

def generate_run_all_script(last_index):
    script = '''#!/bin/bash
OUTPUT="result.all"
DOMAIN="domain.pddl"
'''
    for i in range(1, last_index+1):
        script += "PROBLEMS[" + str(i) + ']="p' + str(i) + '.pddl"' + "\n"

    script += 'TIMEOUT="' + PLANNER_TIMEOUT + '''"
rm -f $OUTPUT
rm -rf log
mkdir -p log
for PROBLEM in "${PROBLEMS[@]}"; do
   echo "=== solving $PROBLEM ===" >> $OUTPUT
   echo -ne "cg: " >> $OUTPUT
   LOG_FILE="log/cg-$PROBLEM.log"
   ../../cg $DOMAIN $PROBLEM $TIMEOUT $LOG_FILE >> $OUTPUT
   if [ -e "sas_plan" ]; then
      mv sas_plan log/cg-$PROBLEM.sas_plan
   fi

   echo -ne "ff: " >> $OUTPUT
   LOG_FILE="log/ff-$PROBLEM.log"
   ../../ff $DOMAIN $PROBLEM $TIMEOUT $LOG_FILE >> $OUTPUT
   if [ -e "sas_plan" ]; then
      mv sas_plan log/ff-$PROBLEM.sas_plan
   fi

   echo -ne "cea: " >> $OUTPUT
   LOG_FILE="log/cea-$PROBLEM.log"
   ../../cea $DOMAIN $PROBLEM $TIMEOUT $LOG_FILE >> $OUTPUT
   if [ -e "sas_plan" ]; then
      mv sas_plan log/cea-$PROBLEM.sas_plan
   fi

   echo -ne "lama: " >> $OUTPUT
   LOG_FILE="log/lama-$PROBLEM.log"
   ../../lama $DOMAIN $PROBLEM $TIMEOUT $LOG_FILE >> $OUTPUT
   if [ -e "sas_plan" ]; then
      mv sas_plan log/lama-$PROBLEM.sas_plan
   fi
done

../../cleanup
'''
    f = open("run-all", "w")
    f.write(script)
    f.close()

class Option:
    def __init__(self):
        self.total_applayers = 1
        self.total_appservices = 1
        self.total_clients = 1
    def dump(self):
        print("applayers=" + str(self.total_applayers) + \
              "appservices=" + str(self.total_appservices) + \
              "clients=" + str(self.total_clients))

def generate_combination_problems(options):
    index = 1
    opt = Option()
    for l in range(1, int(options.total_applayers)+1):
        for a in range(1, int(options.total_appservices)+1):
            for c in range(1, int(options.total_clients)+1):
                outfile = "p" + str(index) + ".pddl"
                opt.total_applayers = l
                opt.total_appservices = a
                opt.total_clients = c
                generate_problem(outfile, opt)
                index += 1

    generate_run_all_script(index-1)

def parse_options():
    parser = optparse.OptionParser(usage="Usage: %prog [options] <output.pddl>")
    parser.add_option("-c", "--clients", dest="total_clients", default=2,
                      help="total clients depend on the web service")
    parser.add_option("-a", "--appservices", dest="total_appservices", default=1,
                      help="total application services which the web service depends on")
    parser.add_option("-l", "--applayers", dest="total_applayers", default=1,
                      help="total application layers")
    parser.add_option("-t", "--automatic", dest="automatic", default=0,
                      help="automatically generate all combinations")
    options, args = parser.parse_args()
    sys.argv = [sys.argv[0]] + args

    if int(options.automatic) > 0:
        return options, None
    elif len(args) < 1:
        parser.error("incorrent number of arguments")
    return options, args[0]

def main():
    options, outfile = parse_options()

    if outfile is None:
        generate_combination_problems(options)
    else:
        generate_problem(outfile, options)

if __name__ == "__main__":
    main()
