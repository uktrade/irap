build:
	docker-compose build

up:
	docker-compose up

web = docker-compose run web
manage = python manage.py

bash:
	$(web) /bin/bash

shell:
	$(web) $(manage) shell

migrations:
	$(web) $(manage) makemigrations
	$(web) chown $(shell id -u):$(shell id -g) */migrations/*

empty-migration:
	$(web) $(manage) makemigrations --empty $(app)
	$(web) chown $(shell id -u):$(shell id -g) */migrations/*

migrate:
	$(web) $(manage) migrate

superuser:
	$(web) $(manage) createsuperuser 

requirements:
	poetry export -f requirements.txt --output requirements.txt --without-hashes

black:
	poetry run black .

isort:
	poetry run isort .

format: black isort

# Checks
check-black:
	poetry run black --check .

check-isort:
	poetry run isort --check .

check-migrations:
	$(web) $(manage) makemigrations --check --dry-run

check-fixme:
	! git --no-pager grep -i "fixme" -- :^Makefile

check-flake8:
	$(web) flake8

check: check-black check-isort check-flake8 check-migrations check-fixme
