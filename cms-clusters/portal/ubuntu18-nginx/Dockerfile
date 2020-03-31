FROM ubuntu:latest
  
RUN apt-get update ; \
    apt-get install -y supervisor nginx npm git curl vim  && rm -rf /var/lib/apt/lists/* 

CMD [“echo”,”nginx is ready”]
