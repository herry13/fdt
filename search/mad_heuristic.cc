#include "mad_heuristic.h"

#include "globals.h"
#include "operator.h"
#include "option_parser.h"
#include "plugin.h"
#include "state.h"

#include <cassert>
#include <vector>
using namespace std;

#include <ext/hash_map>
using namespace __gnu_cxx;


// construction and destruction
MadHeuristic::MadHeuristic(const Options &opts)
: MadAdditiveHeuristic(opts) {
}

MadHeuristic::~MadHeuristic() {
}

// initialization
void MadHeuristic::initialize() {
    cout << "Initializing MC2 heuristic..." << endl;
    MadAdditiveHeuristic::initialize();
    relaxed_plan.resize(g_operators.size(), false);
    no_of_layers = -1;
    layer_solved = false;
    h_plus = 100000;
    times_redistributed = 0;
    switch_to_single_agent = false;
    goal_decomposition(*g_initial_state);
}

void MadHeuristic::mark_preferred_operators_and_relaxed_plan(
                                                                    const State &state, Proposition_A *goal) {
    if (!goal->marked) { // Only consider each subgoal once.
        goal->marked = true;
        UnaryOperator_A *unary_op = goal->reached_by;
        if (unary_op) { // We have not yet chained back to a start node.
            for (int i = 0; i < unary_op->precondition.size(); i++) 
                mark_preferred_operators_and_relaxed_plan(
                                                          state, unary_op->precondition[i]);
            int operator_no = unary_op->operator_no;
            if (operator_no != -1) {
                // This is not an axiom.
                relaxed_plan[operator_no] = true;
                
                //if (unary_op->cost == unary_op->base_cost) {
                // This test is implied by the next but cheaper,
                // so we perform it to save work.
                // If we had no 0-cost operators and axioms to worry
                // about, it would also imply applicability.
                const Operator *op = &g_operators[operator_no];
                if (op->is_applicable(state))
                    set_preferred(op);
                // }
            }
        }
    }
}

void MadHeuristic::mark_preferred_operators_and_relaxed_plan_by_agent(
                                                                              const State &state, Proposition_A *goal, int agent) {
    if (!goal->marked_by_agent[agent]) { // Only consider each subgoal once.
        goal->marked_by_agent[agent] = true;
        
        UnaryOperator_A *unary_op = goal->agent_reached_by[agent];
        
        if (unary_op) { // We have not yet chained back to a start node.
            for (int i = 0; i < unary_op->precondition.size(); i++)
                mark_preferred_operators_and_relaxed_plan_by_agent(
                                                                   state, unary_op->precondition[i], agent);
            int operator_no = unary_op->operator_no;
            if (operator_no != -1) {
                // This is not an axiom.
                relaxed_plan[operator_no] = true;
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
                    
                }
            }
        }
    }
}


void MadHeuristic::mark_preferred_operators_and_relaxed_plan_by_agent_single_marked(
                                                                                            const State &state, Proposition_A *goal, int agent) {
    if (!goal->marked) { // Only consider each subgoal once.
        goal->marked = true;
        
        UnaryOperator_A *unary_op = goal->agent_reached_by[agent];
        if (unary_op) { // We have not yet chained back to a start node.
            for (int i = 0; i < unary_op->precondition.size(); i++)
                mark_preferred_operators_and_relaxed_plan_by_agent(
                                                                   state, unary_op->precondition[i], agent);
            int operator_no = unary_op->operator_no;
            if (operator_no != -1) {
                // This is not an axiom.
                relaxed_plan[operator_no] = true;
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
                    
                }
            }
        }
    }
}

