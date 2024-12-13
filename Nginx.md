## ssl证书生成
~~~
openssl genrsa -out rsa_private.key 2048
openssl req -new -x509 -days 36500 -key rsa_private.key -out cert.crt
~~~
## nginx安装
~~~
yum -y install gcc zlib zlib-devel pcre-devel openssl openssl-devel
wget https://nginx.org/download/nginx-1.22.1.tar.gz
tar -zxvf nginx-1.22.1.tar.gz
cd nginx-1.22.1
./configure --with-http_stub_status_module --with-http_ssl_module
make
make install
./usr/local/nginx/sbin/nginx
~~~
## nginx非443端口ssl配置
~~~
server {
        listen 1443 ssl; 
        server_name 192.168.200.139; 
        ssl_certificate /home/lk/cert.crt; 
        ssl_certificate_key /home/lk/rsa_private.key; 

        ssl_session_timeout 5m;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2; 
        ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE; 
        ssl_prefer_server_ciphers on;

	error_page 497  https://$host:$server_port$request_uri;
	location / {
		proxy_pass http://localhost:8080/;
		proxy_set_header    Host               $host:$server_port;
		proxy_set_header    Remote_Addr        $remote_addr;
		proxy_set_header    X-Real-IP          $remote_addr;
		proxy_set_header    X-Forwarded-For    $proxy_add_x_forwarded_for;
		proxy_set_header    X-Forwarded-Proto  $scheme;
		proxy_set_header    X-Nginx-Proxy      true;
	}
}
~~~
## nginx代理FnOS配置文件
~~~

#user  nobody;
worker_processes  1;

error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    server {
        listen       80;
        server_name  localhost;

        return 301 https://$server_name$request_uri;
    }

    # HTTPS server
    server {
        listen 443 ssl;
        server_name fnos;
        ssl_certificate cert.crt;
        ssl_certificate_key rsa_private.key;

        ssl_session_timeout 5m;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2; 
        ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE; 
        ssl_prefer_server_ciphers on;

        error_page 497  https://$host:$server_port$request_uri;

        location /websocket {
            proxy_pass http://fnos.local:5666/websocket;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Nginx-Proxy true;
        }

        location / {
            proxy_pass http://fnos.local:5666/;
            proxy_set_header    Host               $host:$server_port;
            proxy_set_header    Remote_Addr        $remote_addr;
            proxy_set_header    X-Real-IP          $remote_addr;
            proxy_set_header    X-Forwarded-For    $proxy_add_x_forwarded_for;
            proxy_set_header    X-Forwarded-Proto  $scheme;
            proxy_set_header    X-Nginx-Proxy      true;
        }
    }

}
~~~
