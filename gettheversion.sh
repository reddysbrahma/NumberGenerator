#/bin/bash
ls -lrt target/ | grep num-gen | grep -v war | awk -F "-" '{print $NF}'
