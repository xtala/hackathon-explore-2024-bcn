<img src="https://github.com/user-attachments/assets/e6fe52ff-57ba-456a-a788-ff09b2fdfd05" width="1000">

# VMware Explore 2024 Las Vegas Hackathon
---
### Automating with Aria Automation and Terraform
---

## The Team (Vegas)
* Stephan (C)
* Lucho
* Konstantinos
* Evert
* Francisco
* James

## The Team (Barcelona)
* Danish Dude (Rene)
* Pure Storage Dude (Adam)
* Robert from ITQ (talentless)
* Belgium Dude from VMUG (Maarten)
* Other Belgium Dude from VMUG (Kristof)
* Belgium Dude 3 (Evert)
* Dude from ESA (Daniel) 🚀

## The Mission
Automating anything can be a daunting task with many ways to achieve an automation goal.  Virtual Machines are at the center of any infrastructure, responsible for countless deployment hours.  The ability to automate the deployment of these is a easy win for many an organisation and a great place to begin the journey, saving time and resources that could be better spent on innovation and forward thinking.

There are also many technologies and approaches out there that can help to achieve automation depending on many factors including already adopted technologies and practices.  We aim to look at a few of the possibilities that could be used to reach the goal of automating virtual machine provisioning.

## The Tech
- Aria Automation
- Terraform
- vSphere
- NSX - Networking, load balancing and firewalling.

## The Project

This project is going to consist of two parts. The first part, setting up Aria Automation to deploy an application based on different inputs and constructs with virtual machines, load balancers and firewall rules, and the second one, leveraging terraform to consume the workflows in Aria Automation.

Doing what Aria Automation does out of the box with Terraform, is much much harder and complicated, since Terraform's goal is not to become a full-fledged Cloud Management Platform, but a infrastructure management tool.  Both have their place, if all you have is a hammer, everything starts looking like a nail.

We look to leverage all of Aria Automation's OOB (and extensibility) capabilities within a workflow, which in its self is very powerful.  We then look to consume the Aria Automation workflow by executing it via a Terraform configuration in which the Terraform Provider for Aria Automation interacts with the API.

Now we can consume Aria Automation workflow programmatically, we can now begin to embed this into a much wider deployment pipeline, combining infrastructure deployment such as a new vSphere Clusters while configuring application infastructure such as virtual machines and NSX firewall rules.

## What is the upside of combining both Aria Automation and Terraform?

- Combine the power of two different types of tool.
- Extend the power of Aria Automation.
- Make use of Terraform's concept of state and declarative infrastructure.
- The potential to automate to provisioning of a wider range of infrastructure and configuration.

## Part 1 - Aria Automation

The setup in the lab is pretty simple, but it enables us to deploy an application with:
* Virtual Machines separated in two tiers, with many configurable inputs such as CPU, Memory, Image, etc
* Separate networks for each of these virtual machines
* Load balancing in one of the tiers
* On-Demand security group to secure our virtual machines
* Adding extra disks to each of the virtual machines

The blueprints are in the file section of this repo, called Hackathon.yaml and Hackathon2.yaml respectively. Hackathon.yaml was the initial version, and then once we had something running (better be sure you can demo something for the competition) we started working on the 2nd version, but they are similar.

<img width="1321" alt="image" src="https://github.com/user-attachments/assets/aa5e7e0b-3585-4104-8390-86f593eb6ef9">

When I mention the application "tiers", I am starting to use the concept of constraint and capability tags. This is one of the most important concepts in Aria Automation.

A constraint tag is set at the blueprint resource level (Virtual Machine, Network, Load Balancer, Disk, etc), and it is emphasizing what this resource needs to be deployed.
A capability tag is set at the infrastructure resource level (Cloud Account, Cloud Zone, Network Profile, Network, Cluster, etc) and it shows that capabilities this resource can provide.

