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
2. Copy all files from the `SFSServer` folder into `C:\xampp\htdocs\`
   - This will set up your Media Server

### 4. Start the SmartFox Server
1. Run `start.bat` from the `SFSServer` folder
   - This will launch the SmartFox server with all server-side code

## Create Your Account
1. Navigate to: [http://localhost/register.php](http://localhost/register.php)
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

## Development History
This server originated from the basic fPDN implementation with limited functionality. I worked to:

- Implemented *most* features that players expect
- Cleaned up the code
- Reconstructed most of Project Pandanda's modern features

The media server portions largely came from Project Pandanda, with key modifications:
- Restored most of the original branding
- Stripped some encryption to make some files more accessible
- Added some *personal touches*

## Current State
While I tried to bring this project to what I consider a "good enough" state, I only had so much time to work on this so there always remains room for further Improvements.

## Disclaimers
- I will never open a public server
- This repository is neither owned by me nor is gonna be maintained any further
- I have no plan to re-upload this files in the future, so make sure to download them before someone manages to take

If you find this project useful and build upon it, please consider open-sourcing your improvements so the whole community can benefit from them.
Huge thanks to everyone involved in making this a reality!