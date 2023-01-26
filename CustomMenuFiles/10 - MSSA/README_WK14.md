# MSSA CCAD 8

Started on 10/24/2022 
Ends on 02/10/2023

>**Note:** 2023/02/16: Holiday for MLK day

Week 14: 2023.01.16 - 2022.01.20

## Week 14 - AZ-900

We are working on AZ-900 materials this week

## Day 1 (Tuesday 2023.01.17)

Started the morning with some questions/answers and interview thoughts

### Morning

1. Mark had some kind of encryption key in a job post

1. Rico built an app for the Done Button

1. Brian had encountered "what is the web.config" for and worked on GIT merging conflicts

1. Mark got his app into Azure and ready to show off and talk about if the opportunity arises

1. We took a pulse on GIT

    Most people seem to be in a good place here, maybe a couple still having some questions

1. Magic 8 Ball

    - We finished the first part of the morning with an assignment to use the tools of your own choice to build a magic 8 ball app.

1. The first part of AZ-900

    - [Cloud Concepts](https://learn.microsoft.com/en-us/training/paths/microsoft-azure-fundamentals-describe-cloud-concepts/)

### Afternoon

After lunch we learned about data centers and then did a couple of VM labs

1. Data Centers and Architecture

1. Deploy a VM

    - [Create an Azure Resource](https://learn.microsoft.com/training/modules/describe-core-architectural-components-of-azure/7-exercise-create-azure-resource)

1. Deploy a VM again

    - [Create an Azure Virtual Machine](https://learn.microsoft.com/training/modules/describe-azure-compute-networking-services/3-exercise-create-azure-virtual-machine)

### Learn Modules

During Day 1 we covered or started all of the following Learn Modules:  

#### Microsoft Azure Fundamentals: Describe cloud concepts

- [Describe Cloud Computing](https://learn.microsoft.com/training/modules/describe-cloud-compute/?WT.mc_id=AZ-MVP-5004334)
- [Describe the benefits of using cloud services](https://learn.microsoft.com/en-us/training/modules/describe-benefits-use-cloud-services/?WT.mc_id=AZ-MVP-5004334)
- [Describe cloud service types](https://learn.microsoft.com/training/modules/describe-cloud-service-types/?ns-enrollment-type=learningpath&ns-enrollment-id=learn.wwl.microsoft-azure-fundamentals-describe-cloud-concepts&WT.mc_id=AZ-MVP-5004334)

#### Azure Fundamentals: Describe Azure architecture and services

- [Describe the core architectural components of Azure](https://learn.microsoft.com/en-us/training/modules/describe-core-architectural-components-of-azure/?WT.mc_id=AZ-MVP-5004334)
- [Describe Azure compute and networking services](https://learn.microsoft.com/training/modules/describe-azure-compute-networking-services/?WT.mc_id=AZ-MVP-5004334)

## End of the day  

On this first day of AZ-900 we established a solid foundation around the core cloud concepts and the architecture in an Azure ecosystem.  

## Day 2

Today we continued with AZ-900 but we went off on a tangent into containers

### Morning

Container Instances

1. We did the container instances lab

1. We got Docker and Docker Desktop on our machines

### Afternoon

We worked to build an image for a DN6/7 Web application
We depoyed an Azure Container Registry

1. Build the image locally

    ```bash
    docker build -t yourimagename .
    ```  

1. Run the image locally

    ```bash
    docker run -dp 8080:80 yourimagename
    ```  

1. Log into Azure

    ```
    az login
    ```  

1. Log into Azure Container Registry

    ```
    docker login your-registry.azurecr.io
    ```  

1. Tag the image for the ACR

    ```
    docker tag hello-world your-registry.azurecr.io/hello-world
    ```  

1. Push the image to the ACR

    ```  
    docker push your-registry.azurecr.io/hello-world
    ```  

1. Deploy image to Azure Container Instances

    Use the learning from earlier to deploy container instances and utilize your registry

## Conclusion

Today was difficult and we fought through a lot of issues.  We ended the day having the ability to build an image, push it to the ACR, and deploy to ACI

## Day 3

On Day 3 (Thursday) we started out with a brief chat about morning drinks and quickly moved into discussions around Networking and Storage.  We finished up the day with Identity and Access, Security, and ???

### Morning

In the morning we covered Networking and Storage

1. Networking

    - Subnets and IP Addresses
    - NSGs for the NIC card on the VM
    - NSGs for the Subnets
    - VPN Gateways
    - Express Route
    - Bastion/Jump Boxes

1. Storage

    - Types of accounts
        - Blob (Block/Append/Page)
        - Table (NoSQL)
        - File (SAN w/SMB 3.0 Protocols)
        - Queue (Message Queues)

    - Storage Skus

        - Standard (regular throughput)
        - Premium (high throughput)
    
    - Storage Tiers

        - Hot
        - Cool
        - Archive
    
        [Not covered]
        - Storage Lifecycle (AZ-204 will cover this in more detail)  
            - Automate tier changing per access/time

    - SAS Tokens for accessing private blobs

        - Blob Level
        - Container Level
        - Policies [will cover more in AZ-204, just briefly mentioned here]
    
### Afternoon

The afternoon started with security and moved to ???

