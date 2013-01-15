#include "concurrent_generator.h"
#include "variable.h"
#include "operator.h"
#include "axiom.h"
#include "state.h"
#include <map>
#include <sstream>

bool op1_threat_prevail_op2(const Operator &op1, const Operator &op2) {
    for (int i = 0; i < op2.get_prevail().size(); i++) {
        for (int j = 0; j < op1.get_pre_post().size(); j++) {
            if (op1.get_pre_post()[j].var == op2.get_prevail()[i].var &&
                op1.get_pre_post()[j].post != op2.get_prevail()[i].prev) {
                return true;
            }
        }
    }
    return false;
}

bool op1_threat_pre_post_op2(const Operator &op1, const Operator &op2) {
    for (int i = 0; i < op2.get_pre_post().size(); i++) {
        for (int j = 0; j < op1.get_pre_post().size(); j++) {
            if (op1.get_pre_post()[j].var == op2.get_pre_post()[i].var &&
                (op1.get_pre_post()[j].pre != op2.get_pre_post()[i].pre ||
                 op1.get_pre_post()[j].post != op2.get_pre_post()[i].post)) {
                return true;
            }
        }
    }
    return false;
}

bool op1_parallel_op2(const Operator &op1, const Operator &op2) {
    return !(op1_threat_prevail_op2(op1, op2) ||
             op1_threat_pre_post_op2(op1, op2) ||
             op1_threat_prevail_op2(op2, op1) ||
             op1_threat_pre_post_op2(op2, op1));
}

bool op1_prevail_require_op2_post(const Operator &op1, const Operator &op2) {
    for (int i = 0; i < op1.get_prevail().size(); i++) {
        for (int j = 0; j < op2.get_pre_post().size(); j++) {
            if (op1.get_prevail()[i].var == op2.get_pre_post()[j].var &&
                op1.get_prevail()[i].prev == op2.get_pre_post()[j].post) {
                return true;
            }
        }
    }
    return false;
}

void enforce_op1_prevail_on_op2(Operator &op1, Operator &op2) {
    bool exist;
    for (int i = 0; i < op1.prevails().size(); i++) {
        exist = false;
        for (int j = 0; j < op2.pre_posts().size() && !exist; j++) {
            if (op2.pre_posts()[j].var == op1.prevails()[i].var) {
                exist = true;
            }
        }
        for (int j = 0; j < op2.prevails().size() && !exist; j++) {
            if (op2.prevails()[j].var == op1.prevails()[i].var) {
                exist = true;
                op2.prevails()[j].prev = op2.prevails()[i].prev;
            }
        }
        if (!exist) {
            op2.prevails().push_back(op1.prevails()[i]);
        }
    }
}

int get_prevail_index(const Operator &op, const Variable * var) {
    for (int j = 0; j < op.get_prevail().size(); j++) {
        if (op.get_prevail()[j].var == var)
            return j;
    }
    return -1;
}

int get_pre_post_index(const Operator &op, const Variable * var) {
    for (int j = 0; j < op.get_pre_post().size(); j++) {
        if (op.get_pre_post()[j].var == var)
            return j;
    }
    return -1;
}

int merge_operators(Operator &op1, Operator &op2, vector<Operator> &operators) {
    stringstream ss;
    ss << op1.get_name() << "|" << op2.get_name();
    Operator op_merged = Operator(ss.str(), op2.get_cost());

    for (int i = 0; i < op1.get_prevail().size(); i++)
        op_merged.prevails().push_back(op1.get_prevail()[i]);

    for (int i = 0; i < op1.get_pre_post().size(); i++) {
        op_merged.pre_posts().push_back(op1.get_pre_post()[i]);
    }

    for (int i = 0; i < op2.get_prevail().size(); i++) {
        if (get_prevail_index(op_merged, op2.get_prevail()[i].var) < 0 &&
            get_pre_post_index(op_merged, op2.get_prevail()[i].var) < 0) {

            op_merged.prevails().push_back(op2.get_prevail()[i]);
        }
    }

    int prevail_index;
    for (int i = 0; i < op2.get_pre_post().size(); i++) {
        if (get_pre_post_index(op_merged, op2.get_pre_post()[i].var) < 0) {
            op_merged.pre_posts().push_back(op2.get_pre_post()[i]);

            prevail_index = get_prevail_index(op_merged, op2.get_pre_post()[i].var);
            if (prevail_index >= 0) {
                op_merged.prevails().erase(op_merged.prevails().begin()+prevail_index);
            }
        }
    }

    operators.push_back(op_merged);
    return (operators.size() - 1);
}

bool are_mutually_inclusive(Operator &op1, Operator &op2) {
    // 1) both operators are not threatening each other (can be run in parallel)
    // 2) there's op1's prevail condition required by op2, and vice versa
    if (op1_parallel_op2(op1, op2) &&
        (op1_prevail_require_op2_post(op1, op2) && op1_prevail_require_op2_post(op2, op1))) {
        return true;
    }
    return false;
}

bool has_derived_variable(const Operator &op) {
    for (int i = 0; i < op.get_prevail().size(); i++) {
        if (op.get_prevail()[i].var->is_derived())
            return true;
    }
    for (int i = 0; i < op.get_pre_post().size(); i++) {
        if (op.get_pre_post()[i].var->is_derived())
            return true;
    }
    return false;
}

