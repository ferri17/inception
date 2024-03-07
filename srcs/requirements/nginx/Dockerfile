FROM debian:11.9

RUN apt-get -y update
RUN apt-get install -y nginx openssl
	
EXPOSE 80

COPY ./conf/default /etc/nginx/sites-enabled/
COPY ./tools/nginx_script.sh /etc

RUN chmod a+x /etc/nginx_script.sh

CMD ["nginx", "-g", "daemon off;"]
