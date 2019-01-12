[www]
listen = /run/php-fpm/php-fpm.sock
listen.owner = nginx
listen.group = nginx
listen.mode = 0660

user = nginx
group = nginx
request_slowlog_timeout = 0


pm = dynamic
pm.max_children = 5
pm.start_servers = 3
pm.min_spare_servers = 2
pm.max_spare_servers = 4
pm.max_requests = 200

request_terminate_timeout = 120s
rlimit_files = 131072
rlimit_core = unlimited
catch_workers_output = yes
env[HOSTNAME] = $HOSTNAME
env[TMP] = /tmp
env[TMPDIR] = /tmp
env[TEMP] = /tmp

php_admin_value[memory_limit] = ${PHP_MEMORY_LIMIT:-128m}
php_admin_value[upload_max_filesize] = ${PHP_UPLOAD_MAX_FILESIZE:-20m}
php_admin_value[post_max_size] = ${PHP_POST_MAX_SIZE:-20m}
php_admin_value[allow_url_fopen] = ${PHP_ALLOW_URL_FOPEN:-Off}

; Hardening https://www.owasp.org/index.php/PHP_Configuration_Cheat_Sheet
php_admin_value[display_errors] = Off
php_admin_value[expose_php] = Off
php_admin_value[error_reporting] = E_ALL
php_admin_value[display_startup_errors] = Off
php_admin_value[log_errors] = On
php_admin_value[error_log] = /dev/stderr
php_admin_value[ignore_repeated_errors] = Off
php_admin_value[allow_url_include] = Off
php_admin_value[disable_functions] = system, exec, shell_exec, passthru, phpinfo, show_source, popen, proc_open, fopen_with_path, dbmopen, dbase_open, putenv, move_uploaded_file, filepro, filepro_rowcount, filepro_retrieve, posix_mkfifo

