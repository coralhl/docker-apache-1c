#this container based in standart image Debian+Apache 2.4: https://hub.docker.com/_/httpd
FROM httpd:latest
#update
RUN apt update && apt upgrade -y
MAINTAINER coral <coralhl@gmail.com>
#copy deb64 in directory
COPY deb64.tar.gz /opt/install/deb64.tar.gz

#unpack archive in directory /opt/install
RUN tar xzf /opt/install/deb64.tar.gz -C /opt/install \
    #and run package install
    && /opt/install/*.run --mode unattended --installer-language en --enable-components ws,ru,liberica_jre \
    #remove dir after installation
    && rm -rf /opt/install/
#copy in container httpd.conf
COPY httpd.conf /usr/local/apache2/conf/httpd.conf

RUN mkdir -p /var/www/1c/bp_ip \
    && mkdir -p /var/www/1c/bp_ooo \
    && mkdir -p /var/www/1c/zup_ip \
    && mkdir -p /var/www/1c/zup_ooo

#copy in container default.vrd - config connection to 1c
COPY default_bp_ip.vrd /var/www/1c/bp_ip/default.vrd
COPY default_bp_ooo.vrd /var/www/1c/bp_ooo/default.vrd
COPY default_zup_ip.vrd /var/www/1c/zup_ip/default.vrd
COPY default_zup_ooo.vrd /var/www/1c/zup_ooo/default.vrd

#set file permissions
RUN chown daemon:daemon -R /var/www/1c/
