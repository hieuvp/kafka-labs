#!/usr/bin/env bash

set -eoux pipefail

cd infrastructure

rm -rf ".ansible"
mkdir ".ansible"
cd ".ansible"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Mitogen for Ansible
# https://mitogen.networkgenomics.com/ansible_detailed.html
# Expect a 1.25x-7x speedup and a CPU usage reduction of at least 2x
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

curl --location --remote-name \
  https://files.pythonhosted.org/packages/source/m/mitogen/mitogen-0.3.7.tar.gz

tar -xvzf mitogen-0.3.7.tar.gz
rm mitogen-0.3.7.tar.gz
