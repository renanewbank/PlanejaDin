up:
	docker compose up -d

down:
	docker compose down

clean:
	docker compose down -v

logs:
	docker compose logs -f db

psql:
	docker exec -it planejadin-db psql -U postgres

# Recriar do zero (atenção: apaga o volume!)
reset: clean up logs
