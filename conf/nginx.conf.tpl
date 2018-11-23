events {
  worker_connections  1024;
}

daemon off;
error_log /var/log/nginx/error.log debug;

http {
    access_log /var/log/nginx/access.log;

    server {
        rewrite_log on;

        listen 8000;
        server_name $HOST;

        location ~ /FLOWER_URL_PREFIX$ {
            rewrite ^/FLOWER_URL_PREFIX$ / break;
            proxy_pass http://127.0.0.1:5555;
            proxy_set_header Host $host;
        }

        location ~ /FLOWER_URL_PREFIX/(static|tasks|broker|monitor|dashboard|login) {
            rewrite ^/FLOWER_URL_PREFIX(.*)$ $1 break;
            proxy_pass http://127.0.0.1:5555;
            proxy_set_header Host $host;
        }


        location ~ /FLOWER_URL_PREFIX {
            rewrite ^/FLOWER_URL_PREFIX(.*)$ $1 break;
            proxy_pass http://127.0.0.1:5555;
            proxy_set_header Host $host;
        }

        location "" {
            rewrite ^/(.*)$ /FLOWER_URL_PREFIX/$1 break;
            proxy_pass http://127.0.0.1:5555/;
            proxy_set_header Host $host;
        }

    }

}
