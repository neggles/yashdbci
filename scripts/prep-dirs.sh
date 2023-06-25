#!/usr/bin/env bash
set -euo pipefail

# Create data dirs for docker-compose to use.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "Creating data dirs for docker-compose..."
pushd "${SCRIPT_DIR}/../data" > /dev/null

echo " - data/yag/cert (certificate cache)"
mkdir -p yag/cert
echo " - data/yag/soundboard (soundboard files)"
mkdir -p yag/soundboard

echo " - data/redis/data (Redis)"
mkdir -p redis/data

echo " - data/pgdata (PostgreSQL)"
mkdir -p pgdata
echo " - data/pgadmin (pgAdmin 4)"
mkdir -p pgadmin
popd > /dev/null

echo "Done!"
