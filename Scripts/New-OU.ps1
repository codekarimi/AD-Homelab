<#
.SYNOPSIS
    Creates a new Organizational Unit in Active Directory
.DESCRIPTION
    Prompts for OU name and creates it in the domain.
    Checks if OU already exists before creating.
.NOTES
    Author: Clifford Karimi
    Date: Sep 3rd 2026
    Domain: home.lab
#>

Clear-Host
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "        CREATE ORGANIZATIONAL UNIT       " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""

$OUName = Read-Host "Enter the name for the new OU (e.g., Sales_Department)"

if ([string]::IsNullOrWhiteSpace($OUName)) {
    Write-Host "❌ No OU name entered. Script cancelled." -ForegroundColor Red
    exit
}

# Check if OU already exists
$ExistingOU = Get-ADOrganizationalUnit -Filter "Name -eq '$OUName'" -ErrorAction SilentlyContinue

if ($ExistingOU) {
    Write-Host ""
    Write-Host "⚠️ OU '$OUName' already exists!" -ForegroundColor Yellow
    Write-Host "   DistinguishedName: $($ExistingOU.DistinguishedName)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "No changes made." -ForegroundColor Cyan
    exit
}

Write-Host ""
Write-Host "You are about to create: $OUName" -ForegroundColor Yellow
$Confirm = Read-Host "Do you want to continue? (Y/N)"

if ($Confirm -ne "Y" -and $Confirm -ne "y") {
    Write-Host "❌ OU creation cancelled." -ForegroundColor Red
    exit
}

try {
    New-ADOrganizationalUnit -Name $OUName -Path "DC=home,DC=lab" -ErrorAction Stop
    Write-Host "✅ $OUName created successfully!" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to create $OUName" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "Current OUs:" -ForegroundColor Cyan
Get-ADOrganizationalUnit -Filter * | Format-Table Name -AutoSize