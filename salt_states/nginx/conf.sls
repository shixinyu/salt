include:
  - nginx.install
{% set nginx_user = 'nginx' + ''+ 'nginx' %}


nginx_conf:
  file.managed:
    - name: /opt/server/webserver/nginx/conf/nginx.conf
    - source: salt://nginx/files/nginx.conf
    - template: jinja
    - defaults:
      nginx_user: {{ nginx_user }}
      num_cpus: {{grains['num_cpus']}}

nginx_service:
  file.managed:
    - name: /etc/init.d/nginx
    - user: root
    - mode: 755
    - source: salt://nginx/files/init.sh
  cmd.run:
    - name:
      - /sbin/chkconfig --add nginx
      - /sbin/chkconfig --level 35 nginx on
    - unless: /sbin/chkconfig --list nginx
  service.running:
    - name: nginx
    - enable: True
    - reload: True
