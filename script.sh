#!/usr/bin/env bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file w>
done
script_cwd="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

if [[ ! -f "${PWD}/Makefile" ]]; then
  echo "No Makefile found. Copying template"
  cp $(dirname ${SOURCE})/Makefile.tpl ${PWD}/Makefile
else
  echo "Makefile already exists in current directory. skipping"
fi
