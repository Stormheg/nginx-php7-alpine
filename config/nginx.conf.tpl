user nginx;

# Set number of worker processes automatically based on number of CPU cores.
worker_processes ${NGINX_WORKER_PROCESSES:-auto};

# Enables the use of JIT for regular expressions to speed-up their processing.
pcre_jit on;

# Configures default error logger.
error_log /dev/stderr warn;

# Includes files with directives to load dynamic modules.
include /etc/nginx/modules/*.conf;


events {
	# The maximum number of simultaneous connections that can be opened by
	# a worker process.
	worker_connections ${NGINX_WORKER_CONNECTIONS:-1024};
}

http {
	# Includes mapping of file name extensions to MIME types of responses
	# and defines the default type.
	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	# Name servers used to resolve names of upstream servers into addresses.
	# It's also needed when using tcpsocket and udpsocket in Lua modules.
	#resolver 208.67.222.222 208.67.220.220;

	# Don't tell nginx version to clients.
	server_tokens off;

	# Specifies the maximum accepted body size of a client request, as
	# indicated by the request header Content-Length. If the stated content
	# length is greater than this size, then the client receives the HTTP
	# error code 413. Set to 0 to disable.
	client_max_body_size ${NGINX_CLIENT_MAX_BODY_SIZE:-20m};

	# Timeout for keep-alive connections. Server will close connections after
	# this time.
	keepalive_timeout  ${NGINX_KEEPALIVE_TIMEOUT:-65};

	# Sendfile copies data between one FD and other from within the kernel,
	# which is more efficient than read() + write().
	sendfile on;

	# Don't buffer data-sends (disable Nagle algorithm).
	# Good for sending frequent small bursts of data in real time.
	tcp_nodelay ${NGINX_TCP_NODELAY:-on};

	# Causes nginx to attempt to send its HTTP response head in one packet,
	# instead of using partial frames.
	tcp_nopush  ${NGINX_TCP_NOPUSH:-off};

	
	# Enable gzipping of responses.
	gzip ${NGINX_GZIP:-on};

	# Set the Vary HTTP header as defined in the RFC 2616.
	gzip_vary on;

	# Enable checking the existence of precompressed files.
	gzip_static ${NGINX_GZIP_STATIC:-off};


	# Specifies the main log format.
	log_format main '$remote_addr - $remote_user [$time_local] "$request" '
			'$status $body_bytes_sent "$http_referer" '
			'"$http_user_agent" "$http_x_forwarded_for"';

	# Sets the path, format, and configuration for a buffered log write.
	access_log /dev/stdout main;


	server {
		listen 8080 default_server;
		listen [::]:8080 default_server;
		server_name _;

		root /app/public;
		index index.php;

		location ~ \.php$ {
			fastcgi_pass unix:/run/php-fpm/php-fpm.sock;
			fastcgi_index index.php;
			include fastcgi_params;
			include fastcgi.conf;
			fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
			fastcgi_param SCRIPT_NAME $fastcgi_script_name;
		}
		location ~ /\. {
			access_log off;
			log_not_found off;
			deny all;
		}

		location /_healthcheck/ {
			access_log off;
			default_type text/html;
			return 200 "healthy\n";
		}
	}
}
