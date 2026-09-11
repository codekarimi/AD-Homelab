# Troubleshooting Guide - AD Homelab

## Common Issues and Solutions

### Issue 1: "The server is unwilling to process the request"

**Cause:** AD DS role not installed or server not promoted to Domain Controller.

**Solution:**
```powershell
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "home.lab" -InstallDNS -Force
```

---

### Issue 2: "Access to the path is denied" when downloading files

**Cause:** Destination path missing filename or extension.

**Solution:**
```powershell
# WRONG
Invoke-WebRequest -Uri "https://example.com/image.jpg" -OutFile "C:\Wallpapers"

# CORRECT
Invoke-WebRequest -Uri "https://example.com/image.jpg" -OutFile "C:\Wallpapers\image.jpg"
```

---

### Issue 3: "Cannot find an object with identity"

**Cause:** User, group, or OU does not exist.

**Solution:** Verify the object exists:
```powershell
Get-ADUser -Filter * | Where-Object { $_.SamAccountName -eq "username" }
Get-ADGroup -Filter * | Where-Object { $_.Name -eq "GroupName" }
Get-ADOrganizationalUnit -Filter * | Where-Object { $_.Name -eq "OUName" }
```

---

### Issue 4: GPO not applying to client

**Cause:** GPO not linked, or client hasn't updated policy.

**Solution:**
```powershell
# On DC: Verify GPO is linked
Get-GPO -Name "GPO_Name"
Get-GPInheritance -Target "OU=OU_Name,DC=home,DC=lab"

# On Client: Force update
gpupdate /force
gpresult /r
```

---

### Issue 5: Client cannot join domain

**Cause:** DNS not pointing to DC.

**Solution:** Set DNS to DC IP:
```powershell
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "192.168.0.10"
```

---

### Issue 6: Domain controller not reachable

**Cause:** Network misconfiguration or firewall.

**Solution:**
```powershell
# Ping DC
ping 192.168.0.10

# Check DNS
nslookup home.lab

# Verify services
Get-Service -Name NTDS
Get-Service -Name DNS
```

---

## Quick Reference Commands

| Issue | Command |
|---|---|
| Check AD services | `Get-Service -Name NTDS, DNS` |
| Check domain | `Get-ADDomain` |
| Check user | `Get-ADUser -Identity username` |
| Check group | `Get-ADGroup -Identity groupname` |
| Check GPO | `Get-GPO -All` |
| Force GPO update | `gpupdate /force` |
| Check applied GPOs | `gpresult /r` |