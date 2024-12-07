docker-compose down
docker-compose build
docker-compose up -d

docker-compose exec web /bin/bash
tail -f /var/log/apache2/error.log


