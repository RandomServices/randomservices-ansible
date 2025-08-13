.PHONY: install python-deps ansible-roles ansible-collections
install: python-deps ansible-roles ansible-collections

python-deps:
	uv sync

ansible-roles:
	ansible-galaxy install -r requirements.yml --roles-path .galaxy-roles

ansible-collections:
	ansible-galaxy collection install -r requirements.yml --collections-path .galaxy-collections
