.PHONY: install outdated test converge integration_test unit_test lint syntax all_tests vendor

### Installation Berkshelf
install:
	berks install

outdated:
	berks outdated

vendor: install
	./vendor_berks_cookbooks.sh

### Testing stages
all_tests: lint syntax unit_test integration_test

lint:
	cookstyle

syntax:
	foodcritic . --exclude spec -f any  -t ~FC101

unit_test:
	chef exec rspec spec/

# Shortcut for commonly used integration test
test: integration_test

integration_test: dokken_integration_test

dokken_integration_test: export KITCHEN_YAML=.kitchen.yml
dokken_integration_test: export KITCHEN_LOCAL_YAML=.kitchen.dokken.yml
dokken_integration_test:
	kitchen converge && kitchen verify

vagrant_integration_test: export KITCHEN_LOCAL_YAML=''
vagrant_integration_test:
	kitchen converge && kitchen verify

### Testing Cleanup
clean: vagrant_clean dokken_clean

dokken_clean: export KITCHEN_YAML=.kitchen.yml
dokken_clean: export KITCHEN_LOCAL_YAML=.kitchen.dokken.yml
dokken_clean:
	kitchen destroy

vagrant_clean: export KITCHEN_LOCAL_YAML=''
vagrant_clean:
	kitchen destroy
