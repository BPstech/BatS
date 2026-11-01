# BatS

A collection of lightweight Windows batch (`.bat`) scripts to automate file organization, CAD/engineering project scaffolding, and Git workflows.

---

## Scripts Overview

| Script | Description |
| :--- | :--- |
| **`Arrange.bat`** | Comprehensive file sorter. Automatically organizes loose files into categorized folders (`Images`, `Videos`, `Audio`, `Documents`, `Archives`, `Installers`, `Code`, `Fonts`, etc.). |
| **`organize.bat`** | Lightweight alternative file sorter for grouping media, documents, archives, and executables into standard directories. |
| **`create_project_structure.bat`** | Scaffolds a standardized mechanical/CAD design directory structure (`01_References`, `02_Parts`, `03_Assemblies`, `04_Drawings`, `05_Exports`, `06_Simulation`, `99_Old_Versions`). |
| **`GitHub_Quick_Push.bat`** | Interactive Git helper. Checks prerequisites (`git`, `gh` via `winget`), initializes repositories, and automates staging, committing, and pushing to GitHub. |
| **`ranSys.bat`** | Looping utility that launches core Windows system utilities (`msinfo32`, `calc`, `mspaint`, `explorer`) at 5-second intervals. |

---

## Quick Start

1. **File Organization (`Arrange.bat` / `organize.bat`):**  
   Copy the script into the target directory (e.g., your `Downloads` folder) and execute it to categorize files by extension.

2. **Project Scaffolding (`create_project_structure.bat`):**  
   Run inside a new project root folder to generate standard CAD/engineering subdirectories.

3. **Git Quick Push (`GitHub_Quick_Push.bat`):**  
   Run from the repository root to check dependencies and push your changes interactively.

---

> [!CAUTION]
> **`ranSys.bat`** runs in an infinite loop until manually stopped. Terminate it by pressing `Ctrl + C` or closing the Command Prompt window.
