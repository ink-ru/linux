#!/bin/bash

# TODO: Hash folder names

#if [ ! -w /etc/profile.d ]; then
#    echo "❌ Error: Insufficient rights"
#    echo "Run the script with sudo"
#    exit 1
#fi

if [[ "$PWD" == "/" ]] || [[ "$PWD" == "~" ]]; then
    echo "❌ Error: Running a script in system directory is prohibited!"
    echo "Run the script in the target directory"
    exit 1
fi

if ! command -v openssl &> /dev/null; then
    echo -e "❌ Error: openssl is not installed"
    exit 1
fi

#PASSWORD="password_string"
read -rsp "Enter the encryption password: " PASSWORD
echo # new line line after entering the password

umask 077 # Set default permissions for new files: owner only

# ======================

if [[ "$1" == "-r" ]] || [[ "$1" == "--restore" ]]; then
    find . -name '.backup_*.bak' -print0 | while IFS= read -r -d $'\0' archive; do
        dir=$(dirname "$archive")
        archive_name=$(basename "$archive")

        if (cd "$dir" && openssl enc -d -aes-256-cbc -pbkdf2 -pass pass:"$PASSWORD" -in "$archive_name" | tar -xz); then
            echo "✅ The file '$archive' has been restored."
            rm "$archive"
        else
            echo "❌ ERROR: Unable to decrypt '$archive'. The password may be incorrect."
            # exit 1
        fi
    done

    exit 0
fi

find . -type f -not -name '*.bak' -print0 | while IFS= read -r -d $'\0' file; do
    dir=$(dirname "$file")
    base=$(basename "$file")
    
    hashed_name=$(echo -n "$base" | sha256sum | head -c 16)
    
    archive=".backup_${hashed_name}.bak"

    if (cd "$dir" && tar -cz "$base" | openssl enc -aes-256-cbc -pbkdf2 -pass pass:"$PASSWORD" -out "$archive" && rm "$base"); then
        echo "✅ The '$file' has been processed."
    else
        echo "❌ ERROR: unable to processe file: '$file'"
    fi
    #chmod 600 "$archive"
done

exit 0
