// Run the following from neo4j install directory
// ./bin/neo4j-shell -file /path/to/this/file/combine.cql

// IMPORTANT: assumes combine run with -e (enriched) option

// SETUP
// For all 7 statements, change the file path to one appropriate
// to your situation. It should be location where enriched.csv
// ends up which is likely the directory where combine.py is
// installed.
// For example: "file:///home/username/combine/enriched.csv"

// Create indexes
CREATE INDEX ON :IP(ip);
CREATE INDEX ON :DIRECTION(direction);
CREATE INDEX ON :AS(asnumber);
CREATE INDEX ON :Country(country);
CREATE INDEX ON :OSINT_Source(OSINTsrc);
CREATE INDEX ON :Bad_activity(bad_activity);
CREATE INDEX ON :Date_added(date);

// Create nodes
USING PERIODIC COMMIT 2000
LOAD CSV WITH HEADERS FROM "file:///path/to/combine/enriched.csv" AS csvLine
// MERGE (ip:IP { ip: csvLine.entity, direction: csvLine.direction })
MERGE (ip:IP { ip: csvLine.entity })
MERGE (direction:DIRECTION { direction: csvLine.direction })
MERGE (asname:AS{asname:csvLine.asname,asnumber:csvLine.asnumber})
MERGE (country:Country{country:csvLine.country})
MERGE (source:OSINT_Source{OSINTsrc:csvLine.source})
MERGE (notes:Bad_activity{bad_activity:csvLine.notes})
MERGE (date:Date_added{date:csvLine.date})
RETURN count(DISTINCT ip),count(DISTINCT asname),count(DISTINCT country),count(DISTINCT source),count(DISTINCT notes),count(DISTINCT date);

// CREATE IP to DIRECTION relationships
USING PERIODIC COMMIT 2000
LOAD CSV WITH HEADERS FROM "file:///path/to/combine/enriched.csv" AS csvLine
MATCH (ip:IP {ip: csvLine.entity})
MATCH (direction:DIRECTION {direction:csvLine.direction})
CREATE UNIQUE (ip)-[do:DIRECTION_OF]->(direction)
RETURN type(do),count(DISTINCT do);

// Create IP to AS relationships
USING PERIODIC COMMIT 2000
LOAD CSV WITH HEADERS FROM "file:///path/to/combine/enriched.csv" AS csvLine
MATCH (ip:IP {ip: csvLine.entity})
MATCH (as:AS {asnumber:csvLine.asnumber})
CREATE UNIQUE (ip)-[hb:HOSTED_BY]->(as)
RETURN type(hb),count(DISTINCT hb);

// Create AS to Country relationships
USING PERIODIC COMMIT 2000
LOAD CSV WITH HEADERS FROM "file:///path/to/combine/enriched.csv" AS csvLine
MATCH (asname:AS{asname:csvLine.asname,asnumber:csvLine.asnumber})
MATCH (country:Country{country:csvLine.country})
CREATE UNIQUE (asname)-[li:LOCATED_IN]->(country)
RETURN type(li),count(DISTINCT li);

// Create IP to Country relationships
USING PERIODIC COMMIT 2000
LOAD CSV WITH HEADERS FROM "file:///path/to/combine/enriched.csv" AS csvLine
MATCH (ip:IP {ip: csvLine.entity})
MATCH (country:Country{country:csvLine.country})
CREATE UNIQUE (ip)-[li:LOCATED_IN]->(country)
RETURN type(li),count(DISTINCT li);

// Create IP to OSINT source relationships
USING PERIODIC COMMIT 2000
LOAD CSV WITH HEADERS FROM "file:///path/to/combine/enriched.csv" AS csvLine
MATCH (ip:IP {ip: csvLine.entity})
MATCH (source:OSINT_Source{OSINTsrc:csvLine.source})
CREATE UNIQUE (ip)-[sf:SOURCED_FROM]->(source)
RETURN type(sf),count(DISTINCT sf);

// Create IP to notes relationships
USING PERIODIC COMMIT 2000
LOAD CSV WITH HEADERS FROM "file:///path/to/combine/enriched.csv" AS csvLine
MATCH (ip:IP {ip: csvLine.entity})
MATCH (notes:Bad_activity{bad_activity:csvLine.notes})
CREATE UNIQUE (ip)-[dt:DID_THIS]->(notes)
RETURN type(dt),count(DISTINCT dt);

// Create IP to Date relationships
USING PERIODIC COMMIT 2000
LOAD CSV WITH HEADERS FROM "file:///path/to/combine/enriched.csv" AS csvLine
MATCH (ip:IP {ip: csvLine.entity})
MATCH (date:Date_added{date:csvLine.date})
CREATE UNIQUE (ip)-[do:DOWNLOADED_ON]->(date)
RETURN type(do),count(DISTINCT do);
