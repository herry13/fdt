#ifndef CONCURRENT_GENERATOR_H
#define CONCURRENT_GENERATOR_H

#include <vector>
#include "variable.h"
#include "operator.h"
#include "state.h"
using namespace std;

class Axiom;

void generate_concurrent_operators(vector<Operator> &operators,
                                   vector<Axiom> &axioms);

#endif
