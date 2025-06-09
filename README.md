🐤 FlappyQ — Flappy Bird in Assembly
A throwback-style clone of the iconic Flappy Bird — built from scratch in pure x86 Assembly. No game engines. No frameworks. Just raw Assembly power.
This project was developed as part of a 3rd Semester project of COAL Course in FAST-LHR.

🎮 What is it?
A simple terminal-based Flappy Bird game, coded in x86 Assembly, demonstrating direct hardware interaction, graphics programming, and real-time input handling — all the fun stuff you'd never expect to do in Assembly.

🛠 Built With
x86 Assembly (MASM / TASM)

DOSBox for running in modern systems

Love, sweat, and tons of debugging

👨‍💻 Developers
Qatada – 23L-0998
Saad Zafar – 23L-0829

🚀 How to Run
Follow these steps to compile and run the game:

Option 1: Using TASM + DOSBox
Install DOSBox
Download from https://www.dosbox.com/

Place Files
Put flappyq.asm in a directory you'll mount in DOSBox.

Start DOSBox and mount your folder:

bash
Copy
Edit
mount C C:\path\to\your\flappyq
C:
Compile the Assembly Code:

bash
Copy
Edit
tasm flappyq.asm
tlink flappyq.obj
Run the Game:

bash
Copy
Edit
flappyq.exe

⚠️ This game is meant to run in real mode, so using a DOS environment (like DOSBox) is highly recommended.

⚡ Gameplay
Press Spacebar/Up Key to flap

Avoid the pipes

Try not to rage quit
