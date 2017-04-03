FROM bugthing/docker-archlinux
RUN pacman --noconfirm -Sy archlinux-keyring \
    && pacman-key --populate \
    && pacman-key --refresh-keys \
    && pacman --noconfirm -Syyuu \
    && pacman-db-upgrade
RUN pacman -Syy && pacman -S --noconfirm --quiet nginx
ADD files/nginx.conf /etc/nginx/nginx.conf
VOLUME ["/sites", "/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx"]
EXPOSE 80
EXPOSE 443
CMD ["/usr/bin/nginx"]
