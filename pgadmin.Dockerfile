FROM dpage/pgadmin4:latest

#RUN adduser -S pgadmin

RUN sed -i "2i chown -R apache:apache /var/lib/pgadmin" entry.sh

#USER pgadmin