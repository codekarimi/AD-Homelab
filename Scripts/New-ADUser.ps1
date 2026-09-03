<#
.SYNOPSIS
    Creates a new Active Directory user with prompts
.DESCRIPTION
    Prompts for First Name, Last Name, Username, and Password.
    Checks if user already exists before creating.
.NOTES
    Author: Clifford Karimi
    Date: Sep 3rd 2026
    Domain: home.lab
#>

Clear-Host
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "        CREATE ACTIVE DIRECTORY USER     " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""

# Collect user information
$FirstName = Read-Host "Enter First Name"
if ([string]::IsNullOrWhiteSpace($FirstName)) {
    Write-Host "❌ First Name required. Script cancelled." -ForegroundColor Red
    exit
}

$LastName = Read-Host "Enter Last Name"
if ([string]::IsNullOrWhiteSpace($LastName)) {
    Write-Host "❌ Last Name required. Script cancelled." -ForegroundColor Red
    exit
}

$Username = Read-Host "Enter Username (e.g., jdoe)"
if ([string]::IsNullOrWhiteSpace($Username)) {
    Write-Host "❌ Username required. Script cancelled." -ForegroundColor Red
    exit
}

# Check if user already exists
$ExistingUser = Get-ADUser -Filter "SamAccountName -eq '$Username'" -ErrorAction SilentlyContinue

if ($ExistingUser) {
    Write-Host ""
    Write-Host "⚠️ User '$Username' already exists!" -ForegroundColor Yellow
    Write-Host "   Full Name: $($ExistingUser.Name)" -ForegroundColor Yellow
    Write-Host "   DistinguishedName: $($ExistingUser.DistinguishedName)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "No changes made." -ForegroundColor Cyan
    exit
}

$FullName = "$FirstName $LastName"

Write-Host ""
Write-Host "Existing OUs:" -ForegroundColor Cyan
Get-ADOrganizationalUnit -Filter * | Format-Table Name -AutoSize
Write-Host ""

$OU = Read-Host "Enter OU where user should be created (e.g., HR_Department)"
if ([string]::IsNullOrWhiteSpace($OU)) {
    Write-Host "❌ OU required. Script cancelled." -ForegroundColor Red
    exit
}

# Verify OU exists
$ExistingOU = Get-ADOrganizationalUnit -Filter "Name -eq '$OU'" -ErrorAction SilentlyContinue
if (-not $ExistingOU) {
    Write-Host "❌ OU '$OU' does not exist. Please create it first." -ForegroundColor Red
    exit
}

# Password
Write-Host ""
$Password = Read-Host "Enter Password" -AsSecureString

Write-Host ""
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "        CONFIRM USER DETAILS             " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "Full Name: $FullName"
Write-Host "Username: $Username"
Write-Host "Email: $Username@home.lab"
Write-Host "OU: $OU"
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""

$Confirm = Read-Host "Create this user? (Y/N)"

if ($Confirm -ne "Y" -and $Confirm -ne "y") {
    Write-Host "❌ User creation cancelled." -ForegroundColor Red
    exit
}

try {
    New-ADUser -Name $FullName `
               -GivenName $FirstName `
               -Surname $LastName `
               -SamAccountName $Username `
               -UserPrincipalName "$Username@home.lab" `
               -Path "OU=$OU,DC=home,DC=lab" `
               -AccountPassword $Password `
               -Enabled $true `
               -ErrorAction Stop
    
    Write-Host ""
    Write-Host "✅ User $FullName ($Username) created successfully!" -ForegroundColor Green
    Write-Host "   Email: $Username@home.lab" -ForegroundColor Green
    Write-Host "   OU: $OU" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to create user" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "Users in $OU:" -ForegroundColor Cyan
Get-ADUser -Filter * -SearchBase "OU=$OU,DC=home,DC=lab" | Format-Table Name, SamAccountName, Enabled -AutoSize