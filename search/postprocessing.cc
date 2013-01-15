#include "postprocessing.h"
#include "search_engine.h"
#include "operator.h"
#include <sstream>

using namespace std;

void do_postprocessing(SearchEngine::Plan &plan, SearchEngine::PlanIndex &planIndex) {
    remove_auxiliary_actions(plan, planIndex);
    break_concurrent_actions(plan, planIndex);
}

Operator * create_operator(string name, int cost) {
    stringstream sas;
    sas << "begin_operator\n" << name << "\n0\n0\n" << cost << "\nend_operator";
    Operator * op = new Operator(sas, false);
    return op;
}

void break_concurrent_actions(SearchEngine::Plan &plan, SearchEngine::PlanIndex &planIndex) {
    string name;
    for (int i = 0; i < plan.size(); ) {
        name = plan[i]->get_name();
        int post = name.find_first_of('|');
        if (post > 0) {
            int index = planIndex[i];
            int cost = plan[i]->get_cost();
            int total = 1;
            
            do {
                string sub_name = name.substr(0, post);
                plan.insert(plan.begin()+i+1, create_operator(name.substr(0, post), cost));
                planIndex.insert(planIndex.begin()+i+1, index);
                name = name.substr(post+1);
                ++total;
            } while ((post = name.find_first_of('|')) > 0);

            plan.insert(plan.begin()+i+1, create_operator(name, cost));
            plan.erase(plan.begin()+i);

            i += total;
        } else {
            i++;
        }
    }
}

void remove_auxiliary_actions(SearchEngine::Plan &plan, SearchEngine::PlanIndex &planIndex) {
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
            planIndex.push_back(index++);
            i++;
        }
    }
}
