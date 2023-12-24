FROM alpine

RUN apk --no-cache --update add git openssh

COPY entrypoint.sh authkeys.sh /
RUN chmod -w+x /entrypoint.sh /authkeys.sh

COPY 99-sshd.conf /etc/ssh/sshd_config.d/

RUN rm /etc/motd \
  && mkdir /git-server \
  && adduser -D -s /usr/bin/git-shell git \
  && echo git:tig | chpasswd

COPY git-shell-commands /home/git/git-shell-commands
RUN chown -R git:git /home/git \
  && chmod -R 755 /home/git/git-shell-commands

VOLUME /git-server

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
