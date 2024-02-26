#!/bin/bash

/home/ubuntu/.local/bin/ansible-playbook playbooks/rename-hosts.yml

echo "[+] Waiting 120 seconds for hosts to be up post reboot"
sleep 120

/home/ubuntu/.local/bin/ansible-playbook playbooks/install-adds.yml

echo "[+] Waiting 300 seconds for host to be up post domain creation"
sleep 300

/home/ubuntu/.local/bin/ansible-playbook playbooks/set-dns.yml
/home/ubuntu/.local/bin/ansible-playbook playbooks/join-domain.yml

echo "[+] Configuring Vulnerabilities"
/home/ubuntu/.local/bin/ansible-playbook playbooks/add-user.yml
/home/ubuntu/.local/bin/ansible-playbook playbooks/unconstrained-delegation.yml
/home/ubuntu/.local/bin/ansible-playbook playbooks/constrained-delegation.yml
/home/ubuntu/.local/bin/ansible-playbook playbooks/rbcd.yml

/home/ubuntu/.local/bin/ansible-playbook playbooks/config-localadmin.yml
/home/ubuntu/.local/bin/ansible-playbook playbooks/smb-1-cifs.yml
echo "[+] Almost Done wait 60 seconds"
sleep 60