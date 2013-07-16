#include "mad_additive_heuristic.h"

#include "operator.h"
#include "option_parser.h"
#include "plugin.h"
#include "state.h"

#include <cassert>
#include <vector>
using namespace std;

//This version uses:
//  agent_propositions: variables unique to each agent
//  --> have individual associated cost
//  public_propositions: all public variables
//  --> have cost for each agent

//Action sets are split for each agent
// agent_operators
// agent_joint_operators
// public_operators
//
// (though 1 and 3 are treated the same).




// construction and destruction
MadAdditiveHeuristic::MadAdditiveHeuristic(const Options &opts)
: MadRelaxationHeuristic(opts),
did_write_overflow_warning(false) {
}

MadAdditiveHeuristic::~MadAdditiveHeuristic() {
}

void MadAdditiveHeuristic::write_overflow_warning() {
    if (!did_write_overflow_warning) {
        // TODO: Should have a planner-wide warning mechanism to handle
        // things like this.
        cout << "WARNING: overflow on h^add! Costs clamped to "
        << MAX_COST_VALUE << endl;
        cerr << "WARNING: overflow on h^add! Costs clamped to "
        << MAX_COST_VALUE << endl;
        did_write_overflow_warning = true;
    }
}

// initialization
void MadAdditiveHeuristic::initialize() {
    cout << "Initializing MaD heuristic..." << endl;
    MadRelaxationHeuristic::initialize();
    
    relaxed_plans.resize(goal_propositions.size());
    for(int i = 0; i < relaxed_plans.size(); i++){
        relaxed_plans[i].resize(no_of_agents);
    }
    if(explored_state.size() == 0){
        agent_future_goal_propositions.resize(no_of_agents);
        explored_state.resize(g_variable_domain.size());
        for(int var = 0; var < g_variable_domain.size(); var++){
            explored_state[var].resize(g_variable_domain[var]);
        }
    }
    agent_subgoals.resize(no_of_agents);
}

//This resets the common parts of the public propositions
//These should not be reset between agents or layers!
void MadAdditiveHeuristic::reset_public(){
    for(int i = 0; i < public_propositions.size(); i++){
        Proposition_A* prop = public_propositions[i];
        prop->cost = -1;
        prop->best_agent = prop->agent_id;
    }
}

void MadAdditiveHeuristic::reset_agent(int agent){
    queue.clear();
    
    //Reset propositions
    for(int i = 0; i < agent_propositions[agent].size(); i++){  
        Proposition_A* prop = agent_propositions[agent][i];
        //cout << "Resetting " << prop->id << endl;
        prop->cost = -1;
        prop->marked_by_agent[agent] = false;
        prop->marked = false;
    }
    for(int i = 0; i < public_propositions.size(); i++){
        Proposition_A* prop = public_propositions[i];
        //cout << "Resetting " << prop->id << endl;
        prop->cost_by_agent[agent] = -1;
        //prop->cost = -1;
        //prop->best_agent = prop->agent_id;
        prop->marked_by_agent[agent] = false;
        prop->marked = false;
    }
    
    //Reset operators.
    for(int i = 0; i < agent_operators[agent].size(); i++){
        UnaryOperator_A* op = agent_operators[agent][i];
        op->unsatisfied_preconditions = op->precondition.size();
        op->cost = op->base_cost;
        
        if(op->unsatisfied_preconditions == 0){
            enqueue_if_necessary_for_agent(op->effect, op->base_cost, op, agent);
        }
    }
    for(int i = 0; i < agent_joint_operators[agent].size(); i++){
        UnaryOperator_A* op = agent_joint_operators[agent][i];
        op->unsatisfied_preconditions = op->precondition.size();
        op->agent_cost[agent] = op->base_cost;
        if(op->unsatisfied_preconditions == 0){
            enqueue_if_necessary_for_agent(op->effect, op->base_cost, op, agent);
            
        }
    }
    for(int i = 0; i < public_operators.size(); i++){
        UnaryOperator_A* op = public_operators[i];
        op->unsatisfied_preconditions = op->precondition.size();
        op->agent_cost[agent] = op->base_cost;
        if(op->unsatisfied_preconditions == 0){
            enqueue_if_necessary_for_agent(op->effect, op->base_cost, op, agent);
        }
    }
    
}

