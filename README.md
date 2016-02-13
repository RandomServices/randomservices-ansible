# rndsvc-ansible

We are using Ansible to configure servers.
In order to use the tool please follow the [Installation instruction for Mac OSX]

[Installation instruction for Mac OSX]:http://docs.ansible.com/intro_installation.html#latest-releases-via-homebrew-mac-osx/

## Server Requirements

This is intended for Ubuntu 14.04 and higher. It has been used with as high as 15.10.

## Hosts File

The target servers should be configured in the `hosts-production` file.
When a server is added or removed, commit this file with the changes immediately.

By default when running ansible, all servers will be updated.
To limit to a specific host (or pattern) add the `-l <hostname>` option to the command line.

## Running Ansible

### Encrypted files using Vault

When we store information that must be encrypted in this project, it is stored using Ansible's Vault feature, which encrypts a YAML file. So the file must be in the `vars` folder for the role that uses it.

The vault password is something that we share in an out-of-band way. It is used as the encryption key for editing these files and for running Ansible commands.

The [Ansible documentation](http://docs.ansible.com/playbooks_vault.html#creating-encrypted-files) is pretty straightforward. However, if your editor is TextMate, you need to set `$EDITOR='mate -w'` so that the command will wait for the editor to finish.

So for example: `EDITOR='mate -w' ansible-vault edit roles/web_server/vars/ssl.yml` will prompt you for the passphrase, decrypt the file, wait for you to edit and close the file, then encrypt the new contents.

Place the passphrase in the `.vault_pass.txt` file so you can specify it in the command line.
Never commit the passphrase! If you use this filename it will be ignored by git.


#### New Servers

This process adds our users and applies package updates.
It runs as the root user because no SSH keys have been placed on the machine yet.

Once this step is complete, Ansible will no longer be able to use the root user .

For first-time setup of servers on Linode, you'll need to log in as root with the password.

    ansible-playbook initial_setup.yml -i hosts-production --ask-pass

Enter the root password for the server(s) when prompted.

You can also add `-l hostname.mlw2.net` to limit to a specific host, or `-l host-type`.

If on a host that has an SSH key applied, leave off the `--ask-pass`.

One of the changes made by this run is that password authentication will be permanently disabled.
So you can only do this once.
Subsequent runs must use your account and SSH credentials.

### Existing Servers

For subsequent runs of this (updating users, for instance), do the following:

    ansible-playbook site.yml -i hosts-production --ask-sudo-pass --vault-password-file=.vault_pass.txt

This will update all servers, *note that this may restart services* so don't do it to production servers.

To limit to a specific host (or pattern) add the `-l <hostname>` option to the command line.
You can specify a group name (from the `hosts` file), or a full hostname.

## Testing with Vagrant

In order to test any playbook using Vagrant, Download and Install it from [Vagrant Web Site]
[Vagrant Web Site]:http://www.vagrantup.com/downloads.html
and you would also need [Virtualbox] download and install it.
[Virtualbox]:https://www.virtualbox.org/wiki/Downloads

Change Vagrantfile configuration file in the line for ansible.playbook option in order to add the playbook to test, like:

    ansible.playbook = "initial_setup.yml"

Note: Just for testing purposes, you would need to change the hosts: configuration variable in the playbook to test, use "all".

Run vagrant to build the virtual machine and run the playbook for the first time with:

    vagrant up

To rerun the same playbook after the virtual machine has been built use:

    vagrant provision

You can use:

    VirtualBox

Command to stop, delete or restart the virtual machine.
