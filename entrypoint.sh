#!/bin/sh

GIT_SERVER_STORE=/git-server

# Define the path where SSH host keys will be stored
SSH_HOST_KEYS_DIR=${GIT_SERVER_STORE}/host-keys

# Ensure the SSH host keys directory exists
mkdir -p ${SSH_HOST_KEYS_DIR}

# Function to generate a host key if it doesn't exist
generate_key_if_not_exist() {
  key_path=$1
  key_bits=$2
  key_type=$3

  if [ ! -f ${key_path} ]; then
    ssh-keygen -t ${key_type} -b ${key_bits} -f ${key_path} -N ''
    echo "${key_type} key generated at ${key_path}."
  else
    echo "${key_type} key already exists at ${key_path}."
  fi
}

# Generate all necessary keys if they don't exist
generate_key_if_not_exist "${SSH_HOST_KEYS_DIR}/ssh_host_rsa_key" 4096 rsa
generate_key_if_not_exist "${SSH_HOST_KEYS_DIR}/ssh_host_ed25519_key" 256 ed25519

cd ${GIT_SERVER_STORE}
mkdir -p client-keys
mkdir -p repos
chown -R git:git ${GIT_SERVER_STORE}/repos

# Start the SSH daemon in the foreground
exec /usr/sbin/sshd -D -e
