FROM revel

MAINTAINER Bitnami <containers@bitnami.com>

#
# Eclipse Che
#
USER root

RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN bitnami-pkg install java-1.8.0_91-0 --checksum 64cf20b77dc7cce3a28e9fe1daa149785c9c8c13ad1249071bc778fa40ae8773
ENV PATH=/opt/bitnami/java/bin:$PATH

LABEL che:server:3000:ref=revel che:server:3000:protocol=http

#
# Maria
#

ENV MARIADB_USER=my_user \
    MARIADB_DATABASE=my_database \
    MARIADB_PASSWORD=my_password

RUN bitnami-pkg unpack mariadb-10.1.14-3 --checksum 261d55ed7759cc6708750ff3baa84365f9b00473b7673868d12ac03875ae9823
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH
 
