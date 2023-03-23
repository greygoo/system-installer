#!/bin/sh

PROFILE=${1:-"local_install"}
BOARD=${2:-"orangepi3-lts"}
BRANDING=${3:-"default"}

if [ ! -f profiles/${PROFILE} ]; then
	echo "Profile not found. Exiting"
	exit 1
fi

. profiles/${PROFILE}

echo "Running Installer"
echo "Profile: ${PROFILE}"
echo "Board: ${BOARD}"
echo "Branding: ${BRANDING}"
echo "Selected Playbooks: ${PLAYBOOKS}"

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
	for playbook in ${PLAYBOOKS}; do
        	ansible-playbook --extra-vars "branding=${BRANDING}" \
				 --extra-vars "board=${BOARD}" \
				 --extra-vars "@config.yaml" \
			 	 ansible/playbooks/${playbook}
	done
}

Main "$@"
