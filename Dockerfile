FROM ruby:3.2-slim AS base

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      nodejs \
      && rm -rf /var/lib/apt/lists/*

WORKDIR /site

COPY Gemfile* ./
RUN bundle install --jobs 4 --retry 3

EXPOSE 4000

FROM base AS dev
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--port", "4000", "--force_polling", "--livereload"]

FROM base AS build
CMD ["bundle", "exec", "jekyll", "build"]
