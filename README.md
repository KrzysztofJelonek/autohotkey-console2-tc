# autohotkey-console2-tc
Autohotkey / Console2 / Total Commander integration script.  
Opens Console in a Quake style (at the top of the screen using Win+Tilda).  
Based on: http://www.instructables.com/id/%22Drop-Down%22%2c-Quake-style-command-prompt-for-Window/.  
Modified version of [kosciak-autohotkey](https://code.google.com/archive/p/kosciak-autohotkey/).  

Requirements:
Windows 10 64bit, Total Commander 9.10, Console2, Autohotkey

## Shortcuts:
- WIN + ` (tilda) - show / hide Console2
- Total Commander:
  - CTRL + ` (tilda) - open Console2 with current TC path
  - WIN + A (in Console2) - paste current TC path
- Windows Explorer
  - CTRL + ` - open Console2 with current Windows Explorer path

## Software
- Console2: https://sourceforge.net/projects/console/files/latest/download?source=files
- Autohotkey: https://autohotkey.com/ (1.1.26.01 - July 16, 2017)

## Configuration
1. Install [Console2](https://sourceforge.net/projects/console/files/latest/download?source=files).
2. Install [Autohotkey](https://autohotkey.com/download/).
3. Copy console.xml to Console2 app directory.
4. After download .ahk file, just edit constants (CONSOLE_APP_PATH change is required):
```
SetUp:
	DEFAULT_SLEEP = 0
	CONSOLE_PASTE_SLEEP = 200
	CLEAR_SCREEN_AFTER := false
	CONSOLE_APP_PATH := "c:\Software\Console2\Console.exe"
	CONSOLE_CONFIG := "console.xml"
return
```
5. Run .ahk file

## Warning
**Supported version of Total Commander is: 9.10.**
