from __future__ import print_function

import sys
from collections import defaultdict

from . import effects
from . import actions
from . import axioms
from . import conditions
from . import predicates
from . import pddl_types
from . import functions
from . import f_expression

class Task(object):
    def __init__(self, domain_name, task_name, requirements,
                 types, objects, predicates, functions, init, goal, actions, axioms, use_metric, trajectory):
        self.domain_name = domain_name
        self.task_name = task_name
        self.requirements = requirements
        self.types = types
        self.objects = objects
        self.predicates = predicates
        self.functions = functions
        self.init = init
        self.goal = goal
        self.actions = actions
        self.axioms = axioms
        self.axiom_counter = 0
        self.use_min_cost_metric = use_metric
        self.trajectory = trajectory

    def add_axiom(self, parameters, condition):
        name = "new-axiom@%d" % self.axiom_counter
        self.axiom_counter += 1
        axiom = axioms.Axiom(name, parameters, len(parameters), condition)
        self.predicates.append(predicates.Predicate(name, parameters))
        self.axioms.append(axiom)
        return axiom

    @staticmethod
    def parse(domain_pddl, task_pddl):
        domain_name, domain_requirements, types, constants, predicates, functions, actions, axioms \
                     = parse_domain(domain_pddl)
        task_name, task_domain_name, task_requirements, objects, init, goal, use_metric, trajectory = parse_task(task_pddl)

        # modify existing actions & goal, add necessary actions to maintain the trajectory constraints
        goal = trajectory.modify_goal(goal)
        trajectory.modify_actions(actions)

        assert domain_name == task_domain_name
        requirements = Requirements(sorted(set(
                    domain_requirements.requirements +
                    task_requirements.requirements)))
        objects = constants + objects
        check_for_duplicates(
            [o.name for o in objects],
            errmsg="error: duplicate object %r",
            finalmsg="please check :constants and :objects definitions")
        init += [conditions.Atom("=", (obj.name, obj.name)) for obj in objects]

        return Task(domain_name, task_name, requirements, types, objects,
                    predicates, functions, init, goal, actions, axioms, use_metric, trajectory)

    def dump(self):
        print("Problem %s: %s [%s]" % (
            self.domain_name, self.task_name, self.requirements))
        print("Types:")
        for type in self.types:
            print("  %s" % type)
        print("Objects:")
        for obj in self.objects:
            print("  %s" % obj)
        print("Predicates:")
        for pred in self.predicates:
            print("  %s" % pred)
        print("Functions:")
        for func in self.functions:
            print("  %s" % func)
        print("Init:")
        for fact in self.init:
            print("  %s" % fact)
        print("Goal:")
        self.goal.dump()
        print("Actions:")
        for action in self.actions:
            action.dump()
        if self.axioms:
            print("Axioms:")
            for axiom in self.axioms:
                axiom.dump()

class Requirements(object):
    def __init__(self, requirements):
        self.requirements = requirements
        for req in requirements:
            assert req in (
              ":strips", ":adl", ":typing", ":negation", ":equality",
              ":negative-preconditions", ":disjunctive-preconditions",
              ":existential-preconditions", ":universal-preconditions",
              ":quantified-preconditions", ":conditional-effects", ":constraints",
              ":derived-predicates", ":action-costs"), req
    def __str__(self):
        return ", ".join(self.requirements)