void MadAdditiveHeuristic::setup_exploration_queue_state_for_agent(const State &state, int agent) {  
    //Do this for all agents becuase in future states we may be able to piggyback off other agent's added props for joint actions.
    //This is a minor expense that is not needed in 0 layer problems. 
    //Might be better to have a set pointing to all internal props that are precons for joint actions and only check them. 
    //Probably minor difference.
    for(int agent_it = 0; agent_it < no_of_agents; agent_it++){
        for(int var = 0; var < agent_vars[agent_it].size(); var++){
            Proposition_A *init_prop = &propositions[agent_vars[agent_it][var]][state[agent_vars[agent_it][var]]];
            enqueue_if_necessary_for_agent(init_prop, 0, 0, agent);
        }
    }
    
    for(int var = 0; var < public_vars.size(); var++){
        Proposition_A *init_prop = &propositions[public_vars[var]][state[public_vars[var]]];
        enqueue_if_necessary_for_agent(init_prop, 0, 0, agent);
    }
}

void MadAdditiveHeuristic::setup_exploration_queue_state_for_agent_based_on_previous_explore(int agent){
    queue.clear();
    
    // cout << "Resetting operators" << endl;
    //Reset operators
    for(int i = 0; i < agent_operators[agent].size(); i++){
        UnaryOperator_A* op = agent_operators[agent][i];
        op->unsatisfied_preconditions = op->precondition.size();
        op->cost = op->base_cost;
        // cout << "Resetting agent" << agent << " own" << endl;
        // g_operators[op->operator_no].dump();        
        if(op->unsatisfied_preconditions == 0)
            enqueue_if_necessary_for_agent(op->effect, op->base_cost, op, agent);
    }
    for(int i = 0; i < agent_joint_operators[agent].size(); i++){
        UnaryOperator_A* op = agent_joint_operators[agent][i];
        op->unsatisfied_preconditions = op->precondition.size();
        op->agent_cost[agent] = op->base_cost;
        //  cout << "Resetting agent" << agent << " joint" << endl;
        //  g_operators[op->operator_no].dump();
        if(op->unsatisfied_preconditions == 0)
            enqueue_if_necessary_for_agent(op->effect, op->base_cost, op, agent);
    }
    for(int i = 0; i < public_operators.size(); i++){
        UnaryOperator_A* op = public_operators[i];
        //  cout << "Resetting agent" << agent << " public" << endl;
        //  g_operators[op->operator_no].dump();
        op->unsatisfied_preconditions = op->precondition.size();
        op->agent_cost[agent] = op->base_cost;
        if(op->unsatisfied_preconditions == 0)
            enqueue_if_necessary_for_agent(op->effect, op->base_cost, op, agent);
    }
    
    //cout << "Adding props based on previous explore" << endl;
    
    for(int var = 0; var < explored_state.size(); var++){
        for(int val = 0; val < explored_state[var].size(); val++){
            if(explored_state[var][val].first > -1){
                //cout << "Agent" << agent << " adding " << propositions[var][val].id << ":" << g_fact_names[var][val] << " with cost " 
                //   << explored_state[var][val].first << " from agent " << explored_state[var][val].second << endl;
                if(propositions[var][val].agent_id == -1 && propositions[var][val].cost_by_agent[agent] > -1){
                    queue.push(propositions[var][val].cost_by_agent[agent], &propositions[var][val]);
                }
                else{
                    queue.push(propositions[var][val].cost, &propositions[var][val]);
                    
                }
                //enqueue_if_necessary_for_agent(&propositions[var][val], explored_state[var][val].first, 0, agent);
            }
        }
    }
    
}

void MadAdditiveHeuristic::relaxed_exploration_for_agent(int agent) {
    int unsolved_goals = current_goals.size();
    while (!queue.empty()) {
        pair<int, Proposition_A *> top_pair = queue.pop();
        int distance = top_pair.first;
        Proposition_A *prop = top_pair.second;
        int prop_cost = prop->cost;
        if(prop->agent_id == -1)
            prop_cost = prop->cost_by_agent[agent];
        /*
         else if(prop->agent_id != agent){
         //This only happens in a subsequent layer.
         prop_cost = prop->cost;
         }*/
        assert(prop_cost >= 0);
        assert(prop_cost <= distance);
        if (prop_cost < distance)
            continue;
        //For when using goal_agent.
        if (prop->is_goal && prop->goal_agent == agent && --unsolved_goals == 0)
            return;
        //For with each goal to each possible agent.
        //if (prop->is_goal && --unsolved_goals == 0)
        //      return;
        const vector<UnaryOperator_A *> &triggered_operators = prop ->precondition_of;
        for (int i = 0; i < triggered_operators.size(); i++) {            
            UnaryOperator_A *unary_op = triggered_operators[i];
            if(unary_op->agent_id == agent){
                increase_cost(unary_op->cost, prop_cost);
                unary_op->unsatisfied_preconditions--;
                assert(unary_op->unsatisfied_preconditions >= 0);
                if (unary_op->unsatisfied_preconditions == 0)
                    enqueue_if_necessary_for_agent(unary_op->effect,
                                                   unary_op->cost, unary_op, agent);
            }
            else if(unary_op->agent_id < 0){
                increase_cost(unary_op->agent_cost[agent], prop_cost);
                unary_op->unsatisfied_preconditions--;
                if(unary_op->unsatisfied_preconditions == 0)
                    enqueue_if_necessary_for_agent(unary_op->effect,
                                                   unary_op->agent_cost[agent], unary_op, agent);
                
            }
        }
    }
}

