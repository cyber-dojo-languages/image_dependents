#!/bin/bash
set -e

readonly TMP_DIR=$(mktemp -d)

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
    echo 'FAILED'
    echo "expected: ${expected}"
    echo "  actual: ${actual}"
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
git clone https://github.com/cyber-dojo-languages/python-pytest.git
cd python-pytest
EXPECTED="csharp-moq csharp-nunit csharp-specflow"
ACTUAL=$(image_dependents)
assert_equals "${EXPECTED}" "${ACTUAL}"
