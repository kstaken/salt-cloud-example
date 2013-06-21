apache-libcloud:
    pip.installed

salt-cloud:
    pip.installed
        
/etc/salt/cloud:
  file.managed:
    - source: salt://salt-cloud/cloud.dist
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
        custom_var: "override"
    - defaults:
        custom_var: "default value"
        other_var: 123