void MadAdditiveHeuristic::full_exploration_for_agent(int agent){
    while (!queue.empty()) {
        pair<int, Proposition_A *> top_pair = queue.pop();
        int distance = top_pair.first;
        Proposition_A *prop = top_pair.second;
        int prop_cost = prop->cost;
        if(prop->agent_id == -1)
            prop_cost = prop->cost_by_agent[agent];
        prop_cost++;
        /*
         else if(prop->agent_id != agent){
         //Only happens in subsequent layers but not a problem.
         }*/
        assert(prop_cost >= 0);
        assert(prop_cost <= distance);
        //cout << "prop cost " << prop_cost << " distance " << distance << endl;
        if (prop_cost < distance)
            continue;
        //  if (prop->is_goal)
        //      --unsolved_goals;
        const vector<UnaryOperator_A *> &triggered_operators =
        prop->precondition_of;
        for (int i = 0; i < triggered_operators.size(); i++) {            
            UnaryOperator_A *unary_op = triggered_operators[i];
            if(unary_op->agent_id == agent){
                increase_cost(unary_op->cost, prop_cost);
                unary_op->unsatisfied_preconditions--;
                assert(unary_op->unsatisfied_preconditions >= 0);
                if (unary_op->unsatisfied_preconditions == 0){
                   // cout << "addding " << g_fact_names[unary_op->effect->var][unary_op->effect->val] << "cost " << unary_op->cost << " for " << agent << endl;
                    enqueue_if_necessary_for_agent(unary_op->effect,
                                                   unary_op->cost, unary_op, agent);
                }
                
            }
            else if(unary_op->agent_id < 0){
                increase_cost(unary_op->agent_cost[agent], prop_cost);
                unary_op->unsatisfied_preconditions--;
                if(unary_op->unsatisfied_preconditions == 0){
                    /*if(unary_op->effect->agent_id > -1 && unary_op->effect->agent_id != agent){
                        cout << "The effect of a joint or public action is a private variable of a different agent." << endl;
                        cout << "This should not happen with a proper decomposition.." << endl;
                        cout << "Agent decomposition value -1" << endl;
                        exit(1);
                    }*/ 
                   // cout << "addding " << g_fact_names[unary_op->effect->var][unary_op->effect->val] << "cost " << unary_op->cost << " for " << agent << endl;
                    enqueue_if_necessary_for_agent(unary_op->effect,
                                                   unary_op->agent_cost[agent], unary_op, agent);
                }
                
            }
        }
    }
}

void MadAdditiveHeuristic::full_exploration_for_agent_in_subsequent_layer(int agent){
    while (!queue.empty()) {
        pair<int, Proposition_A *> top_pair = queue.pop();
        //int distance = top_pair.first;
        Proposition_A *prop = top_pair.second;
        //cout << "Dealing with " << prop->id;
        int prop_cost = prop->cost;
        prop_cost++;
        // if(prop->agent_id == -1)
        //    prop_cost = prop->cost_by_agent[prop->best_agent];
        //cout << " prop cost " << prop_cost << endl;
        assert(prop_cost >= 0);
        //assert(prop_cost <= distance);
        //We no longer care if prop_cost is < distance - as it won't be because taking costs from previous layer.
        //if (prop_cost < distance)
        //  continue;
        //  if (prop->is_goal)
        //      --unsolved_goals;
        const vector<UnaryOperator_A *> &triggered_operators = prop->precondition_of;
        for (int i = 0; i < triggered_operators.size(); i++) {            
            UnaryOperator_A *unary_op = triggered_operators[i];
            if(unary_op->agent_id == agent){
                increase_cost(unary_op->cost, prop_cost);
                unary_op->unsatisfied_preconditions--;
                //g_operators[unary_op->operator_no].dump();
                //cout << unary_op->unsatisfied_preconditions << " precons left of " << unary_op->precondition.size() << endl;
                assert(unary_op->unsatisfied_preconditions >= 0);
                if (unary_op->unsatisfied_preconditions == 0){
                    //cout << "Queing " << unary_op->effect->id << " cost " << unary_op->cost << endl;
                    enqueue_if_necessary_for_agent(unary_op->effect,
                                                   unary_op->cost, unary_op, agent);
                }
                
            }
            else if(unary_op->agent_id < 0){
                increase_cost(unary_op->agent_cost[agent], prop_cost);
                unary_op->unsatisfied_preconditions--;
                //g_operators[unary_op->operator_no].dump();
                //cout << unary_op->unsatisfied_preconditions << " precons left of " << unary_op->precondition.size() << endl;
                if(unary_op->unsatisfied_preconditions == 0){
                    //  cout << "Queueing " << unary_op->effect->id << " cost " << unary_op->agent_cost[agent] << endl;
                    enqueue_if_necessary_for_agent(unary_op->effect,
                                                   unary_op->agent_cost[agent], unary_op, agent);
                }
                
            }
        }
    }
}

