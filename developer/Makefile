setup:
	cd ..; pip3 install --ignore-installed "pywinrm>=0.2.2"
	cd ..; pip3 install --ignore-installed ansible
	cd ..; go install github.com/hashicorp/packer-plugin-sdk/cmd/packer-sdc@latest
	cd ..; go get github.com/hashicorp/hcl/v2/hcldec@latest
	cd ..; go get golang.org/x/crypto/ssh@latest
	cd ..; go get github.com/zclconf/go-cty/cty@latest

plugin:
	cd ..; go mod tidy
	cd ..; go mod vendor
	cd ..; go generate ./builder/ibmcloud/...
	cd ..; go mod vendor
	cd ..; go build .

validate-all:
	cd ..; packer validate -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.centos.pkr.hcl
	cd ..; packer validate -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.centos-ansible.pkr.hcl
	cd ..; packer validate -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.windows.pkr.hcl
	cd ..; packer validate -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.rhel.pkr.hcl
	cd ..; packer validate -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.zprofile.pkr.hcl


run-centos:
	cd ..; packer validate -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.centos.pkr.hcl
	cd ..; packer build -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.centos.pkr.hcl

run-centos-parallel:
	cd ..; packer validate -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.centos-parallel.pkr.hcl
	cd ..; packer build -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.centos-parallel.pkr.hcl

run-centos-ansible:
	cd ..; packer validate -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.centos-ansible.pkr.hcl
	cd ..; packer build -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.centos-ansible.pkr.hcl

run-rhel:
	cd ..; packer validate -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.rhel.pkr.hcl
	cd ..; packer build -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.rhel.pkr.hcl

run-rhel-parallel:
	cd ..; packer validate -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.rhel-parallel.pkr.hcl
	cd ..; packer build -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.rhel-parallel.pkr.hcl

run-windows:
	cd ..; packer init -upgrade developer/examples/build.vpc.windows.pkr.hcl
	cd ..; packer validate -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.windows.pkr.hcl
	cd ..; packer build -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.windows.pkr.hcl

run-windows-parallel:
	cd ..; packer validate -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.windows-parallel.pkr.hcl
	cd ..; packer build -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.windows-parallel.pkr.hcl

run-zprofile:
	cd ..; packer validate -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.zprofile.pkr.hcl
	cd ..; packer build -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.zprofile.pkr.hcl

run-zprofile-parallel:
	cd ..; packer validate -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.zprofile-parallel.pkr.hcl
	cd ..; packer build -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.zprofile-parallel.pkr.hcl

run-centos-encrypted:
	cd ..; packer validate -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.centos-encrypted-image.pkr.hcl
	cd ..; packer build -var-file="developer/variables.pkrvars.hcl" developer/examples/build.vpc.centos-encrypted-image.pkr.hcl