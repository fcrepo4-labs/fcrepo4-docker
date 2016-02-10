######################
# Fedora Camel Toolbox
######################

/opt/karaf/bin/client -u karaf -h localhost -a 8101 -f "/root/fedora_camel_toolbox.script"

# Solr indexing
/opt/karaf/bin/client -u karaf -h localhost -a 8101 "feature:install fcrepo-indexing-solr"

sed -i 's|solr.baseUrl=localhost:8983/solr/collection1|solr.baseUrl=localhost:8080/solr/collection1|' /opt/karaf/etc/org.fcrepo.camel.indexing.solr.cfg
sed -i 's|fcrepo.authUsername=$|fcrepo.authUsername=fedoraAdmin|' /opt/karaf/etc/org.fcrepo.camel.indexing.solr.cfg
sed -i 's|fcrepo.authPassword=$|fcrepo.authPassword=secret3|' /opt/karaf/etc/org.fcrepo.camel.indexing.solr.cfg

# Triplestore indexing
/opt/karaf/bin/client -u karaf -h localhost -a 8101 "feature:install fcrepo-indexing-triplestore"

sed -i 's|fcrepo.authUsername=$|fcrepo.authUsername=fedoraAdmin|' /opt/karaf/etc/org.fcrepo.camel.indexing.triplestore.cfg
sed -i 's|fcrepo.authPassword=$|fcrepo.authPassword=secret3|' /opt/karaf/etc/org.fcrepo.camel.indexing.triplestore.cfg

# Audit service
/opt/karaf/bin/client -u karaf -h localhost -a 8101 "feature:install fcrepo-audit-triplestore"

# Fixity service
/opt/karaf/bin/client -u karaf -h localhost -a 8101 "feature:install fcrepo-fixity"

sed -i 's|fcrepo.authUsername=$|fcrepo.authUsername=fedoraAdmin|' /opt/karaf/etc/org.fcrepo.camel.fixity.cfg
sed -i 's|fcrepo.authPassword=$|fcrepo.authPassword=secret3|' /opt/karaf/etc/org.fcrepo.camel.fixity.cfg

# Serialization service
/opt/karaf/bin/client -u karaf -h localhost -a 8101 "feature:install fcrepo-serialization"

sed -i 's|fcrepo.authUsername=$|fcrepo.authUsername=fedoraAdmin|' /opt/karaf/etc/org.fcrepo.camel.serialization.cfg
sed -i 's|fcrepo.authPassword=$|fcrepo.authPassword=secret3|' /opt/karaf/etc/org.fcrepo.camel.serialization.cfg

# Reindexing service
/opt/karaf/bin/client -u karaf -h localhost -a 8101 "feature:install fcrepo-reindexing"

sed -i 's|fcrepo.authUsername=$|fcrepo.authUsername=fedoraAdmin|' /opt/karaf/etc/org.fcrepo.camel.reindexing.cfg
sed -i 's|fcrepo.authPassword=$|fcrepo.authPassword=secret3|' /opt/karaf/etc/org.fcrepo.camel.reindexing.cfg

