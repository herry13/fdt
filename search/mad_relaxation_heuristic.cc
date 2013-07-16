#include "mad_relaxation_heuristic.h"

#include "globals.h"
#include "operator.h"
#include "state.h"
#include "causal_graph.h"

#include <cassert>
#include <vector>
using namespace std;

#include <ext/hash_map>
using namespace __gnu_cxx;

// construction and destruction
MadRelaxationHeuristic::MadRelaxationHeuristic(const Options &opts)
: Heuristic(opts) {
}

MadRelaxationHeuristic::~MadRelaxationHeuristic() {
}

// initialization
void MadRelaxationHeuristic::initialize() {   
    //if(g_axioms.size() > 0){
     //   cout << "CURRENTLY UNABLE TO DEAL WITH AXIOMS" << endl;
      //  exit(0);
        //Should be able to ignore axioms in the causal graph to extract agents - needs implementation.
    //}
    
    /*
     cout << "TWO THINGS TO DO" << endl;
     cout << "Actually 3 - this one comes first" << endl;
     cout << "0: sort domains by how easy the agent decomposition is" << endl;
     cout << "Solve all easy ones first" << endl;
     cout << "For the hard ones we know who they are because the removing cycles part doesn't work" << endl;
     cout << "Therefore we only need to do more complext stuff for those ones." << endl;
     cout << "Can write up paper number 1 as well." << endl;
     cout << "1: See if it makes sense to re-order subgoal/goal allocations" << endl;
     cout << "it might be much better if we do all subgoals to achieve a particular goal together and then do that goal - then move to the next.." << endl;
     cout << "Depending on how well this works we then try the next thing." << endl;
     cout << "2: Change the search algorithm form lazy_greedy to one that can backtrack to a different subgoal decomposition once we reach a dead end." << endl;
     //exit(0);*/
    
    cout << "Calculating Agents..." << endl;
    /*Splits into agents via the causal graph and then calculates agent specific variables (ie. those connected only to agents and therefore belonging to that agent.
     Creates:
     agent_vars which gives has each agents internal variables and
     public_vars with the leftover ones.
     no_of_agents the number of agents.
     */
    split_into_agents();
    
    cout << "Extending agent variables..." << endl;
    //Not sure if this calculation is needed as should/could be done automatically when building operators.
    for(int agent = 0; agent < no_of_agents; agent++){
        if(graph_level == 0){
            extend_agent_vars(agent, agent_vars[agent][0]);
        }
        //else if(graph_level == 1){
       //     extend_agent_vars_two_way(agent, agent_vars[agent][0]);
       // }
       // else{
       //     extend_agent_vars(agent, agent_vars[agent][0]);
       // }
    }
    
    cout << "Refining Agents by joint action space..." << endl;
    int prev_agents = no_of_agents;
    cout << no_of_agents << "->";
    /*Refine agents by combining joint actions where this reduces the number of agents to a number > 1.
     This is done by operator as opposed to by action.
     Operator actions are not necessarily adjacent in g_operators.
     Lazy implementation for finding actions of the same operator.     
     */
    vector<string> op_names;
    vector<vector < Operator *> > op_numbers;
    for (int i = 0; i < g_operators.size(); i++){
        string new_name = g_operators[i].get_name();
        new_name = new_name.substr(0, new_name.find(' '));             
        if(find(op_names.begin(), op_names.end(), new_name) == op_names.end()){//ie a new name
            op_names.push_back(new_name);
        }
    }
    op_numbers.resize(op_names.size());
    for (int i = 0; i < g_operators.size(); i++){
        string new_name = g_operators[i].get_name();
        new_name = new_name.substr(0, new_name.find(' ')); 
        vector<string>::iterator it = find(op_names.begin(), op_names.end(), new_name);
        int val = op_names.end()-it;
        op_numbers[val-1].push_back(&g_operators[i]);        
    }  
    for(int i = 0; i < op_numbers.size(); i++){
        check_operator_for_jointness(op_numbers[i]);
    }
    cout << no_of_agents << " agents left" << endl;
    
    if(no_of_agents < 2){
        cout << "Agent merging resulted in less than 2 agents" << endl;
        cout << "This should not happen" << endl;
        exit(1);
    }
    
    //Output found agents. 
    if(prev_agents > no_of_agents){
        for(int i = 0; i < no_of_agents; i++){
            cout << "Agent" << i << endl;
            for(int j = 0; j < agent_vars[i].size(); j++){
                cout << "  " << g_fact_names[agent_vars[i][j]][0] << endl;
            }
        }
    }
    
    
    
    //Figure out public variables (all variables that are left).
    for(int i = 0; i < g_variable_name.size(); i++){
        bool global_v = true;
        for(int agent = 0; agent < agent_vars.size(); agent++){
            if(find(agent_vars[agent].begin(), agent_vars[agent].end(), i) != agent_vars[agent].end()){
                global_v = false;
                break;
            }
        }
        if(global_v){
            public_vars.push_back(i);
        }
    }
    /*
     cout << "Public: ";
     for (int i = 0; i < public_vars.size(); i++)
     cout << public_vars[i] << " ";
     cout << endl;
     */
    
    
    for(int i = 0; i < agent_vars.size(); i++){
        cout << "Agent " << i << ": ";
        for(int j = 0; j < agent_vars[i].size(); j++){
            cout << agent_vars[i][j] << " ";
        }
        cout << endl;
    }
    cout << "With " << public_vars.size() << " public" << endl;
    
    if (no_of_agents > 1){  
        cout << no_of_agents << " agents found!" << endl;
        //for(int i = 0; i < no_of_agents; i++){
        //    for(int j = 0; j < agent_vars[i].size(); j++){
        //        cout << "Agent" << i << " " << g_fact_names[agent_vars[i][j]][0] << endl;
        //    }
        //}
    }
    
    //Collect agent variables to associated_agent_by_var.
    for(int i = 0; i < g_variable_domain.size(); i++){
        bool agent_found = false;
        for(int agent = 0; agent < no_of_agents; agent++){
            if(find(agent_vars[agent].begin(), agent_vars[agent].end(), i) != agent_vars[agent].end()){
                associated_agent_by_var.push_back(agent);
                agent_found = true;
            }
        }
        if(!agent_found)
            associated_agent_by_var.push_back(-1);
    }
    assert(associated_agent_by_var.size() == g_variable_domain.size());
    
    // Build Proposition_As - each agent has associated agent or -1 for public.
    agent_propositions.resize(no_of_agents);
    int prop_id = 0;
    propositions.resize(g_variable_domain.size());
    for (int var = 0; var < g_variable_domain.size(); var++) {
        for (int value = 0; value < g_variable_domain[var]; value++){
            propositions[var].push_back(Proposition_A(prop_id++, associated_agent_by_var[var], no_of_agents, var, value));
        }
    }
    
    //Creating agent_prop and public_prop reference sets.
    for(int i = 0; i < propositions.size(); i++){
        for(int j = 0; j < propositions[i].size(); j++){
            if(associated_agent_by_var[i] != -1){
                agent_propositions[associated_agent_by_var[i]].push_back(&propositions[i][j]);
            }
            else{
                public_propositions.push_back(&propositions[i][j]);
            }
        }
    }
    
    // Build goal propositions.
    for (int i = 0; i < g_goal.size(); i++) {
        int var = g_goal[i].first, val = g_goal[i].second;
        propositions[var][val].is_goal = true;
        goal_propositions.push_back(&propositions[var][val]);
    }
    
    // Build unary operators for operators and axioms.
    for (int i = 0; i < g_operators.size(); i++)
        build_unary_operators(g_operators[i], i);
    for (int i = 0; i < g_axioms.size(); i++)
        build_unary_operators(g_axioms[i], -1);
    
    // Simplify unary operators.
    simplify();
    
    cout << "Cross-referencing operators" << endl;    
    // Cross-reference unary operators for each agent.
    for (int i = 0; i < unary_operators.size(); i++) {
        UnaryOperator_A *op = &unary_operators[i];
        for (int j = 0; j < op->precondition.size(); j++){
            op->precondition[j]->precondition_of.push_back(op);
        }
    }
    
    cout << "Creating agent operator sets" << endl;
    //Create pointers to agent operator sets. 
    agent_operators.resize(no_of_agents);
    agent_joint_operators.resize(no_of_agents);
    int internal = 0;
    int partial_internal = 0;
    for (int i = 0; i < unary_operators.size(); i++){
        UnaryOperator_A *op = &unary_operators[i];
        std::set< int> used_by;
        for (int j = 0; j < op->precondition.size(); j++){
            if(op->precondition[j]->agent_id != -1)
                used_by.insert(op->precondition[j]->agent_id);
        }
        if(used_by.size() == 0){
            //This is a public action
            op->agent_id = -1;
            op->agent_cost.resize(no_of_agents);
            public_operators.push_back(op);
        }
        else if(used_by.size() == 1){
            //This action is for one agent only.
            if(op->effect->agent_id == *used_by.begin())
                internal++;
            else
                partial_internal++;
            op->agent_id = *used_by.begin();
            agent_operators[*used_by.begin()].push_back(op);
        }
        else{
            //This is a joint operator.
            op->agent_id = -2;
            op->agent_cost.resize(no_of_agents);//Note not all agents can do this action though.
            set<int>::iterator it;
            for(it = used_by.begin(); it != used_by.end(); it++){
                agent_joint_operators[*it].push_back(op);
            }
        }
    }
    
    //Output action decomposition.
    int internal_ops = 0;
    int joint_ops = 0;
    for(int i=0; i < no_of_agents; i++){
        internal_ops += agent_operators[i].size();
        joint_ops += agent_joint_operators[i].size();
    }
    cout << internal_ops << " total internal actions" << endl;
    cout << "   " << internal << " completely internal" << endl;
    cout << "   " << partial_internal << " partial internal" << endl;
    cout << public_operators.size() << " total public actions" << endl;
    cout << joint_ops << " total joint actions" << endl;
    
    /*
     cout << "Public:" << endl;
     for(int i = 0; i < public_operators.size(); i++){
     if(public_operators[i]->operator_no > -1)
     cout << g_operators[public_operators[i]->operator_no].get_name() << endl;
     else
     cout << "Axiom - not sure what to do with these..." << endl;
     }
     cout << "Joint:" << endl;
     for(int agent = 0; agent < no_of_agents; agent++){
     cout << "Agent " << agent << endl;
     for(int i = 0; i < agent_joint_operators[agent].size(); i++){
     if(agent_joint_operators[agent][i]->operator_no > -1)
     cout << g_operators[agent_joint_operators[agent][i]->operator_no].get_name() << endl;
     else
     cout << "Axiom - not sure what to do with these..." << endl;
     }
     }*/
    
    
    /*
     //Huge variable/causal graph dump for debug.
     for(int i = 0; i < propositions.size(); i++){
     for(int j = 0; j < propositions[i].size(); j++){
     cout << i << "," << j << "=" << g_fact_names[i][j] << endl;
     }
     }
     g_causal_graph->dump();
     cout << "Vars: " << g_variable_name.size() << endl;
     for(int i = 0; i < g_variable_name.size(); i++){
     cout << i << ":" << g_variable_name[i] << endl;
     }    
     exit(0);*/
    
}

