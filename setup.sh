#! /bin/bash

ENV_FILE="srcs/.env"
echo "" > srcs/.env
mkdir -p secrets

getValue() {
	local prompt=$1
	local var
	while [[ true ]]; do
		read -p "$prompt" -r var
		if [[ ! -z $var ]]; then
			break
		fi
		echo "field cannot be empty" 1>&2
	done
	echo $var
}

echo -e "The following information is required to setup your application\n"

#nginx
echo "nginx"
domain_name="$(getValue "domain name: ")"
echo "DOMAIN_NAME=$domain_name" >> $ENV_FILE

#mariadb
echo -e "\nmariadb"
database_name="$(getValue "database name: ")"
echo "MARIADB_DATABASE=$database_name" >> $ENV_FILE
user_name="$(getValue "database user name: ")"
echo "MARIADB_USER=$user_name" >> $ENV_FILE
password="$(getValue "database password: ")"
echo "$password" > secrets/db_password.txt
root_password="$(getValue "database root password: ")"
echo "$root_password" > secrets/db_root_password.txt

#wp
echo -e "\nwp"
db_prefix="$(getValue "db prefix: ")"
echo "WP_DB_PREFIX=$db_prefix" >> $ENV_FILE
admin_user="$(getValue "admin user name: ")"
echo "WP_ADMIN_USER=$admin_user" >> $ENV_FILE
password="$(getValue "admin password: ")"
echo "$password" > secrets/wp_admin_password.txt
mail="$(getValue "admin mail: ")"
echo "WP_ADMIN_EMAIL=$mail" >> $ENV_FILE
url="$(getValue "website url (e.g. https://localhost): ")"
echo "WP_WEBSITE_URL=$url" >> $ENV_FILE
title="$(getValue "website titel: ")"
echo "WP_WEBSITE_TITLE=$title" >> $ENV_FILE

