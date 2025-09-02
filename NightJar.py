#!/usr/bin/env python3
#
# RavenCraft:NightJAR Password Security Generator v1.0 (Python)
# A professional password and passphrase generator for cross-platform use.
# Aligned with ACSC & Cyber Wardens security principles.
# Copyright (c) 2025 Tapiwa Alexander Shumba aka 'D3rRav3n'
# Githhub Link: https://github.com/D3rRav3n
# LinkedIn: https://www.linkedin.com/in/tapiwa-alexander-shumba-a26258272/
# Licensed under MIT and CC BY-SA 4.0.
# --- Dependencies ---
# Python 3.x with tkinter (usually built-in) and pyperclip
# To install pyperclip: pip install pyperclip

import tkinter as tk
from tkinter import simpledialog, messagebox
import random
import string
import sys
import pyperclip

# --- Core Logic & ACSC Referencing ---
# URL: https://www.cyber.gov.au/protect-yourself/securing-your-accounts/passphrases

# --- Wordlist for Passphrase Generation ---
WORDLIST = ["apple", "breeze", "cloud", "dragon", "eagle", "forest", "glacier", "harvest", "island", "jungle", "knight", "lunar", "mystic", "ocean", "phoenix", "quiver", "river", "storm", "tablet", "unity", "vortex", "whisper", "xebec", "yonder", "zenith"]

# --- Generator Functions ---
def generate_password(length):
    chars = string.ascii_letters + string.digits + string.punctuation
    return ''.join(random.choice(chars) for _ in range(length))

def generate_passphrase(num_words):
    passphrase = [random.choice(WORDLIST) for _ in range(num_words)]
    return '-'.join(passphrase)

def generate_pin(length):
    return ''.join(random.choice(string.digits) for _ in range(length))

# --- GUI Logic ---
class App(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("RavenCraft:NightJAR ⚙️")
        self.geometry("450x250")
        self.create_widgets()

    def create_widgets(self):
        tk.Label(self, text="Choose a generator profile:", font=("Helvetica", 14)).pack(pady=10)

        button_frame = tk.Frame(self)
        button_frame.pack(pady=5)

        tk.Button(button_frame, text="🔐 Password", command=self.generate_password_gui, width=20).pack(pady=5)
        tk.Button(button_frame, text="🔑 Passphrase", command=self.generate_passphrase_gui, width=20).pack(pady=5)
        tk.Button(button_frame, text="🔢 PIN Code", command=self.generate_pin_gui, width=20).pack(pady=5)
        tk.Button(self, text="📚 Help", command=self.show_help, width=20).pack(side=tk.LEFT, padx=10)
        tk.Button(self, text="👋 Exit", command=self.quit, width=20).pack(side=tk.RIGHT, padx=10)

    def show_result(self, generated_text, profile):
        pyperclip.copy(generated_text)
        messagebox.showinfo("✨ Success", f"Your new {profile} has been copied to your clipboard.\n\n{generated_text}")

    def generate_password_gui(self):
        length_str = simpledialog.askstring("Password Length", "Enter desired password length (min. 15):", initialvalue="15")
        if length_str and length_str.isdigit():
            length = int(length_str)
            if length < 15:
                messagebox.showwarning("Invalid Input", "Invalid length. Using default 15.")
                length = 15
            password = generate_password(length)
            self.show_result(password, "Password")

    def generate_passphrase_gui(self):
        num_words_str = simpledialog.askstring("Passphrase Words", "Enter desired number of words (min. 3):", initialvalue="4")
        if num_words_str and num_words_str.isdigit():
            num_words = int(num_words_str)
            if num_words < 3:
                messagebox.showwarning("Invalid Input", "Invalid number. Using default 4.")
                num_words = 4
            passphrase = generate_passphrase(num_words)
            self.show_result(passphrase, "Passphrase")

    def generate_pin_gui(self):
        length_str = simpledialog.askstring("PIN Length", "Enter desired PIN length (min. 4):", initialvalue="6")
        if length_str and length_str.isdigit():
            length = int(length_str)
            if length < 4:
                messagebox.showwarning("Invalid Input", "Invalid length. Using default 6.")
                length = 6
            pin = generate_pin(length)
            self.show_result(pin, "PIN Code")

    def show_help(self):
        messagebox.showinfo("📚 Help & Guidance", """
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
""")

if __name__ == "__main__":
    app = App()
    app.mainloop()