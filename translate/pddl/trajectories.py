from __future__ import print_function

import sys
import copy
from collections import defaultdict

from . import effects
from . import actions
from . import axioms
from . import conditions
from . import pddl_types

class TrajectoryCondition(object):
    def __init__(self):
        self.objects = []
        self.types = []
    def substitute_variables(self, parameters, condition):
        assert False, 'TODO: implement'

class SometimeCondition(TrajectoryCondition):
    # (sometime (condition))
    index = 0
    def __init__(self, condition, parameters):
        super(SometimeCondition, self).__init__()
        self.index = SometimeCondition.index
        SometimeCondition.index += 1
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
    def get_always_effects(self):
        eff = effects.SimpleEffect(self.atom)
        #return [effects.ConditionalEffect(self.condition, eff)]
        return []
    def get_axioms(self):
        eff = effects.SimpleEffect(self.atom)
        return []
        #return [axioms.Axiom("sometime-" + str(self.index), self.parameters, len(self.parameters), self.condition)]
        #return [axioms.PropositionalAxiom("sometime-" + str(self.index), self.condition, eff)]
        #name, parameters, num_external_parameters, condition
    def get_actions(self):
        eff = []
        cost = effects.create_simple_effect(self.atom, eff)
        name = "verify_" + self.atom.predicate
        yield actions.Action(name, self.parameters, 0, self.condition, eff, cost)

class SometimeAfterCondition(TrajectoryCondition):
    # (sometime-after (condition1) (condition2))
    # add goal: not <not_satisfied_condition2>
    # add conditional_effect into "verifier_always":
    #     if <condition1> then <not_satisfied_condition2>
    # create verifier_condition2 with
    #     precondition: <condition2>
    #     effect: not <not_satisfied_condition2>
    index = 0
    def __init__(self, condition1, condition2, parameters):
        super(SometimeAfterCondition, self).__init__()
        if len(parameters) > 0:
            '''assert False, "sometime-after with parameters is not supported (yet)"'''
        self.index = SometimeAfterCondition.index
        SometimeAfterCondition.index += 1
        self.parameters = parameters
        args = [param.name for param in parameters]
        name = "sometime_after-" + str(self.index)
        self.atom = conditions.Atom(name, args)
        self.negated_atom = conditions.NegatedAtom(name, args)
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
        return self.negated_atom
    def get_always_effects(self):
        eff = effects.SimpleEffect(self.atom)
        return [effects.ConditionalEffect(self.condition1, eff)]
    def get_actions(self):
        eff = []
        cost = effects.create_simple_effect(self.negated_atom, eff)
        name = "verify_" + self.atom.predicate
        yield actions.Action(name, self.parameters, 0, self.condition2, eff, cost)

class SometimeBeforeCondition(TrajectoryCondition):
    # (sometime-before (condition1) (condition2))
    # add conditional effects into "verify_always":
    #     if <condition2> then <satisfied_condition2>
    # add preconditions into "verify_always":
    #     if <condition1> then <satisfied_condition2>
    #
    # TODO:
    # - need to consider "uniquifying" variables in parameters
    index = 0
    def __init__(self, condition1, condition2, parameters):
        super(SometimeBeforeCondition, self).__init__()
        print(str(condition1.uniquify_variables({})))
        #if len(parameters) > 0:
        #    '''assert False, "sometime-before with parameters is not supported (yet)"'''
        self.parameters = parameters
        self.index = SometimeBeforeCondition.index
        SometimeBeforeCondition.index += 1
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
        return conditions.Truth()
    def get_always_effects(self):
        eff = effects.SimpleEffect(self.atom2)
        effs = [effects.ConditionalEffect(self.condition2, eff)]
        return effs
    def get_always_precondition(self):
        condition = conditions.Disjunction([self.condition1.negate(), self.atom2])
        if len(self.parameters) > 0:
            return conditions.UniversalCondition(self.parameters, [condition])
        else:
            return condition

