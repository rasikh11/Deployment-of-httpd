FROM httpd:2.4

# Copy your SSL certificates into the image
COPY rasikh.cloud.crt /usr/local/apache2/conf/server.crt
COPY rasikh.cloud.key /usr/local/apache2/conf/server.key

# Enable SSL module and configure Apache for SSL
RUN sed -i 's/#LoadModule ssl_module/LoadModule ssl_module/' /usr/local/apache2/conf/httpd.conf && \
    sed -i 's/#Include conf\/extra\/httpd-ssl.conf/Include conf\/extra\/httpd-ssl.conf/' /usr/local/apache2/conf/httpd.conf

# Copy custom ssl.conf to configure the HTTPS virtual host
COPY ssl.conf /usr/local/apache2/conf/extra/httpd-ssl.conf

# Expose port 443 for HTTPS traffic
EXPOSE 443

