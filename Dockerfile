FROM base/archlinux
RUN pacman -Syy && pacman -S --noconfirm --quiet nginx
ADD files/nginx.conf /etc/nginx/nginx.conf
VOLUME ["/sites", "/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx"]
EXPOSE 80
EXPOSE 443
CMD ["/usr/bin/nginx"]