class AtMostOnceCondition(TrajectoryCondition):
    # (at-most-once (condition))
    # add conditional effect into "verify_always":
    #     if <condition> then <flag_1>
    #     if not <condition> and <flag_1> then <flag_2>
    # add precondition into "verify_always":
    #     if <condition> then not <flag_2>
    #
    index = 0
    def __init__(self, condition, parameters):
        super(AtMostOnceCondition, self).__init__()
        #if len(parameters) > 0:
        #    '''assert False, "at-most-once with parameters is not supported (yet)"'''
        self.index = AtMostOnceCondition.index
        AtMostOnceCondition.index += 1
        self.parameters = parameters
        args = [param.name for param in parameters]
        name1 = "at_most_once_1-" + str(self.index)
        self.atom1 = conditions.Atom(name1, args)
        name2 = "at_most_once_2-" + str(self.index)
        self.atom2 = conditions.Atom(name2, args)
        self.negated_atom2 = conditions.NegatedAtom(name2, args)
        self.condition = condition
        self.negated_condition = condition.negate()
    def simplified(self):
        self.condition = self.condition.simplified()
    def dump(self):
        print("at-most-once:")
        self.condition.dump()
    def get_goal(self):
        return conditions.Truth()
    def get_always_effects(self):
        eff = effects.SimpleEffect(self.atom1)
        effs = [effects.ConditionalEffect(self.condition, eff)]
        condition = conditions.Conjunction([self.negated_condition, self.atom1])
        eff = effects.SimpleEffect(self.atom2)
        effs.append(effects.ConditionalEffect(condition, eff))
        return effs
    def get_always_precondition(self):
        condition = conditions.Disjunction([self.negated_condition, self.negated_atom2])
        if len(self.parameters) > 0:
            return conditions.UniversalCondition(self.parameters, [condition])
        else:
            return condition

