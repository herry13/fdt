#ifndef POSTPROCESSING_H
#define POSTPROCESSING_H

#include "search_engine.h"

using namespace std;

void remove_auxiliary_actions(SearchEngine::Plan &plan, SearchEngine::PlanIndex &planIndex);
void break_concurrent_actions(SearchEngine::Plan &plan, SearchEngine::PlanIndex &planIndex);
void do_postprocessing(SearchEngine::Plan &plan, SearchEngine::PlanIndex &planIndex);

#endif
