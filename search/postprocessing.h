#ifndef POSTPROCESSING_H
#define POSTPROCESSING_H

#include "search_engine.h"

using namespace std;

void remove_auxiliary_actions(SearchEngine::Plan &plan);
void break_concurrent_actions(SearchEngine::Plan &plan);
void do_postprocessing(SearchEngine::Plan &plan);

#endif
