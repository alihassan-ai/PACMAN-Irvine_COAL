# 🎮 ByteRunner: Assembly Language Pac-Man Clone

Welcome to **ByteRunner** — a modern and meme-fueled take on the classic Pac-Man game, written entirely in **x86 Assembly Language** using the **Irvine32 library**. Designed for students, hackers, and retro enthusiasts, ByteRunner blends nostalgia with Indian meme culture and humor.

---

## 🚀 Features

- 👾 Maze-based gameplay with collectible coins
- 💀 Ghosts and power-ups to keep you on your toes
- 🔊 **Hindi meme sound effects** integrated for every major event
- 🌈 Colorful GUI interface with HUD panel for Score, Lives, and Level
- 🧠 Completely written in **low-level Assembly**, demonstrating memory and input handling
- 📁 Compatible with **Visual Studio + Irvine32 library setup**

---

## 🛠 Requirements

- Windows OS
- Visual Studio with MASM support
- Irvine32 Library (add to `C:\Irvine` or modify include paths)
- `.wav` files in the same folder as the `.asm` file

---

## 🎮 Controls

| Key | Action           |
|-----|------------------|
| W   | Move Up          |
| A   | Move Left        |
| S   | Move Down        |
| D   | Move Right       |
| O   | Ghost immunity   |
| L   | Extra life       |
| P   | Pause Game       |
| Esc | Exit Game        |

---

## 📂 Folder Structure

```
Final Project/
│
├── byterunner.asm               # Main source code
├── *.wav                        # All meme sound effects
├── score.txt                    # High score tracking
├── Final Project.sln            # Visual Studio solution file
├── Debug/                       # Compiled .exe and temp files
└── README.md                    # You're reading it!
```

---

## 📸 Screenshots

> _"Score: 50 | Lives: ♥♥ | Level: 2"_  
> ! Player in cyan, ghosts in magenta, and coins as blinking dots.

---

## 🎵 Recommended Meme Sounds

Replace default `.wav` files with your favorite:
- **startsound.wav** → "Indian Intro Meme"
- **deadsound.wav** → "Hey Bhagwan Kya Zulum Hai"
- **arcadesound.wav** → "Dhakatiki Dhakatiki"

Check out [Voicy](https://www.voicy.network/official-soundboards/meme/hindi-memes) or [Geno Meme Soundboard](https://geno.fineshare.com/soundboards/indian-meme/) for fun clips.

---

## ⚠️ Notes

- All logic is written using `Irvine32.inc`
- Uses `PlaySound` from `Winmm.lib` to play audio
- Ensure `.wav` files are in correct format (PCM, uncompressed)

---

## 📜 License

This project is open-source and educational. Use it to learn, remix, and submit — responsibly 😉

---

Made with ❤️ and low-level madness by Ali Hassan
