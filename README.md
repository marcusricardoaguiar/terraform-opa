# terraform-opa
Terraform code with Open Policy Agent

## Running OPA

To start the OPA application, run the following command:
```
docker pull openpolicyagent/opa:1.0.0
docker run -d --name opa-server -p 8181:8181 -v "$PWD/policies:/policies" -v "$PWD/inputs:/inputs" openpolicyagent/opa:latest run --server --bundle /policies
```

## Plan terraform to a json file

In order to evaluate the terraform plan on the OPA deployment, it is required to plan terraform to a json file.
Follow these steps to create a plan:
```
terraform init
terraform plan --out=tfplan.binary
terraform show --json tfplan.binary > inputs/tfplan.json
```

## Check policies with OPA

With the OPA server running as a docker container and with the terraform plan file in the correct format, you should run the following curl command to validate the plan:
```
docker exec -it $CONTAINER_ID opa exec --decision terraform/gcp_policy/violate --bundle policies/ /inputs/tfplan.json
```
