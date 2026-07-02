FROM node:20-slim

ARG http_proxy
ARG https_proxy
ARG no_proxy

RUN apt-get update -qq && apt-get install -y -qq \
    libglib2.0-0 libnss3 libnspr4 libdbus-1-3 \
    libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 \
    libxdamage1 libxkbcommon0 libxcomposite1 libxrandr2 \
    libgbm1 libpango-1.0-0 libcairo2 libasound2 \
    libatspi2.0-0 libwayland-client0 libxfixes3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN --mount=type=cache,target=/root/.npm \
    npm install playwright express && \
    npx playwright install chromium && \
    rm -rf /tmp/*

COPY server.js .

EXPOSE 3000
CMD ["node", "server.js"]
