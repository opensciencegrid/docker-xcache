# prp-stashcache
Stashcache Docker Container. It is based on the OSG stashcache instructions deployed here:

http://opensciencegrid.org/docs/data/stashcache/install-cache/

Supervisord is the main process on the container and it starts three main process:

* Stashcache
* (Optional) SecureStashcache
* HTCondor for some monitoring information

(Optional) For Secure Stashcache host certificates are required. The container expects them to find them on the underlying host in the following locations:

/etc/grid-security/hostcert.pem /etc/grid-security/hostkey.pem




