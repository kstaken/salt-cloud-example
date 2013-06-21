apache-libcloud:
    pip.installed

salt-cloud:
    pip.installed

{{ pillar['AWS_SSH_PRIVKEY']}}:
  file.managed:
    - user: root
    - group: root
    - mode: '0400'

/etc/salt/cloud.profiles:
  file.managed:
    - source: salt://salt-cloud/cloud.profiles
    - user: root
    - group: root
    - mode: 644
    - template: jinja

/etc/salt/cloud:
  file.managed:
    - source: salt://salt-cloud/cloud.dist
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    