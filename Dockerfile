FROM debian:stretch
LABEL maintainer "Daichi Sakai <daisaru11@gmail.com>"

COPY ./install.sh /install.sh
RUN /install.sh
