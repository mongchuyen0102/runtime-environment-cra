# 1. For build React app
FROM node:lts AS build

WORKDIR /app

COPY package*.json .

RUN npm ci

COPY . .

RUN npm run build

# 2. For Nginx setup
FROM nginx:alpine

# Copy config nginx
COPY --from=build /app/.nginx/nginx.conf /etc/nginx/conf.d/default.conf
# Copy env-config.sh
COPY --from=build /app/env.sh /app/env.sh

WORKDIR /usr/share/nginx/html

# Remove default nginx static assets

RUN rm -rf ./*

# Copy static assets from builder stage
COPY --from=build /app/build .

# Containers run nginx with global directives and daemon off
RUN chmod +x /app/env.sh
ENTRYPOINT ["/app/env.sh"]

CMD ["nginx", "-g", "daemon off;"]