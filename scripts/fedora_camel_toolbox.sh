######################
# Fedora Camel Toolbox
######################

/opt/karaf/bin/client -u karaf -h localhost -a 8101 -f "/root/fedora_camel_toolbox.script"

# ActiveMQ
if [ ! -f "/opt/karaf/etc/org.fcrepo.camel.service.activemq.cfg" ]; then
   /opt/karaf/bin/client -u karaf -h localhost -a 8101 "feature:install fcrepo-service-activemq"
fi

# Solr indexing
if [ ! -f "/opt/karaf/etc/org.fcrepo.camel.indexing.solr.cfg" ]; then
   /opt/karaf/bin/client -u karaf -h localhost -a 8101 "feature:install fcrepo-indexing-solr"
fi
sed -i 's|solr.baseUrl=http://localhost:8983/solr/collection1|solr.baseUrl=http://localhost:8080/solr/collection1|' /opt/karaf/etc/org.fcrepo.camel.indexing.solr.cfg

# Triplestore indexing
if [ ! -f "/opt/karaf/etc/org.fcrepo.camel.indexing.triplestore.cfg" ]; then
   /opt/karaf/bin/client -u karaf -h localhost -a 8101 "feature:install fcrepo-indexing-triplestore"
fi

# Audit service
if [ ! -f "/opt/karaf/etc/org.fcrepo.camel.audit.cfg" ]; then
   /opt/karaf/bin/client -u karaf -h localhost -a 8101 "feature:install fcrepo-audit-triplestore"
fi

# Fixity service
if [ ! -f "/opt/karaf/etc/org.fcrepo.camel.fixity.cfg" ]; then
   /opt/karaf/bin/client -u karaf -h localhost -a 8101 "feature:install fcrepo-fixity"
fi

# Serialization service
if [ ! -f "/opt/karaf/etc/org.fcrepo.camel.serialization.cfg" ]; then
   /opt/karaf/bin/client -u karaf -h localhost -a 8101 "feature:install fcrepo-serialization"
fi

# Reindexing service
if [ ! -f "/opt/karaf/etc/org.fcrepo.camel.reindexing.cfg" ]; then
   /opt/karaf/bin/client -u karaf -h localhost -a 8101 "feature:install fcrepo-reindexing"
fi
sed -i 's|rest.host=localhost$|rest.host=0.0.0.0|' /opt/karaf/etc/org.fcrepo.camel.reindexing.cfg
