#include "postprocessing.h"
#include "search_engine.h"
#include "operator.h"
#include <sstream>

using namespace std;

void do_postprocessing(SearchEngine::Plan &plan) {
    remove_auxiliary_actions(plan);
    break_concurrent_actions(plan);
}

Operator * create_operator(string name, int cost, int index) {
    stringstream sas;
    sas << "begin_operator\n" << name << "\n0\n0\n" << cost << "\nend_operator";
    Operator * op = new Operator(sas, false);
    op->index = index;
    return op;
}

void break_concurrent_actions(SearchEngine::Plan &plan) {
    string name;
    for (int i = 0; i < plan.size(); ) {
        name = plan[i]->get_name();
        int post = name.find_first_of('|');
        if (post > 0) {
            int index = plan[i]->index;
            int cost = plan[i]->get_cost();
            do {
                string sub_name = name.substr(0, post);
                plan.insert(plan.begin()+i+1, create_operator(name.substr(0, post), cost, index));
                name = name.substr(post+1);
            } while ((post = name.find_first_of('|')) > 0);
            plan.insert(plan.begin()+i+1, create_operator(name, cost, index));
            plan.erase(plan.begin()+i);
        } else {
            i++;
        }
    }
}

void remove_auxiliary_actions(SearchEngine::Plan &plan) {
    // removing auxiliary actions for trajectory constraints
    string name;
    int index = 1;
    for (int i = 0; i < plan.size(); ) {
        name = plan[i]->get_name();
        if (name.compare("verify_always ") == 0) {
            plan.erase(plan.begin()+i);
        } else if (name.length() > 15 && name.substr(0, 15).compare("verify_sometime") == 0) {
            plan.erase(plan.begin()+i);
        } else {
            plan[i]->index = index++;
            i++;
        }
    }
}
