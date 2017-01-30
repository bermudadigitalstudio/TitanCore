#!/usr/bin/env bash
# test TitanCore inside a disposable Docker container

set -eo pipefail

docker build -t titancore .
docker run --rm --name titancore_test titancore