void MadAdditiveHeuristic::mark_preferred_operators(
                                                    const State &state, Proposition_A *goal) {
    if (!goal->marked) { // Only consider each subgoal once.
        goal->marked = true;
        UnaryOperator_A *unary_op = goal->reached_by;
        if (unary_op) { // We have not yet chained back to a start node.
            for (int i = 0; i < unary_op->precondition.size(); i++)
                mark_preferred_operators(state, unary_op->precondition[i]);
            int operator_no = unary_op->operator_no;
            if (unary_op->cost == unary_op->base_cost && operator_no != -1) {
                // Necessary condition for this being a preferred
                // operator, which we use as a quick test before the
                // more expensive applicability test.
                // If we had no 0-cost operators and axioms to worry
                // about, this would also be a sufficient condition.
                const Operator *op = &g_operators[operator_no];
                if (op->is_applicable(state))
                    set_preferred(op);
            }
        }
    }
}


int MadAdditiveHeuristic::compute_add_and_ff(const State &state) {
    //cout << "Current goal agent = " << current_goal_agent << endl;
    //for(int i = 0; i < current_goals.size(); i++){
    //    cout << "   -->" << g_fact_names[current_goals[i]->var][current_goals[i]->val] << endl;
    //}
    int total_cost = 0;
    reset_public();
    reset_agent(current_goal_agent);
    setup_exploration_queue_state_for_agent(state, current_goal_agent);
    relaxed_exploration_for_agent(current_goal_agent);
    
    for(int i = 0; i < current_goals.size(); i++){
        if(current_goals[i]->agent_id == -1){
            if(current_goals[i]->cost_by_agent[current_goal_agent] > -1)
                total_cost += current_goals[i]->cost_by_agent[current_goal_agent];
            else
                return DEAD_END;
        }
        else{
            if(current_goals[i]->cost > -1)
                total_cost += current_goals[i]->cost;
            else
                return DEAD_END;
        }
        
    }
    
    if(total_cost == 0){
        cout << "All current goals for " << current_goal_agent << " found." << endl;
        agent_goal_propositions[current_goal_agent].clear();
        agent_subgoals[current_goal_agent].clear();
    }
    return total_cost;
}
    
int MadAdditiveHeuristic::compute_heuristic(const State &state) {
    int h = compute_add_and_ff(state);
    if (h != DEAD_END) {
        for (int i = 0; i < goal_propositions.size(); i++)
            mark_preferred_operators(state, goal_propositions[i]);
    }
    return h;
}

/*
int MadAdditiveHeuristic::check_reachability(const State &state){
    reset_public();
    int layer = 0;
    for(int agent = 0; agent < no_of_agents; agent++){
        reset_agent(agent);
        setup_exploration_queue_state_for_agent(state, agent);
        full_exploration_for_agent(agent);
    }
    
    //Keep exploring each layer and distributing the goals until they are all reachable.
    while(!check_goals()){
        layer++;
        if(no_of_layers > -1 && layer > no_of_layers)
            break;
        for(int var = 0; var < g_variable_domain.size(); var++){
            for(int val = 0; val < g_variable_domain[var]; val++){
                explored_state[var][val].first = propositions[var][val].cost;
                explored_state[var][val].second = propositions[var][val].best_agent;
            }
        }       
        for(int agent = 0; agent < no_of_agents; agent++){
            setup_exploration_queue_state_for_agent_based_on_previous_explore(agent);
            full_exploration_for_agent_in_subsequent_layer(agent);
        }    
        
    }
    
    return layer;
}*/

