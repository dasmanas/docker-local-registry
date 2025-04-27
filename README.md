# Docker Local Registry
This project is to set up a Docker Local Registry which can be used to deploy application from a local Docker Image 
repository.

## Pre-requisite
Install `OpenSSL` in you local machine. Recommended version is > 3. 

## Docker Local Registry for 
The APIs of the registry runs on TLS. Therefore, you need to set it up using the following steps

### Root KeyPair for Certificate Authority (CA)
```
openssl req \
-x509 \
-newkey rsa:4096 \
-sha512 \
-nodes \
-keyout certs/rootCA.key \
-days 1825 \
-subj "/C=US/ST=CA/L=Los Angeles/O=Manas Inc/OU=Certificate Authority/CN=manas.com/emailAddress=ca@manas.com" \
-addext "subjectAltName = DNS:manas.com" \
-out certs/rootCA.crt
```

### Docker domain Server's Key & Certificate

#### Private Key
```
openssl genrsa -out certs/dockerdoamin.key 4096
```
#### Signing Request
```
openssl req \
-new \
-sha512 \
-key certs/dockerdoamin.key \
-subj "/C=US/ST=CA/L=Los Angeles/O=Manas Inc/OU=Manas Docker Registry Server/CN=myregistry.dockerdomain.com/emailAddress=myregistry@dockerdomain.com" \
-addext "subjectAltName = DNS:myregistry.dockerdomain.com" \
-out certs/dockerdoamin.csr
```
#### Generate Certificate
```
openssl x509 \
-req \
-in certs/dockerdoamin.csr \
-CA certs/rootCA.crt \
-CAkey certs/rootCA.key \
-CAcreateserial \
-days 365 \
-sha512 \
-out certs/dockerdoamin.crt \
-extfile certs/dockerdoamin-csr.conf \
-extensions v3_req
```

**Make sure all your Private Keys are safe and secure.**

## Docker Engine configuration configuration

You can choose to run on TLS or without TLS. Depending upon your choice pick your option from below.

### Without TLS/HTTPS config
For this, you have to mention `insecure-registries` key in the config.
```json
{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "experimental": false,
  "insecure-registries": [
    "http://docker.localhost:5000"
  ],
  "registry-mirrors": [
    "http://docker.localhost:5000"
  ]
}
```

### TLS/HTTPS config

```json
{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "experimental": false,
  "registry-mirrors": [
    "https://myregistry.dockerdomain.com:443"
  ]
}
```

Once the configuration is updated, Apply & Restart Docker.

## Machine Host Entry
Put a proper Host Entry accordingly into `/etc/hosts` file. For example
```
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1       localhost
255.255.255.255 broadcasthost
::1             localhost
127.0.0.1       myregistry.dockerdomain.com
127.0.0.1       docker.localhost
```