void MadRelaxationHeuristic::split_into_agents(){
    vector<int> agent_mainvar; 
    graph_level = 0;
    
    cout << "Calculating cycles" << endl;
    index = 0;    
    if(connected_sets.size() != 0){
        connected_sets.clear();
    }
    vertices_index.resize(g_variable_name.size());
    for(int i = 0; i < vertices_index.size(); i++){
        vertices_index[i] = -1;
    }
    vertices_lowlink.resize(g_variable_name.size());
    for(int i = 0; i < vertices_lowlink.size(); i++){
        vertices_lowlink[i] = -1;
    }
    in_a_cycle.resize(g_variable_name.size());
    in_same_cycle.resize(g_variable_name.size());
    for(int i = 0; i < g_variable_name.size(); i++){
        in_same_cycle[i].resize(g_variable_name.size());
    }
    
    for(int i = 0; i < g_variable_name.size(); i++){
        if(vertices_index[i] == -1){
            strongconnect(i);
        }
    }
    
    cout << "Found " << connected_sets.size() << " cycles" << endl;
    no_of_agents = 0;
    
    
    if(no_of_agents <= 1){
        cout << "Trying cycle-less graph" << endl;
        agent_mainvar.clear();
        //Remove all cycles
        //Find top level variables in cycleless graph.
        for(int i = 0; i < g_variable_name.size(); i++){
            vector<int> successors = g_causal_graph->get_successors(i);
            vector<int> predecessors = g_causal_graph->get_predecessors(i);
            
            if(predecessors.size() == 0 && successors.size() > 0){
                agent_mainvar.push_back(i);
            }
            //check again after removing cycle edges
            else if(in_a_cycle[i]){
                bool possible_agent = true;
                for(int pre = 0; pre < predecessors.size(); pre++){
                    if(!in_same_cycle[i][predecessors[pre]]){
                        possible_agent = false;
                    }
                }
                if(possible_agent){
                    for(int suc = 0; suc < successors.size(); suc++){
                        if(!in_same_cycle[i][successors[suc]]){
                            agent_mainvar.push_back(i);
                            break;
                        }
                    }
                }
            }
            
        }
        no_of_agents = agent_mainvar.size();        
        
    }
    
    //Remove Cycles of size 2.
    if(no_of_agents <= 1){
        cout << "Trying with simple 2-way cycles removed" << endl;
        graph_level++;
        //Use root nodes removing loops a <-> b
        agent_mainvar.clear();
        for(int i = 0; i < g_variable_name.size(); i++){
            if (g_causal_graph->get_neighbours(i).size() != g_causal_graph->get_predecessors(i).size() ||
                g_causal_graph->get_neighbours(i).size() != g_causal_graph->get_successors(i).size())
                if(g_causal_graph->get_neighbours(i).size() - g_causal_graph->get_successors(i).size() == 0){
                    agent_mainvar.push_back(i);
                }
        }
        no_of_agents = agent_mainvar.size(); 
    }
    
    
    
    if(no_of_agents <= 1){
        cout << "Using straight up graph" << endl;
        graph_level++;
        agent_mainvar.clear();
        //Get root nodes
        for(int i = 0; i < g_variable_name.size(); i++){
            if(g_causal_graph->get_neighbours(i).size() - g_causal_graph->get_successors(i).size() == 0){
                agent_mainvar.push_back(i);
            }
        }
        no_of_agents = agent_mainvar.size(); 
    }
    
    if (no_of_agents > 1){  
        cout << no_of_agents << " agents found!" << endl;
        for(int i = 0; i < no_of_agents; i++){
            cout << "Agent" << i << " " << g_fact_names[agent_mainvar[i]][0] << endl;
        }
        cout << "G-level: " << graph_level << endl;
    }
    else if(no_of_agents == 1){
        cout << "1 agents found!" << endl;
        cout << "Use a normal planner for this problem" << endl;
        cout << "Agent Value: 0" << endl;
        exit(0);
    }
    else{
        cout << "0 agents found!" << endl;
        cout << "Agent Value: -1" << endl;
        exit(0);
    }
    
    agent_vars.resize(no_of_agents);
    for (int agent = 0; agent < no_of_agents; agent++){
        agent_vars[agent].push_back(agent_mainvar[agent]);
    }
}

