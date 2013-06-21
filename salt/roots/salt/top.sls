base:
  'salt-master':
    - salt-cloud
  'node*':
    - nodejs
  'mongo*':
    - mongodb
  'balancer*':
    - nginx