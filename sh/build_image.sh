#!/bin/bash

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

docker build \
  --tag cyberdojofoundation/image_dependents \
  "${MY_DIR}/.."