//Extend while ignoring full cycles. 
void MadRelaxationHeuristic::extend_agent_vars(int agent, int var_to_expand){    
    const vector<int> &succs = g_causal_graph->get_successors(var_to_expand);
    // cout << "agent " << agent << " var_to_expand " << var_to_expand << endl;
    for(int i = 0; i < succs.size(); i++){
        const vector<int> succs_pres = g_causal_graph->get_predecessors(succs[i]);
        if(succs_pres.size() > 0){
            int testable = succs_pres.size();
            for(int j = 0; j < succs_pres.size(); j++){
                if(in_same_cycle[succs[i]][succs_pres[j]]){
                    testable--;
                }
            }
            if(testable > 0){
                
                bool valid = true;
                //if there exists a predecessor that is not in the agent set and is not in a cycle then it's false
                for(int j = 0; j < succs_pres.size(); j++){
                    if(!in_same_cycle[succs[i]][succs_pres[j]] &&
                       find(agent_vars[agent].begin(), agent_vars[agent].end(), succs_pres[j]) == agent_vars[agent].end()){
                        valid = false;
                        break;
                    }
                }
                if(valid){
                    if(find(agent_vars[agent].begin(), agent_vars[agent].end(), succs[i]) == agent_vars[agent].end()){
                        agent_vars[agent].push_back(succs[i]);
                        extend_agent_vars(agent, succs[i]);
                    }
                    
                }
            }
        }
        
        
    }
}

