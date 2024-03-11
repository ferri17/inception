#! /bin/bash

if [ ! -f ./wp-config.php ]
then
	wp core download --allow-root
	wp config create --dbname=$(DB_NAME) --dbuser=$(DB_USER) --dbpass=$(DB_PASS) --dbhost=$(DB_HOST) --dbprefix=$(DB_PREFIX) --allow-root
	wp core install  --url=$(DOMAIN_NAME) --title=$(WP_TITLE) --admin_user=$(WP_ADMIN_USER) --admin_password=$(WP_ADMIN_PASS) --admin_email=$(WP_ADMIN_EMAIL) --allow-root
fi
#wp --info

#while [ -f /etc/wordpress_start.sh ]; do
#done
