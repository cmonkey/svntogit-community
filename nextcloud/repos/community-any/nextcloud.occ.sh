#!/usr/bin/env bash

readonly default_config="/etc/php/php.ini"
readonly default_php_command="/usr/bin/php"
readonly default_user="nextcloud"

config=""
php_command=""
user=""

check_sudo() {
  if ! command -v sudo > /dev/null; then
    printf "The sudo command is not available.\n"
    exit 1
  fi
}

check_sudo

# allow overriding the php.ini
if [[ -n "${NEXTCLOUD_PHP_CONFIG}" ]] && [[ -f "${NEXTCLOUD_PHP_CONFIG}" ]]; then
  config="${NEXTCLOUD_PHP_CONFIG}"
else
  config="${default_config}"
fi

# allow overriding the php executable
if [[ -n "${NEXTCLOUD_PHP}" ]] && command -v "${NEXTCLOUD_PHP}" > /dev/null; then
  php_command="${NEXTCLOUD_PHP}"
else
  php_command="${default_php_command}"
fi

# allow overriding the user to run as
if [[ -n "${NEXTCLOUD_USER}" ]] && id "${NEXTCLOUD_USER}" > /dev/null 2>&1; then
  user="${NEXTCLOUD_USER}"
else
  user="${default_user}"
fi

sudo --preserve-env=NEXTCLOUD_CONFIG_DIR -u "$user" "$php_command" -c "${config}" /usr/share/webapps/nextcloud/occ "$@"
