# combine-to-neo4j
Shell script and cypher statements to load cyber threat intelligence gathered by combine.py into neo4j

combine.cql contains cypher statements that merges the data gathered into enriched.csv by combine.py. The file path to enriched.csv must be set on each statement in the file (7 statements). Use the neo4j cypher shell to load and run this file.

runcombine.sh is a shell script which calls combine.py and then runs the neo4j shell to parse combine.cql. File paths must be configured in the script prior to running the first time. This script makes it easy to add this process to a cron job.

The end result is a graph database of the threat intel. All data is merged so there are no duplicates.

To install combine.py: [Follow directions here](https://github.com/mlsecproject/combine#installation)

To install neo4j: [Follow directions here](http://neo4j.com/developer/get-started/)

This has been run on Ubuntu 14.04. It has not been tested on other operating systems. The cypher statements should transfer over easily with formatting changes to the file path.

Example graphs:

![Example1](/screenshots/example_graph1.PNG)
