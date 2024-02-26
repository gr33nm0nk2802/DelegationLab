#!/bin/bash

# Install git and python3
sudo apt-get update
sudo apt-get install -y git python3-venv python3-pip
sudo snap install crackmapexec

#python3 -m venv .venv
#source .venv/bin/activate

# Install ansible and pywinrm
python3 -m pip install --upgrade pip
python3 -m pip install ansible-core
python3 -m pip install pywinrm
python3 -m pip install impacket
python3 -m pip install coercer


# Install the required ansible libraries
/home/ubuntu/.local/bin/ansible-galaxy install -r /home/ubuntu/DelegationLab/scripts/ansible/requirements.yml

# set color
sudo sed -i '/force_color_prompt=yes/s/^#//g' /home/*/.bashrc
sudo sed -i '/force_color_prompt=yes/s/^#//g' /root/.bashrc


echo "[+] Add /home/ubuntu/.local/bin/ to PATH"
echo '[+] export PATH=$PATH:/home/ubuntu/.local/bin'