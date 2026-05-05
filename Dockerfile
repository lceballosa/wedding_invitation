# Stage 1: Build the Flutter web app
FROM ubuntu:22.04 AS builder

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Download and install Flutter from official release
RUN mkdir -p /flutter && \
    curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz -o flutter.tar.xz && \
    tar xf flutter.tar.xz -C / && \
    rm flutter.tar.xz && \
    /flutter/bin/flutter --version

ENV PATH="/flutter/bin:${PATH}"
ENV FLUTTER_SKIP_DOWNLOAD_DEVELOPMENT_BINARIES=true

WORKDIR /app

# Copy only pubspec files first (for better caching)
COPY pubspec.yaml pubspec.lock* ./

# Get dependencies
RUN flutter config --enable-web --no-analytics && \
    flutter pub get

# Copy the rest of the app
COPY lib ./lib
COPY assets ./assets
COPY web ./web
COPY analysis_options.yaml ./

# Build web app
RUN flutter build web --release --verbose

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Copy built app to nginx
COPY --from=builder /app/build/web /usr/share/nginx/html

# Copy nginx config for SPA routing
COPY <<EOF /etc/nginx/conf.d/default.conf
server {
    listen 80;
    location / {
        root /usr/share/nginx/html;
        try_files \$uri \$uri/ /index.html;
    }
}
EOF

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

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
