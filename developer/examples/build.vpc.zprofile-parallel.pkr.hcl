// packer {
//   required_plugins {
//     ibmcloud = {
//       version = ">=v3.0.0"
//       source = "github.com/IBM/ibmcloud"
//     }
//   }
// }

variable "ANSIBLE_INVENTORY_FILE" {
  type    = string
  default = "provisioner/hosts"
}


variable "IBM_API_KEY" {
  type = string
}

variable "SUBNET_ID" {
  type = string
}

variable "REGION" {
  type = string
}

variable "RESOURCE_GROUP_ID" {
  type = string
}

variable "SECURITY_GROUP_ID" {
  type = string
}
// variable "VPC_URL" {
//   type = string
// }
// variable "IAM_URL" {
//   type = string
// }


locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "ibmcloud-vpc" "zprofile" {
  api_key           = var.IBM_API_KEY
  region            = var.REGION
  subnet_id         = var.SUBNET_ID
  resource_group_id = var.RESOURCE_GROUP_ID
  security_group_id = var.SECURITY_GROUP_ID

  vsi_base_image_name = "ibm-zos-2-4-s390x-dev-test-wazi-1"
  vsi_profile        = "bz2-2x8"
  vsi_interface      = "public"
  vsi_user_data_file = ""

  image_name = "packer-zprofile-bz2-2x8-${local.timestamp}-1"

  communicator = "ssh"
  ssh_username = "ibmuser"
  ssh_port     = 22
  ssh_timeout  = "8m"

  timeout = "20m"
}

source "ibmcloud-vpc" "zprofile-other" {
  api_key           = var.IBM_API_KEY
  region            = var.REGION
  subnet_id         = var.SUBNET_ID
  resource_group_id = var.RESOURCE_GROUP_ID
  security_group_id = var.SECURITY_GROUP_ID

  vsi_base_image_name = "ibm-zos-2-4-s390x-dev-test-wazi-1"
  vsi_profile        = "bz2-2x8"
  vsi_interface      = "public"
  vsi_user_data_file = ""

  image_name = "packer-zprofile-bz2-2x8-${local.timestamp}-1"

  communicator = "ssh"
  ssh_username = "ibmuser"
  ssh_port     = 22
  ssh_timeout  = "8m"

  timeout = "20m"
}

build {
  sources = [
    "source.ibmcloud-vpc.zprofile",
    "source.ibmcloud-vpc.zprofile-other"
  ]

  provisioner "shell" {
    execute_command = "{{.Vars}} bash '{{.Path}}'"
    inline = [
      "echo 'Hello from IBM Cloud Packer Plugin - VPC Infrastructure'",
      "echo 'Hello from IBM Cloud Packer Plugin - VPC Infrastructure' >> /hello.txt"
    ]
  }
}
