# Usa una imagen base de Ubuntu
FROM ubuntu:latest

# Actualizar e instalar dependencias necesarias
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y \
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

RUN echo '<VirtualHost *:80>\n\
    ServerName localhost\n\
    DocumentRoot /var/www/html\n\
    ScriptAlias /cgi-bin/ /var/www/html/cgi-bin/\n\
    <Directory "/var/www/html/cgi-bin">\n\
        Options +ExecCGI\n\
        AddHandler cgi-script .pl\n\
        Require all granted\n\
    </Directory>\n\
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf


# Copiar archivos CGI, HTML y la carpeta CSS al contenedor
COPY ./cgi-bin /var/www/html/cgi-bin
COPY ./*.html /var/www/html/
COPY ./css /var/www/html/css  

# Cambiar permisos de ejecución para los scripts .pl
RUN chmod +x /var/www/html/cgi-bin/*.pl

# Exponer el puerto de Apache
EXPOSE 80

# Iniciar Apache en primer plano cuando el contenedor se ejecute
CMD ["apache2ctl", "-D", "FOREGROUND"]
