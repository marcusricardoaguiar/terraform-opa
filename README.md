# terraform-opa
Terraform code with Open Policy Agent

## Running OPA

To start the OPA application, run the following command:
```
docker pull openpolicyagent/opa:latest
docker run -d --name opa-server -p 8181:8181 \
    -v $(pwd)/policies:/policies \
    openpolicyagent/opa:latest run \
    --server --bundle /policies
```

## Plan terraform to a json file

In order to evaluate the terraform plan on the OPA deployment, it is required to plan terraform to a json file.
Follow these steps to create a plan:
```
terraform plan -out=tfplan.binary
terraform show -json tfplan.binary > tfplan.json
```
It is also required to update the terraform plan file. The OPA server requires a json with a object "input"
and terraform does not provide it by default. The following script adds it automatically:
```
./opa-config.sh
```

## Check policies with OPA

With the OPA server running as a docker container and with the terraform plan file in the correct format, you should run the following curl command to validate the plan:
```
curl -X POST "http://localhost:8181/v1/data/terraform/gcp_policy/deny" \
  -H "Content-Type: application/json" \
  -d @input.json
```