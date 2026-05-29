#!/bin/bash

temp_file_path=$(mktemp)

echo $temp_file_path
echo

XPECTED_CHECKSUM="$(php -r 'copy("https://getcomposer.org/download/latest-stable/composer.phar.sha256", "php://stdout");')"
php -r "copy('https://getcomposer.org/download/latest-stable/composer.phar', 'composer.phar');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha256', 'composer.phar');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer.phar
    exit 1
fi


#wget -P "${$temp_file_path}" https://getcomposer.org/composer.phar
#wget https://getcomposer.org/composer.phar -O $temp_file_path &&

#sudo mv $temp_file_path /usr/local/bin

#if [ $? -eq 0 ]; then
#  mv "${temp_dir}" /path/to/final/destination/file.zip
#else
#  echo "Download failed. Temporary file removed."
#fi

echo -e "alias composer='/usr/local/bin/composer.phar'\n" > /etc/profile.d/composer
source /etc/profile.d/composer

composer -V

exit 0
