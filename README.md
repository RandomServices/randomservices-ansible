# rndsvc-ansible

We are using Ansible to configure servers.

## Prerequisites

In order to use the tool please follow the [Installation instruction for Mac OSX]

[Installation instruction for Mac OSX]:http://docs.ansible.com/intro_installation.html#latest-releases-via-homebrew-mac-osx/

### Hosts File

The target devices are listed in a hosts file such as `hosts-production`.

`hosts-production` contains the up-to-date list of known production devices.
When a device is added or removed, commit this file with the changes immediately.

You should create a `hosts-dev` for testing changes to Ansible, and the devices placed there are for your own development.

By default when running ansible, all servers in a specified "hosts" file will be updated.
To limit to a specific host, host group, or hostname pattern add the `-l <hostname>` option to the command line.

### Encrypted files using Vault

When data such as passwords or encryption keys are needed by Ansible, we need to store that information in this repo, but we still need that data to remain private.
We do this by encrypting the file(s) that contain that data using Ansible Vault.

As with other variables needed in Ansible, these are stored in yml files in the `vars/` folder of the role in which they are used.
The data, for example a password string, is stored as a variable with a name.
Then the variable can be used in the Ansible tasks.

Place the passphrase in the `.vault_pass.txt` file.
That file will be ignored by git. Never commit the passphrase to git!

The [Ansible documentation](http://docs.ansible.com/playbooks_vault.html#creating-encrypted-files) is pretty straightforward.
If you use use TextMate, you can set `EDITOR='mate -w'` so that the command will wait for the editor to finish.

So for example, to edit an existing Vault-encrypted file, wait for you to edit and close the file, then encrypt the new contents:

    EDITOR='mate -w' ansible-vault edit --vault-password-file=.vault_pass.txt roles/web_server/vars/ssl.yml

## Running Ansible

### New Servers

This process adds our users and applies package updates.
It runs as the root user because no SSH keys have been placed on the machine yet.

Once this step is complete, Ansible will no longer be able to use the root user .

For first-time setup of servers on Linode, you'll need to log in as root with the password.

    ansible-playbook initial_setup.yml -i hosts-production --vault-password-file=.vault_pass.txt --ask-pass

Enter the root password for the server(s) when prompted. If on a host that has an SSH key applied for the root user, leave off the `--ask-pass`.

You can also add `-l hostname` to limit to a specific host, or `-l host-type`.

After `initial_setup`, password authentication will be disabled, and root login over SSH will also be disabled.
So you can only do this once.
Subsequent runs must use _your_ user account and SSH key, and Ansible will need your password to `sudo` on the server.

### Existing Servers

For subsequent runs of this (updating users, for instance), do the following:

    ansible-playbook site.yml -i hosts-production --ask-sudo-pass --vault-password-file=.vault_pass.txt

This will update all servers, *note that this may restart services*.

To limit to a specific host (or pattern) add the `-l <hostname>` option to the command line.
You can specify a group name (from the `hosts` file), or a full hostname.
