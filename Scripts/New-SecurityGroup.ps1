<#
.SYNOPSIS
    Creates a new Security Group in Active Directory
.DESCRIPTION
    Prompts for group name and OU location, then creates the group.
    Checks if group already exists before creating.
.NOTES
    Author: Clifford Karimi
    Date: Sep 3rd 2026
    Domain: home.lab
#>

Clear-Host
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "        CREATE SECURITY GROUP            " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""

$GroupName = Read-Host "Enter the name for the new Security Group (e.g., Sales_Staff)"

if ([string]::IsNullOrWhiteSpace($GroupName)) {
    Write-Host "❌ No group name entered. Script cancelled." -ForegroundColor Red
    exit
}

# Check if Group already exists
$ExistingGroup = Get-ADGroup -Filter "Name -eq '$GroupName'" -ErrorAction SilentlyContinue

if ($ExistingGroup) {
    Write-Host ""
    Write-Host "⚠️ Security Group '$GroupName' already exists!" -ForegroundColor Yellow
    Write-Host "   DistinguishedName: $($ExistingGroup.DistinguishedName)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "No changes made." -ForegroundColor Cyan
    exit
}

Write-Host ""
Write-Host "Existing OUs:" -ForegroundColor Cyan
Get-ADOrganizationalUnit -Filter * | Format-Table Name -AutoSize
Write-Host ""

$OUName = Read-Host "Enter the OU where this group should be created (e.g., HR_Department)"

if ([string]::IsNullOrWhiteSpace($OUName)) {
    Write-Host "❌ No OU entered. Script cancelled." -ForegroundColor Red
    exit
}

# Verify OU exists
$ExistingOU = Get-ADOrganizationalUnit -Filter "Name -eq '$OUName'" -ErrorAction SilentlyContinue
if (-not $ExistingOU) {
    Write-Host "❌ OU '$OUName' does not exist. Please create it first." -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "You are about to create: $GroupName in OU=$OUName" -ForegroundColor Yellow
$Confirm = Read-Host "Do you want to continue? (Y/N)"

if ($Confirm -ne "Y" -and $Confirm -ne "y") {
    Write-Host "❌ Group creation cancelled." -ForegroundColor Red
    exit
}

try {
    New-ADGroup -Name $GroupName -GroupScope Global -GroupCategory Security -Path "OU=$OUName,DC=home,DC=lab" -ErrorAction Stop
    Write-Host "✅ $GroupName created successfully in OU=$OUName!" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to create $GroupName" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "Current Security Groups:" -ForegroundColor Cyan
Get-ADGroup -Filter * | Where-Object { $_.GroupCategory -eq "Security" } | Format-Table Name -AutoSize