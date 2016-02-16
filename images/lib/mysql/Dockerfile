FROM clamp/lib-base:latest
MAINTAINER Fernando Mayo <fernando@tutum.co>, Feng Honglin <hfeng@tutum.co>

# Add MySQL configuration
COPY my.cnf /etc/mysql/conf.d/my.cnf
COPY mysqld_charset.cnf /etc/mysql/conf.d/mysqld_charset.cnf

RUN apt-get-install-min mysql-server-5.6 pwgen && \
    rm -rf /var/lib/apt/lists/* && \
    rm /etc/mysql/conf.d/mysqld_safe_syslog.cnf && \
    if [ ! -f /usr/share/mysql/my-default.cnf ] ; then cp /etc/mysql/my.cnf /usr/share/mysql/my-default.cnf; fi && \
    mysql_install_db > /dev/null 2>&1 && \
    touch /var/lib/mysql/.EMPTY_DB

# Add MySQL scripts
COPY import_sql.sh /import_sql.sh
COPY run.sh /etc/services.d/mysql/run
COPY finish.sh /etc/services.d/mysql/finish

ENV MYSQL_USER=admin \
    MYSQL_PASS=**Random** \
    ON_CREATE_DB=**False** \
    REPLICATION_MASTER=**False** \
    REPLICATION_SLAVE=**False** \
    REPLICATION_USER=replica \
    REPLICATION_PASS=replica

# Add VOLUMEs to allow backup of config and databases
VOLUME  ["/etc/mysql", "/var/lib/mysql"]

EXPOSE 3306