//Extend while ignoring simple 2-way cycles. 
void MadRelaxationHeuristic::extend_agent_vars_two_way(int agent, int var_to_expand){    
    const vector<int> &succs = g_causal_graph->get_successors(var_to_expand);
    for(int i = 0; i < succs.size(); i++){
        const vector<int> succs_pres = g_causal_graph->get_predecessors(succs[i]);
        bool valid = true;
        if(succs_pres.size() > 0){
            for(int j = 0; j < succs_pres.size(); j++){
                // cout << "    " << g_fact_names[succs_pres[j]][0].substr(5, 3) << ":" << <<endl;
                if(g_fact_names[succs_pres[j]][0].substr(5, 3)!="new"){
                    if(find(agent_vars[agent].begin(), agent_vars[agent].end(), succs_pres[j]) == agent_vars[agent].end()){
                        if(find(g_causal_graph->get_successors(succs[i]).begin(), g_causal_graph->get_successors(succs[i]).end(), succs_pres[j]) == 
                           g_causal_graph->get_successors(succs[i]).end()){
                            valid = false;
                        }
                        
                    }
                }
            }
        }
        if(valid){
            if(find(agent_vars[agent].begin(), agent_vars[agent].end(), succs[i]) == agent_vars[agent].end()){
                agent_vars[agent].push_back(succs[i]);
                extend_agent_vars_two_way(agent, succs[i]);
            }
        }
    }
}

