.PHONY: install test

install:
	bundle install

test:
	ruby test_data.rb
