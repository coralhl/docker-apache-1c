#this container based in standart image Debian+Apache 2.4: https://hub.docker.com/_/httpd
FROM httpd:latest
#update
RUN apt update && apt upgrade -y
MAINTAINER coral <coralhl@gmail.com>
#copy deb64 in directory
COPY setup-full-8.3.23.1865-x86_64.run /opt/install/setup.run

#run package install
RUN chmod +x /opt/install/setup.run \
    && /opt/install/setup.run --mode unattended --installer-language en --enable-components ws,ru,liberica_jre \
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
RUN chown www-data:www-data -R /var/www/1c/
