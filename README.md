# IMT-A3-Terraform (Aman KUMAR & Pierre LAFON)

## Objective
The goal of this project is to provide hands-on experience with Terraform for deploying an application composed of 5 services available on GitHub: [Example Voting App](https://github.com/dockersamples/example-voting-app/tree/main).


## Part 1 - Docker
In this initial phase, the application is deployed using Terraform's Docker provider. It's deployed in containers locally on host machine.

### To run the docker terraform files,

```bash
cd part 1 - docker
terraform init
terraform plan
terraform apply
```

## Part 2 - GKE and Kubernetes
In the second part, the objective is to deploy the application on a Kubernetes cluster provisioned with Terraform on Google Kubernetes Engine (GKE). This involves using the Google Cloud Platform (GCP) and Kubernetes providers.

### To run the GKE terraform files,

```bash
cd part 2 - GKE - K8s
terraform init
terraform plan
terraform apply
```

### Variables to be set in terraform.tfvars file  (Google Cloud Platform variables)
- project_id
- region
- zone
- GOOGLE_CREDENTIALS_File : string of json Google credentials (it should be a string of json, you can concert JSON to string using [this](https://codebeautify.org/json-to-string-online) website)

If everything goes well, you should see in GCP ingress service with external IP address. You can access the application using that IP address.

## Additional features

This respository also use Giithub Actions to automate the terraform workflow to deploy the application on GKE. The workflow is triggered when a new release is created. The workflow is defined in .github/workflows/terraform.yml file.

However, once the workflow is triggered, it will create resources on GCP and deploy the application on GKE. But, it will not destroy the resources once the workflow is completed. To destroy the resources, you need to do it manually in GCP.

## Contributors
- Aman Kumar
- Pierre LAFON

Happy Terraforming!
