#!/bin/bash

sudo chown -R www-data:www-data /var/www
sudo chown -R root:www-data /etc/nginx

sudo chmod -R g+w /var/www
sudo chmod -R g+w /etc/nginx/sites-available
sudo chmod -R g+w /etc/nginx/sites-enabled
#sudo chmod -R 777 /var/www/white-ink.space/automad

exit 0
