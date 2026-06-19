FROM ruby:3.2-slim AS base

ARG APT_MIRROR=
ARG GEM_MIRROR=

# Trust mounted site directory (volume mount at runtime)
RUN git config --global --add safe.directory /site

RUN if [ -n "$APT_MIRROR" ]; then \
      sed -i "s|deb.debian.org|$APT_MIRROR|g" /etc/apt/sources.list.d/debian.sources 2>/dev/null || \
      sed -i "s|deb.debian.org|$APT_MIRROR|g" /etc/apt/sources.list; \
    fi && \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      nodejs \
      && rm -rf /var/lib/apt/lists/*

WORKDIR /site

COPY Gemfile* ./
RUN if [ -n "$GEM_MIRROR" ]; then \
      bundle config mirror.https://rubygems.org $GEM_MIRROR; \
    fi && \
    bundle install --jobs 4 --retry 3

EXPOSE 4000

FROM base AS dev
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--port", "4000", "--force_polling", "--livereload"]

FROM base AS build
CMD ["bundle", "exec", "jekyll", "build"]
