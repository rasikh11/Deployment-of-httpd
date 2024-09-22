## Deployment-of-httpd
# Deployment of Apache Server with SSL on Docker Container.

Follow the steps: 
		**Make sure you have sudo access**

1. **Make sure docker installed on your system.**

2. **Generate a self-signed certificate:**

```
openssl req -x509 -nodes -days 90 -newkey rsa:2048 -keyout rasikh.cloud.key -out rasikh.cloud.crt

```
- Follow  the prompt steps.
- I will provide my SSL private key and certificate key, It's security risk, but anyway I do that for testing purpose. 

I have done in same present working directory, where's my `dockerfile`, `ssl.conf`

3. **create a ssl.conf:**  Create a vim `ssl.conf` Apache for configure Virtual Host for HTTPS,

```bash
Listen 443
<VirtualHost *:443>
    ServerName rasikh.cloud

    SSLEngine on
    SSLCertificateFile "/usr/local/apache2/conf/server.crt"
    SSLCertificateKeyFile "/usr/local/apache2/conf/server.key"

    DocumentRoot "/usr/local/apache2/htdocs"
    ErrorLog "/usr/local/apache2/logs/error_log"
    TransferLog "/usr/local/apache2/logs/access_log"

    <Directory "/usr/local/apache2/htdocs">
        AllowOverride None
        Require all granted
    </Directory>
</VirtualHost>
```

4. **Create a dockerfile:**

```
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
```
- Make sure you have to specify path of your `crt` and `key` file. In my case I was doing in the same present working directory.

5. **Build the Image:** After creating the `dockerfile` and `ssl.conf`, than build the docker image.

```
docker build -t my-apache-ssl-server .
``` 

- here's `.` mean i have `dockerfile` and `ssl.conf` in the same directory, `my-apache-ssl-server` is your image Name you can change it accordingly.

6. **Run the Container based on image:** 

```
docker run -dit --name rasikh.cloud -p 192.168.3.228:443:443 -v /home/rasikh/my-website/:/usr/local/apache2/htdocs/ my-apache-ssl-server 
```

- Here's i have run container in foreground `-dit` and publish the port `443` to host Machine ip and attach and `-v` mount the volume from host machine to docker container, where httpd serve the page to us, and last is the our created image `my-apache-ssl-server`.

7. **Access the website.** https://rasikh.cloud # --> I used Flat DNS

- you can copy the Host Machine ip like `https://182.192.22.2`

