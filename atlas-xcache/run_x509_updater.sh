#!/bin/sh

CERTPATH=/etc/grid-certs

export X509_USER_PROXY=/etc/proxy/x509up


while true; do 
  date

  for i in 1; do  
    echo "Fetching crls"
    /usr/sbin/fetch-crl -q -r 360 -p 20 -T 10
    RESULT=$?
    if [ $RESULT -eq 0 ]; then
      echo "Fetched crls."
      break 
    else
      echo "Warning: An issue encountered when fetching crls."
      sleep 5
    fi
  done

  date

  echo 'updating proxy'
    
  while true; do 
    voms-proxy-init -valid 96:0 -key $CERTPATH/userkey.pem -cert $CERTPATH/usercert.pem --voms=atlas
    RESULT=$?
    if [ $RESULT -eq 0 ]; then
      echo "Proxy renewed."
      break
    else
      echo "Could not renew proxy."
      sleep 5
    fi
  done

  echo "Chowning proxy"
  
  while true; do 
    chown xrootd /etc/proxy/x509up 
    RESULT=$?
    if [ $RESULT -eq 0 ]; then
      echo "Chowned proxy."
      break
    else
      echo "Could not chown proxy."
      sleep 5
    fi
  done

  sleep 86000
  
done