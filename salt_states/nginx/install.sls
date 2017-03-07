nginx_source:
  file.managed:
    - name: /opt/nginx-1.10.3.tar.gz
    - unless: test -e /opt/nginx-1.10.3.tar.gz
    - source: salt://nginx/files/nginx-1.10.3.tar.gz
extract_nginx:
  cmd.run:
    - cwd: /opt
    - names:
      - tar xvzf nginx-1.10.3.tar.gz
    - unless: test -d /opt/nginx-1.10.3
    - require:
      - file: nginx_source
nginx_user:
  user.present:
    - name: nginx
    - uid: 1020
    - createhome: True
    - gid_from_name: True
    - shell: /sbin/nologin
nginx_pkg:
  pkg.installed:
    - pkgs:
      - gcc
      - gcc-c++
      - autoconf
      - automake
      - zlib
      - zlib-devel
      - openssl
      - openssl-devel
      - pcre
      - pcre-devel
      - libjpeg-turbo
      - libjpeg-turbo-devel
      - libpng
      - libpng-devel
      - freetype
      - freetype-devel
      - libxml2
      - libxml2-devel
      - glibc
      - glibc-devel
      - glib2
      - glib2-devel
      - bzip2
      - bzip2-devel
      - ncurses
      - ncurses-devel
      - curl
      - libcurl-devel
      - e2fsprogs
      - e2fsprogs-devel
      - krb5-devel
      - libidn
nginx_compile:
  cmd.run:
    - cwd: /opt/nginx-1.10.3
    - names:
      - ./configure --prefix=/opt/server/webserver/nginx/ --sbin-path=/opt/server/webserver/nginx/bin/nginx --user=nginx --group=nginx --with-http_ssl_module --with-http_flv_module --with-http_gzip_static_module --with-http_stub_status_module --http-client-body-temp-path=/opt/server/webserver/nginx/temp/client --http-proxy-temp-path=/opt/server/webserver/nginx/temp/proxy --http-fastcgi-temp-path=/opt/server/webserver/nginx/temp/fastcgi --http-uwsgi-temp-path=/opt/server/webserver/nginx/temp/uwsgi --http-scgi-temp-path=/opt/server/webserver/nginx/temp/scgi --with-mail --with-mail_ssl_module --with-debug
    - require:
      - cmd: extract_nginx
      - pkg: nginx_pkg
    - unless: test -d /opt/server/webserver/nginx/bin/nginx
nginx_make:
  cmd.run:
    - cwd: /opt/nginx-1.10.3
    - names:
      - make
    - require:
      - pkg: nginx_pkg
nginx_makeinstall:
  cmd.run:
    - cwd: /opt/nginx-1.10.3
    - names:
      - make install
    - require:
      - cmd: nginx_make
nginx_postinstall:
  cmd.run:
    - cwd: /opt/nginx-1.10.3
    - names:
      - mkdir /opt/server/webserver/nginx/temp -p && chown -R nginx.nginx /opt/server/webserver/nginx/temp
    - require:
      - cmd: nginx_makeinstall
