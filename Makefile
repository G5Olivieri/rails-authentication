install_deps:
	docker-compose run --rm app sh -c "bundle install"

create_db:
	docker-compose run --rm app sh -c "bin/rails db:create"

migrate:
	docker-compose run --rm app sh -c "bin/rails db:migrate"

up:
	docker-compose up -d

down:
	docker-compose kill
	docker-compose rm -f
	rm -rf tmp/pids/server.pid

shell:
	docker-compose run --rm app sh

logs:
	docker-compose logs -f app
