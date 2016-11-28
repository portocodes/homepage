Nowadays, we need to ensure that applications are operating 24/7, and
PostgreSQL does not support master-master replication (only through third
parties, with some limitations).

With this in mind, I will talk about migrating an application from PostgreSQL
to RethinkDB. In a technical talk, I will present the issues I encountered, as
well as a performance analysis between both databases.

Relevant links:
* https://kkovacs.eu/cassandra-vs-mongodb-vs-couchdb-vs-redis
* http://jepsen.io/
