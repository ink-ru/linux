#!/bin/bash

# Запрет на выполнение от имени root (проверка по UID)
if [ "$EUID" -eq 0 ]; then
    echo "Ошибка: Этот скрипт не должен выполняться от пользователя root"
    exit 1
fi

# Получаем имя текущего пользователя
CURRENT_USER=$(whoami)

echo "Текущий пользователь: $CURRENT_USER"

# Проверяем, существует ли группа
if ! getent group "www-data" &>/dev/null; then
    echo "Ошибка: Группа www-data не существует"
    exit 1
fi

# Добавляем пользователя в группу (если еще не добавлен)
if ! groups $CURRENT_USER | grep -q "www-data"; then
    echo "Добавляем пользователя $CURRENT_USER в группу www-data..."
    sudo usermod -aG www-data $CURRENT_USER
    
    # Проверяем успешность выполнения
    if [ $? -eq 0 ]; then
        echo "✓ Пользователь успешно добавлен в группу www-data"
    else
        echo "✗ Ошибка при добавлении пользователя в группу"
        exit 1
    fi
else
    echo "Пользователь $CURRENT_USER уже находится в группе www-data"
    exit 0
fi

echo "Применяем изменения в текущей сессии..."

# Применяем изменения с помощью newgrp
exec newgrp www-data

id -nG

exit 0