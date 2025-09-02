#!/bin/bash
#
# RavenCraft:NightJAR Password Security Generator v1.2 (Final)
# A professional password and passphrase generator for Debian-based systems.
# Aligned with ACSC & Cyber Wardens security principles.
#
# Copyright (c) 2025 Tapiwa Alexander Shumba aka 'D3rRav3n'
# Githhub Link: https://github.com/D3rRav3n
# LinkedIn: https://www.linkedin.com/in/tapiwa-alexander-shumba-a26258272/
#
# --- Core Logic & ACSC Referencing ---
# URL: https://www.cyber.gov.au/protect-yourself/securing-your-accounts/passphrases
#
# --- Dependencies Check ---
# Ensure zenity and xclip are installed.
if ! command -v zenity &> /dev/null || ! command -v xclip &> /dev/null; then
    zenity --error --title="Dependency Error" --text="Required tools 'zenity' and 'xclip' are not installed.\nPlease install them using:\n\nsudo apt-get update && sudo apt-get install zenity xclip"
    exit 1
fi

# --- Wordlist for Passphrase Generation ---
# A safe, small list of simple words.
WORDLIST=("apple" "breeze" "cloud" "dragon" "eagle" "forest" "glacier" "harvest" "island" "jungle" "knight" "lunar" "mystic" "ocean" "phoenix" "quiver" "river" "storm" "tablet" "unity" "vortex" "whisper" "xebec" "yonder" "zenith")

# --- Functions ---

# Function to display the help file in its own window
# This function is now designed to run independently
show_help() {
    zenity --text-info --title="📚 Help & Guidance" --width=600 --height=400 \
    --filename=<(echo "
    ## RavenCraft:NightJAR Password Security Generator
    
    This tool embodies the core principles of the Cyber Wardens program: simplifying cybersecurity for everyone. 
    It generates strong, random passwords and passphrases based on current best practices.

    ### Password Categories
    Choose the category that best fits your account. The recommended lengths are based on Australian Cyber Security Centre (ACSC) guidelines.

    - **🔐 Password (15+ chars):** Ideal for most new accounts. A mix of letters, numbers, and symbols for high-entropy security.
    - **🔑 Passphrase (3-4+ words):** A set of random words that are easy to remember but incredibly hard for a computer to guess. Recommended by ACSC for memorability.
    - **🔢 PIN Code:** A numerical-only code for devices, bank cards, or other systems with number-only requirements.

    ### Cyber Wardens Principles
    - **Simplicity:** We remove the guesswork with clear, categorized options.
    - **Focus on High-Impact Actions:** Creating a strong password is one of the most effective steps you can take.
    - **Encourage Good Habits:** This tool promotes the use of unique, strong passwords for every account.

    **Always use a password manager** to store your generated passwords securely.
    ")
}

# Function to generate a random password
generate_password() {
    local length=$1
    tr -dc '[:graph:]' < /dev/urandom | head -c "$length"
}

# Function to generate a passphrase
generate_passphrase() {
    local num_words=$1
    local passphrase=""
    local word_count=${#WORDLIST[@]}

    for (( i=0; i<$num_words; i++ )); do
        random_index=$(( RANDOM % word_count ))
        passphrase+="${WORDLIST[$random_index]}"
        if [ $i -lt $((num_words - 1)) ]; then
            passphrase+="-" # Use a hyphen for readability
        fi
    done
    echo "$passphrase"
}

# Function to generate a PIN code
generate_pin() {
    local length=$1
    tr -dc '0-9' < /dev/urandom | head -c "$length"
}

# --- Main Script Loop ---
while true; do

    # 1. Main menu with enhanced descriptions and a help button
    CHOICE=$(zenity --list --radiolist --title="RavenCraft:NightJAR ⚙️" --text="Choose a generator profile:" \
        --extra-button="📚 Help" \
        --column="Select" --column="Profile" --column="Description" \
        FALSE "Password" "🔐 High-entropy, 15+ characters" \
        FALSE "Passphrase" "🔑 Easy to remember, multi-word" \
        FALSE "PIN Code" "🔢 Numeric-only code" \
        --width=550 --height=280)
    
    ZENITY_EXIT_CODE=$?

    # Check which button was pressed
    if [ "$ZENITY_EXIT_CODE" -eq 2 ]; then
        # Run help in a subshell, then continue the loop.
        ( show_help )
        continue
    elif [ "$ZENITY_EXIT_CODE" -ne 0 ]; then
        zenity --info --title="👋 Farewell" --text="Thank you for using RavenCraft:NightJAR. Stay secure."
        exit 0
    fi
    
    # Check if a choice was made
    if [ -z "$CHOICE" ]; then
        zenity --info --title="No Selection" --text="Please make a selection to continue."
        continue
    fi

    # 2. Handle the user's choice
    case "$CHOICE" in
        "Password")
            FINAL_LENGTH=$(zenity --entry --title="🔐 Password Length" --text="Enter desired password length (min. 15):" --entry-text="15")
            if ! [[ "$FINAL_LENGTH" =~ ^[0-9]+$ ]] || [ "$FINAL_LENGTH" -lt 15 ]; then
                zenity --error --title="Invalid Input" --text="Invalid length. Using default 15."
                FINAL_LENGTH=15
            fi
            GENERATED=$(generate_password "$FINAL_LENGTH")
            ;;
        "Passphrase")
            NUM_WORDS=$(zenity --entry --title="🔑 Passphrase Words" --text="Enter desired number of words (min. 3):" --entry-text="4")
            if ! [[ "$NUM_WORDS" =~ ^[0-9]+$ ]] || [ "$NUM_WORDS" -lt 3 ]; then
                zenity --error --title="Invalid Input" --text="Invalid number. Using default 4."
                NUM_WORDS=4
            fi
            GENERATED=$(generate_passphrase "$NUM_WORDS")
            ;;
        "PIN Code")
            PIN_LENGTH=$(zenity --entry --title="🔢 PIN Length" --text="Enter desired PIN length (min. 4):" --entry-text="6")
            if ! [[ "$PIN_LENGTH" =~ ^[0-9]+$ ]_] || [ "$PIN_LENGTH" -lt 4 ]; then
                zenity --error --title="Invalid Input" --text="Invalid length. Using default 6."
                PIN_LENGTH=6
            fi
            GENERATED=$(generate_pin "$PIN_LENGTH")
            ;;
        *)
            zenity --info --title="No Selection" --text="Please make a selection to continue."
            continue
            ;;
    esac

    # 3. Display and copy the generated string
    echo -n "$GENERATED" | xclip -selection clipboard
    zenity --info --title="✨ Success" --text="<big>Your new ${CHOICE} has been copied to your clipboard.</big>\n\n<b>$GENERATED</b>" --width=500 --height=200

    # 4. Ask the user if they want to continue
    zenity --question --title="Continue?" --text="Would you like to generate another one?" --width=300
    if [ $? -ne 0 ]; then
        zenity --info --title="👋 Farewell" --text="Thank you for using RavenCraft:NightJAR. Stay secure."
        break
    fi

done

exit 0