pushcerts:
	-kubectl delete secret certs -n osg # delete if already exists, ignore errors
	kubectl create secret generic certs -n osg --from-file=hostcerts/xrdkey.pem --from-file=hostcerts/xrdcert.pem

pushconfig:
	-kubectl delete configmap stashcache -n osg  # delete if already exists, ignore errors
	kubectl create configmap stashcache  -n osg --from-file=xrootd-stashcache-cache-server.cfg=stashcache-server.cfg --from-file=Authfile-noauth=Authfile-noauth --from-file=stashcache-robots.txt=stashcache-robots.txt --from-file=lcmaps.cfg=lcmaps.cfg
