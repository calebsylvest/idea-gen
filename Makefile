default: install start

install:
	@bundle install

clean:
	@echo 'clean task not implemented'

build:
	@bundle exec middleman build

start:
	@bundle exec middleman server

deploy:
	@bundle mgd

.PHONY: install clean build start test console
