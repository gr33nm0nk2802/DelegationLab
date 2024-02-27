# Delegation Lab

> Author: Syed Modassir Ali (@gr33nm0nk2802)

# About

This project was created to demonstrate the three types of kerberos delegations. Kerberos Unconstrained Delegations(KUD), Kerberos Constrained Delegation(KCD) and Resource Based Constrained Delegation(RBCD). The lab is going to do the following.

## Provisoning the Infrastructure in AWS
 
- Create DelegationLab-vpc
- Create Public and Private Subnet
- Create Internet Gateway and attach it to Public Subnet in VPC
- Create Route Table
- Create Public and Private Security Groups
- Create KeyPair
- Find Windows AMI
- Find Ubuntu AMI (For attacker linux and ansible)
- Launch EC2 Instances with Password
- Fetch Public IP of Attacker Machine

The infrastructure is configured as follows.

![](/docs/assets/images/DelegationLab-Diagram.png)

## Configuring the RED.LOCAL domain with ansible

- Rename 
- Configure Ethernet Adapter on DC
- Install ADDS Feature
- Create RED.LOCAL domain
- Configure DNS on client machines
- Domain Join the machines to DC
- Add the Domain User Account
- Configure Unconstrained Delegation 
- Configure Constrained Delegation
- Configure Resource Based Constrained Delegation
- Add `domuser` to local admin on the machine.
- Install SMB 1.0/CIFS File Sharing Support
- Install IIS Feature

# TODO 

- [x]~~Modify the Destroy script to delete selected instances only~~
- [x]~~Add a Solution Book for each vulnerability~~.
- [ ] Fix DNS Issues
- [ ] DC Auto logon on Scheduled Task
- [ ] Check KUD - User Account
- [ ] Check KCD - Computer Account
- [ ] Coercer Exploit
