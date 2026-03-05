#!/bin/bash

# AC loads

octave ./compare.m
octave ./compare_MTBF_at_varying_lambdaU.m
octave ./compare_MTBF_at_varying_of_m.m
octave ./compare_MTBF_at_varying_of_r.m
octave ./compare_MTBF_muU2_at_varying_lambdaD.m
octave ./compare_MTBF_at_varying_muU.m
