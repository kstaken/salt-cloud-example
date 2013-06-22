mongodb-10gen:
    pkgrepo:
    - managed
    - name: deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen
    - keyserver: keyserver.ubuntu.com
    - keyid: 7F0CEB10
    - require_in:
        - pkg: mongodb-10gen
    - require:
        - file: /etc/mongodb.conf
    pkg:
        - installed

mongodb:
  service:
    - running
    - watch:
        - file: /etc/mongodb.conf

/etc/mongodb.conf:
  file.managed:
    - source: salt://mongodb/mongodb.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
