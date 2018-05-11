run:
	docker-compose --project-directory=. -f docker/docker-compose.yml up --build -d

dev:
	docker-compose --project-directory=. -f docker/docker-compose-dev.yml up --build