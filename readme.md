# 📱 Todo Task Manager - Hackathon Submission

A sleek and intuitive cross-platform Todo Task Management Mobile Application built with **Flutter**, allowing users to log in with **Google authentication** and manage tasks efficiently with full CRUD operations, filters, animations, and clean UI.

---

This project is a part of a hackathon run by https://www.katomaran.com 

---

## 🚀 Features

### ✅ Authentication
- Google Sign-In with error handling for failed login attempts.
- Secure token storage and logout flow.

### 📝 Task Management
- Create, Read, Update, Mark as Complete, and Delete tasks.
- Each task contains:
  - `Title`
  - `Description`
  - `Due Date`
  - `Status` (open/complete)
- Task data is managed in app state for the session.

### 🎨 User Experience
- Tab-based UI to filter tasks (All, Open, Completed).
- Search functionality to quickly locate tasks.
- No-data placeholders with clean visuals.
- Floating Action Button (FAB) to add new tasks.
- Smooth animations on task actions (add, delete, complete).
- Pull-to-refresh and swipe-to-delete support.

### 📱 Tech Stack
- **Frontend**: Flutter (Dart)
- **Backend**: Firebase (Authentication & optional Crashlytics)
- **Authentication**: Google OAuth
- **State Management**: Provider
- **Crash Reporting**: Firebase Crashlytics (optional)

---

## 🛠️ Installation

### Prerequisites
- Flutter SDK installed
- Android Studio or VS Code
- Google Firebase Project

### Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/devikacv20/todo-task-manager.git
   cd todo-task-manager
