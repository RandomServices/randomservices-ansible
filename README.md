# rndsvc-ansible

We are using Ansible to configure servers.

## Prerequisites

1. Install [uv](https://docs.astral.sh/uv/getting-started/installation/) for Python dependency management

1. Install [direnv](https://direnv.net) for automatic environment activation

1. Allow direnv to activate the environment: `direnv allow`

1. Install 1Password and the [1Password CLI](https://developer.1password.com/docs/cli/get-started/)

1. Install dependencies: `make install`

### Inventory File

The target devices are listed in a hosts file such as `inventory`.

`inventory` contains the up-to-date list of known production devices.
When a server is added/removed/replaced in the production infrastructure, commit this file with the changes immediately.

You should create a `inventory-dev` for testing changes to Ansible, and the devices placed there are for your own development.

By default when running ansible, all servers in a specified inventory file will be updated.
To limit to a specific host, host group, or hostname pattern add the `-l <hostname>` option to the command line.

### Encrypted values using Vault

When data such as passwords or encryption keys are needed by Ansible, we store that information in this repo, but we still need that data to remain private.
We do this by encrypting those sensitive values, using Ansible Vault.

Ansible is configured (in `ansible.cfg`) to call the `vault-pass-1password-client.sh` script,
which uses the 1Password CLI.
So you must have 1Password installed locally and authenticated with the correct 1Password account.

Originally whole files were encrypted, but we want to encrypt individual YML values instead.
So going forward, the first time that a value in a fully-encrypted file changes, decrypt the whole
file and encrypt the specific values that should be kept private.

## Running Ansible

### New Servers

This process adds our users and applies package updates.
It runs as the root user because no SSH keys have been placed on the machine yet.

Once this step is complete, Ansible will no longer be able to use the root user .

For first-time setup of servers on Linode, you'll need to log in as root with the password.

    ansible-playbook play/initial_setup.yml -i hosts-production

Enter the root password for the server(s) when prompted. If on a host does not have your SSH key applied for the root user, add `--ask-pass`.

You can also add `-l hostname` to limit to a specific host, or `-l host-type`.

After `initial_setup`, password authentication will be disabled, and root login over SSH will also be disabled.
So you can only do this once.
Subsequent runs must use _your_ user account and SSH key, and Ansible will need your password to `sudo` on the server.

### Existing Servers

For subsequent runs of this (updating users, for instance), do the following:

    ansible-playbook play/site.yml --ask-become-pass

This will update all servers, *note that this may restart services*.

To limit to a specific host (or pattern) add the `-l <hostname>` option to the command line.
You can specify a group name (from the `hosts` file), or a full hostname.

## Project notes

- When using nodenv, the project needs to do the following before a deployment:
   `if [[ "$(node -v 2>&1)" =~ "is not installed" ]]; then nodenv install; corepack install; corepack enable; fi`

## TODO

- Other processes. e.g. Sidekiq
- Use sockets for Ruby web apps instead of local ports
- nvm or nodejs installation. Currently it must be done manually:
    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
    sudo apt-get install -y nodejs
    npm install -g yarn
