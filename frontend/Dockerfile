FROM nginx:stable-alpine

LABEL maintainer="Kunal <your-email@example.com>"

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Remove default HTML
RUN rm -rf /usr/share/nginx/html/*

# Copy nginx config
COPY nginx.conf /etc/nginx/conf.d/

# Copy your app files
COPY . /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
