FROM phusion/passenger-nodejs

# Set correct environment variables.
ENV HOME /root

## Download shit
RUN apt-get update
RUN apt-get install -qq -y software-properties-common curl git build-essential

# ...put your own build instructions here...
# RUN rm -f /etc/nginx/sites-enabled/default
RUN rm -f /etc/service/nginx/down
COPY --chown=app:app ./meteorapp/ /home/app/meteorapp

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]