Aria Automation will only deploy a resource where there is a "match" between what the blueprint resource "needs" and what the infrastructure resource can "provide"

Since this is a HOL lab, both capability tags (for Development and Production) are applied at the same Cloud Zone level) - but it mimics having a location for production and a region for development.
The Cloud Zone is a subset of the Cloud Account (in this case, a vCenter) and it contains a set of clusters that can be used for deployment.

<img width="338" alt="image" src="https://github.com/user-attachments/assets/2b5a819c-7fe4-4331-b979-df4a8e8d1e73">

Same thing applies to the networks, we have two different networks within a network profile, each mapping to one of the environments

<img width="1090" alt="image" src="https://github.com/user-attachments/assets/23dbf0db-efc6-46fc-9746-24c54090750a">

To be able to leverage Aria Automation's IPAM, you need to create IP ranges in these networks, for example:

<img width="590" alt="image" src="https://github.com/user-attachments/assets/f46c7c87-f4f6-4476-aeb2-b6bc32c28cdd">

Once we have all of this, we can go to our blueprint, click on deploy, select our inputs, and we will deploy the application!

<img width="1108" alt="image" src="https://github.com/user-attachments/assets/0115907f-a941-442e-8f53-61f6abf327bf">

Now, as mentioned, this is done through Aria Automation GUI - It is not done programmatically, so it wouldn't fit very well within a DevOps workflow.

How do we consume this same blueprint from Terraform?

## Part 2 - Terraform

Now we have working Aria Automation blueprints, we started looking at how we could now consume this via a Terraform configuration.

To start, we needed to configure our Terraform Provider for Aria Automation, this configuration is found in the providers.tf file.

It looks a little something like this:

![image](https://github.com/user-attachments/assets/8f87c3f4-7853-493e-a5a7-687b0e41c406)

We are making use of two providers, the Aria Automation and another called Terracurl.  Both require configuration details to be able to connect to the required endpoint.  One can have a username and password passed directly, the other needs and access or refresh token to be passed.

To be able to authenticate with the Aria Automation instance we need an access token, so we made use of the very flexible Terracurl Provider to be able to run the access token API and consume the output:

![image](https://github.com/user-attachments/assets/0e71aaee-bf0b-49c8-8d8b-b18f2e559461)

Here we are making an API call to the Aria Automation endpoint, providing username and password values via environment variables and outputting the access token into a local variable called 'bearer' that we can consume in our provider.tf configuration.

Now we move onto the file with the bulk of the configuration, main.tf.  Here is the core configuration that we are using to consume the Aria Automation blueprint.

At the beginning of this file we are defining the values and parameters of the 't-shirt' sizes we have configured in Aria Automation.  You could pull that from Aria Automation, but we were running out of time!!

We then pull some other required data using a terraform data block for things like the blueprint and the project:

![image](https://github.com/user-attachments/assets/ad5a393a-83b2-4cd7-98a5-7c52ad86d2ff)

From here its a case of defining the resource we wish to deploy using a resource block:

![image](https://github.com/user-attachments/assets/7925dfda-2769-44be-b7f8-a36e5fbecddf)

We are passing in the ID values from the data sources we specified earlier as configuration parameters as well as a size value, this is hard coded in the example, but could be passed via a environment variable or just as a var value in the command line.

## Wrap up

Overall this was a fantastic experience to be part of for all involved, and lots learnt!  The project was lucky enough to be crowned the winner project which we were all really proud to have contributed to.

Hopefully this is a useful resource to help other interested in embarking on their own automation journey.

Until next time...

#### Useful Links:

https://registry.terraform.io/providers/vmware/vra/latest/docs
https://registry.terraform.io/providers/vmware/nsxt/latest
https://registry.terraform.io/providers/vmware/vcf/latest
https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs
https://registry.terraform.io/providers/devops-rob/terracurl/latest/docs
https://www.vmware.com/products/cloud-infrastructure/cloud-foundation-automation
