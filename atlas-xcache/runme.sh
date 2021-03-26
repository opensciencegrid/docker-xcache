#!/bin/sh

# find all cache mounts
# export them as variables understandable by xcache config
# make sure their ownership is right
COUNTER=0
for dir in /xcache/data_*
do
    echo "Found ${dir}."
    let COUNTER=COUNTER+1
    echo "exporting it as CACHE_${COUNTER}"
    export CACHE${COUNTER}=${dir}
    echo "making it owned by xrootd if not already."
    if [ $(stat -c "%U:%G" ${dir} ) != "xrootd:xrootd" ]; then  chown -R xrootd:xrootd ${dir}; fi
done


# the same for metadata mount
echo "adding metadata directory."
export XC_META=/xcache/meta
mkdir -p ${XC_META}/xrdcinfos
mkdir -p ${XC_META}/namespace
if [ $(stat -c "%U:%G" ${XC_META} ) != "xrootd:xrootd" ]; then  chown xrootd:xrootd ${XC_META}; fi
if [ $(stat -c "%U:%G" ${XC_META}/xrdcinfos ) != "xrootd:xrootd" ]; then  chown -R xrootd:xrootd ${XC_META}/xrdcinfos; fi
if [ $(stat -c "%U:%G" ${XC_META}/namespace ) != "xrootd:xrootd" ]; then  chown -R xrootd:xrootd ${XC_META}/namespace; fi


export X509_USER_PROXY=/etc/proxy/x509up
export X509_USER_CERT=/etc/grid-certs/usercert.pem
export X509_USER_KEY=/etc/grid-certs/userkey.pem
export XrdSecGSIPROXYVALID="96:00"
export XrdSecGSICACHECK=0
export XrdSecGSICRLCHECK=0
# export XrdSecDEBUG=3 

echo "Cleaning dark data"
python3 /usr/local/sbin/dark-data-cleaner.py

# sleep until x509 things set up.
while [ ! -f $X509_USER_PROXY ]
do
  sleep 10
  echo "waiting for x509 proxy."
done

ls -lh $X509_USER_PROXY

# if X509_CERT_DIR is provided mount it in /etc/grid-security/certificates
[ -s /etc/grid-security/certificates ] && export X509_CERT_DIR=/etc/grid-security/certificates

## if X509_VOMS_DIR is provided mount it in /etc/grid-security/vomsdir
#unset X509_VOMS_DIR
#[ ! -d "$X509_VOMS_DIR" ] && export X509_VOMS_DIR=/etc/grid-security/vomsdir


# sets memory to be used
if [ -z "$XC_RAMSIZE" ]; then
  XC_RAMSIZE=$(free | tail -2 | head -1 | awk '{printf("%d", $NF/1024/1024/2)}')
  [ $XC_RAMSIZE -lt 1 ] && XC_RAMSIZE=1
  XC_RAMSIZE=${XC_RAMSIZE}g
  echo "will use ${XC_RAMSIZE}g for memory."
fi

[ -z "$XC_SPACE_LO_MARK" ] && XC_SPACE_LO_MARK="0.85"
[ -z "$XC_SPACE_HI_MARK" ] && XC_SPACE_HI_MARK="0.95"

export LD_PRELOAD=/usr/lib64/libtcmalloc.so
export TCMALLOC_RELEASE_RATE=10

env
echo "Starting cache ..."

# k parameters control logrotate.
# su -p xrootd -c "/usr/bin/xrootd -n atlas-xcache -k fifo -k 1g -c /etc/xrootd/xcache.cfg &"
su -p xrootd -c "/usr/bin/xrootd -n atlas-xcache -k fifo -k 1g -c /etc/xrootd/xrootd-atlas-xcache.cfg &"

if  [ -z "$CRIC_PROTOCOL_ID" ]; then
  echo 'not updating CRIC protocol status.'
else
  echo "making CRIC protocol ${CRIC_PROTOCOL_ID} active..."
  /usr/local/sbin/update-cric-status.sh ${CRIC_PROTOCOL_ID} ACTIVE
fi

sleep infinity