def parse_domain(domain_pddl):
    iterator = iter(domain_pddl)

    define_tag = next(iterator)
    assert define_tag == "define"
    domain_line = next(iterator)
    assert domain_line[0] == "domain" and len(domain_line) == 2
    yield domain_line[1]

    ## We allow an arbitrary order of the requirement, types, constants,
    ## predicates and functions specification. The PDDL BNF is more strict on
    ## this, so we print a warning if it is violated.
    requirements = Requirements([":strips"])
    the_types = [pddl_types.Type("object")]
    constants, the_predicates, the_functions = [], [], []
    correct_order = [":requirements", ":types", ":constants", ":predicates",
                     ":functions"]
    seen_fields = []
    for opt in iterator:
        field = opt[0]
        if field not in correct_order:
            first_action = opt
            break
        if field in seen_fields:
            raise SystemExit("Error in domain specification\n" +
                             "Reason: two '%s' specifications." % field)
        if (seen_fields and
            correct_order.index(seen_fields[-1]) > correct_order.index(field)):
            msg = "\nWarning: %s specification not allowed here (cf. PDDL BNF)" % field
            print(msg, file=sys.stderr)
        seen_fields.append(field)
        if field == ":requirements":
            requirements = Requirements(opt[1:])
        elif field == ":types":
            the_types.extend(pddl_types.parse_typed_list(opt[1:],
                        constructor=pddl_types.Type))
        elif field == ":constants":
            constants = pddl_types.parse_typed_list(opt[1:])
        elif field == ":predicates":
            the_predicates = [predicates.Predicate.parse(entry)
                              for entry in opt[1:]]
            the_predicates += [predicates.Predicate("=",
                                 [pddl_types.TypedObject("?x", "object"),
                                  pddl_types.TypedObject("?y", "object")])]
        elif field == ":functions":
            the_functions = [functions.Function.parse(entry)
                             for entry in opt[1:]]
    pddl_types.set_supertypes(the_types)
    # for type in the_types:
    #   print repr(type), type.supertype_names
    yield requirements
    yield the_types
    yield constants
    yield the_predicates
    yield the_functions

    entries = [first_action] + [entry for entry in iterator]
    the_axioms = []
    the_actions = []
    for entry in entries:
        if entry[0] == ":derived":
            axiom = axioms.Axiom.parse(entry)
            the_axioms.append(axiom)
        else:
            action = actions.Action.parse(entry)
            the_actions.append(action)
    yield the_actions
    yield the_axioms

def get_objects_by_type(objects, types):
    result = defaultdict(list)
    supertypes = {}
    for type in types:
        supertypes[type.name] = type.supertype_names
    for obj in objects:
        result[obj.type].append(obj.name)
        for type in supertypes[obj.type]:
            result[type].append(obj.name)
    return result

def parse_task(task_pddl):
    iterator = iter(task_pddl)
    define_tag = next(iterator)
    assert define_tag == "define"
    problem_line = next(iterator)
    assert problem_line[0] == "problem" and len(problem_line) == 2
    yield problem_line[1]
    domain_line = next(iterator)
    assert domain_line[0] == ":domain" and len(domain_line) == 2
    yield domain_line[1]

    requirements_opt = next(iterator)
    if requirements_opt[0] == ":requirements":
        requirements = requirements_opt[1:]
        objects_opt = next(iterator)
    else:
        requirements = []
        objects_opt = requirements_opt
    yield Requirements(requirements)

    objects = []
    if objects_opt[0] == ":objects":
        objects = pddl_types.parse_typed_list(objects_opt[1:])
        init = next(iterator)
    else:
        objects = []
        init = objects_opt
    yield objects

    assert init[0] == ":init"
    initial = []
    for fact in init[1:]:
        if fact[0] == "=":
            try:
                initial.append(f_expression.parse_assignment(fact))
            except ValueError as e:
                raise SystemExit("Error in initial state specification\n" +
                                 "Reason: %s." %  e)
        else:
            initial.append(conditions.Atom(fact[0], fact[1:]))
    yield initial

    goal = next(iterator)
    assert goal[0] == ":goal" and len(goal) == 2
    goal_condition = conditions.parse_goal(goal[1])

    use_metric = False
    trajectory = None
    for entry in iterator:
        if entry[0] == ":metric":
            if entry[1]=="minimize" and entry[2][0] == "total-cost":
                use_metric = True
            else:
                assert False, "Unknown metric."
        elif entry[0] == ":constraints": # handle trajectory constraints
            assert trajectory == None
            trajectory = Trajectory()
            conditions.parse_trajectory_condition(entry[1], trajectory)

    yield goal_condition
    yield use_metric
    print("trajectory.dump(): ")
    trajectory.dump()
    yield trajectory
    print("=======================")

    for entry in iterator:
        assert False, entry

def check_for_duplicates(elements, errmsg, finalmsg):
    seen = set()
    errors = []
    for element in elements:
        if element in seen:
            errors.append(errmsg % element)
        else:
            seen.add(element)
    if errors:
        raise SystemExit("\n".join(errors) + "\n" + finalmsg)

class SometimeTrajectory:
    index = 0
    def __init__(self, condition, parameters):
        self.index = SometimeTrajectory.index
        SometimeTrajectory.index += 1
        self.parameters = parameters
        args = [param.name for param in parameters]
        self.atom = conditions.Atom("sometime-" + str(self.index), args)
        self.condition = condition
    def simplified(self):
        self.condition.simplified()
    def dump(self):
        print("sometime")
        self.condition.dump()
    def get_goal(self):
        if len(self.parameters) > 0:
            return conditions.UniversalCondition(self.parameters, [self.atom])
        return self.atom
    def get_action(self):
        eff = []
        cost = effects.create_simple_effect(self.atom, eff)
        name = "verify_" + self.atom.predicate
        return actions.Action(name, self.parameters, 0, self.condition, eff, cost)

