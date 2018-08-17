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
	delivery local unit

lint:
	delivery local lint

syntax:
	delivery local syntax

vendor: install
	./vendor_berks_cookbooks.sh
