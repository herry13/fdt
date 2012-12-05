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
        op_merged.prevail.push_back(op1.get_prevail()[i]);

    for (int i = 0; i < op1.get_pre_post().size(); i++) {
        op_merged.pre_post.push_back(op1.get_pre_post()[i]);
    }

    for (int i = 0; i < op2.get_prevail().size(); i++) {
        if (get_prevail_index(op_merged, op2.get_prevail()[i].var) < 0 &&
            get_pre_post_index(op_merged, op2.get_prevail()[i].var) < 0) {

            op_merged.prevail.push_back(op2.get_prevail()[i]);
        }
    }

    int prevail_index;
    for (int i = 0; i < op2.get_pre_post().size(); i++) {
        if (get_pre_post_index(op_merged, op2.get_pre_post()[i].var) < 0) {
            op_merged.pre_post.push_back(op2.get_pre_post()[i]);

            prevail_index = get_prevail_index(op_merged, op2.get_pre_post()[i].var);
            if (prevail_index >= 0) {
                op_merged.prevail.erase(op_merged.prevail.begin()+prevail_index);
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

void generate_concurrent_operators(vector<Operator> &operators,
                                   vector<Axiom> &axioms) {

    cout << "Detect and merge concurrent operators..." << endl;
    string always = "verify_always ";
    vector<Operator> always_operators;
    Variable * always_variable = NULL;
    for (int i = 0; i < operators.size(); ) {
        if (operators[i].get_name().compare(always) == 0) {
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
    vector<Operator*> satisfied;
    map< Operator*, vector<int> > groups;
    int index = 0;
    for (int i = 0; i < operators.size(); ) {
        satisfied.clear();
        for (int j = 0; j < always_operators.size(); j++) {
            if (!op1_threat_prevail_op2(operators[i], always_operators[j]))
                satisfied.push_back(&(always_operators[j]));
        }
        if (satisfied.size() < always_operators.size()) {
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
    cout << "total new operators: " << new_operators.size() << endl;

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

    cout << "final total operators: " << operators.size() << endl;
}
