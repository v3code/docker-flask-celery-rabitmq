install-api:
	poetry install --without worker

install-worker:
	poetry install --without api

run-dev-api:
	poetry run api_dev