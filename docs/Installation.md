# Installation 

> Note: The setup requires ansible and awscli and aws account to provison the resources. Also kindly change the hardcoded credentials to some custom ones for the Windows Attacker instance on Public Subnet.

## Steps on host

1. Install `ansible` and `awscli`

```bash
sudo apt update
sudo apt install python3-pip
python3 -m pip install --user ansible
python3 -m pip install --user ansible-core
sudo apt install awscli
```

2. Configure your `awscli` to use the appropriate profile and set it up in the `global_vars`.

3. To allocate the resources and spin up the infrastructure use the following.

```bash
ansible-playbook provison.yml
```

4. To decomision the resources run the following command.

```bash
ansible-playbook destroy.yml
```

## Configure Ubuntu Attacker Machine

1. Login to the ubuntu attacker machine using the IP address of the machine provided.

2. Use `rsync` to synchronize the files to the attacker ubuntu machine.

```bash
# cd to the repository root folder
rsync -a --exclude-from='.gitignore' -e "ssh -i `pwd`/keypair/adlab.pem" "`pwd`/" ubuntu@$public_ip:~/DelegationLab/
```

3. Mark the `ansible.sh` as executable and run it to install ansible on the attacker ubuntu machine.

```bash
chmod +x ansible.sh
./ansible.sh
```

2. Wait for the machines to be up and verify the same by trying to ping the hosts on the private network.

```bash
ping 10.0.10.10
ping 10.0.10.20
ping 10.0.10.30
```

5. Run the `domain-create.sh` to configure the hosts.

```bash
./domain-create.sh
```