void MadRelaxationHeuristic::check_operator_for_jointness(vector<Operator *> ops) {
    std::vector<std::vector<int> > old_agent_vars;
    for(int i = 0; i < agent_vars.size(); i++){
        old_agent_vars.push_back(agent_vars[i]);
    }    
    
    set<int> relevant_agents_by_action;
    for(int i = 0; i < ops.size(); i++){
        relevant_agents_by_action.clear();
        const Operator op = *ops[i];
        
        const vector<Prevail> &prevail = op.get_prevail();
        const vector<PrePost> &pre_post = op.get_pre_post();
        
        std::vector<int> uses_var(g_variable_domain.size());
        for(int i=0; i < uses_var.size(); i++){
            uses_var.at(i) = 0;
        }
        
        for (int i = 0; i < prevail.size(); i++){
            uses_var.at(prevail[i].var) =  1;
        }
        for (int i = 0; i < pre_post.size(); i++){
            uses_var.at(pre_post[i].var) = 1;
        }
        for(int agent = 0; agent < no_of_agents; agent++)
            for(int j = 0; j < agent_vars[agent].size(); j++)
                if(uses_var[agent_vars[agent][j]] == 1)
                    relevant_agents_by_action.insert(agent);
        
        if(relevant_agents_by_action.size() > 1){//Only update if it is actually a joint operator.
            set<int>::iterator it = relevant_agents_by_action.end();
            for(it--; it != relevant_agents_by_action.begin(); it--){
                for(int i = 0; i < agent_vars[*it].size(); i++){
                    agent_vars[*relevant_agents_by_action.begin()].push_back(agent_vars[*it][i]);
                }
                agent_vars.erase(agent_vars.begin() + *it);
            }
        }
        no_of_agents = agent_vars.size();
        
        
    }
    if(agent_vars.size() < 2){
        agent_vars = old_agent_vars;
        no_of_agents = agent_vars.size();
    }
    
    /* (Previous code)
     //Collect all agents involved in each instance of the operator.    
     set<int> relevant_agents;
     set<int> relevant_agents_by_action;
     
     for(int i = 0; i < ops.size(); i++){
     relevant_agents_by_action.clear();
     const Operator op = *ops[i];
     
     const vector<Prevail> &prevail = op.get_prevail();
     const vector<PrePost> &pre_post = op.get_pre_post();
     
     std::vector<int> uses_var(g_variable_domain.size());
     for(int i=0; i < uses_var.size(); i++){
     uses_var.at(i) = 0;
     }
     
     for (int i = 0; i < prevail.size(); i++){
     uses_var.at(prevail[i].var) =  1;
     }
     for (int i = 0; i < pre_post.size(); i++){
     uses_var.at(pre_post[i].var) = 1;
     }
     for(int agent = 0; agent < no_of_agents; agent++)
     for(int j = 0; j < agent_vars[agent].size(); j++)
     if(uses_var[agent_vars[agent][j]] == 1)
     relevant_agents_by_action.insert(agent);
     
     if(relevant_agents_by_action.size() > 1){//Only add if it is actually a joint operator.
     set<int>::iterator it;
     for(it = relevant_agents_by_action.begin(); it != relevant_agents_by_action.end(); it++){
     relevant_agents.insert(*it);
     }
     }
     } 
     
     //Join them if there is more than one and will still leave some separate agents.
     if (relevant_agents.size() > 1 && relevant_agents.size() < (no_of_agents - 1)){
     for(int i = 0; i < ops.size(); i++){
     relevant_agents_by_action.clear();
     const Operator op = *ops[i];
     
     const vector<Prevail> &prevail = op.get_prevail();
     const vector<PrePost> &pre_post = op.get_pre_post();
     
     std::vector<int> uses_var(g_variable_domain.size());
     for(int i=0; i < uses_var.size(); i++){
     uses_var.at(i) = 0;
     }
     
     for (int i = 0; i < prevail.size(); i++){
     uses_var.at(prevail[i].var) =  1;
     }
     for (int i = 0; i < pre_post.size(); i++){
     uses_var.at(pre_post[i].var) = 1;
     }
     for(int agent = 0; agent < no_of_agents; agent++)
     for(int j = 0; j < agent_vars[agent].size(); j++)
     if(uses_var[agent_vars[agent][j]] == 1)
     relevant_agents_by_action.insert(agent);
     
     if(relevant_agents_by_action.size() > 1){//Only add if it is actually a joint operator.
     set<int>::iterator it = relevant_agents_by_action.end();
     for(it--; it != relevant_agents_by_action.begin(); it--){
     for(int i = 0; i < agent_vars[*it].size(); i++){
     agent_vars[*relevant_agents_by_action.begin()].push_back(agent_vars[*it][i]);
     }
     agent_vars.erase(agent_vars.begin() + *it);
     }
     no_of_agents = agent_vars.size(); 
     }
     
     }
     
     }*/
}


