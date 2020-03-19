#!/bin/sh

# Decrypt the file
# --batch to prevent interactive command --yes to assume "yes" for questions
gpg --quiet --batch --yes --decrypt --passphrase="$LARGE_SECRET_PASSPHRASE" \
--output ${FILE_NAME} ${FILE_NAME}.gpg
gpg --quiet --batch --yes --decrypt --passphrase="joly170707" \
--output gcp/ssh_key gcp/ssh_key.gpg