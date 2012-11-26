from __future__ import print_function

import sys
from collections import defaultdict

from . import effects
from . import actions
from . import axioms
from . import conditions
from . import pddl_types

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
    # add goal: not <not_satisfied_condition2>
    # add conditional_effect into "verifier_always": if <condition1> then <not_satisfied_condition2>
    # create verifier_condition2 with precondition: <condition2>, effect: not <not_satisfied_condition2>
    index = 0
    def __init__(self, condition1, condition2, parameters):
        if len(parameters) > 0:
            assert False, "sometime-after with parameters is not supported (yet)"
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

class SometimeBeforeTrajectory:
    # add goal: <satisfied_condition1>
    # add conditional effect into "verifier_always": if <condition2> then <satisfied_condition2>
    # add conditional effect into "verifier_always":
    #     if <condition1> and <satisfied_condition2> then <satisfied_condition1>
    # add new precondition into "verifier_always":
    #     if <condition1> then <satisfied_condition2>
    index = 0
    def __init__(self, condition1, condition2, parameters):
        if len(parameters) > 0:
            assert False, "sometime-before with parameters is not supported (yet)"
        self.index = SometimeBeforeTrajectory.index
        SometimeBeforeTrajectory.index += 1
        self.parameters = parameters
        args = [param.name for param in parameters]
        self.atom1 = conditions.Atom("sometime_before_1-" + str(self.index), args)
        self.atom2 = conditions.Atom("sometime_before_2-" + str(self.index), args)
        self.condition1 = condition1
        self.condition2 = condition2
    def simplified(self):
        self.condition1 = self.condition1.simplified()
        self.condition2 = self.condition2.simplified()
    def dump(self):
        print("sometime-before:")
        self.condition1.dump()
        self.condition2.dump()
    def get_goal(self):
        return self.atom1
    def get_always_effect(self):
        eff = effects.SimpleEffect(self.atom2)
        yield effects.ConditionalEffect(self.condition2, eff)
        eff = effects.SimpleEffect(self.atom1)
        condition = conditions.Conjunction([self.condition1, self.atom2]).simplified()
        yield effects.ConditionalEffect(condition, eff)
    def get_always_precondition(self):
        return conditions.Disjunction([self.condition1.negate(), self.atom2])

class AtMostOnceTrajectory:
    # add conditional effect into "verify_always":
    #     if <condition> then <flag_1>
    #     if not <condition> and <flag_1> then <flag_2>
    # add precondition into "verify_always":
    #     if <condition> then not <flag_2>
    index = 0
    def __init__(self, condition, parameters):
        if len(parameters) > 0:
            assert False, "at-most-once with parameters is not supported (yet)"
        self.index = AtMostOnceTrajectory.index
        AtMostOnceTrajectory.index += 1
        self.parameters = parameters
        args = [param.name for param in parameters]
        self.atom1 = conditions.Atom("at_most_once_1-" + str(self.index), args)
        self.atom2 = conditions.Atom("at_most_once_2-" + str(self.index), args)
        self.negated_atom2 = conditions.NegatedAtom("at_most_once_2-" + str(self.index), args)
        self.condition = condition
        self.negated_condition = condition.negate()
    def simplified(self):
        self.condition = self.condition.simplified()
    def dump(self):
        print("at-most-once:")
        self.condition.dump()
    def get_goal(self):
        conditions.Truth()
    def get_always_effect(self):
        eff = effects.SimpleEffect(self.atom1)
        yield effects.ConditionalEffect(self.condition, eff)
        condition = conditions.Conjunction([self.negated_condition, self.atom1])
        eff = effects.SimpleEffect(self.atom2)
        yield effects.ConditionalEffect(condition, eff)
    def get_always_precondition(self):
        return conditions.Disjunction([self.negated_condition, self.negated_atom2])

class Trajectory:
    def __init__(self):
        self.always_atom = conditions.Atom("always", [])
        self.negated_always_atom = conditions.NegatedAtom("always", [])
        self.always = conditions.Truth()
        self.sometimes = []
        self.sometime_afters = []
        self.sometime_befores = []
        self.at_most_onces = []
    def add_always_condition(self, condition, parameters):
        if len(parameters) > 0:
            condition = conditions.UniversalCondition(parameters, [condition])
        self.always = conditions.Conjunction([self.always, condition])
    def add_sometime_condition(self, condition, parameters):
        self.sometimes.append(SometimeTrajectory(condition, parameters))
    def add_sometime_after_condition(self, condition1, condition2, parameters):
        self.sometime_afters.append(SometimeAfterTrajectory(condition1, condition2, parameters))
    def add_sometime_before_condition(self, condition1, condition2, parameters):
        self.sometime_befores.append(SometimeBeforeTrajectory(condition1, condition2, parameters))
    def add_at_most_once_condition(self, condition, parameters):
        #assert False, 'TODO -- implement add_at_most_once_condition'
        self.at_most_onces.append(AtMostOnceTrajectory(condition, parameters))
    def add_at_end_condition(self, condition, parameters):
        assert False, 'TODO -- implement add_at_end_condition'
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
        for sometime_before in self.sometime_befores:
            parts.append(sometime_before.get_goal())
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

        ### add "always_verifier" action ###
        eff = [effects.SimpleEffect(self.always_atom)]
        pre = [self.always]
        # add "sometime-after" conditional_effect into "verify_always":
        #     if <condition1> then <not_satisfied_condition2>
        for sometime_after in self.sometime_afters:
            cond_params, cond_effect = sometime_after.get_always_effect()
            eff.append(cond_effect)
        # add "sometime-before" conditional_effect and preconditon
        for sometime_before in self.sometime_befores:
            # add conditional effects
            cond_effect1, cond_effect2 = sometime_before.get_always_effect()
            eff.append(cond_effect1)
            eff.append(cond_effect2)
            # add precondition
            pre.append(sometime_before.get_always_precondition())
        # add "at-most-once" conditional_effect and precondition
        for atmostonce in self.at_most_onces:
            # add conditional effects
            cond_effect1, cond_effect2 = atmostonce.get_always_effect()
            eff.append(cond_effect1)
            eff.append(cond_effect2)
            # add precondition
            pre.append(atmostonce.get_always_precondition())
        # generate the effect
        temp_effect = effects.ConjunctiveEffect(eff)
        normalized = temp_effect.normalize()
        cost_eff, rest_effect = normalized.extract_cost()
        eff = []
        effects.add_effect(rest_effect, eff)
        if cost_eff:
            cost_eff = cost_eff.effect
        else:
            cost_eff = None
        pre = conditions.Conjunction(pre).simplified()
        #always_action = actions.Action("verify_always", [], 0, self.always, eff, cost_eff)
        always_action = actions.Action("verify_always", [], 0, pre, eff, cost_eff)
        print("=====")
        always_action.dump()
        actions_list.append(always_action)

        # add "sometime_verifier" action
        for sometime in self.sometimes:
            actions_list.append(sometime.get_action())

        # add "sometime_after" verifier action
        for sometime_after in self.sometime_afters:
            actions_list.append(sometime_after.get_action())
