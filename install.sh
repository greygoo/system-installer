#!/bin/sh

RELEASE=$1
LINUXFAMILY=$2
BOARD=$3
BUILD_DESKTOP=$4
BRANDING= $5

Main() {
        InstallAnsible
        RunAnsiblePlaybooks
	UninstallAnsible
}

InstallAnsible()
{
        echo "Installing ansible"
        yes | DEBIAN_FRONTEND=noninteractive apt-get -yqq install ansible
        apt clean
} # InstallAdvancedDesktop

UninstallAnsible()
{
        echo "Uninstalling ansible"
        yes | DEBIAN_FRONTEND=noninteractive apt-get -yqq remove ansible
        apt clean
} # UninstallAnsible

RunAnsiblePlaybooks()
{
        echo "Running playbooks"
        ansible-playbook --extra-vars "branding=${BRANDING}" \
			 --extra-vars "board=${BOARD}" \
			 --extra-vars "@config.yaml" \
			 ansible/playbooks/*
}

Main "$@"
