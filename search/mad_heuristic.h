#ifndef MAD_HEURISTIC_H
#define MAD_HEURISTIC_H

#include "mad_additive_heuristic.h"

#include <vector>

class MadHeuristic : public MadAdditiveHeuristic {
    // Relaxed plans are represented as a set of operators implemented
    // as a bit vector.
    typedef std::vector<bool> RelaxedPlan;
    RelaxedPlan relaxed_plan;
    void mark_preferred_operators_and_relaxed_plan(
                                                   const State &state, Proposition_A *goal);
    void mark_preferred_operators_and_relaxed_plan_by_agent(
                                                            const State &state, Proposition_A *goal, int agent);
    void mark_preferred_operators_and_relaxed_plan_by_agent_second_layer(
                                                                         const State &state, Proposition_A *goal, int agent);
    void mark_preferred_operators_and_relaxed_plan_by_agent_single_marked(
                                                                          const State &state, Proposition_A *goal, int agent);
protected:
    int h_plus;
    
    virtual void initialize();
    virtual int compute_heuristic(const State &state);
public:
    MadHeuristic(const Options &options);
    ~MadHeuristic();
};

#endif


