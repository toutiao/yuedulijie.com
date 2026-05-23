.PHONY: build serve test deploy clean

build:
	docker compose run --rm build

serve:
	docker compose up jekyll

test: build

deploy:
	docker compose run --rm build && \
	git add -A && \
	git commit -m "$(msg)" && \
	git push origin master

clean:
	docker compose down -v
	docker image prune -f

shell:
	docker compose run --rm build bash

logs:
	docker compose logs -f
