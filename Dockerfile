# Stage 1: Build the Flutter web app
FROM ubuntu:22.04 AS builder

RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:${PATH}"

WORKDIR /app

COPY pubspec.* ./
COPY lib ./lib
COPY assets ./assets
COPY web ./web

RUN flutter config --enable-web && \
    flutter pub get && \
    flutter build web --release

# Stage 2: Serve with nginx
FROM nginx:alpine

COPY --from=builder /app/build/web /usr/share/nginx/html

# Configure nginx to handle SPA routing
RUN echo 'server { \
    listen 80; \
    location / { \
        root /usr/share/nginx/html; \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
