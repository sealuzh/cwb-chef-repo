.PHONY: install outdated lint vendor

install:
	berks install

outdated:
	berks outdated

lint:
	foodcritic .

vendor:
	./vendor_berks_cookbooks.sh
