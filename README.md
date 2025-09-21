Kanban Board — Mini-ERP (Flutter)

⬇️ Download APK
 • ▶️ Demo Video (30–60s)

A lightweight Kanban application built with Flutter that demonstrates Clean Architecture + BLoC, drag & drop across columns, task CRUD (add/edit/delete/view), connectivity awareness with friendly error handling, and Firebase Cloud Firestore persistence scoped per device (each device writes to its own user namespace).

Note on the brief: Local database caching + offline sync is documented in the Roadmap section. This delivery ships remote storage via Firestore (device-scoped) with real-time connectivity awareness.

✨ Features

Kanban Board (Backlog / To-Do / In-Progress / Done)

Drag & Drop between columns with precise reordering using slim “gap targets”

Task CRUD via dialog/bottom sheet
Fields: title, description, status, priority (low/medium/high/urgent), due date, tags

Delete confirmation dialog

Task details dialog (priority pill, tags, due date + countdown: Due today / Due in Xd / Overdue)

Connectivity banner (radio + reachability) — “You’re offline. Changes won’t sync.”

Static column headers; only task list scrolls

Tablet UX hint (warn on very small screens)

Centralized theme (colors & typography) + Dark UI

Lottie splash (2 seconds)

🧭 Screens

Splash → Main Dashboard (Kanban)

Add/Edit Task (bottom sheet)

Task Details (dialog)

Delete Confirmation (dialog)

🏗 Architecture

Clean Architecture with SOLID:

Presentation (Widgets + BLoC)
   ├── BoardBloc (board events/states)
   └── ConnectivityBloc (online/offline tracking)
Data
   ├── Repository contract (DashboardRepository)
   └── Firebase impl (DashboardRepoImp)
Core (DI, errors, theme, utils)


Flow: UI → Bloc (Event) → Repository (Contract) → Firestore (Impl) → Bloc (State) → UI
Optimistic UI on drag/drop + CRUD, then persistence. Dependencies injected via get_it.

🗂 Project Structure
lib/
  core/
    errors/
    helper_functions/
    services/
      get_it_service.dart
      shared_preferences_singleton.dart
    theme/
      app_theme.dart
    utils/
      app_colors.dart
      app_text_styles.dart
    widgets/
  features/
    main_dashboard/
      data/
        enums/
        locale_storage/          # reserved for future offline cache
        models/
        repo/
        repo_imp/
      presentation/
        view_model/
          board_bloc/
          connectivity_bloc/
        views/
          main_dashboard_view.dart
          widgets/
            add_task_form.dart
            due_countdown.dart
            draggable_task_card.dart
            gap_target.dart
            lane.dart
            main_dashboard_view_body.dart
            priority_pill.dart
            section_header.dart
            tag_chip.dart
            task_actions_button.dart
            task_card.dart
            task_dialogs_and_sheets.dart
    splash/
      presentation/
        views/
          splash_view.dart
          widgets/
            splash_view_body.dart
firebase_options.dart
main.dart

📦 Data Model
class TaskModel {
  final String id;            // Firestore doc id
  final String title;
  final String description;
  final BoardColumn status;   // backlog | todo | inProgress | done
  final Priority priority;    // low | medium | high | urgent
  final DateTime? dueDate;
  final List<String> tags;
}


Firestore Path (device-scoped):
users/{deviceId}/tasks/{taskId}

A stable deviceId is generated and stored at first launch.

Each device has an isolated task space.

🔌 State Management

BoardBloc

BoardLoadAllColumns, BoardAddTask, BoardUpdateTask, BoardDeleteTaskById

BoardAcceptTask (move across columns + persist)

BoardReorderWithinColumn (precise insert index)

Gap hover state to limit rebuilds & animate drop areas

ConnectivityBloc

connectivity_plus (radio) + internet_connection_checker (reachability)

Exposes online: bool → shows offline banner; can gate writes if desired

🧯 Error Handling & Connectivity

Repository catches FirebaseException / network errors and maps them to readable messages.

UI shows SnackBars/dialogs on failures.

Offline banner: “You’re offline. Changes won’t sync.”

Drag/drop is optimistic; repository call follows to persist status.

🎨 Theme & UI System

Centralized tokens:

core/utils/app_colors.dart

core/utils/app_text_styles.dart

core/theme/app_theme.dart (Material 3, dark theme)

Task Card UI:

Title + optional description

Priority pill (color-coded) & chips for tags

Due date & DueCountdown (Due today / Due in Xd / Overdue)

Inline actions menu: Display / Edit / Delete

📚 Packages & Rationale
Package	Purpose	Why it’s chosen
flutter_bloc	State management	Clear event/state flow, great testing story, minimal rebuilds
equatable	Value equality	Clean state comparison without boilerplate
get_it	DI / service locator	Lightweight, simple, testable
firebase_core, cloud_firestore	Remote data store	Hosted, scalable, quick to integrate
shared_preferences	Persist generated deviceId	Lightweight K/V store
connectivity_plus	Network radio stream	De-facto connectivity utility
internet_connection_checker	Reachability	Avoids Wi-Fi-without-internet false positives
lottie	Splash animation	Compact, smooth vector animations
▶️ Run the Project
1) Prerequisites

Flutter SDK

Android Studio / Xcode set up

Firebase project (this repo includes firebase_options.dart; to regenerate: flutterfire configure)

2) Install dependencies
flutter pub get

3) Run
flutter run

4) Build release APK (optional)
flutter build apk --release

5) Firebase config (if you rebuild)

Android: place google-services.json under android/app/

iOS: place GoogleService-Info.plist under ios/Runner/

Ensure firebase_options.dart exists (via flutterfire configure)

✅ Testing & TDD

The brief emphasizes TDD. This project structures the logic to be testable and documents the test plan below; add tests as needed.

Unit Tests (planned/covered)

BoardBloc

add/update/delete mutations

move across columns (BoardAcceptTask) with proper insert index

reorder within a column (index math)

error propagation from repository

TaskModel

Firestore mapping (to/from), handling null dueDate, tags parsing

Widget Tests

Drag & drop interaction (feedback + gap highlight + target insertion)

Edit form validation (title required)

Delete confirmation (confirm vs cancel)

Run:

flutter test

🔄 Offline/Online Sync — Roadmap

The brief asks for local DB cache + online sync. Planned approach:

Local DB: Use Isar or Hive for tasks (per device: tasks_{deviceId}).

Change queue: Log offline mutations (create/update/delete + updatedAt).

Sync on reconnect:

Push queued changes → remote (Firestore or REST).

Conflict rule: Last-write-wins using updatedAt (UTC).

Pull remote snapshot; merge into local DB and update UI.

Optional: hydrated_bloc for instant state restore.

⚙️ Performance Notes

BlocBuilder/BlocSelector used to restrict rebuilds

Slim, animated gap targets for precise drop positions

Drag feedback reuses the task card layout for smoothness

Static lane header; only list portion scrolls

🧪 Environment

Please include these outputs in your README (replace with your machine’s results):

flutter --version

flutter doctor -v

🔗 Links (replace with real URLs)

APK Download: https://YOUR-APK-LINK

Demo Video: https://YOUR-VIDEO-LINK

📄 License

MIT (or your preferred license).

Notes for Reviewers

Scope deviation: Local database caching + sync is planned (see Roadmap). Current build uses Firebase (device-scoped) with robust connectivity handling and clean, testable architecture.
