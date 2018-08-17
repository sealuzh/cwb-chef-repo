.PHONY: install outdated test converge integration_test unit_test lint syntax all_tests vendor

install:
	berks install

outdated:
	berks outdated

test: integration_test

converge:
	kitchen converge

integration_test:
	kitchen verify

dokken_test: KITCHEN_LOCAL_YAML=.kitchen.dokken.yml
dokken_test:
	kitchen verify

unit_test:
	chef exec rspec spec/

lint:
	chef exec cookstyle

syntax:
	chef exec foodcritic . --exclude spec -f any # -t \"~FC064\" -t \"~FC065\"

all_tests: lint syntax unit_test integration_test

vendor: install
	./vendor_berks_cookbooks.sh
