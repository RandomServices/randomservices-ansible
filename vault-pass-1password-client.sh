#!/bin/bash

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --vault-id) VAULT_ID="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if [[ -z "${VAULT_ID}" || "${VAULT_ID}" == "default" ]]; then
  echo "This script requires the --vault-id argument, so that we know which 1password item to use, and to demonstrate that Ansible Vault knows the current key."
  exit 1
fi

ITEM_PATH="op://Random Services/rndsvc-ansible vault ${VAULT_ID}/password"
op read "$ITEM_PATH" --account daughertyfamily.1password.com
