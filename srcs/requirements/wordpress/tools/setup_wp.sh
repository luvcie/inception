#!/bin/sh
set -e

if [ ! -f "/var/www/html/wp-load.php" ]; then
    wp core download --allow-root --path=/var/www/html
fi

if [ ! -f "/var/www/html/wp-config.php" ]; then
    wp config create \
        --allow-root \
        --path=/var/www/html \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost=mariadb \
        --skip-check
fi

wp config set WP_REDIS_HOST redis --allow-root --path=/var/www/html

i=0
while ! wp db check --allow-root --path=/var/www/html > /dev/null 2>&1; do
    i=$((i + 1))
    if [ "$i" -ge 30 ]; then
        echo "mariadb not reachable after 30 tries" >&2
        exit 1
    fi
    sleep 2
done

if ! wp core is-installed --allow-root --path=/var/www/html > /dev/null 2>&1; then

    wp core install \
        --allow-root \
        --path=/var/www/html \
        --url="https://${DOMAIN_NAME}" \
        --title="Inception" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}"

    wp user create \
        --allow-root \
        --path=/var/www/html \
        "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=author

    wp plugin install redis-cache --allow-root --path=/var/www/html --activate || true

fi

wp redis enable --allow-root --path=/var/www/html || true

chown -R nobody:nobody /var/www/html

exec php-fpm83 -F
