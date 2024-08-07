# Deployment Configurations

Sub directories contain scripts and configuration for deployment in target platforms. 

We previously supported other platforms, and you can take a look at them at https://github.com/microservices-demo/user-contribs.

## Deployment to the Yandex Cloud

### Requirements

* Yandex cloud account
* Terraform

### How to deploy

1. Move to the `microservices-demo/deploy/docker-swarm/infra/yandex` dir
2. Add credentials for access to Ya Cloud
   1. Ya credentials
      1. token
      2. cloud_id
      3. folder_id
   2. ssh credentials (public and private key for access to instances)
3. Run `terraform apply`
4. Open external ip in browser from an output

### Known issues

E: `Failed to unlink socket file /tmp/mongodb-27017.sock errno:30 Read-only file system`

[Issue](https://stackoverflow.com/questions/38125172/run-mongo-in-docker-with-read-only-fs)

Short solution: remove and redeploy swarm service