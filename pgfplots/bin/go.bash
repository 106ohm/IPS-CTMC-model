#!/bin/bash

function main () {

    # the absolute project path where is bin, 2 directories above the script:
    # 5       4       3    2    1   0
    # maindir/Fig_src/tikz/dist/bin/go.bash
    #BASEDIR=$(scriptancestorpath 5)
    BASEDIR=$(scriptancestorpath 2)
    
    # name of the basedir
    BASENAME=$(basename "${BASEDIR}")

    # my dir
    DIR="${BASEDIR}"

    # bin
    BIN="${DIR}/bin"

    # curr dir
    CURRDIR=$PWD

    # latex
    cd ${DIR}

pdflatex 01-ips-mtbf-varying-load.tex
pdflatex 02-ips-availability-varying-load.tex
pdflatex 03-ips-mtbf-varying-utility-availability.tex
pdflatex 04-ips-mtbf-varying-m.tex
pdflatex 05-IMTBF-varying-r-50-600.tex
pdflatex 06-IMTBF-varying-r-100-250.tex
pdflatex 07-ips-mtbf-varying-lambdaU-min-max-muU.tex
pdflatex 07bis-ips-mtbf-varying-lambdaU-min-max-muU.tex
pdflatex 08-ips-mtbf-varying-load-alsoAC.tex
pdflatex 09-ips-mtbf-varying-m.tex
pdflatex 15-IMTBF-varying-r-50-600-alsoAC.tex
pdflatex 16-IMTBF-varying-r-100-250-alsoAC.tex

    cd "$CURRDIR"
}



# get the i-th ancestor path of the script that calls this function (the currently running script)
# i=0: for the path of the script,
# i=1: for the directory where is the script,
# i=2: for the directory including the directory corresponding to i=1,
# etc...
# $1: level of the ancestor path (from the end of the path)
scriptancestorpath () {
    [[ $1 -lt 0 ]] && { echo "Ops! Input less than 0: $1"; exit 1; }
    local THEPATH="$(cd "$(dirname "$0")"; pwd)/$(basename "$0")"
    i=1
    while [[  $i -le ${1} && "${THEPATH}" != "/" ]]; do
        THEPATH="$(cd "$(dirname "$THEPATH")"; pwd)"
        let i=i+1 
    done
    #    echo "depth: $i"
    echo "${THEPATH}"
}

# check if the $1/$2 exists
# $1: path of directory
# $2: path of directory or file
checkmergedpaths() {
    if [[ ! -e "${1}/${2}" ]]; then
        echo "Ops! Element not found: ${1}/${2}"
        exit 1
    fi
}

main "$@"
