events {
  worker_connections  1024;
}

daemon off;
error_log /var/log/nginx/error.log debug;

http {
   access_log /var/log/nginx/access.log;

   server {
        listen SERVER_PORT;

        charset utf-8;

        location /_health {
            access_log off;
            return 200 "healthy\n";
        }

        location / {
            proxy_pass http://FLOWER_ADDRESS:5555;
            proxy_set_header Host $host;
            proxy_redirect off;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
        }
    }

}