//Output the current values of the goal propositions.
void MadAdditiveHeuristic::output_goal_costs(int agent){
    cout << "Agent" << agent << ": ";
    for(int j = 0; j < goal_propositions.size(); j++){
        int cost = -1;
        if(goal_propositions[j]->agent_id < 0)
            cost = goal_propositions[j]->cost_by_agent[agent];
        else if(goal_propositions[j]->agent_id == agent)
            cost = goal_propositions[j]->cost;
        if(cost > -1 && cost < 10)
            cout << " ";
        if(cost > -1)
            cout << cost << " ";
        else
            cout << "-- ";
    }
    cout << endl;
}

bool MadAdditiveHeuristic::goal_decomposition(const State &state){
    for(int i = 0; i < goal_propositions.size(); i++){
        goal_propositions[i]->goal_agent = -1;
    }
    
    
    int layer = 0;   
    reset_public();
    for(int agent = 0; agent < no_of_agents; agent++){
        reset_agent(agent);
        setup_exploration_queue_state_for_agent(state, agent);
        full_exploration_for_agent(agent);
        output_goal_costs(agent);   
    }
    
    //Keep exploring each layer until all goals are reachable.
    //HACK! limit max-layers expanded to 3 - should just do until no futher facts can be added.
    int l = 0;
    while(!distribute_goals_current_layer(layer)){
        layer++;
        explore_next_layer();
        if(++l > 2){
            cout << "DEAD END" << endl;
            return false;
        }
    }
    
    cout << "total " << layer << " layers" << endl; 
    no_of_layers = layer;
    
    if(layer > 0){
        cout << "Finding subgoals" << endl;
        for(int i = 0; i < goal_propositions.size(); i++){
            if(goal_propositions[i]->layer > 0){
                extract_one_layer_relaxed_plan(goal_propositions[i], goal_propositions[i]->goal_agent, goal_propositions[i]->layer);
            }
        }
    }
    
    /*
    cout << "Goal decomp ";
    for(int i = 0; i < goal_propositions.size(); i++){
        cout << goal_propositions[i]->goal_agent << " ";
    }
    cout << endl;
    
    if(layer > 0){
        cout << "Sub goals:" << endl;
        for(int agent = 0; agent < no_of_agents; agent++){
            cout << "Agent" << agent << " ";
            for(int i = 0; i < agent_subgoals[agent].size(); i++){
                cout << g_fact_names[agent_subgoals[agent][i]->var][agent_subgoals[agent][i]->val] << ":" << agent_subgoals[agent][i]->layer << " ";
                
            }
            cout << endl;
        }
    }
    
    for(int i = 0; i < agent_goal_propositions.size(); i++){
        for(int j = 0; j < agent_goal_propositions[i].size(); j++){
            cout << i << ":" << j << ":" << g_fact_names[agent_goal_propositions[i][j]->var][agent_goal_propositions[i][j]->val] << endl;
        }
    }*/
    
    get_next_goal_set();
    
    return true;
}

void MadAdditiveHeuristic::get_next_goal_set(){
    //Getting next goal set.
    current_goals.clear();
    for(int test_layer = 0; test_layer <= no_of_layers; test_layer++){
        for(int agent = 0; agent < no_of_agents; agent++){
            for(int i = 0; i < agent_goal_propositions[agent].size(); i++){
                if(agent_goal_propositions[agent][i]->layer == test_layer){
                    current_goals.push_back(agent_goal_propositions[agent][i]);
                }
            }
            for(int i = 0; i < agent_subgoals[agent].size(); i++){
                if(agent_subgoals[agent][i]->layer == test_layer){
                    current_goals.push_back(agent_subgoals[agent][i]);
                }
            }
            if(current_goals.size() > 0){
                current_goal_agent = agent;
                break;
            }
        }
        if(current_goals.size() > 0){
            break;
        }
    }
    cout << "Goal agent " << current_goal_agent << " " << current_goals.size() << " goals" << endl;
    //for(int i = 0; i < current_goals.size(); i++){
      //  cout << " -->" << g_fact_names[current_goals[i]->var][current_goals[i]->val] << endl;
    //}
}

bool MadAdditiveHeuristic::check_goals(){
    for(int i = 0; i < agent_goal_propositions.size(); i++){
        for(int j = 0; j < agent_goal_propositions[i].size(); j++){
            Proposition_A *g_prop = agent_goal_propositions[i][j];
            if(g_prop->cost == -1){
                return false;
            }
        }
    }
    return true;
}

