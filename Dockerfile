FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/usr/games:${PATH}"  

RUN apt-get update && \
    apt-get install -y fortune-mod cowsay netcat-openbsd 

COPY wisecow.sh /usr/local/bin/server.sh
RUN chmod +x /usr/local/bin/server.sh

EXPOSE 4499

ENTRYPOINT ["/usr/local/bin/server.sh"]


