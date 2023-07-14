import requests
import sys
import json
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

rcfg = open("/opt/rucio/etc/rucio.cfg", "r")
lines = rcfg.readlines()
for line in lines:
    if line.startswith('rucio_host'):
        rucio_host = line[line.index('https'):]
    # if line.startswith('auth_host'):
        # auth_host = line[line.index('https'):]

tokenfile = open("/opt/rucio/etc/token", "r")
token = tokenfile.readline()
headers = {'X-Rucio-Auth-Token': token}

data = sys.argv[1:]
payload = {
    'site': data[0],
    'instance': data[1],
    'address': data[2],
    'size': data[3]
}
print('payload:', payload)

s = requests.session()

# result = s.get(f'{rucio_host}/accounts/xcache', headers=headers, verify=False)
# print(result.text)

result = s.post(f'{rucio_host}/heartbeats', headers=headers, verify=False, json={
    'executable': 'xcache',
    'hostname': payload['instance'],
    'pid': 0,
    'payload': json.dumps(payload),
    'older_than': 181  # ignore heartbeats older than 3 minutes.
})
print('post result:', result.text)

result = s.get(f'{rucio_host}/heartbeats', headers=headers, verify=False)
res = result.json()
# print(res)
for i in res:
    if i['readable'] == 'xcache':
        print(i)
