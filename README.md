 Journal 📖✨

**Journal** is a modern, elegant, and minimalist iOS journaling application built entirely in **SwiftUI** using a strict **MVVM (Model-View-ViewModel)** architecture. It allows users to capture their thoughts, manage daily entries, bookmark memories, and search through logs seamlessly with a custom dark-mode aesthetic.

---

 🎨 Design System & Color Palette

Journal features a custom-crafted dark theme design system defined by precise hex code extensions:

| Element | Color Role | Hex Code |
| :--- | :--- | :--- |
| **Primary / Accent** | Interactive elements & highlights | `#7F81FF` |
| **Text / Accent** | Titles & secondary accents | `#AF99FD` |
| **Text / Primary** | Main body content | `#FFFFFF` |
| **Text / Secondary** | Dates, captions, & placeholders | `#A39A9A` |
| **Surface / Card** | Card backgrounds & menus | `#1C1C1E` |
| **Background / Primary** | App background | `#000000` |
| **Semantic / Destructive** | Swipe-to-delete actions | `#FD453C` |

---

✨ Features

- **Splash & Empty States:** Custom loading launch screen and dynamic empty state illustrations (`firstp` & `secp`).
- **Full CRUD Support:** Add, edit, view, and delete journal entries dynamically through intuitive modal sheets.
- **Bookmarks & Filtering:** Easily bookmark important entries and sort your journal list by date or bookmarks.
- **Instant Search:** Floating bottom search bar with real-time text matching.
- **Safety Checks:** Built-in alert confirmation when attempting to discard edits on unsaved journal entries.

---

📂 Project Architecture (MVVM)

The project is organized into structured folders for clean separation of concerns:

```text
JournalP/
│
├── MyApp.swift            # App entry point
├── Assets.xcassets        # Custom color sets & images
│
├── Models/
│   └── JournalEntry.swift # Data structure for journal entries
│
├── ViewModels/
│   └── JournalViewModel.swift # App state, sorting, and filtering logic
│
└── Views/
    ├── SplashView.swift   # Animated startup screen
    ├── MainView.swift     # Core dashboard, list view, and floating search bar
    └── AddEditJournalView.swift # Modal sheet for creating/editing entries

  ---

 🚀 Getting Started

### Prerequisites
* **Xcode 15+**
* **iOS 17+** Simulator or physical device

### Installation & Running
1. **Clone the repository** or open the project folder in Xcode.
2. **Ensure all custom assets** (`firstp` and `secp`) are present in your `Assets.xcassets`.
3. **Select your target simulator** (e.g., iPhone 17).
4. **Press `Cmd + R`** to build and run the app!

---