void MadRelaxationHeuristic::build_unary_operators(const Operator &op, int op_no) {
    /*
     int base_cost = get_adjusted_cost(op);
     const vector<Prevail> &prevail = op.get_prevail();
     const vector<PrePost> &pre_post = op.get_pre_post();
     
     //Make precondition.
     vector<Proposition_A *> precondition;
     for (int i = 0; i < prevail.size(); i++) {
     assert(prevail[i].var >= 0 && prevail[i].var < g_variable_domain.size());
     assert(prevail[i].prev >= 0 && prevail[i].prev < g_variable_domain[prevail[i].var]);
     precondition.push_back(&propositions[prevail[i].var][prevail[i].prev]);
     }
     for (int i = 0; i < pre_post.size(); i++) {
     if (pre_post[i].pre != -1) {
     assert(pre_post[i].var >= 0 && pre_post[i].var < g_variable_domain.size());
     assert(pre_post[i].pre >= 0 && pre_post[i].pre < g_variable_domain[pre_post[i].var]);
     precondition.push_back(&propositions[pre_post[i].var][pre_post[i].pre]);
     }
     }
     
     //Make unary effect and (multiple) operators
     for (int i = 0; i < pre_post.size(); i++) {
     assert(pre_post[i].var >= 0 && pre_post[i].var < g_variable_domain.size());
     assert(pre_post[i].post >= 0 && pre_post[i].post < g_variable_domain[pre_post[i].var]);
     Proposition_A *effect = &propositions[pre_post[i].var][pre_post[i].post];
     const vector<Prevail> &eff_cond = pre_post[i].cond;
     for (int j = 0; j < eff_cond.size(); j++) {
     assert(eff_cond[j].var >= 0 && eff_cond[j].var < g_variable_domain.size());
     assert(eff_cond[j].prev >= 0 && eff_cond[j].prev < g_variable_domain[eff_cond[j].var]);
     precondition.push_back(&propositions[eff_cond[j].var][eff_cond[j].prev]);
     }
     unary_operators.push_back(UnaryOperator_A(precondition, effect, op_no, base_cost));
     precondition.erase(precondition.end() - eff_cond.size(), precondition.end());
     }*/
    
    int base_cost = get_adjusted_cost(op);
    const vector<Prevail> &prevail = op.get_prevail();
    const vector<PrePost> &pre_post = op.get_pre_post();
    vector<Proposition_A *> precondition;
    for (int i = 0; i < prevail.size(); i++) {
        assert(prevail[i].var >= 0 && prevail[i].var < g_variable_domain.size());
        assert(prevail[i].prev >= 0 && prevail[i].prev < g_variable_domain[prevail[i].var]);
        precondition.push_back(&propositions[prevail[i].var][prevail[i].prev]);
    }
    for (int i = 0; i < pre_post.size(); i++) {
        if (pre_post[i].pre != -1) {
            assert(pre_post[i].var >= 0 && pre_post[i].var < g_variable_domain.size());
            assert(pre_post[i].pre >= 0 && pre_post[i].pre < g_variable_domain[pre_post[i].var]);
            precondition.push_back(&propositions[pre_post[i].var][pre_post[i].pre]);
        }
    }
    for (int i = 0; i < pre_post.size(); i++) {
        assert(pre_post[i].var >= 0 && pre_post[i].var < g_variable_domain.size());
        assert(pre_post[i].post >= 0 && pre_post[i].post < g_variable_domain[pre_post[i].var]);
        Proposition_A *effect = &propositions[pre_post[i].var][pre_post[i].post];
        const vector<Prevail> &eff_cond = pre_post[i].cond;
        for (int j = 0; j < eff_cond.size(); j++) {
            assert(eff_cond[j].var >= 0 && eff_cond[j].var < g_variable_domain.size());
            assert(eff_cond[j].prev >= 0 && eff_cond[j].prev < g_variable_domain[eff_cond[j].var]);
            precondition.push_back(&propositions[eff_cond[j].var][eff_cond[j].prev]);
        }
        unary_operators.push_back(UnaryOperator_A(precondition, effect, op_no, base_cost));
        precondition.erase(precondition.end() - eff_cond.size(), precondition.end());
    }
    
}



