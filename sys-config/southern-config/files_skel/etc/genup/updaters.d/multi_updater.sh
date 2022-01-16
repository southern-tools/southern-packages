#!/bin/bash
# Southern Tools
#
set -e
#
#eselect python update --python2
#eselect python update --python3
haskell-updater
eclean --deep packages
eclean --deep distfiles
rm -vfr /var/tmp/portage/*
