# Kanban Board — Mini-ERP (Flutter)

[**⬇️ APK**](https://YOUR-APK-LINK) • [**▶️ Demo**](https://YOUR-VIDEO-LINK)

A clean **Flutter + BLoC** Kanban app with drag & drop, task CRUD, connectivity awareness, and **Firebase Firestore** (device-scoped). Local cache & sync are outlined in Roadmap.

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
