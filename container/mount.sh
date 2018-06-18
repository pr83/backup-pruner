test_env_var_set() {
    envvar="$1"
    additional_message="$2"
    if [ -z "${!envvar}" ]; then
        echo "Configuration error: Environment variable $envvar not set. $additional_message"
        exit 1
    fi
}

if [ "$STORAGE_TYPE" == "S3" ]; then

    additional_message="It is mandatory for storage type 'S3'."

    test_env_var_set S3_ACCESS_KEY "$additional_message"
    test_env_var_set S3_SECRET_KEY "$additional_message"
    test_env_var_set S3_BUCKET "$additional_message"

    echo ${S3_ACCESS_KEY}:${S3_SECRET_KEY} > ~/.passwd-s3fs
    chmod 600 ~/.passwd-s3fs

    mkdir ~/s3-drive
    s3fs ${S3_BUCKET} ~/s3-drive

    export DIRECTORY='/root/s3-drive'

elif [ "$STORAGE_TYPE" == "filesystem" ]; then

    test_env_var_set DIRECTORY "It is mandatory for storage type 'filesystem'."

elif [ "$STORAGE_TYPE" == "SFTP" ]; then

    additional_message="It is mandatory for storage type 'SFTP'."
    test_env_var_set SFTP_HOSTNAME "$additional_message"
    test_env_var_set SFTP_DIRECTORY "$additional_message"
    test_env_var_set SFTP_USER "$additional_message"

    mkdir ~/sftp-drive

    if [ -z "${SFTP_PASSWORD}" ] && [ -z "${SFTP_PRIVATE_KEY}" ]; then
        echo "Configuration error: At least one of these variables must be set for storage type SFTP: " \
            "SFTP_PASSWORD, SFTP_PRIVATE_KEY"
        exit 1
    fi

    if [ -n "${SFTP_PASSWORD}" ] && [ -n "${SFTP_PRIVATE_KEY}" ]; then
        echo "Configuration error: At most one of these variables can be set: " \
            "SFTP_PASSWORD, SFTP_PRIVATE_KEY"
        exit 1
    fi

    if [ -n "${SFTP_PASSWORD}" ]; then
        echo "$SFTP_PASSWORD" | \
            sshfs -o password_stdin -o StrictHostKeyChecking=no -o allow_root \
                "${SFTP_USER}@${SFTP_HOSTNAME}:${SFTP_DIRECTORY}" \
                ~/sftp-drive
    fi

    if [ -n "${SFTP_PRIVATE_KEY}" ]; then

        export private_key_copy_file=$(mktemp)
        chmod 700 "${private_key_copy_file}"
        cat "${SFTP_PRIVATE_KEY}" > "${private_key_copy_file}"

        if [ -n "${SFTP_KEY_PASSPHRASE}" ]; then
            chmod u+x /tmp/mount_sftp_key_with_passphrase.exp
            /tmp/mount_sftp_key_with_passphrase.exp
        else
            sshfs -o IdentityFile="${private_key_copy_file}" -o StrictHostKeyChecking=no \
                "${SFTP_USER}@${SFTP_HOSTNAME}:${SFTP_DIRECTORY}" \
                 ~/sftp-drive
        fi

    fi

    export DIRECTORY='/root/sftp-drive'

fi

cd /tmp/pruner
ruby main.rb