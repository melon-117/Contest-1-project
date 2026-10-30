# Space Invaders

A classic Space Invaders arcade-style game developed in x86 Assembly using MASM and the Irvine32 library.

Defend against waves of incoming invaders, shoot enemy ships, earn points, and try to survive!

## About the Game

Space Invaders is a console-based recreation of the classic arcade game. The player controls a spaceship at the bottom of the screen and must eliminate the invading enemies while avoiding incoming enemy fire.

The project was developed using 32-bit x86 Assembly (MASM) in Microsoft Visual Studio.

## Features

- **Player Movement:** Move your spaceship left and right across the screen.
- **Shooting Mechanics:** Fire bullets to eliminate incoming invaders.
- **Enemy Movement:** Invaders move across the screen and change direction when reaching the boundaries.
- **Enemy Shooting:** Invaders periodically fire bullets toward the player.
- **Collision Detection:** Detect collisions between player bullets and invaders, as well as enemy bullets and the player.
- **Scoring System:** Earn points by eliminating invaders.
- **Lives System:** Lose lives when hit by enemy bullets.
- **Victory and Game Over Screens:** Win by eliminating all invaders or lose when your lives run out.
- **Colored Graphics:** Different colors distinguish the player, invaders, bullets, and HUD.

## Screenshots

<!-- Add screenshots of your game here -->

### Gameplay
![Gameplay Screenshot]
<img width="1152" height="620" alt="image" src="https://github.com/user-attachments/assets/3830971f-f89e-4abe-91b5-552f0d4d7b7e" />

### Victory Screen
![Victory Screenshot]
<img width="1155" height="617" alt="image" src="https://github.com/user-attachments/assets/e033764e-e5f8-4f5d-969e-34db2333a332" />

### Game Over Screen
![Game Over Screenshot]
<img width="1154" height="620" alt="image" src="https://github.com/user-attachments/assets/5a5c4bf8-c885-43cd-b32e-85d86bc0a1e1" />

## Download and Installation

### Download the Game

[**Download Space Invaders for Windows**](https://github.com/melon-117/Contest-1-project/releases/tag/v1.0)

1. Download the ZIP file from the GitHub Releases page.
2. Extract the downloaded ZIP file.
3. Open the extracted folder.
4. Double-click `Space_Invaders.exe` to start playing.

### System Requirements

- Windows operating system
- 64-bit Windows or Windows capable of running 32-bit applications
- Keyboard

## Controls

| Key | Action |
|---|---|
| A / Left Arrow | Move Left |
| D / Right Arrow | Move Right |
| Spacebar | Shoot |
| Q | Quit Game |

## Technologies Used

- **Assembly Language:** 32-bit x86 MASM
- **IDE:** Microsoft Visual Studio
- **Library:** Irvine32
- **Platform:** Windows

## Building from Source

To build the game from source, you will need:

- Microsoft Visual Studio
- MASM (Microsoft Macro Assembler)
- Irvine32 library
- Win32 build configuration

### Build Instructions

1. Clone or download this repository.
2. Open `Space_Invaders.sln` in Visual Studio.
3. Make sure the MASM build customization is installed.
4. Configure the project for **Release | Win32**.
5. Configure the Irvine32 include and library directories for your local installation.
6. Under **Linker → Advanced**, set **Image Has Safe Exception Handlers** to **No (/SAFESEH:NO)**.
7. Build the solution.
8. Run the generated executable.

## Contributors

Developed as a collaborative programming project.

- [Melon-117]
- [Endrf]

