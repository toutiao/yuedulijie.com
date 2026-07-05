.PHONY: build build-fast serve test deploy clean fetch fetch-best

build:
	docker compose run --rm build

serve:
	docker compose up jekyll

test: build

deploy:
	@[ -n "$(msg)" ] || (echo "Usage: make deploy msg='commit message'" && exit 1)
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

build-fast:
	APT_MIRROR=mirrors.aliyun.com \
	GEM_MIRROR=https://gems.ruby-china.com \
	docker compose run --rm build

fetch:
	@[ -n "$(url)" ] || (echo "Usage: make fetch url='<hn_url>'" && exit 1)
	docker compose run --rm build ruby scripts/hn-fetch.rb --url "$(url)" --fetch-articles-simple

fetch-best:
	docker compose run --rm build ruby scripts/hn-fetch.rb --best --fetch-articles-simple --jobs 5
