status:
			docker-compose ps

new: clean start

start:
	    docker-compose up -d

stop:
			docker-compose down

clean: stop
			sudo rm -rf elephant/* tiger/* horse/* monkey/*

shell:
			docker-compose exec --user hdfs elephant bash

rootshell:
			docker-compose exec --user root elephant bash

dbshell:
			docker-compose exec --user root mysqldb bash

logs:
			docker-compose logs -f