class hash_unary_operator {
public:
    size_t operator()(const pair<vector<Proposition_A *>, Proposition_A *> &key) const {
        // NOTE: We used to hash the Proposition_A* values directly, but
        // this had the disadvantage that the results were not
        // reproducible. This propagates through to the heuristic
        // computation: runs on different computers could lead to
        // different initial h values, for example.
        
        unsigned long hash_value = key.second->id;
        const vector<Proposition_A *> &vec = key.first;
        for (int i = 0; i < vec.size(); i++)
            hash_value = 17 * hash_value + vec[i]->id;
        return size_t(hash_value);
    }
};


static bool compare_prop_pointer(const Proposition_A *p1, const Proposition_A *p2) {
    return p1->id < p2->id;
}


void MadRelaxationHeuristic::simplify() {
    // Remove duplicate or dominated unary operators.
    
    /*
     Algorithm: Put all unary operators into a hash_map
     (key: condition and effect; value: index in operator vector.
     This gets rid of operators with identical conditions.
     
     Then go through the hash_map, checking for each element if
     none of the possible dominators are part of the hash_map.
     Put the element into the new operator vector iff this is the case.
     
     In both loops, be careful to ensure that a higher-cost operator
     never dominates a lower-cost operator.
     */
    
    
    cout << "Simplifying " << unary_operators.size() << " unary operators..." << flush;
    
    typedef pair<vector<Proposition_A *>, Proposition_A *> HashKey;
    typedef hash_map<HashKey, int, hash_unary_operator> HashMap;
    HashMap unary_operator_index;
    unary_operator_index.resize(unary_operators.size() * 2);
    
    for (int i = 0; i < unary_operators.size(); i++) {
        UnaryOperator_A &op = unary_operators[i];
        sort(op.precondition.begin(), op.precondition.end(), compare_prop_pointer);
        HashKey key(op.precondition, op.effect);
        pair<HashMap::iterator, bool> inserted = unary_operator_index.insert(
                                                                             make_pair(key, i));
        if (!inserted.second) {
            // We already had an element with this key; check its cost.
            HashMap::iterator iter = inserted.first;
            int old_op_no = iter->second;
            int old_cost = unary_operators[old_op_no].base_cost;
            int new_cost = unary_operators[i].base_cost;
            if (new_cost < old_cost)
                iter->second = i;
            assert(unary_operators[unary_operator_index[key]].base_cost ==
                   min(old_cost, new_cost));
        }
    }
    
    vector<UnaryOperator_A> old_unary_operators;
    old_unary_operators.swap(unary_operators);
    
    for (HashMap::iterator it = unary_operator_index.begin();
         it != unary_operator_index.end(); ++it) {
        const HashKey &key = it->first;
        int unary_operator_no = it->second;
        int powerset_size = (1 << key.first.size()) - 1; // -1: only consider proper subsets
        bool match = false;
        if (powerset_size <= 31) { // HACK! Don't spend too much time here...
            for (int mask = 0; mask < powerset_size; mask++) {
                HashKey dominating_key = make_pair(vector<Proposition_A *>(), key.second);
                for (int i = 0; i < key.first.size(); i++)
                    if (mask & (1 << i))
                        dominating_key.first.push_back(key.first[i]);
                HashMap::iterator found = unary_operator_index.find(
                                                                    dominating_key);
                if (found != unary_operator_index.end()) {
                    int my_cost = old_unary_operators[unary_operator_no].base_cost;
                    int dominator_op_no = found->second;
                    int dominator_cost = old_unary_operators[dominator_op_no].base_cost;
                    if (dominator_cost <= my_cost) {
                        match = true;
                        break;
                    }
                }
            }
        }
        if (!match)
            unary_operators.push_back(old_unary_operators[unary_operator_no]);
    }
    
    cout << " done! [" << unary_operators.size() << " unary operators]" << endl;
}

