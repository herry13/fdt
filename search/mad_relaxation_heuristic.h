#ifndef MAD_RELAXATION_HEURISTIC_H
#define MAD_RELAXATION_HEURISTIC_H

#include "heuristic.h"

#include <vector>
#include <deque>


class Operator;
class State;

class Proposition_A;
class UnaryOperator_A;

struct UnaryOperator_A {
    int operator_no; // -1 for axioms; index into g_operators otherwise
    int agent_id; //-1 for public, -2 for joint
    std::vector<Proposition_A *> precondition;
    Proposition_A *effect;
    int base_cost;
    
    int unsatisfied_preconditions;
    int cost; // Used for h^max cost or h^add cost;
    std::vector<int > agent_cost;
    
    // includes operator cost (base_cost)
    UnaryOperator_A(const std::vector<Proposition_A *> &pre, Proposition_A *eff,
                    int operator_no_, int base)
    : operator_no(operator_no_), precondition(pre), effect(eff),
    base_cost(base) {}
};


struct Proposition_A {
    //FOR DEBUG
    int var;
    int val;
    
    bool is_goal;
    int goal_agent;
    int id;
    int agent_id;
    int best_agent;
    int layer;
    std::vector<UnaryOperator_A *> precondition_of; //This is how the operators are linked.
    
    
    int cost; // Used for h^max cost or h^add cost
    std::vector< int> cost_by_agent; //For public propositions.
    UnaryOperator_A *reached_by;
    std::vector<UnaryOperator_A *> agent_reached_by;
    
    bool marked; // used when computing preferred operators for h^add and h^FF
    std::vector<bool> marked_by_agent;
    //std::vector< bool> marked_by_agent; //used for public propositions otherwise not needed.
    
    Proposition_A(int id_, int agent, int no_of_agents, int var_, int val_) {
        //For DEBUG
        var = var_;
        val = val_;
        
        id = id_;
        agent_id = agent; //-1 if public
        best_agent = agent;
        is_goal = false;
        cost = -1;
        layer = -1;
        if(agent == -1){
            for(int i = 0; i < no_of_agents; i++){
                cost_by_agent.push_back(-1);
            }
        }
        reached_by = 0;
        marked = false;
        goal_agent = -1;
        for(int i = 0; i < no_of_agents; i++){
            marked_by_agent.push_back(false);
        }
        
        agent_reached_by.resize(no_of_agents);
    }
};

class MadRelaxationHeuristic : public Heuristic {
    void build_unary_operators(const Operator &op, int operator_no);
    void simplify();
    void split_into_agents();
    void strongconnect(int v); //For finding cycles in the causal graph.
    void extend_agent_vars(int agent, int var_to_expand);
    void extend_agent_vars_two_way(int agent, int var_to_expand);
    void check_operator_for_jointness(std::vector<Operator *> ops);
protected:
    //agents
    int no_of_agents;
    std::vector<std::vector<Proposition_A *> > agent_propositions;
    std::vector<Proposition_A *> public_propositions;
    std::vector<std::vector<UnaryOperator_A *> > agent_operators;
    std::vector<std::vector<UnaryOperator_A *> > agent_joint_operators;
    std::vector<UnaryOperator_A *> public_operators;
    std::vector<std::vector<int> > agent_vars; 
    std::vector<int> public_vars;
    std::vector<std::vector<Proposition_A *> > agent_goal_propositions;
    std::vector<std::vector<Proposition_A *> > agent_current_goals;
    std::vector<std::vector<Proposition_A *> > agent_future_goal_propositions;
    
    //Probably not needed
    std::vector<int> associated_agent_by_var; //-1 if public var - agent number otherwise.
    
    
    //for graph search
    int graph_level;
    int index;
    std::vector<int> vertices_index;
    std::vector<int> vertices_lowlink;
    std::deque<int> S;
    std::vector<std::vector<int > > connected_sets;
    std::vector<bool> in_a_cycle;
    std::vector<std::vector<bool> > in_same_cycle;  
    
    //single agent structure    
    std::vector<UnaryOperator_A> unary_operators;
    std::vector<std::vector<Proposition_A> > propositions;
    std::vector<Proposition_A *> goal_propositions;
    
    virtual void initialize();
    virtual int compute_heuristic(const State &state) = 0;
public:
    MadRelaxationHeuristic(const Options &options);
    virtual ~MadRelaxationHeuristic();
};

#endif
