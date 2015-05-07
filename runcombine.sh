#!/bin/bash

# FYI run as cron job 15 in after every hour like this:
# 15 * * * * /path/to/runcombine.sh

# ***********CONFIGURE THIS SECTION*******************
# Path to directory where combine is installed
COMBINEDIR='/path/to/combine'

# Path to directory where ne04j is installed
NEO4JDIR='/path/to/neo4j/neo4j-community-2.2.0'

# Path to directory where combine.cql is located
SCRIPTDIR='/path/to/here'
# ****************************************************

echo "-------------------------------------" | tee -a output.log
echo "START TIME: `date +%y/%m/%d_%H:%M:%S`" | tee -a output.log
echo "-------------------------------------" | tee -a output.log

cd $COMBINEDIR

echo "Starting combine.py" | tee -a output.log
./venv/bin/python combine.py -t CSV -d -e
echo "combine.py finished. Took $SECONDS seconds." | tee -a output.log

cd $SCRIPTDIR

echo "Starting Neo4j import." | tee -a output.log
$NEO4JDIR/bin/neo4j-shell -file combine.cql | tee -a output.log
echo "Finished Neo4j import." | tee -a output.log

echo "-------------------------------------" | tee -a output.log
echo "END TIME: `date +%y/%m/%d_%H:%M:%S`" | tee -a output.log
echo "-------------------------------------" | tee -a output.log
echo "TOTAL ELAPSED TIME: $SECONDS seconds" | tee -a output.log
echo "-------------------------------------" | tee -a output.log
echo "-------------------------------------" | tee -a output.log