bool MadAdditiveHeuristic::all_goals_reached(){
    bool all_reachable = true;
    for(int i = 0; i < goal_propositions.size(); i++){
        if(goal_propositions[i]->goal_agent == -1){
            if(goal_propositions[i]->agent_id > -1){
                if(goal_propositions[i]->cost <= -1)
                    all_reachable = false;
            }
            else{
                int best_cost = MAX_COST_VALUE;
                int best_agent = -1;
                for(int j = 0; j < no_of_agents; j++){
                    int test_cost = goal_propositions[i]->cost_by_agent[j];
                    if(test_cost > -1 && test_cost < best_cost){
                        best_cost = test_cost;
                        best_agent = j;
                    }
                }
                if(best_agent == -1){
                    all_reachable = false;
                }
            }
        }
    }
    return all_reachable;
}

bool MadAdditiveHeuristic::distribute_goals_current_layer(int current_layer){
    //Each goal is assigned to the agent with the lowest estimated cost.
    //Returns true if all goals are reachable.     
    
    agent_goal_propositions.resize(no_of_agents);
    bool all_reachable = true;
    for(int i = 0; i < goal_propositions.size(); i++){
        if(goal_propositions[i]->goal_agent == -1){
            if(goal_propositions[i]->agent_id > -1){
                if(goal_propositions[i]->cost > -1){
                    if(goal_propositions[i]->cost > 0){
                        agent_goal_propositions[goal_propositions[i]->agent_id].push_back(goal_propositions[i]);
                        goal_propositions[i]->goal_agent = goal_propositions[i]->agent_id;
                        goal_propositions[i]->layer = current_layer;
                    }
                }
                else
                    all_reachable = false;
            }
            else{
                int best_cost = MAX_COST_VALUE;
                int best_agent = -1;
                for(int j = 0; j < no_of_agents; j++){
                    int test_cost = goal_propositions[i]->cost_by_agent[j];
                    if(test_cost > -1 && test_cost < best_cost){
                        best_cost = test_cost;
                        best_agent = j;
                    }
                }
                if(best_agent == -1){
                    all_reachable = false;
                }
                else{
                    if(best_cost > 0){
                        agent_goal_propositions[best_agent].push_back(goal_propositions[i]);
                        goal_propositions[i]->goal_agent = best_agent;
                        goal_propositions[i]->layer = current_layer;
                    }
                }
            }
        }
    }
    return all_reachable;
}

bool MadAdditiveHeuristic::distribute_goals(){
    //Each goal is assigned to the agent with the lowest estimated cost.
    //Returns true if all goals are reachable.     
    
    agent_goal_propositions.resize(no_of_agents);
    bool all_reachable = true;
    for(int i = 0; i < goal_propositions.size(); i++){
        if(goal_propositions[i]->goal_agent == -1){
            if(goal_propositions[i]->agent_id > -1){
                if(goal_propositions[i]->cost > -1){
                    if(goal_propositions[i]->cost > 0){
                        agent_goal_propositions[goal_propositions[i]->agent_id].push_back(goal_propositions[i]);
                        goal_propositions[i]->goal_agent = goal_propositions[i]->agent_id;
                        goal_propositions[i]->layer = current_layer;
                    }
                }
                else
                    all_reachable = false;
            }
            else{
                int best_cost = MAX_COST_VALUE;
                int best_agent = -1;
                for(int j = 0; j < no_of_agents; j++){
                    int test_cost = goal_propositions[i]->cost_by_agent[j];
                    if(test_cost > -1 && test_cost < best_cost){
                        best_cost = test_cost;
                        best_agent = j;
                    }
                }
                if(best_agent == -1){
                    all_reachable = false;
                }
                else{
                    if(best_cost > 0){
                        agent_goal_propositions[best_agent].push_back(goal_propositions[i]);
                        goal_propositions[i]->goal_agent = best_agent;
                        goal_propositions[i]->layer = current_layer;
                    }
                }
            }
        }
    }
    return all_reachable;
}