void MadRelaxationHeuristic::strongconnect(int v){
    vertices_index[v] = index;
    vertices_lowlink[v] = index;
    index++;
    S.push_front(v);
    
    const vector<int> successors = g_causal_graph->get_successors(v);
    for(int i = 0; i < successors.size(); i++){
        int w = successors[i];
        if(vertices_index[w] == -1){
            strongconnect(w);
            if(vertices_lowlink[v] == -1){
                vertices_lowlink[v] = vertices_lowlink[w];
            }
            else if(vertices_lowlink[w] == -1){
            }
            else{
                vertices_lowlink[v] = min(vertices_lowlink[v], vertices_lowlink[w]);
            }
        }
        else if(find(S.begin(), S.end(), successors[i]) != S.end()){
            if(vertices_lowlink[v] == -1){
                vertices_lowlink[v] = vertices_index[w];
            }
            else if(vertices_index[w] == -1){
            }
            else{
                vertices_lowlink[v] = min(vertices_lowlink[v], vertices_index[w]);
            }        
        }
    }
    
    if(vertices_lowlink[v] == vertices_index[v]){
        vector<int> connected_set;
        while(true){
            int connected = S.front();
            S.pop_front();
            connected_set.push_back(connected);
            in_a_cycle[connected] = true;
            if(connected == v){
                break;
            }
        }
        if(connected_set.size() > 1){
            connected_sets.push_back(connected_set);
            for(int i = 0; i < connected_set.size(); i++){
                //cout << connected_set[i] << " ";
                for(int j = 0; j < connected_set.size(); j++){
                    if(j != i){
                        in_same_cycle[connected_set[i]][connected_set[j]] = true;
                        in_same_cycle[connected_set[j]][connected_set[i]] = true;
                    }
                }
            }
            //cout << endl;
        }
    }
    
}

