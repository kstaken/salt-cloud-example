{% set ips = salt['mine.get']('mongo*', 'network.ip_addrs') %}

/tmp/test:
  file.append:
    - text:
{% for ip in ips %}
      - {{ ips[ip][0] }}
{% endfor %}