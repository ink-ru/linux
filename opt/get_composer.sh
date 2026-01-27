#!/bin/sh

# https://getcomposer.org/doc/faqs/how-to-install-composer-programmatically.md

EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi

# --quiet
php composer-setup.php --install-dir=/usr/local/bin --filename=composer

rm composer-setup.php

if [ $? -eq 0 ]; then
    echo 'export PATH="$PATH:$HOME/.composer/vendor/bin" > /etc/profile.d/path.sh
    source /etc/profile.d/path.sh
    composer diagnose
else
    exit 1
    echo "Download failed!"
fi

exit 0
