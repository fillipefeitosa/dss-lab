FROM phusion/passenger-nodejs

# Set correct environment variables.
ENV HOME /root

## Download shit
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qq -y software-properties-common curl git build-essential g++

# Remove Default configuration and Copy DSS-lab Nginx service
RUN rm -f /etc/nginx/sites-enabled/default  
COPY ./phusion-config/dsslab.conf /etc/nginx/sites-enabled
# Copy meteorapp bundle to container with APP user permissions and ownership
COPY --chown=app:app ./meteorapp/ /home/app/meteorapp

# Set Workdir to install npm dependencies
WORKDIR /home/app/meteorapp/bundle/programs/server
RUN pwd
# Update npm to avoid npm install error
RUN npm install npm@latest -g
# Run Bundle Install
# RUN su - app -c "npm install --production"
RUN npm install --production

# Activate nginx
RUN rm -f /etc/service/nginx/down

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Restart Nginx Service to load meteor app
# RUN service nginx restart

WORKDIR /
# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]
