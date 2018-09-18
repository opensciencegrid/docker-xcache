# prp-stashcache
Stashcache Docker Container. It is based on the OSG stashcache instructions deployed here:

http://opensciencegrid.org/docs/data/stashcache/install-cache/

Supervisord is the main process on the container and it starts three main process:

* Stashcache
* SecureStashcache
* HTCondor for some monitoring information

If wanted to have securestashcache too then it is needed to have host certificates in the host located at
/etc/grid-security/hostcert.pem /etc/grid-security/hostkey.pem


