FROM clamp/lib-base:$BUILD_NUMBER
MAINTAINER Fernando Mayo <fernando@tutum.co>, Feng Honglin <hfeng@tutum.co>

# Add MySQL configuration
COPY my.cnf /etc/mysql/conf.d/my.cnf
COPY mysqld_charset.cnf /etc/mysql/conf.d/mysqld_charset.cnf

RUN apk add --no-cache mysql mysql-client pwgen && \
    if [ ! -f /usr/share/mysql/my-default.cnf ] ; then cp /etc/mysql/my.cnf /usr/share/mysql/my-default.cnf; fi && \
    rm -rf /var/lib/mysql/* && \
    touch /var/lib/mysql/.EMPTY_DB

# Add MySQL scripts
COPY import_sql.sh /import_sql.sh
COPY run.sh /etc/services.d/mysql/run
COPY finish.sh /etc/services.d/mysql/finish

ENV MYSQL_USER=admin
ENV MYSQL_PASS=**Random**
ENV ON_CREATE_DB=**False**
ENV REPLICATION_MASTER=**False**
ENV REPLICATION_SLAVE=**False**
ENV REPLICATION_USER=replica
ENV REPLICATION_PASS=replic

# Add VOLUMEs to allow backup of config and databases
VOLUME  ["/etc/mysql", "/var/lib/mysql"]

EXPOSE 3306