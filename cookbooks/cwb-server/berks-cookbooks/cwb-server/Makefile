.PHONY: install outdated test lint vendor

install:
	berks install

outdated:
	berks outdated

test:
	kitchen verify

lint:
	foodcritic .

vendor:
	./vendor_berks_cookbooks.sh
