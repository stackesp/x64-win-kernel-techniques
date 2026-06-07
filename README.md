# Assembly Malware Research

a collection of x64 assembly utilities for educational malware research and reverse engineering. includes low-level Windows internals techniques such as kernel32 base resolution and manual PE export table parsing.

## Purpose

this repository contains reusable x64 assembly snippets and techniques commonly used in malware analysis, reverse engineering, and security research.
made specifially for re-using and not re-inventing the wheel.

## Contents

### GetKernel32Base
resolves the base address of kernel32.dll using peb walking, done via `gs:0x60`

### FindExport
manually parses the PE export table to locate and resolve a function by name within a loaded DLL

## Building

assembling:
```bash
nasm -f win64 -o source.asm
gcc source.obj -o stub.exe -luser32 -lkernel32
