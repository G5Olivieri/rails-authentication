install_deps:
	docker-compose run --rm app sh -c "bundle install"

up:
	docker-compose up -d

down:
	docker-compose kill
	docker-compose rm -f

shell:
	docker-compose run --rm app sh

logs:
	docker-compose logs -f app
