# Pandanda Private Server Setup Guide

## Prerequisites
- Windows operating system
- [XAMPP](https://www.apachefriends.org/) installed
- [Flash Browser](https://github.com/radubirsan/FlashBrowser/releases/tag/v0.81) (for playing the game)

## Installation Steps

### 1. Set Up Web and Database Servers
1. Launch XAMPP Control Panel
2. Start the `Apache` and `MySQL` services

### 2. Import the Database
1. Open phpMyAdmin by navigating to [http://localhost/phpmyadmin/](http://localhost/phpmyadmin/)
2. Create a new database named `pandanda`
3. Import the `pandanda.sql` file (located in `Utils/Database`) into this new database
   - This will set up your Database

### 3. Set Up the Media Server
1. Clear all existing files in `C:\xampp\htdocs\`
2. Copy all files from the `MediaServer` folder into `C:\xampp\htdocs\`
   - This will set up your Media Server

### 4. Start the SmartFox Server
1. Run `start.bat` from the `SFSServer` folder
   - This will launch the SmartFox server with all server-side code

## Create Your Account
1. Navigate to: [http://localhost/register.php](http://localhost/register.php) or use the in-game register
2. Register a new account

## Play the Game
1. Open Flash Browser
2. Navigate to: [http://localhost/](http://localhost/)
3. Enjoy your private Pandanda server!

## Troubleshooting
- If you encounter issues, ensure:
  - All services are running in XAMPP
  - The database was imported correctly
  - All files were copied to the correct location

---

# Start Working On The Files

## Prerequisites

Before starting, ensure you have the following tools installed:

1. **Python**
   - Download from [python.org](https://www.python.org/).
   - When installing, **make sure to check** "Add python.exe to PATH" to avoid potential issues.

2. **JPEXS Free Flash Decompiler**
   - Download from [GitHub](https://github.com/jindrapetrik/jpexs-decompiler/releases).
   - This tool is required to decompile SWF files.

---

## Configure the Game

**Edit `pandanda.swf`**
   - Open `pandanda.swf` with JPEXS.
   - Use the text search tool (top bar) to search for the original domain (e.g., `localhost`).
   - Edit the domain string to your domain if you plan to host this files somewhere else.
     - Because this file contains obfuscated code, use the **right editor**. The right editor is only needed for this file!.
     - Click "Edit P code" to make the change.
   - Save the file, and on the top toolbar click save again, than close JPEXS.

---

## Edit Another File

1. **Decrypt SWF Files**
   - Use the `dectool.py` script to decrypt them:
     - Place the SWF file (e.g., `UI/game_ui.swf`) in the same folder as `dectool.py`.
     - Run the script to generate a decrypted file ending in `.dec.swf`.

2. **Edit SWF Files**
   - Open the decrypted SWF file with JPEXS.
   - For example, try to change the "Friends" string to "Liabilities":
     - Use the global search tool to locate "Friends".
     - Edit the string in the appropriate file (e.g., `PlayerCard`).
     - Save the changes and close JPEXS.

3. **Re-Encrypt the File**
   - Run the `dectool.py` script again to re-encrypt the file.
   - Replace the old SWF file in your base game with the newly modified version.

---

## Extra

- The `config/client` in the database is base64 encoded. Use the **file** encoder/decoder from [base64decode.org](https://www.base64decode.org/).
- Most of the Server Side code you will care about is inside `SFSServer\sfsExtensions`
- If changes don't appear in your game try to clear the cache.
- If you want to use a client rather than Flash Browser simply modify an already existing one (e.g., from a Club Penguin server) to point to your domain (e.g., http://localhost/)
- If you plan to host this files on a server rather than `localhost` you will need to modify mostly `pandanda.swf`, `pandandaLogin.swf` and `config.xml (from both Media Server and SFS Server` 
- The server can be started on a linux server using `start.sh` instead of `start.bat`

# Project Notes

## PRs / Community Contributions Needed

- Line Four / Pig Pen Minigame Integration
- In-built Reporting System
- Buddy Icon showing for server with friends online
- New/Custom Room Creation toolkit?

## Contributions

Pandanda Rewritten 
   - Implemented the original in-game register.
   - Hashing for IP addresses

iPandanda
   - Original Media Server assets

## Current State

This is a basic functioning Pandanda Server, It runs everything bar minigames works. Any additional work would be specific to your own creation or community contribution.

## Disclaimers
- This repository stands to be a public archive/asset for anyone wanting to create a Pandanda Server
- This repository is placed in the public domain and will be maintained based off enhancements from Pandanda Rewritten and any community contirbutions

If you find this project useful and build upon it, please consider submitting a pull request with your improvements so the whole community can benefit from them. 
Huge thanks to everyone involved in making this a reality!
