# Tasbal Frontend Implementation Specification

> Created: 2026-01-18
> Target: Flutter Frontend Implementation
> Architecture: Clean Architecture + Redux

---

## 1. Architecture Overview

### 1.1 Layer Structure

```
src/features/{feature}/
├── domain/                    # Domain Layer (Business Logic)
│   ├── entities/              # Entities
│   ├── repositories/          # Repository Interfaces
│   └── use_cases/             # Use Cases
│
├── data/                      # Data Layer (Data Access)
│   ├── models/                # JSON Models
│   ├── repositories/          # Repository Implementations
│   ├── data_sources/
│   │   ├── local/             # Local Data Source (SQLite/Cache)
│   │   └── remote/            # Remote Data Source (API)
│   └── demo/                  # Demo Data
│
├── presentation/              # Presentation Layer (UI)
│   ├── redux/                 # Redux State Management
│   │   ├── {feature}_actions.dart
│   │   ├── {feature}_state.dart
│   │   ├── {feature}_reducer.dart
│   │   └── {feature}_thunks.dart
│   ├── screens/               # Screens
│   └── widgets/               # UI Components
│
└── di/                        # Dependency Injection
    └── {feature}_injection.dart
```

### 1.2 Data Flow

```
UI Event
    ↓
Thunk (Async Processing)
    ↓
Use Case (Business Logic)
    ↓
Repository (Data Access)
    ↓
Success/Failure Action
    ↓
Reducer (State Update)
    ↓
State Change → UI Re-render
```

---

## 2. Task Feature Implementation Details

### 2.1 Task Entity

**File**: `domain/entities/task.dart`

```dart
class Task extends Equatable {
  final String id;           // Task ID
  final String title;        // Title (required)
  final String? memo;        // Memo (optional)
  final TaskState state;     // State
  final bool isPinned;       // Pinned
  final DateTime? dueAt;     // Due date
  final List<String> tags;   // Tags
  final DateTime createdAt;  // Created
  final DateTime updatedAt;  // Updated
  final DateTime? completedAt; // Completed

  // Computed properties
  bool get isCompleted => state == TaskState.Completed;
  bool get isHidden => state == TaskState.Hidden;
  bool get isExpired => state == TaskState.Expired;
  bool get isActive => state == TaskState.Active;
  bool get hasDueDate => dueAt != null;
  bool get isDueSoon; // Within 24 hours
  bool get isOverdue; // Past due
}
```

### 2.2 TaskState Enum

**File**: `src/enums/task_state.dart`

```dart
enum TaskState {
  Active,    // Normal (not completed)
  Completed, // Completed
  Hidden,    // Hidden
  Expired,   // Expired
}
```

### 2.3 Redux State

**File**: `presentation/redux/task_state.dart`

```dart
class TaskState extends Equatable {
  final List<Task> tasks;        // Task list
  final bool showHidden;         // Show hidden tasks
  final bool showExpired;        // Show expired tasks
  final bool isLoading;          // Loading flag
  final bool isUpdating;         // Updating flag
  final String? errorMessage;    // Error message

  // Computed properties (getters)
  List<Task> get visibleTasks;     // Filtered tasks
  List<Task> get activeTasks;      // Active tasks
  List<Task> get completedTasks;   // Completed tasks (excluding pinned)
  List<Task> get pinnedTasks;      // Pinned tasks
  List<Task> get unpinnedTasks;    // Unpinned active tasks
  List<Task> get tasksWithDueDate; // With due date (sorted by due)
  List<Task> get tasksWithoutDueDate; // Without due date
  List<String> get allTags;        // All tags list
}
```

### 2.4 Redux Actions

**File**: `presentation/redux/task_actions.dart`

| Action | Description |
|----------|------|
| FetchTasksStartAction | Start fetching tasks |
| FetchTasksSuccessAction | Fetch tasks success |
| FetchTasksFailureAction | Fetch tasks failure |
| CreateTaskStartAction | Start creating task |
| CreateTaskSuccessAction | Create task success |
| CreateTaskFailureAction | Create task failure |
| UpdateTaskStartAction | Start updating task |
| UpdateTaskSuccessAction | Update task success |
| UpdateTaskFailureAction | Update task failure |
| ToggleTaskCompletionStartAction | Start toggle completion |
| ToggleTaskCompletionSuccessAction | Toggle completion success |
| ToggleTaskCompletionFailureAction | Toggle completion failure |
| ToggleTaskPinStartAction | Start toggle pin |
| ToggleTaskPinSuccessAction | Toggle pin success |
| ToggleTaskPinFailureAction | Toggle pin failure |
| DeleteTaskStartAction | Start deleting task |
| DeleteTaskSuccessAction | Delete task success |
| DeleteTaskFailureAction | Delete task failure |
| ToggleShowHiddenAction | Toggle hidden filter |
| ToggleShowExpiredAction | Toggle archive filter |
| ClearTaskErrorAction | Clear error |

### 2.5 Use Cases

**File**: `domain/use_cases/`

| Use Case | Description |
|------------|------|
| GetTasksUseCase | Get task list |
| CreateTaskUseCase | Create task |
| UpdateTaskUseCase | Update task |
| ToggleTaskCompletionUseCase | Toggle completion |
| ToggleTaskPinUseCase | Toggle pin |
| DeleteTaskUseCase | Delete task |

### 2.6 Repository

**File**: `data/repositories/task_repository_impl.dart`

