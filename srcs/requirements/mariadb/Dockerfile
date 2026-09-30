FROM debian:12

RUN apt-get update && \
        apt-get install -y --no-install-recommends \
        mariadb-server && \
        rm -rf /var/lib/apt/lists/*

COPY tools/init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh

ENTRYPOINT ["/usr/local/bin/init.sh"]

EXPOSE 3306
