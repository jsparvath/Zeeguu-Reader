#!/usr/bin/env bash
# Run this script to host on your machine.

if [ -z ${ZEEGUU_UMR_VENV_ROOT+x} ]
then
    ZEEGUU_UMR_VENV_ROOT="$HOME/.virtualenvs/zeeguu_umr"
    echo "ZEEGUU_UMR_VENV_ROOT not set, using default ($ZEEGUU_UMR_VENV_ROOT)." 
fi

source ${ZEEGUU_UMR_VENV_ROOT}/bin/activate
python src/zeeguu_umr.py