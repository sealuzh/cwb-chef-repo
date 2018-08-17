.PHONY: install outdated test lint vendor

install:
	berks install

outdated:
	berks outdated

test:
	kitchen verify

integration_test:
	kitchen test

unit_test:
	chef exec rspec

lint:
	foodcritic .

vendor: install
	./vendor_berks_cookbooks.sh
