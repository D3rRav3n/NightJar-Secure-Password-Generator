# RavenCraft:NightJAR Password Security Generator v1.0 (PowerShell)
# A professional password and passphrase generator for Windows systems.
# Aligned with ACSC & Cyber Wardens security principles.
#
# Copyright (c) 2025 Tapiwa Alexander Shumba aka 'D3rRav3n'
# Githhub Link: https://github.com/D3rRav3n
# LinkedIn: https://www.linkedin.com/in/tapiwa-alexander-shumba-a26258272/
# Licensed under MIT and CC BY-SA 4.0.
#
# --- Dependencies ---
# This script uses built-in .NET classes and requires PowerShell 5.1+
# No external dependencies needed.

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Wordlist for Passphrase Generation . This can be change to include a larger list as necessary.---
# TODO: Add a wordlist download option to increase the wordlist and possible combine all into a simple concise ditionary file. 
$wordList = @("apple", "breeze", "cloud", "dragon", "eagle", "forest", "glacier", "harvest", "island", "jungle", "knight", "lunar", "mystic", "ocean", "phoenix", "quiver", "river", "storm", "tablet", "unity", "vortex", "whisper", "xebec", "yonder", "zenith")

# --- Generator Functions ---
function Generate-Password {
    param([int]$Length)
    $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|;':,.<>/?`~"
    $password = ""
    for ($i = 0; $i -lt $Length; $i++) {
        $password += $chars[(Get-Random -Maximum $chars.Length)]
    }
    return $password
}

function Generate-Passphrase {
    param([int]$NumWords)
    $passphrase = ""
    for ($i = 0; $i -lt $NumWords; $i++) {
        $passphrase += $wordList[(Get-Random -Maximum $wordList.Count)]
        if ($i -lt ($NumWords - 1)) {
            $passphrase += "-"
        }
    }
    return $passphrase
}

function Generate-PIN {
    param([int]$Length)
    $chars = "0123456789"
    $pin = ""
    for ($i = 0; $i -lt $Length; $i++) {
        $pin += $chars[(Get-Random -Maximum $chars.Length)]
    }
    return $pin
}