void MadHeuristic::mark_preferred_operators_and_relaxed_plan_by_agent_second_layer(
                                                                                           const State &state, Proposition_A *goal, int agent) {
    if (!goal->marked_by_agent[agent]) { // Only consider each subgoal once.
        goal->marked_by_agent[agent] = true;
        
        //MAybe this hsould be the best reached by??
        UnaryOperator_A *unary_op = goal->agent_reached_by[agent];
        
        if (unary_op) { // We have not yet chained back to a start node.
            for (int i = 0; i < unary_op->precondition.size(); i++){
                if(unary_op->precondition[i]->best_agent == agent){
                    mark_preferred_operators_and_relaxed_plan_by_agent_second_layer(
                                                                                    state, unary_op->precondition[i], agent);
                }
                else if(unary_op->precondition[i]->best_agent == -1){
                    //cout << "This precondition " << unary_op->precondition[i]->id << " has no best agent or cost ie. was not reached" << endl;
                    //cout << "Maybe it's in the initial state for this?" << endl;
                    //perform_reachability_analysis(state);
                    //exit(0);
                }
                else{
                    mark_preferred_operators_and_relaxed_plan_by_agent(state, unary_op->precondition[i], unary_op->precondition[i]->best_agent);
                }
            }
            int operator_no = unary_op->operator_no;
            if (operator_no != -1) {
                // This is not an axiom.
                relaxed_plan[operator_no] = true;
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
                    
                }
            }
        }
    }
}

int MadHeuristic::compute_heuristic(const State &state) {
    if(switch_to_single_agent){
        int h_add = compute_add_and_ff_single_agent(state);
        if (h_add == DEAD_END)
            return h_add;
        
        // Collecting the relaxed plan also sets the preferred operators.
        for (int i = 0; i < goal_propositions.size(); i++)
            mark_preferred_operators_and_relaxed_plan(state, goal_propositions[i]);
        
        int h_ff = 0;
        for (int op_no = 0; op_no < relaxed_plan.size(); op_no++) {
            if (relaxed_plan[op_no]) {
                relaxed_plan[op_no] = false; // Clean up for next computation.
                h_ff += get_adjusted_cost(g_operators[op_no]);
            }
        }
        return h_ff;   
    }
    else{
    int h_add = compute_add_and_ff(state);
    //cout << h_add << endl;
    if(h_add == DEAD_END){
        //goal_decomposition(state);
        return h_add;
    }
    if(h_add == 0){
        goal_decomposition(state);
        //get_next_goal_set();
        /*
        times_redistributed++;
        if(times_redistributed > (no_of_layers+1) * no_of_agents){
            switch_to_single_agent = true;
            int h_add = compute_add_and_ff_single_agent(state);
            if (h_add == DEAD_END)
                return h_add;
            
            // Collecting the relaxed plan also sets the preferred operators.
            for (int i = 0; i < goal_propositions.size(); i++)
                mark_preferred_operators_and_relaxed_plan(state, goal_propositions[i]);
            
            int h_ff = 0;
            for (int op_no = 0; op_no < relaxed_plan.size(); op_no++) {
                if (relaxed_plan[op_no]) {
                    relaxed_plan[op_no] = false; // Clean up for next computation.
                    h_ff += get_adjusted_cost(g_operators[op_no]);
                }
            }
            return h_ff;
        }*/
        if(current_goals.size() == 0){
            if( times_redistributed <= -1){
                times_redistributed++;
                cout << "Finished all goals - resorting goals from current position!" << endl;
                goal_decomposition(state);
            }
            else{
                cout << "Switching to single agent algorithm" << endl;
                switch_to_single_agent = true;
            }            
        }
        
        h_plus = h_plus - 100;
        if(h_plus < 0){
            cout << "too many subgoals" << endl;
            exit(0);
        }
        h_add = compute_add_and_ff(state);
    }
    
    for(int i = 0; i < current_goals.size(); i++){
        mark_preferred_operators_and_relaxed_plan_by_agent(state, current_goals[i], current_goal_agent);
    }

    int h_ff = 0;
    for (int op_no = 0; op_no < relaxed_plan.size(); op_no++) {
        if (relaxed_plan[op_no]) {
            relaxed_plan[op_no] = false; // Clean up for next computation.
            h_ff += get_adjusted_cost(g_operators[op_no]) + 1;
        }
    }

    return h_ff + h_plus;
    }
}

static ScalarEvaluator *_parse(OptionParser &parser) {
    Heuristic::add_options_to_parser(parser);
    Options opts = parser.parse();
    if (parser.dry_run())
        return 0;
    else
        return new MadHeuristic(opts);
}

static Plugin<ScalarEvaluator> _plugin("mad", _parse);
