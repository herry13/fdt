#ifndef MAD_ADDITIVE_HEURISTIC_H
#define MAD_ADDITIVE_HEURISTIC_H

#include "priority_queue.h"
#include "mad_relaxation_heuristic.h"
#include <cassert>

class MadAdditiveHeuristic : public MadRelaxationHeuristic {
    /* Costs larger than MAX_COST_VALUE are clamped to max_value. The
     precise value (100M) is a bit of a hack, since other parts of
     the code don't reliably check against overflow as of this
     writing. With a value of 100M, we want to ensure that even
     weighted A* with a weight of 10 will have f values comfortably
     below the signed 32-bit int upper bound.
     */
    static const int MAX_COST_VALUE = 100000000;
    
    AdaptiveQueue<Proposition_A *> queue;
    std::vector<std::vector<std::pair<int, int> > > explored_state;  //cost or -1 then agent
    
    
    bool did_write_overflow_warning;
    
    //Single agent
    void setup_exploration_queue();
    void setup_exploration_queue_state(const State &state);
    void relaxed_exploration();
    
    //Multiagent
    void reset_public();
    void reset_agent(int agent);
    void setup_exploration_queue_state_for_agent(const State &state, int agent);
    void setup_exploration_queue_state_for_agent_based_on_previous_explore(int agent);
    void relaxed_exploration_for_agent(int agent);
    void full_exploration_for_agent(int agent);
    bool check_goals();
    bool distribute_goals_current_layer(int current_layer);
    void output_goal_costs(int agent);
    bool all_goals_reached();
    void explore_next_layer();
    void full_exploration_for_agent_in_subsequent_layer(int agent);
    bool distribute_goals();
    void extract_one_layer_relaxed_plan(Proposition_A *goal, int extract_agent, int layer);
    void extract_relaxed_plan(const State &state, Proposition_A *goal, int achieve_agent, int extract_agent, int layer);
    void mark_preferred_operators(const State &state, Proposition_A *goal);
    
    void enqueue_if_necessary(Proposition_A *prop, int cost, UnaryOperator_A *op) {
        assert(cost >= 0);
        if (prop->cost == -1 || prop->cost > cost) {
            prop->cost = cost;
            prop->reached_by = op;
            queue.push(cost, prop);
        }
        assert(prop->cost != -1 && prop->cost <= cost);
    }
    
    void enqueue_if_necessary_for_agent(Proposition_A *prop, int cost, UnaryOperator_A *op, int agent) {
        assert(cost >= 0);
        if(prop->agent_id == agent){
            if (prop->cost == -1 || prop->cost > cost) {
                prop->cost = cost;
                prop->agent_reached_by[agent] = op;
                prop->reached_by = op;
                queue.push(cost, prop);
            }
            assert(prop->cost != -1 && prop->cost <= cost);
        }
        else if(prop->agent_id > -1){//from another agent - should only be added in initial state.
            prop->cost = cost;
            queue.push(cost, prop);
        }
        else {//prop->agent_id must be -1 therefore public proposition
            if (prop->cost_by_agent[agent] == -1 || prop->cost_by_agent[agent] > cost){
                prop->cost_by_agent[agent] = cost;
                if(prop->cost == -1 || prop->cost > cost){
                    prop->cost = cost;
                    if(cost > 0){
                        prop->best_agent = agent;
                        prop->reached_by = op;
                    }
                }
                prop->agent_reached_by[agent] = op;
                queue.push(cost, prop);
            }
        }
    }
        
    void increase_cost(int &cost, int amount) {
        assert(cost >= 0);
        assert(amount >= 0);
        cost += amount;
        if (cost > MAX_COST_VALUE) {
            write_overflow_warning();
            cost = MAX_COST_VALUE;
        }
    }
    
    void write_overflow_warning();
protected:
    bool switch_to_single_agent;
    int times_redistributed;
    int no_of_layers; //first layer is layer 0
    int current_layer;
    bool layer_solved;
    std::vector<std::vector<std::set<int > > > relaxed_plans;
    std::vector<std::vector<Proposition_A *> > agent_subgoals;
    int current_goal_agent;
    std::vector<Proposition_A *> current_goals;

    
    virtual void initialize();
    virtual int compute_heuristic(const State &state);
    void get_next_goal_set();
    bool goal_decomposition(const State &state);
    
    // Common part of h^add and h^ff computation.
    int compute_add_and_ff(const State &state);
    int compute_add_and_ff_single_agent(const State &state);

    
public:
    MadAdditiveHeuristic(const Options &options);
    ~MadAdditiveHeuristic();
};

#endif