# --- GUI Logic ---
function Show-PasswordGeneratorUI {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "RavenCraft:NightJAR ⚙️"
    $form.Size = New-Object System.Drawing.Size(450, 250)
    $form.StartPosition = 'CenterScreen'

    $font = New-Object System.Drawing.Font("Segoe UI", 12)

    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Choose a generator profile:"
    $label.Location = New-Object System.Drawing.Point(10, 10)
    $label.Size = New-Object System.Drawing.Size(400, 30)
    $label.Font = $font
    $form.Controls.Add($label)

    $buttonPassword = New-Object System.Windows.Forms.Button
    $buttonPassword.Text = "🔐 Password"
    $buttonPassword.Location = New-Object System.Drawing.Point(150, 50)
    $buttonPassword.Size = New-Object System.Drawing.Size(150, 40)
    $buttonPassword.Font = $font
    $form.Controls.Add($buttonPassword)
    
    $buttonPassphrase = New-Object System.Windows.Forms.Button
    $buttonPassphrase.Text = "🔑 Passphrase"
    $buttonPassphrase.Location = New-Object System.Drawing.Point(150, 100)
    $buttonPassphrase.Size = New-Object System.Drawing.Size(150, 40)
    $buttonPassphrase.Font = $font
    $form.Controls.Add($buttonPassphrase)

    $buttonPIN = New-Object System.Windows.Forms.Button
    $buttonPIN.Text = "🔢 PIN Code"
    $buttonPIN.Location = New-Object System.Drawing.Point(150, 150)
    $buttonPIN.Size = New-Object System.Drawing.Size(150, 40)
    $buttonPIN.Font = $font
    $form.Controls.Add($buttonPIN)

    $buttonHelp = New-Object System.Windows.Forms.Button
    $buttonHelp.Text = "📚 Help"
    $buttonHelp.Location = New-Object System.Drawing.Point(10, 190)
    $buttonHelp.Size = New-Object System.Drawing.Size(100, 30)
    $buttonHelp.Font = $font
    $form.Controls.Add($buttonHelp)

    $buttonExit = New-Object System.Windows.Forms.Button
    $buttonExit.Text = "👋 Exit"
    $buttonExit.Location = New-Object System.Drawing.Point(320, 190)
    $buttonExit.Size = New-Object System.Drawing.Size(100, 30)
    $buttonExit.Font = $font
    $form.Controls.Add($buttonExit)

    $buttonPassword.Add_Click({
        $length = [Microsoft.VisualBasic.Interaction]::InputBox("Enter desired password length (min. 15):", "Password Length", "15")
        if ([string]::IsNullOrEmpty($length) -or ![int]::TryParse($length, [ref]$null) -or [int]$length -lt 15) {
            $length = 15
            [System.Windows.Forms.MessageBox]::Show("Invalid length. Using default 15.", "Invalid Input", 0, [System.Windows.Forms.MessageBoxIcon]::Warning)
        }
        $password = Generate-Password -Length [int]$length
        Set-Clipboard -Value $password
        [System.Windows.Forms.MessageBox]::Show("Your new password has been copied to your clipboard.`n`n$password", "✨ Success", 0, [System.Windows.Forms.MessageBoxIcon]::Information)
    })
    
    $buttonPassphrase.Add_Click({
        $numWords = [Microsoft.VisualBasic.Interaction]::InputBox("Enter desired number of words (min. 3):", "Passphrase Words", "4")
        if ([string]::IsNullOrEmpty($numWords) -or ![int]::TryParse($numWords, [ref]$null) -or [int]$numWords -lt 3) {
            $numWords = 4
            [System.Windows.Forms.MessageBox]::Show("Invalid number. Using default 4.", "Invalid Input", 0, [System.Windows.Forms.MessageBoxIcon]::Warning)
        }
        $passphrase = Generate-Passphrase -NumWords [int]$numWords
        Set-Clipboard -Value $passphrase
        [System.Windows.Forms.MessageBox]::Show("Your new passphrase has been copied to your clipboard.`n`n$passphrase", "✨ Success", 0, [System.Windows.Forms.MessageBoxIcon]::Information)
    })

    $buttonPIN.Add_Click({
        $length = [Microsoft.VisualBasic.Interaction]::InputBox("Enter desired PIN length (min. 4):", "PIN Length", "6")
        if ([string]::IsNullOrEmpty($length) -or ![int]::TryParse($length, [ref]$null) -or [int]$length -lt 4) {
            $length = 6
            [System.Windows.Forms.MessageBox]::Show("Invalid length. Using default 6.", "Invalid Input", 0, [System.Windows.Forms.MessageBoxIcon]::Warning)
        }
        $pin = Generate-PIN -Length [int]$length
        Set-Clipboard -Value $pin
        [System.Windows.Forms.MessageBox]::Show("Your new PIN has been copied to your clipboard.`n`n$pin", "✨ Success", 0, [System.Windows.Forms.MessageBoxIcon]::Information)
    })

    $buttonHelp.Add_Click({
        [System.Windows.Forms.MessageBox]::Show("
RavenCraft:NightJAR Password Security Generator
    
This tool embodies the core principles of the Cyber Wardens program: simplifying cybersecurity for everyone. 
It generates strong, random passwords and passphrases based on current best practices.

### Password Categories
Choose the category that best fits your account. The recommended lengths are based on Australian Cyber Security Centre (ACSC) guidelines.

- 🔐 Password (15+ chars): Ideal for most new accounts. A mix of letters, numbers, and symbols for high-entropy security.
- 🔑 Passphrase (3-4+ words): A set of random words that are easy to remember but incredibly hard for a computer to guess. Recommended by ACSC for memorability.
- 🔢 PIN Code: A numerical-only code for devices, bank cards, or other systems with number-only requirements.

### Cyber Wardens Principles
- Simplicity: We remove the guesswork with clear, categorized options.
- Focus on High-Impact Actions: Creating a strong password is one of the most effective steps you can take.
- Encourage Good Habits: This tool promotes the use of unique, strong passwords for every account.

Always use a password manager to store your generated passwords securely.
        ", "📚 Help & Guidance")
    })

    $buttonExit.Add_Click({ $form.Close() })

    $form.ShowDialog() | Out-Null
}

Show-PasswordGeneratorUI