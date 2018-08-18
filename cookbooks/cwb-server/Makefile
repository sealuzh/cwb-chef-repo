### Configurable Variables
# Example: `make all_tests INSTANCE=ubuntu-1804`
INSTANCE=default-ubuntu-1604

### Default Target
all: all_tests

### Installation Berkshelf
.PHONY: install
install:
	berks install

.PHONY: outdated
outdated:
	berks outdated

.PHONY: install
vendor: install
	./vendor_berks_cookbooks.sh

### Testing stages
.PHONY: all_tests
all_tests: lint syntax unit_test integration_test

.PHONY: lint
lint:
	cookstyle

.PHONY: syntax
syntax:
	foodcritic . --exclude spec -f any  -t ~FC101

.PHONY: unit_test
unit_test:
	chef exec rspec spec/

# Shortcut for commonly used integration test
.PHONY: test
test: integration_test

.PHONY: integration_test
integration_test: dokken_integration_test

.PHONY: dokken_integration_test
dokken_integration_test: export KITCHEN_YAML=.kitchen.yml
dokken_integration_test: export KITCHEN_LOCAL_YAML=.kitchen.dokken.yml
dokken_integration_test:
	kitchen converge $(INSTANCE) && kitchen verify $(INSTANCE)

.PHONY: login
login: export KITCHEN_YAML=.kitchen.yml
login: export KITCHEN_LOCAL_YAML=.kitchen.dokken.yml
login:
	kitchen login $(INSTANCE)

.PHONY: vagrant_integration_test
vagrant_integration_test: export KITCHEN_LOCAL_YAML=''
vagrant_integration_test:
	kitchen converge $(INSTANCE) && kitchen verify $(INSTANCE)

### Testing Cleanup
.PHONY: clean
clean: vagrant_clean dokken_clean

.PHONY: dokken_clean
dokken_clean: export KITCHEN_YAML=.kitchen.yml
dokken_clean: export KITCHEN_LOCAL_YAML=.kitchen.dokken.yml
dokken_clean:
	kitchen destroy

.PHONY: vagrant_clean
vagrant_clean: export KITCHEN_LOCAL_YAML=''
vagrant_clean:
	kitchen destroy