class SometimeAfterTrajectory:
    index = 0
    def __init__(self, condition1, condition2, parameters):
        self.index = SometimeAfterTrajectory.index
        SometimeAfterTrajectory.index += 1
        self.parameters = parameters
        args = [param.name for param in parameters]
        self.atom = conditions.Atom("sometime_after-" + str(self.index), args)
        self.negated_atom = conditions.NegatedAtom("sometime_after-" + str(self.index), args)
        self.condition1 = condition1
        self.condition2 = condition2
    def simplified(self):
        self.condition1.simplified()
        self.condition2.simplified()
    def dump(self):
        print("sometime-after:")
        self.condition1.dump()
        self.condition2.dump()
    def get_goal(self):
        # add goal: not <not_satisfied_condition2>
        return self.negated_atom
    def get_always_effect(self):
        yield self.parameters
        # add conditional_effect into "verifier_always": if <condition1> then <not_satisfied_condition2>
        eff = effects.SimpleEffect(self.atom)
        yield effects.ConditionalEffect(self.condition1, eff)
    def get_action(self): #, always_action):
        # create verifier_condition2 with precondition: <condition2>, effect: not <not_satisfied_condition2>
        eff = []
        cost = effects.create_simple_effect(self.negated_atom, eff)
        name = "verify_" + self.atom.predicate
        return actions.Action(name, self.parameters, 0, self.condition2, eff, cost)

class Trajectory:
    def __init__(self):
        self.always_atom = conditions.Atom("always", [])
        self.negated_always_atom = conditions.NegatedAtom("always", [])
        self.always = conditions.Truth()
        self.sometimes = []
        self.sometime_afters = []
    def add_always_condition(self, condition, parameters):
        if len(parameters) > 0:
            condition = conditions.UniversalCondition(parameters, [condition])
        self.always = conditions.Conjunction([self.always, condition])
    def add_sometime_condition(self, condition, parameters):
        self.sometimes.append(SometimeTrajectory(condition, parameters))
    def add_sometime_after_condition(self, condition1, condition2, parameters):
        self.sometime_afters.append(SometimeAfterTrajectory(condition1, condition2, parameters))
    def simplified(self):
        self.always = self.always.simplified()
        for sometime in self.sometimes:
            sometime.simplified()
    def dump(self):
        print("always:")
        self.always.dump()
        for sometime in self.sometimes:
            sometime.dump()
        for sometime_after in self.sometime_afters:
            sometime_after.dump()
    def modify_goal(self, goal):
        parts = [goal, self.always, self.always_atom]
        index = 0
        for sometime in self.sometimes:
            parts.append(sometime.get_goal())
        for sometime_after in self.sometime_afters:
            parts.append(sometime_after.get_goal())
        goal = conditions.Conjunction(parts)
        return goal.simplified()
    def modify_actions(self, actions_list):
        # modify existing actions for always constraints
        always_negated_effect = effects.Effect([], conditions.Truth(), self.negated_always_atom)
        for action in actions_list:
            new_precondition = conditions.Conjunction([self.always_atom, action.precondition]).simplified()
            action.precondition = new_precondition
            action.uniquify_variables()
            action.effects.append(always_negated_effect)
        # add "always_verifier" action
        eff = [effects.SimpleEffect(self.always_atom)]
        # add conditional_effect into "verifier_always": if <condition1> then <not_satisfied_condition2>
        for sometime_after in self.sometime_afters:
            #eff.append(sometime_after.get_always_effect())
            cond_params, cond_effect = sometime_after.get_always_effect()
            if len(cond_params) > 0:
                '''TODO -- add parameters'''
            eff.append(cond_effect)
        temp_effect = effects.ConjunctiveEffect(eff)
        normalized = temp_effect.normalize()
        cost_eff, rest_effect = normalized.extract_cost()
        eff = []
        effects.add_effect(rest_effect, eff)
        if cost_eff:
            cost_eff = cost_eff.effect
        else:
            cost_eff = None
        always_action = actions.Action("verify_always", [], 0, self.always, eff, cost_eff)
        actions_list.append(always_action)

        # add "sometime_verifier" action
        for sometime in self.sometimes:
            actions_list.append(sometime.get_action())

        # add "sometime_after" verifier action
        for sometime_after in self.sometime_afters:
            actions_list.append(sometime_after.get_action())