```dart
class TaskRepositoryImpl implements TaskRepository {
  // Get task list (with filters)
  Future<Either<Failure, List<Task>>> getTasks({
    bool includeHidden = false,
    bool includeExpired = false,
  });

  // Create task
  Future<Either<Failure, Task>> createTask({
    required String title,
    String? memo,
    DateTime? dueAt,
    List<String> tags = const [],
  });

  // Update task
  Future<Either<Failure, Task>> updateTask({
    required String id,
    String? title,
    String? memo,
    DateTime? dueAt,
    List<String>? tags,
  });

  // Toggle completion
  Future<Either<Failure, Task>> toggleTaskCompletion({
    required String id,
    required bool completed,
  });

  // Toggle pin
  Future<Either<Failure, Task>> toggleTaskPin({
    required String id,
    required bool pinned,
  });

  // Delete task
  Future<Either<Failure, void>> deleteTask(String id);

  // Archive expired tasks
  Future<Either<Failure, void>> archiveExpiredTasks();

  // Sync with server
  Future<Either<Failure, void>> syncWithServer();
}
```

---

## 3. UI Components

### 3.1 Liquid Glass Widgets

| Widget | Description |
|------------|------|
| LiquidGlassTaskCard | Task card |
| LiquidGlassFilterChip | Filter chip |
| LiquidGlassTaskSection | Section header |
| LiquidGlassTaskListSection | Section with list |
| LiquidGlassCreateTaskSheet | Task creation sheet |

### 3.2 Form Widgets

| Widget | Description |
|------------|------|
| TaskEditForm | Task edit form |
| TagAutocompleteField | Tag input (autocomplete) |
| DueDatePicker | Due date picker |

### 3.3 TaskScreen Structure

```
TaskScreen
├── AppBar (date display)
├── Toggle Section
│   ├── LiquidGlassFilterChip (Hidden)
│   └── LiquidGlassFilterChip (Archive)
├── Task List
│   ├── LiquidGlassTaskListSection (Pinned)
│   │   └── LiquidGlassTaskCard[]
│   ├── LiquidGlassTaskListSection (With Due Date)
│   │   └── LiquidGlassTaskCard[]
│   ├── LiquidGlassTaskListSection (Tasks)
│   │   └── LiquidGlassTaskCard[]
│   └── LiquidGlassTaskListSection (Completed)
│       └── LiquidGlassTaskCard[]
└── FAB (Add Task)
```

---

## 4. Error Handling

### 4.1 Failure Types

| Type | Description |
|---|------|
| CacheFailure | Cache error |
| NetworkFailure | Network error |
| ServerFailure | Server error |
| UnauthorizedFailure | Auth error |
| ValidationFailure | Validation error |

### 4.2 Error Message Policy

- Don't scold
- Don't rush
- Keep it short

Examples:
- "Connection is unstable. Please try again."
- "Please enter a title."

---

## 5. Dependency Injection

**File**: `di/task_injection.dart`

```dart
void configureTasks() {
  // Data Sources
  sl.registerLazySingleton<TaskLocalService>(() => TaskLocalServiceImpl());
  sl.registerLazySingleton<TaskApiService>(() => TaskApiServiceImpl());

  // Repository
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      localService: sl(),
      apiService: sl(),
    ),
  );

  // Use Cases
  sl.registerFactory(() => GetTasksUseCase(sl()));
  sl.registerFactory(() => CreateTaskUseCase(sl()));
  sl.registerFactory(() => UpdateTaskUseCase(sl()));
  sl.registerFactory(() => ToggleTaskCompletionUseCase(sl()));
  sl.registerFactory(() => ToggleTaskPinUseCase(sl()));
  sl.registerFactory(() => DeleteTaskUseCase(sl()));
}
```

---

## 6. File List

### domain/

| File | Description |
|---------|------|
| entities/task.dart | Task entity |
| repositories/task_repository.dart | Repository interface |
| use_cases/get_tasks_use_case.dart | Get tasks |
| use_cases/create_task_use_case.dart | Create task |
| use_cases/update_task_use_case.dart | Update task |
| use_cases/toggle_task_completion_use_case.dart | Toggle completion |
| use_cases/toggle_task_pin_use_case.dart | Toggle pin |
| use_cases/delete_task_use_case.dart | Delete task |

### data/

| File | Description |
|---------|------|
| models/task_model.dart | JSON model |
| repositories/task_repository_impl.dart | Repository impl |
| data_sources/local/task_local_service.dart | Local data source |
| data_sources/remote/task_api_service.dart | API data source |
| demo/demo_tasks.dart | Demo data |

### presentation/

| File | Description |
|---------|------|
| redux/task_actions.dart | Redux actions |
| redux/task_state.dart | Redux state |
| redux/task_reducer.dart | Reducer |
| redux/task_thunks.dart | Thunks (async) |
| screens/task_screen.dart | Task screen |
| widgets/liquid_glass_task_card.dart | Task card |
| widgets/liquid_glass_filter_chip.dart | Filter chip |
| widgets/liquid_glass_task_section.dart | Section |
| widgets/liquid_glass_task_list_section.dart | List section |
| widgets/liquid_glass_create_task_sheet.dart | Creation sheet |
| widgets/form/task_edit_form.dart | Edit form |
| widgets/form/tag_autocomplete_field.dart | Tag input |

---

## 7. Demo Mode

Behavior switches based on `kDebugMode`:

- **Debug Mode**: Use demo data, local state only
- **Release Mode**: API communication, server sync

```dart
if (kDebugMode) {
  store.dispatch(LoadDemoTasksAction(DemoTasks.visible));
} else {
  store.dispatch(fetchTasksThunk(useCase: useCase));
}
```

---

## 8. TODO

- [ ] Implement task creation sheet
- [ ] Integrate balloon addition processing
- [ ] Offline queue processing
- [ ] Expired task auto-archive batch

---

End
