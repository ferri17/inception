FROM debian:11.9

RUN apt-get -y update
RUN apt-get install -y nginx openssl
	
EXPOSE 80

COPY conf/default /etc/nginx/sites-enabled/
CMD ["nginx", "-g", "daemon off;"]
