#!/bin/bash

# where are the files .jl
SRCDIR="./"

# Set <dir> as the project environment
# when starting Julia as specified in the files
# Project.toml and Manifest.toml in <dir>
# option: --project=<dir>
PRJDIR="./"

# destination of the generated figures    
DESTDIR="./"
    
# run the script
julia --project="./" "${SRCDIR}/cost_IPS_archs.jl" "${DESTDIR}"