class Trajectory:
    use_preference = False
    def __init__(self):
        name = "always"
        self.always_atom = conditions.Atom(name, [])
        self.negated_always_atom = conditions.NegatedAtom(name, [])
        self.always = conditions.Truth()
        self.always_effects = []
        self.sometimes = []
        self.sometime_afters = []
        self.sometime_befores = []
        self.at_most_onces = []
        self.at_end = []

        self.preference_metrics = {}
        self.preference_penalties = []
    def set_preference_metric(self, label, value):
        self.preference_metrics[label] = value
    def add_always_condition(self, condition, parameters, preference_label=None):
        if len(parameters) > 0:
            condition = conditions.UniversalCondition(parameters, [condition])
        if preference_label != None:
            # TODO -- need to be fixed: handling always preference
            args = [param.name for param in parameters]
            atom = conditions.Atom("not-" + preference_label, args)
            eff = effects.SimpleEffect(atom)
            cond_effect = effects.ConditionalEffect(condition.negate(), eff)
            self.always_effects.append(cond_effect)
            penalty_cond = conditions.ExistentialCondition(parameters, [atom])
            goal_atom = conditions.Atom("pref-" + preference_label, args)
            self.preference_penalties.append([preference_label, parameters, atom, goal_atom])
        else:
            self.always = conditions.Conjunction([self.always, condition])
    def add_sometime_condition(self, condition, parameters, preference_label=None):
        self.sometimes.append(SometimeCondition(condition, parameters))
        if preference_label != None:
            self.use_preference = True
    def add_sometime_after_condition(self, condition1, condition2, parameters, preference_label=None):
        self.sometime_afters.append(SometimeAfterCondition(condition1, condition2, parameters))
        if preference_label != None:
            self.use_preference = True
    def add_sometime_before_condition(self, condition1, condition2, parameters, preference_label=None):
        self.sometime_befores.append(SometimeBeforeCondition(condition1, condition2, parameters))
        if preference_label != None:
            self.use_preference = True
    def add_at_most_once_condition(self, condition, parameters, preference_label=None):
        self.at_most_onces.append(AtMostOnceCondition(condition, parameters))
        if preference_label != None:
            self.use_preference = True
    def add_at_end_condition(self, condition, parameters, preference_label=None):
        if len(parameters) > 0:
            condition = conditions.UniversalCondition(parameters, [condition])
        if preference_label != None:
            self.use_preference = True
        else:
            self.at_end.append(condition)
    def simplified(self):
        self.always = self.always.simplified()
        for sometime in self.sometimes:
            sometime.simplified()
    def set_types_and_objects(self, types, objects):
        for condition in (self.sometime_afters + self.sometime_befores + self.at_most_onces):
            condition.types = types
            condition.objects = objects
    def dump(self):
        print("always:")
        self.always.dump()
        for sometime in self.sometimes:
            sometime.dump()
        for sometime_after in self.sometime_afters:
            sometime_after.dump()
    def modify_goal(self, goal):
        parts = [goal, self.always, self.always_atom]
        parts.extend(self.at_end)
        index = 0
        for sometime in self.sometimes:
            parts.append(sometime.get_goal())
        for sometime_after in self.sometime_afters:
            parts.append(sometime_after.get_goal())
        for sometime_before in self.sometime_befores:
            parts.append(sometime_before.get_goal())
        # preferences
        for penalty in self.preference_penalties:
            parameters = penalty[1]
            goal_atom = penalty[3]
            goal_cond = conditions.UniversalCondition(parameters, [goal_atom])
            parts.append(goal_cond) #penalty[3])
        goal = conditions.Conjunction(parts)
        return goal.simplified()

    def modify_axioms(self, axioms_list):
        for sometime in self.sometimes:
            axioms_list.extend(sometime.get_axioms())
        return axioms_list

    def modify_actions(self, actions_list):
        new_actions = list(actions_list)
        # modify existing actions for always constraints
        always_negated_effect = effects.Effect([], conditions.Truth(), self.negated_always_atom)
        for action in new_actions:
            new_precondition = conditions.Conjunction([self.always_atom, action.precondition]).simplified()
            action.precondition = new_precondition
            #action.uniquify_variables()
            action.effects.append(always_negated_effect)

        ### add "always_verifier" action ###
        parameters = []
        eff = [effects.SimpleEffect(self.always_atom)]
        pre = [self.always]
        # add "sometime" conditional_effect
        for sometime in self.sometimes:
            parameters.extend(sometime.parameters)
            eff.extend(sometime.get_always_effects())
        # add "sometime-after" conditional_effect
        for sometime_after in self.sometime_afters:
            parameters.extend(sometime_after.parameters)
            eff.extend(sometime_after.get_always_effects())
        # add "sometime-before" conditional_effect and preconditon
        for sometime_before in self.sometime_befores:
            parameters.extend(sometime_before.parameters)
            eff.extend(sometime_before.get_always_effects())
            pre.append(sometime_before.get_always_precondition())
        # add "at-most-once" conditional_effect and precondition
        for atmostonce in self.at_most_onces:
            parameters.extend(atmostonce.parameters)
            eff.extend(atmostonce.get_always_effects())
            pre.append(atmostonce.get_always_precondition())

        # add always effects
        #print(str(self.always_effects))
        if len(self.always_effects) > 0:
            eff.extend(self.always_effects)

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
        #pre, axiom = self.substitute_complicated_condition(pre)
        self.always_action = actions.Action("verify_always", parameters, 0, pre, eff, cost_eff)
        #print("=====")
        #self.always_action.dump()
        new_actions.append(self.always_action)

        # add "sometime_verifier" action
        for sometime in self.sometimes:
            new_actions.extend(sometime.get_actions())

        # add "sometime_after" verifier action
        for sometime_after in self.sometime_afters:
            new_actions.extend(sometime_after.get_actions())

        '''# add actions of preference penalty collector
        for penalty in self.preference_penalties:
            label = penalty[0]
            parameters = penalty[1]
            atom = penalty[2]
            goal_atom = penalty[3]
            # create penalty action
            penalty = self.preference_metrics[label]
            pre = conditions.Conjunction([atom]).simplified()
            eff = []
            cost = effects.create_simple_effect(goal_atom, eff)
            action = actions.Action("penalty-" + label, parameters, penalty, pre, eff, cost)
            action.dump()
            #new_actions.append(action)
            # create non-penalty action
            pre = pre.negate()
            action = actions.Action("non-penalty-" + label, parameters, 0, pre, eff, cost)
            new_actions.append(action)'''

        return new_actions

        '''eff = []
        cost = effects.create_simple_effect(self.atom, eff)
        name = "verify_" + self.atom.predicate
        return actions.Action(name, self.parameters, 0, self.condition, eff, cost)'''

    def parse_metrics(self, entries):
        minimize = (entries[1] == "minimize")
        # we assume that the metric is '+'
        for part in entries[2][1:]:
            value = int(part[1])
            label = part[2][1]
            if part[2][0] == "is-violated" and minimize:
                self.set_preference_metric(label, value)
            else:
                assert False, "Not (yet) implemented - " + part[2][0]
