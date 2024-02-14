# Node.js Vehicle Rental Microservice

An example microservice for vehicle rental company that uses node.js and mongodb.

## Prerequisites

1. [Yarn](https://yarnpkg.com/)
1. [Docker](https://www.docker.com/)
1. [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/)

## To Run Locally:

1. `yarn install`
1. `docker compose up -d`

## To Deploy:

1. Enter Azure credentials into `main.tf` `provider`
1. Enter docker image into `main.tf` `site_config`
1. terraform init
1. terraform plan
1. terraform apply
