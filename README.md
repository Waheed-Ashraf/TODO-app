# Kanban Board — Mini-ERP (Flutter)

[**⬇️ APK**]([https://YOUR-APK-LINK](https://drive.google.com/file/d/19TPg8r_glrJHF2_97axrk6g9CPawuvY6/view?usp=sharing)) • [**▶️ Demo**]([https://YOUR-VIDEO-LINK](https://drive.google.com/file/d/1-iMjAUNgncVNvccYomxVAr8T7jsnPXbJ/view?usp=sharing))

A clean **Flutter + BLoC** Kanban app with drag & drop, task CRUD, connectivity awareness, and **Firebase Firestore** (device-scoped).

---

## Highlights
- Columns: **Backlog / To-Do / In-Progress / Done**
- **Drag & Drop** across/reorder within columns (animated drop gaps)
- **Task CRUD** (title, description, status, priority, due date, tags)
- **Task details** dialog + **delete confirmation**
- **Connectivity banner** (offline notice)
- **Dark theme**, centralized **colors & text styles**
- **Lottie** splash (2s)
- Tablet notice on small screens

---

## Architecture
- **Clean Architecture + SOLID**
- **BLoC**: `BoardBloc` (board), `ConnectivityBloc` (online/offline)
- **Repository**: `DashboardRepository` (contract) → `DashboardRepoImp` (Firestore)
- **DI**: `get_it`
