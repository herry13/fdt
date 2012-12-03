#include "concurrent_generator.h"
#include "variable.h"
#include "operator.h"
#include "axiom.h"
#include "state.h"

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

void enforce_op1_prevail_on_op2(Operator &op1, Operator &op2) {
    bool exist;
    for (int i = 0; i < op1.prevail.size(); i++) {
        exist = false;
        for (int j = 0; j < op2.pre_post.size() && !exist; j++) {
            if (op2.pre_post[j].var == op1.prevail[i].var) {
                exist = true;
            }
        }
        for (int j = 0; j < op2.prevail.size() && !exist; j++) {
            if (op2.prevail[j].var == op1.prevail[i].var) {
                exist = true;
                op2.prevail[j].prev = op2.prevail[i].prev;
            }
        }
        if (!exist) {
            op2.prevail.push_back(op1.prevail[i]);
        }
    }
}

void generate_concurrent_operators(vector<Operator> &operators,
                                   vector<Axiom> &axioms) {

    cout << "Detect and merge concurrent operators..." << endl;
    string always = "verify_always";
    vector<Operator> always_operators;
    Variable * always_variable = NULL;
    for (int i = 0; i < operators.size(); ) {
        if (operators[i].get_name().substr(0, always.length()).compare(always) == 0) {
            if (always_variable == NULL) {
                for (int j = 0; j < operators[i].pre_post.size(); j++) {
                    if (!operators[i].pre_post[j].is_conditional_effect) {
                        always_variable = operators[i].pre_post[j].var;
                        break;
                    }
                }
            }
            always_operators.push_back(operators[i]);
            operators.erase(operators.begin()+i);
        } else {
            i++;
        }
    }

    vector<Operator> new_operators;
    vector<Operator> satisfied;
    for (int i = 0; i < operators.size(); ) {
        satisfied.clear();
        for (int j = 0; j < always_operators.size(); j++) {
            if (!op1_threat_prevail_op2(operators[i], always_operators[j]))
                satisfied.push_back(always_operators[j]);
        }
        if (satisfied.size() < always_operators.size()) {
            for (int j = 0; j < satisfied.size(); j++) {
                new_operators.push_back(operators[i]);
                enforce_op1_prevail_on_op2(satisfied[j], new_operators[new_operators.size()-1]);
            }
            operators.erase(operators.begin()+i);
        } else {
            i++;
        }
    }

    cout << "total unmodified operators: " << operators.size() << endl;
    cout << "total new operators: " << new_operators.size() << endl;

    for (int i = 0; i < new_operators.size(); i++) {
        operators.push_back(new_operators[i]);
    }


    for (int j = 0; j < operators.size(); j++) {
        for (int k = 0; k < operators[j].prevail.size(); ) {
            if (operators[j].prevail[k].var == always_variable)
                operators[j].prevail.erase(operators[j].prevail.begin()+k);
            else
                k++;
        }
        for (int k = 0; k < operators[j].pre_post.size(); ) {
            if (operators[j].pre_post[k].var == always_variable)
                operators[j].pre_post.erase(operators[j].pre_post.begin()+k);
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

    //initial_state.values[always_variable] = 0;

    cout << "final total operators: " << operators.size() << endl;
}
