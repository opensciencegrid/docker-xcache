import requests
import sys

rcfg = open("/opt/rucio/etc/rucio.cfg", "r")
lines = rcfg.readlines()
for line in lines:
    if line.startswith('rucio_host'):
        rucio_host = line[line.index('https'):]
    if line.startswith('auth_host'):
        auth_host = line[line.index('https'):]

tokenfile = open("/opt/rucio/etc/token", "r")
token = tokenfile.readline()
headers = {'X-Rucio-Auth-Token': token}

address = rucio_host+'/accounts/ivukotic'

data = sys.argv[1:]
print(data)

s = requests.session()
result = s.get(address, headers=headers, verify=False)
print(result.text)