void generate_concurrent_operators(vector<Operator> &operators,
                                   vector<Axiom> &axioms) {

    cout << "Detecting and merging concurrent operators...";
    bool doable = true;
    bool has_cond_effect = false;

    // collect all "verify_always" operators
    string always = "verify_always ";
    vector<Operator> always_operators;
    vector<Operator> always_operators_cond_eff;
    Variable * always_variable = NULL;
    for (int i = 0; i < operators.size(); ) {
        if (operators[i].get_name().compare(always) == 0) {
            if (always_variable == NULL) {
                for (int j = 0; j < operators[i].pre_posts().size(); j++) {
                    if (!operators[i].pre_posts()[j].is_conditional_effect) {
                        always_variable = operators[i].pre_posts()[j].var;
                        break;
                    }
                }
            }
            // check derived variable
            if (has_derived_variable(operators[i])) {
                doable = false;
                break;
            }
            // check conditional effect
            for (int j = 0; j < operators[i].get_pre_post().size(); j++) {
                if (operators[i].get_pre_post()[j].is_conditional_effect) {
                    has_cond_effect = true;
                    always_operators_cond_eff.push_back(operators[i]);
                    //break;
                }
            }
            always_operators.push_back(operators[i]);
            operators.erase(operators.begin()+i);
        } else {
            i++;
        }
    }

    if (doable) {
        cout << "is doable" << endl;
    } else {
        cout << "is not doable (always constraint has axiom)!" << endl;
        // put back "verify_always" operators
        for (int i = 0; i < always_operators.size(); i++)
            operators.push_back(always_operators[i]);
        return;
    }

    // Apply Patrik's approach:
    // All trajectory constraints were compiled, all "always" conditions are saved as the prevail
    // conditions of "verify_always" operators (see file "translator/pddl/trajectories.py").
    //
    // 1) Remove operator which does not satisfy the prevail conditions of all "verify_always" operators
    // 2) For each operator x that partially satisfies,
    //    for each "verify_always" operators, create a copy of operator x then add the "verify_always"
    //    prevail conditions into the new operator
    //    All operators that are modified by the same "verify_always" operator are grouped together.
    // 3) Do nothing for operator that satisfies the prevail conditions of all "verify_always" operators
    vector<Operator> new_operators;
    vector<Operator*> satisfied;
    map< Operator*, vector<int> > groups;
    int index = 0;
    for (int i = 0; i < operators.size(); ) {
        satisfied.clear();
        for (int j = 0; j < always_operators.size(); j++) {
            if (!op1_threat_prevail_op2(operators[i], always_operators[j]))
                satisfied.push_back(&(always_operators[j]));
        }
        if (satisfied.size() <= 0) {
            operators.erase(operators.begin()+i);
        } else if (satisfied.size() < always_operators.size()) {
            for (int j = 0; j < satisfied.size(); j++) {
                new_operators.push_back(operators[i]);
                index = new_operators.size() - 1;
                enforce_op1_prevail_on_op2( *(satisfied[j]), new_operators[index]);
                groups[ satisfied[j] ].push_back(index);
            }
            operators.erase(operators.begin()+i);
        } else {
            i++;
        }
    }

    cout << "total unmodified operators: " << operators.size() << endl;

    // For each group, find a set of operators that can be run in parallel and required each other.
    // These operators are mutually inclusive operators. The new (merged) operator is created by merging
    // all operators in the set.
    int index1, index2;
    for (map< Operator*, vector<int> >::iterator itr = groups.begin(); itr != groups.end(); itr++) {
        for (int i = 0; i < itr->second.size(); i++) {
            index1 = itr->second[i];
            for (int j = i+1; j < itr->second.size(); j++) {
                index2 = itr->second[j];
                if (are_mutually_inclusive(new_operators[index1], new_operators[index2]))
                    index1 = merge_operators(new_operators[index1], new_operators[index2], new_operators);
            }
        }
    }

    cout << "total new operators: " << new_operators.size() << endl;

    for (int i = 0; i < new_operators.size(); i++)
        operators.push_back(new_operators[i]);

    for (int i = 0; i < always_operators_cond_eff.size(); i++)
        operators.push_back(always_operators_cond_eff[i]);

    if (!has_cond_effect) {
    // Remove any prevail/pre-post conditions of variable "always" from all operators
    // and axioms since all operators are assured satisfying the "always" condition.
    for (int j = 0; j < operators.size(); j++) {
        for (int k = 0; k < operators[j].prevails().size(); ) {
            if (operators[j].prevails()[k].var == always_variable)
                operators[j].prevails().erase(operators[j].prevails().begin()+k);
            else
                k++;
        }
        for (int k = 0; k < operators[j].pre_posts().size(); ) {
            if (operators[j].pre_posts()[k].var == always_variable)
                operators[j].pre_posts().erase(operators[j].pre_posts().begin()+k);
            else
                k++;
        }
    }
    for (int i = 0; i < axioms.size(); i++) {
        for (int j = 0; j < axioms[i].conditions.size(); ) {
            if (axioms[i].conditions[j].var == always_variable)
                axioms[i].conditions.erase(axioms[i].conditions.begin()+j);
            else
                j++;
        }
    }
    }

    cout << "final total operators: " << operators.size() << endl;
}
