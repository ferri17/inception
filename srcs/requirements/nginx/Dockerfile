FROM debian:11.9

RUN apt-get -y update
RUN apt-get install -y nginx openssl
	
EXPOSE 443

COPY ./conf/default /etc/nginx/sites-enabled/
COPY ./tools/nginx_start.sh /etc

RUN chmod a+x /etc/nginx_start.sh

ENTRYPOINT ["/etc/nginx_start.sh"]

CMD ["nginx", "-g", "daemon off;"]
