db_name = poc_fulltextsearch

mc:
	@if [ -z "$(name)" ]; then \
		echo "Please provide a migration name using 'make mc name=create_users_table'"; \
		exit 1; \
	fi
	docker run --rm \
		-v "$$(pwd)/script/migrations:/migrations" \
		migrate/migrate:v4.19.0 \
		create -ext sql -dir /migrations -seq $${name}

mu:
	docker run --rm \
		-v "$$(pwd)/script/migrations:/migrations" \
		migrate/migrate:v4.19.0 \
		-path=/migrations \
		-database "mysql://root:12345678@tcp(host.docker.internal:3306)/$(db_name)?multiStatements=true" \
		up
