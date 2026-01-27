#!/bin/bash

if [ ! -w /etc/profile.d ]; then
    echo "❌ Ошибка: Недостаточно прав для записи в /etc/profile.d"
    echo "Запустите скрипт с sudo"
    exit 1
fi

ORIGINAL_USER=${SUDO_USER:-$(whoami)}

if [ ! -f /etc/profile.d/laravel ]; then

    #USER_HOME=$(eval echo "~$ORIGINAL_USER")

    sudo -u $ORIGINAL_USER composer global require laravel/installer

    echo -e "export PATH='~/.config/composer/vendor/bin:$PATH'\n" > /etc/profile.d/laravel
    sudo -u $ORIGINAL_USER source /etc/profile.d/laravel

    echo -e "\033[0;32m✅ Laravel успешно установлен и добавлен в PATH\033[0m"
else
    #export PATH="/home/$ORIGINAL_USER/.config/composer/vendor/bin:$PATH"
    echo -e "\033[0;36m✅ Laravel уже установлен\033[0m"
fi

bash -c "/home/$ORIGINAL_USER/.config/composer/vendor/bin/laravel -V"

exit 0