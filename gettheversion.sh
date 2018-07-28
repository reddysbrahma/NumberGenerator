#/bin/bash
ls -lrt target/ | grep NumberGenerator | grep -v war | awk -F "-" '{print $NF}'
