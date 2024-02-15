# Node.js Vehicle Rental Microservice

An example microservice for vehicle rental company that uses node.js and mongodb.

## Prerequisites

1. [Yarn](https://yarnpkg.com/)
1. [Docker](https://www.docker.com/)
1. [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/)

## To Run Locally:

1. `yarn install`
1. copy `.env.template` to `.env` and provide necessary values.
1. `cd VehicleService`
1. `docker compose up`
1. Navigate to `http://localhost:3000/api-docs/`

## To Deploy:

1. `cd infra`
1. `az login`
1. Enter value for `docker_image` in `terraform.tfvars` (or use default, `mwolfhoffman/vehicleservice`)
1. `terraform init`
1. `terraform plan`
1. `terraform apply`
1. Add env vars as secrets in Github. These will be used by the `build-and-push` github actions job.
