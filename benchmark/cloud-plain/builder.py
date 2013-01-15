#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import optparse
import sys
import os

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

def generate_run_all_script(problems):
    script = '''#!/bin/bash
OUTPUT="result.all"
DOMAIN="domain.pddl"
'''
    translate = '''#!/bin/bash
DOMAIN="domain.pddl"
TRANSLATE="../../translate/translate.py"
'''

    index = 0
    for p in problems:
        script += "PROBLEMS[" + str(index) + ']="' + p + '.pddl"' + "\n"
        translate += "PROBLEMS[" + str(index) + ']="' + p + '.pddl"' + "\n"
        index += 1

    translate += '''rm -rf $DIR
SAS="sas"
OPTIONS="" #--force-old-python

mkdir -p $SAS
for PROBLEM in "${PROBLEMS[@]}"; do
    DEST="$SAS/$PROBLEM-output.sas"
    if [[ -e "$DEST" ]]; then
       echo "$PROBLEM has been translated!"
    else
       command time --output="translate.time" --format="%U" $TRANSLATE $OPTIONS $DOMAIN $PROBLEM 1> $PROBLEM-translate-out.log 2> $PROBLEM-translate-err.log
       mv output.sas "$SAS/$PROBLEM-output.sas"
       mv translate.time "$SAS/$PROBLEM-translate.time"
       mv "$PROBLEM-translate-out.log" "$SAS"
       mv "$PROBLEM-translate-err.log" "$SAS"
    fi
done

'''

    script += 'TIMEOUT="' + PLANNER_TIMEOUT + '''"
$PLAN="plan"
PREPROCESS="../../preprocess/preprocess"
SEARCH="../../search/downward"
VAL="../../VAL/validate"

mkdir -p $DIR
for PROBLEM in "${PROBLEMS[@]}"; do
   SAS_FILE="$SAS/$PROBLEM-output.sas"
   echo "=== solving $PROBLEM === $SAS_FILE" >> $OUTPUT

   # preprocessing
   command time --output="preprocess.time" --format="%U" "$PREPROCESS" < $SAS_FILE 1> "$PLAN/$PROBLEM-preprocess-out.log" 2> "$PLAN/$PROBLEM-preprocess-err.log"
   RUNTIME=$(cat preprocess.time)
   echo "preprocessing: $RUNTIME" >> $OUTPUT
   mv preprocess.time "$PLAN/$PROBLEM-preprocess.time"

   ### CG
   echo -ne "cg: " >> $OUTPUT
   LOG_FILE="$PLAN/cg-$PROBLEM-search-out.log"
   ERROR_FILE="$PLAN/cg-$PROBLEM-search-err.log"
   PLAN_FILE="$PLAN/cg-$PRObLEM-sas.plan"
   command time --output="search.time" -f "%U" "$SEARCH" --heuristic "hcg=cg(cost_type=2)" --search "lazy_greedy(hcg)" < output 1> $LOG_FILE 2> $ERROR_FILE
   if [ -e "sas_plan" ]; then
      RESULT=$($VAL $DOMAIN $PROBLEM sas_plan)
      if [[ "$RESULT" == *"Plan valid"* ]]; then
         RUNTIME=$(cat search.time)
         echo "valid $RUNTIME" >> $OUTPUT
      else
         echo "invalid" >> $OUTPUT
      fi
      mv sas_plan $PLAN/cg-$PROBLEM.sas_plan
   else
      echo "no-plan" >> $OUTPUT
      touch $PLAN/cg-$PROBLEM.no_plan
   fi
   rm -f search.time

   ### FF
   echo -ne "ff: " >> $OUTPUT
   LOG_FILE="$PLAN/ff-$PROBLEM-search-out.log"
   ERROR_FILE="$PLAN/ff-$PROBLEM-search-err.log"
   PLAN_FILE="$PLAN/ff-$PRObLEM-sas.plan"
   command time --output="search.time" -f "%U" "$SEARCH" --heuristic "hff=ff(cost_type=0)" --search "lazy_greedy(hff)" < output 1> $LOG_FILE 2> $ERROR_FILE
   if [ -e "sas_plan" ]; then
      RESULT=$($VAL $DOMAIN $PROBLEM sas_plan)
      if [[ "$RESULT" == *"Plan valid"* ]]; then
         RUNTIME=$(cat search.time)
         echo "valid $RUNTIME" >> $OUTPUT
      else
         echo "invalid" >> $OUTPUT
      fi
      mv sas_plan $PLAN/ff-$PROBLEM.sas_plan
   else
      echo "no-plan" >> $OUTPUT
      touch $PLAN/ff-$PROBLEM.no_plan
   fi
   rm -f search.time

   ### CEA
   echo -ne "cea: " >> $OUTPUT
   LOG_FILE="$PLAN/cea-$PROBLEM-search-out.log"
   ERROR_FILE="$PLAN/cea-$PROBLEM-search-err.log"
   PLAN_FILE="$PLAN/cea-$PRObLEM-sas.plan"
   command time --output="search.time" -f "%U" "$SEARCH" --heuristic "hcea=cea(cost_type=2)" --search "lazy_greedy(hcea)" < output 1> $LOG_FILE 2> $ERROR_FILE
   if [ -e "sas_plan" ]; then
      RESULT=$($VAL $DOMAIN $PROBLEM sas_plan)
      if [[ "$RESULT" == *"Plan valid"* ]]; then
         RUNTIME=$(cat search.time)
         echo "valid $RUNTIME" >> $OUTPUT
      else
         echo "invalid" >> $OUTPUT
      fi
      mv sas_plan $PLAN/cea-$PROBLEM.sas_plan
   else
      echo "no-plan" >> $OUTPUT
      touch $PLAN/cea-$PROBLEM.no_plan
   fi
   rm -f search.time

done

../../cleanup
'''
    f = open("run-all", "w")
    f.write(script)
    f.close()

    f = open("translate-all", "w")
    f.write(translate)
    f.close()


class Option:
    def __init__(self):
        self.total_applayers = 1
        self.total_appservices = 1
        self.total_clients = 1
        self.name = "problem"
    def dump(self):
        print("applayers=" + str(self.total_applayers) + \
              "appservices=" + str(self.total_appservices) + \
              "clients=" + str(self.total_clients))

def generate_combination_problems(options):
    index = 0
    opt = Option()
    problems = []
    for l in range(1, int(options.total_applayers)+1):
        for a in range(1, int(options.total_appservices)+1):
            for c in range(1, int(options.total_clients)+1):
                name = "p-" + str(l) + "-" + str(a) + "-" + str(c)
                opt.total_applayers = l
                opt.total_appservices = a
                opt.total_clients = c
                opt.name = name
                outfile = name + ".pddl"
                generate_problem(outfile, opt)
                problems.append(name)
                index += 1

    generate_run_all_script(problems)
    print("Total problems: " + str(index))

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
