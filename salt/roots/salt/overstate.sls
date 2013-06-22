mongodb:
  match: mongo*

mongodb-replica:
  match: mongo*
  require:
    - mongodb
  sls:
    - mongodb-replica.sls