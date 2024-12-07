# Usa una imagen base de Ubuntu
FROM ubuntu:latest

# Actualizar e instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    perl \
    mariadb-client \
    libdbi-perl \
    libcgi-pm-perl \
    apache2 \
    make \
    gcc \
    libmariadb-dev \
    cpanminus \
    libapache2-mod-perl2 \ 
    libapache2-mod-php \   
    curl \                  
    nano \                 
    && rm -rf /var/lib/apt/lists/*

# Instalar DBD::MariaDB
RUN cpanm --force DBD::MariaDB || exit 1

# Habilitar módulos CGI y CGID en Apache
RUN a2enmod cgi cgid

# Configurar Apache para ejecutar CGI
RUN echo "<VirtualHost *:80>\n\
    ServerName localhost\n\
    DocumentRoot /var/www/html\n\
    ScriptAlias /cgi-bin/ /var/www/html/cgi-bin/\n\
    <Directory \"/var/www/html/cgi-bin\">\n\
        Options +ExecCGI\n\
        AddHandler cgi-script .pl\n\
        Require all granted\n\
    </Directory>\n\
</VirtualHost>" > /etc/apache2/sites-available/000-default.conf

# Copiar archivos CGI, HTML y la carpeta CSS al contenedor
COPY ./cgi-bin /var/www/html/cgi-bin
COPY ./index.html /var/www/html/
COPY ./new.html /var/www/html/
COPY ./css /var/www/html/css  

# Reiniciar Apache después de copiar los archivos
RUN service apache2 restart

# Establecer permisos adecuados para los archivos y directorios CGI
RUN chmod -R 755 /var/www/html/cgi-bin \
    && chown -R www-data:www-data /var/www/html/cgi-bin

# Exponer el puerto 80 para acceder al servidor web
EXPOSE 80

# Iniciar Apache en primer plano
CMD ["apache2ctl", "-D", "FOREGROUND"]
