# combine-to-neo4j
Shell script and cypher statements to load cyber threat intelligence gathered by combine.py into neo4j

```combine.cql``` contains cypher statements that merges the data gathered by combine.py. Note that you must run combine.py with the -e parameter to get enriched data. **The file path to enriched.csv must be set on each statement in the file (7 statements)**.

```runcombine.sh``` is a shell script which calls combine.py and then runs the neo4j shell to parse combine.cql. **File paths must be configured in the script prior to running the first time.** This script makes it easy to add this process to a cron job. Only new nodes and relationships are added each time since all additions are called with MERGE or CREATE UNIQUE.

The end result is a graph database of the threat intel. All data is merged so there are no duplicates.

To install combine.py: [Follow directions here](https://github.com/mlsecproject/combine#installation)

To install neo4j: [Follow directions here](http://neo4j.com/developer/get-started/)

I am running this on Ubuntu 14.04 as an hourly cron job. It has not been tested on other operating systems. The cypher statements should transfer over easily with formatting changes to the file path.

#### Performance
How long it takes to run combine and import the data into Neo4j is highly variable on the machine and the configuration of Neo4j. My experience: in a VirtualBox VM with 4GB of RAM and 2 CPUs, running on a host with an i7 CPU and 8GB of RAM with 2.5GB Java heap size set in neo4j-wrapper.conf, it takes less 6-7 minutes to run both combine.py with the enriched paramter and then import the data. Roughly, just over 3 minutes for combine.py and just over 3 minutes for import. Note that the script logs times in output.log along with the output of the Neo4j shell script.

#### Example graphs

![Example1](/screenshots/example_graph1.PNG)

![Example2](/screenshots/example_graph2.PNG)

![Example3](/screenshots/example_graph3.PNG)
