ARG REGISTRY_IMAGE_VERSION=latest
FROM registry:${REGISTRY_IMAGE_VERSION}
## Section to enable pull through cache using a local rigistry to proxy Docker Hub. With this settings enable
## unfortunately docker push to local registry doesn't work
#RUN tee -a /etc/docker/registry/config.yml > /dev/null <<EOT
#proxy:
#  remoteurl: https://registry-1.docker.io
#EOT
