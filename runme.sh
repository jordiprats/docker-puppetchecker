#!/bin/bash

cd ${EYP_MODULEPATH}

LINTLOG=$(mktemp /tmp/lint.XXXXXXXXXXXXXXXXXXXXXXX)
VALIDATELOG=$(mktemp /tmp/validate.XXXXXXXXXXXXXXXXXXXXXXX)
METADATALINTLOG=$(mktemp /tmp/metadatalint.XXXXXXXXXXXXXXXXXXXXXXX)

rake lint > $LINTLOG 2>&1
if [ $? -ne 0 ];
then
  ERROR_STATUS="$ERROR_STATUS $(echo -e "\n=== rake lint: ERROR ===\n$(cat $LINTLOG)")"
else
  OK_STATUS="$OK_STATUS $(echo -e "\n=== rake lint: OK ===\n")""
fi

rake validate > $VALIDATELOG 2>&1
if [ $? -ne 0 ];
then
  ERROR_STATUS="$ERROR_STATUS $(echo -e "\n=== rake validate: ERROR ===\n$(cat $VALIDATELOG)")"
else
  OK_STATUS="$OK_STATUS $(echo -e "\n=== rake validate: OK ===\n")"
fi

rake metadata_lint > $METADATALINTLOG 2>&1
if [ $? -ne 0 ];
then
  ERROR_STATUS="$ERROR_STATUS $(echo -e "\n=== rake metadata_lint: ERROR ===\n$(cat $METADATALINTLOG)")"
else
  OK_STATUS="$OK_STATUS $(echo -e "\n=== rake metadata_lint: OK ===\n")"
fi

echo $OK_STATUS
echo $ERROR_STATUS

rm -f $LINTLOG $VALIDATELOG $METADATALINTLOG