void MadAdditiveHeuristic::explore_next_layer(){
    //First collate the state - this is each reached proposition with the agent that best reached it
    //If an agent has a particular variable then for each possible value check if it's in the state and add if so 
    //  provided it has better cost                      
    for(int var = 0; var < g_variable_domain.size(); var++){
        for(int val = 0; val < g_variable_domain[var]; val++){
            explored_state[var][val].first = propositions[var][val].cost;
            explored_state[var][val].second = propositions[var][val].best_agent;
            
            //TODO
            //If this is an already assigned goal then we can assume cost 0
            //--IDEALLY WANT TO DO THIS FOR ALL PROPOSITIONS IN EXTRACTED PLANS
            //and build off it.
            
        }
    }   
    
    cout << "--next-layer--" << endl;
    for(int agent = 0; agent < no_of_agents; agent++){
        setup_exploration_queue_state_for_agent_based_on_previous_explore(agent);
        full_exploration_for_agent_in_subsequent_layer(agent);
        
        cout << "Agent" << agent << ": ";
        for(int j = 0; j < goal_propositions.size(); j++){
            int cost = -1;
            if(goal_propositions[j]->agent_id == -1){
                cost = goal_propositions[j]->cost_by_agent[agent];
            }
            else if(goal_propositions[j]->agent_id == agent){
                cost = goal_propositions[j]->cost;
            }
            if(cost > -1 && cost < 10)
                cout << " ";
            if(cost > -1)
                cout << cost << " ";
            else
                cout << "-- ";
            
        }
        cout << endl;
    }
    cout << "Finished re-explore" << endl;
}


void MadAdditiveHeuristic::extract_one_layer_relaxed_plan(Proposition_A *goal, int extract_agent, int layer){
    UnaryOperator_A *unary_op = goal->agent_reached_by[extract_agent];
    if(unary_op){ // We have not yet chained back to a start node of the current layer so continue with same agent.
        for (int i = 0; i < unary_op->precondition.size(); i++){
            if(unary_op->precondition[i]->cost > 0 && !unary_op->precondition[i]->marked_by_agent[extract_agent]){
                unary_op->precondition[i]->marked_by_agent[extract_agent] = true;
                if(unary_op->precondition[i]->agent_id == -1){
                    if(unary_op->precondition[i]->best_agent != extract_agent){
                        //cout << "Adding subgoal " << unary_op->precondition[i]->id << " for agent " << unary_op->precondition[i]->best_agent << endl;
                        unary_op->precondition[i]->layer = layer-1;
                        agent_subgoals[unary_op->precondition[i]->best_agent].push_back(unary_op->precondition[i]);
                        if(layer > 1){
                            extract_one_layer_relaxed_plan(unary_op->precondition[i], unary_op->precondition[i]->best_agent, layer-1);
                        }

                    }
                    else{
                        extract_one_layer_relaxed_plan(unary_op->precondition[i], extract_agent, layer);
                    }
                }
                else{
                    extract_one_layer_relaxed_plan(unary_op->precondition[i], extract_agent, layer);
                }
            }
        }
    }
    else{ //Either we are at layer 0 or this was reached by a different agent.
        unary_op = goal->reached_by;
        if(unary_op){
            for (int i = 0; i < unary_op->precondition.size(); i++){
                //cout << "Adding subgoal " << unary_op->precondition[i]->id << " for agent " << unary_op->precondition[i]->best_agent << endl;
                unary_op->precondition[i]->layer = layer -1;
                agent_subgoals[unary_op->precondition[i]->best_agent].push_back(unary_op->precondition[i]);
                if(layer > 1){
                    extract_one_layer_relaxed_plan(unary_op->precondition[i], unary_op->precondition[i]->best_agent, layer-1);
                }
            }        
        }
    }
}

void MadAdditiveHeuristic::extract_relaxed_plan(const State &state, Proposition_A *goal, int achieve_agent, int extract_agent, int layer){
    if(achieve_agent != extract_agent){
        //cout << "Adding subgoal " << goal->id << " for agent " << achieve_agent << " layer " << (layer-1) << endl;
        agent_goal_propositions[achieve_agent].push_back(goal);
        goal->goal_agent = achieve_agent;
        goal->is_goal = true;
        goal->layer = layer-1;
    }
    else if (!goal->marked_by_agent[extract_agent]) { // Only consider each subgoal once.
        goal->marked_by_agent[extract_agent] = true;
        
        UnaryOperator_A *unary_op = goal->reached_by;
        
        if (unary_op) { // We have not yet chained back to a start node.
            for (int i = 0; i < unary_op->precondition.size(); i++){
                if(unary_op->precondition[i]->cost > 0)
                    extract_relaxed_plan(state, unary_op->precondition[i], unary_op->precondition[i]->best_agent, extract_agent, layer);
            }
            
            /*
             //This part of the code is not needed in this extraction.
             //It checks for applicability and updates relaxed plan and preferred operators. 
             //However, we should re-add later to test if we can get a better goal decomposition using relaxed plans. 
             int operator_no = unary_op->operator_no;
             if (operator_no != -1) {
             // This is not an axiom.
             //relaxed_plan[operator_no] = true;
             if(unary_op->agent_id > -1){
             if (unary_op->cost == unary_op->base_cost) {
             // This test is implied by the next but cheaper,
             // so we perform it to save work.
             // If we had no 0-cost operators and axioms to worry
             // about, it would also imply applicability.
             const Operator *op = &g_operators[operator_no];
             if (op->is_applicable(state))
             set_preferred(op);
             }
             }
             else{
             for(int agent = 0; agent < no_of_agents; agent++){
             if (unary_op->agent_cost[agent] == unary_op->base_cost) {
             // This test is implied by the next but cheaper,
             // so we perform it to save work.
             // If we had no 0-cost operators and axioms to worry
             // about, it would also imply applicability.
             const Operator *op = &g_operators[operator_no];
             if (op->is_applicable(state))
             set_preferred(op);
             break;
             } 
             }
             
             }*/
            
        }
    }
    
}


