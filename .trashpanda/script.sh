#!/usr/bin/env bash
# script: make file now. generate project files

script_cwd="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
make -C ${script_cwd}/../mfn ${1}
