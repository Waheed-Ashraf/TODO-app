# Kanban Board — Mini-ERP (Flutter)

[**⬇️ APK**](https://drive.google.com/file/d/19TPg8r_glrJHF2_97axrk6g9CPawuvY6/view?usp=sharing) •
[**▶️ Demo**](https://drive.google.com/file/d/1-iMjAUNgncVNvccYomxVAr8T7jsnPXbJ/view?usp=sharing)

A clean **Flutter + BLoC** Kanban app with drag & drop, task CRUD, connectivity awareness, and **Firebase Firestore** (device-scoped).

---

## Highlights
- Columns: **Backlog / To-Do / In-Progress / Done**
- **Drag & Drop** across & reorder within columns
- **Task CRUD**: title, description, status, priority, due date, tags
- **Details dialog** + **delete confirmation**
- **Connectivity banner** (offline notice)
- **Dark theme** with centralized colors & text styles
- **Lottie** splash (2s)
- Tablet notice on small screens

---

## Architecture
- **Clean Architecture + SOLID**
- **BLoC**: `BoardBloc` (board), `ConnectivityBloc` (online/offline)
- **Repository**: `DashboardRepository` → `DashboardRepoImp` (Firestore)
- **DI**: `get_it`

---

## Project Structure

lib/
├─ core/
│ ├─ errors/ # Failures, exceptions
│ ├─ helper_functions/ # Helpers (formatting, etc.)
│ ├─ services/ # DI (get_it), prefs, device-id, observers
│ ├─ theme/ # AppTheme (dark), AppColors, TextStyles
│ ├─ utils/ # Constants, assets, misc utils
│ └─ widgets/ # Reusable UI components (generic)
│
├─ features/
│ └─ main_dashboard/
│ ├─ data/
│ │ ├─ enums/ # BoardColumn, Priority, etc.
│ │ ├─ locale_storage/ # (placeholder for future offline DB)
│ │ ├─ models/ # TaskModel, payloads
│ │ ├─ repo/ # Repository contracts
│ │ └─ repo_imp/ # Firestore implementation
│ ├─ presentation/
│ │ ├─ view_model/
│ │ │ ├─ board_bloc/ # BoardBloc + events + state
│ │ │ └─ connectivity_bloc/ # ConnectivityBloc + events + state
│ │ └─ views/
│ │ ├─ widgets/ # Lane, TaskCard, headers, dialogs, sheets
│ │ └─ main_dashboard_view.dart
│
├─ features/
│ └─ splash/presentation/views/
│ ├─ widgets/ # (if any)
│ └─ splash_view.dart # Lottie splash
│
├─ firebase_options.dart # FlutterFire config
└─ main.dart # App entry: routes, theme, DI bootstrap