static ScalarEvaluator *_parse(OptionParser &parser) {
    Heuristic::add_options_to_parser(parser);
    Options opts = parser.parse();
    if (parser.dry_run())
        return 0;
    else
        return new MadAdditiveHeuristic(opts);
}

/*
 //CODE FOR GIVING EACH GOAL TO EACH POSSIBLE AGENT.
 agent_goal_propositions.resize(no_of_agents);
 for(int i = 0; i < goal_propositions.size(); i++){
 if(goal_propositions[i]->agent_id > -1){
 agent_goal_propositions[goal_propositions[i]->agent_id].push_back(goal_propositions[i]);
 goal_propositions[i]->goal_agent = goal_propositions[i]->agent_id;
 }
 else{
 bool found_an_agent = false;
 for(int agent = 0; agent < no_of_agents; agent++){
 if(goal_propositions[i]->cost_by_agent[agent] > -1){
 agent_goal_propositions[agent].push_back(goal_propositions[i]);
 found_an_agent = true;
 }
 }
 if(!found_an_agent){
 cout << "Goal " << i << " unreachable" << endl;
 exit(0);
 }
 }
 }*/

// ***SINGLE-AGENT CODE //
void MadAdditiveHeuristic::setup_exploration_queue() {
    queue.clear();
    
    for (int var = 0; var < propositions.size(); var++) {
        for (int value = 0; value < propositions[var].size(); value++) {
            Proposition_A &prop = propositions[var][value];
            prop.cost = -1;
            prop.marked = false;
        }
    }
    
    // Deal with operators and axioms without preconditions.
    for (int i = 0; i < unary_operators.size(); i++) {
        UnaryOperator_A &op = unary_operators[i];
        op.unsatisfied_preconditions = op.precondition.size();
        op.cost = op.base_cost; // will be increased by precondition costs
        
        if (op.unsatisfied_preconditions == 0)
            enqueue_if_necessary(op.effect, op.base_cost, &op);
    }
}

void MadAdditiveHeuristic::setup_exploration_queue_state(const State &state) {
    for (int var = 0; var < propositions.size(); var++) {
        Proposition_A *init_prop = &propositions[var][state[var]];
        enqueue_if_necessary(init_prop, 0, 0);
    }
}

void MadAdditiveHeuristic::relaxed_exploration() {
    int unsolved_goals = goal_propositions.size();
    while (!queue.empty()) {
        pair<int, Proposition_A *> top_pair = queue.pop();
        int distance = top_pair.first;
        Proposition_A *prop = top_pair.second;
        int prop_cost = prop->cost;
        assert(prop_cost >= 0);
        assert(prop_cost <= distance);
        if (prop_cost < distance)
            continue;
        if (prop->is_goal && --unsolved_goals == 0)
            return;
        const vector<UnaryOperator_A *> &triggered_operators =
        prop->precondition_of;
        for (int i = 0; i < triggered_operators.size(); i++) {
            UnaryOperator_A *unary_op = triggered_operators[i];
            increase_cost(unary_op->cost, prop_cost);
            unary_op->unsatisfied_preconditions--;
            assert(unary_op->unsatisfied_preconditions >= 0);
            if (unary_op->unsatisfied_preconditions == 0)
                enqueue_if_necessary(unary_op->effect,
                                     unary_op->cost, unary_op);
        }
    }
}

int MadAdditiveHeuristic::compute_add_and_ff_single_agent(const State &state) {
    setup_exploration_queue();
    setup_exploration_queue_state(state);
    relaxed_exploration();
    
    int total_cost = 0;
    for (int i = 0; i < goal_propositions.size(); i++) {
        int prop_cost = goal_propositions[i]->cost;
        if (prop_cost == -1)
            return DEAD_END;
        increase_cost(total_cost, prop_cost);
    }
    return total_cost;
}




static Plugin<ScalarEvaluator> _plugin("mad_add", _parse);
