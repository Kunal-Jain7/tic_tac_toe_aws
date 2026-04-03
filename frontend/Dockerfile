# Use a lightweight NGINX image to serve static files
FROM nginx:stable-alpine

# Set maintainer label (optional)
LABEL maintainer="Kunal <your-email@example.com>"

# Clean default nginx configuration and copy our custom config
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/

# Copy all frontend assets into nginx html directory
COPY . /usr/share/nginx/html

# Expose default HTTP port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
