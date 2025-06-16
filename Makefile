.PHONY: all certs up down restart logs

all: certs up

certs:
	./cert-gen.sh

up:
	docker-compose up -d

down:
	docker-compose down

restart:
	docker-compose down && docker-compose up -d

logs:
	docker-compose logs -f modsec
