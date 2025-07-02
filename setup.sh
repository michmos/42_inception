#! /bin/bash

ENV_FILE="srcs/.env"
echo "" > srcs/.env
mkdir -p secrets/certificate

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

user="$(getValue "user name: ")"
echo "WP_USER=$user" >> $ENV_FILE
password="$(getValue "user password: ")"
echo "$password" > secrets/wp_user_password.txt
mail="$(getValue "user mail: ")"
echo "WP_USER_EMAIL=$mail" >> $ENV_FILE

title="$(getValue "website titel: ")"
echo "WP_WEBSITE_TITLE=$title" >> $ENV_FILE

echo -e "\nDo you want to create a self-signed certificate? (y/n)"
if [[ $(getValue "Answer: ") == "y" ]]; then
	cert_name="$(getValue "certificate name (e.g. localhost): ")"
	country_code="$(getValue "country code (2 letter code): ")"
	state="$(getValue "state or province name: ")"
	locality="$(getValue "locality name (e.g. city): ")"
	organization="$(getValue "company name: ")"
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout secrets/certificate/key.pem \
		-out secrets/certificate/cert.pem \
		-subj "/C=$country_code/ST=$state/L=$locality/O=$organization/CN=$cert_name" 2> /dev/null
	chmod 644 secrets/certificate/key.pem secrets/certificate/cert.pem
else
	echo "No self-signed certificate will be created. Please provide your the following files yourself:\n- secrets/certificate/key.pem\n- secrets/certificate/cert.pem"
fi


