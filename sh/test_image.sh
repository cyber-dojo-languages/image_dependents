#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
# don't create TMP_DIR off /tmp because on Docker Toolbox
# /tmp will not be available on the default VM
readonly TMP=$(cd ${MY_DIR} && mktemp -d XXXXXX)
readonly TMP_DIR=${MY_DIR}/${TMP}

remove_tmp_dir()
{
  rm -rf "${TMP_DIR}" > /dev/null;
}

trap remove_tmp_dir INT EXIT

assert_equals()
{
  local -r expected="${1}"
  local -r actual="${2}"
  if [ "${expected}" != "${actual}" ]; then
    echo "expected: ${expected}"
    echo "  actual: ${actual}"
    echo 'assert_equals() FAILED'
    exit 3
  fi
}

image_dependents()
{
  docker run \
    --rm \
    --volume "${PWD}:/data:ro" \
      cyberdojofoundation/image_dependents
}

cd ${TMP_DIR}
git clone https://github.com/cyber-dojo-languages/python.git
cd python
EXPECTED="python-assert python-behave python-pytest python-unittest"
ACTUAL=$(image_dependents)
assert_equals "${EXPECTED}" "${ACTUAL}"

cd ${TMP_DIR}
git clone https://github.com/cyber-dojo-languages/csharp.git
cd csharp
EXPECTED="csharp-moq csharp-nunit csharp-specflow"
ACTUAL=$(image_dependents)
assert_equals "${EXPECTED}" "${ACTUAL}"
