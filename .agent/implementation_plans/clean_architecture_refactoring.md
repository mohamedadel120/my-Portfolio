# Portfolio Clean Architecture - Implementation Plan

## 📋 Overview

This document outlines the plan to refactor the portfolio website from its current structure to a Clean Architecture with proper separation of concerns, SOLID principles, and responsive view separation.

---

## 🎯 Goals

1. **Separate responsive views** - Mobile, Tablet, Desktop in distinct files
2. **Implement Clean Architecture** - Data, Domain, Presentation layers
3. **Apply SOLID principles** - Single Responsibility, Open/Closed, etc.
4. **Add Cubit state management** - Logic separated from UI
5. **Improve performance** - Better widget rebuilding control
6. **Enhance testability** - Easy to unit test each layer

---

## 📁 Target Folder Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   ├── app_dimensions.dart
│   │   └── app_assets.dart
│   │
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── dark_theme.dart
│   │   └── light_theme.dart
│   │
│   ├── utils/
│   │   ├── device_utils.dart
│   │   ├── url_launcher_utils.dart
│   │   └── extensions/
│   │       ├── context_extensions.dart
│   │       └── string_extensions.dart
│   │
│   ├── responsive/
│   │   ├── responsive_builder.dart
│   │   ├── responsive_breakpoints.dart
│   │   └── device_type.dart
│   │
│   └── widgets/
│       ├── buttons/
│       │   ├── primary_button.dart
│       │   └── magnetic_button.dart
│       ├── cards/
│       │   └── glass_card.dart
│       └── common/
│           ├── section_title.dart
│           └── loading_indicator.dart
│
├── features/
│   │
│   ├── home/
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── home_cubit.dart
│   │       │   └── home_state.dart
│   │       ├── pages/
│   │       │   ├── home_page.dart              # Router
│   │       │   ├── mobile/
│   │       │   │   └── home_mobile_view.dart
│   │       │   ├── tablet/
│   │       │   │   └── home_tablet_view.dart
│   │       │   └── desktop/
│   │       │       └── home_desktop_view.dart
│   │       └── widgets/
│   │           └── navigation_drawer.dart
│   │
│   ├── hero/
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── hero_cubit.dart
│   │       │   └── hero_state.dart
│   │       ├── pages/
│   │       │   ├── hero_section.dart           # Router
│   │       │   ├── mobile/
│   │       │   │   └── hero_mobile_view.dart
│   │       │   ├── tablet/
│   │       │   │   └── hero_tablet_view.dart
│   │       │   └── desktop/
│   │       │       └── hero_desktop_view.dart
│   │       └── widgets/
│   │           └── aurora_background.dart
│   │
│   ├── about/
│   │   ├── data/
│   │   │   └── models/
│   │   │       └── skill_model.dart
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       └── skill_entity.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       ├── pages/
│   │       │   ├── mobile/
│   │       │   ├── tablet/
│   │       │   └── desktop/
│   │       └── widgets/
│   │
│   ├── expertise/
│   │   └── presentation/
│   │       ├── cubit/
│   │       ├── pages/
│   │       │   ├── mobile/
│   │       │   ├── tablet/
│   │       │   └── desktop/
│   │       └── widgets/
│   │
│   ├── experience/
│   │   ├── data/
│   │   │   └── models/
│   │   │       └── experience_model.dart
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       └── experience_entity.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       ├── pages/
│   │       │   ├── mobile/
│   │       │   ├── tablet/
│   │       │   └── desktop/
│   │       └── widgets/
│   │
│   ├── projects/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── project_model.dart
│   │   │   └── repositories/
│   │   │       └── project_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── project_entity.dart
│   │   │   └── repositories/
│   │   │       └── project_repository.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── projects_cubit.dart
│   │       │   └── projects_state.dart
│   │       ├── pages/
│   │       │   ├── projects_section.dart       # Router
│   │       │   ├── mobile/
│   │       │   │   └── projects_mobile_view.dart
│   │       │   ├── tablet/
│   │       │   │   └── projects_tablet_view.dart
│   │       │   └── desktop/
│   │       │       └── projects_desktop_view.dart
│   │       └── widgets/
│   │           ├── project_card.dart
│   │           └── phone_frame.dart
│   │
│   └── contact/
│       ├── data/
│       │   └── repositories/
│       │       └── contact_repository_impl.dart
│       ├── domain/
│       │   └── repositories/
│       │       └── contact_repository.dart
│       └── presentation/
│           ├── cubit/
│           │   ├── contact_cubit.dart
│           │   └── contact_state.dart
│           ├── pages/
│           │   ├── mobile/
│           │   ├── tablet/
│           │   └── desktop/
│           └── widgets/
│
├── injection_container.dart    # Dependency Injection setup
│
└── main.dart
```

---

## 🔧 Core Components to Create

### 1. ResponsiveBuilder Widget

```dart
class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveBuilder({
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < ResponsiveBreakpoints.mobile) {
          return mobile;
        } else if (constraints.maxWidth < ResponsiveBreakpoints.tablet) {
          return tablet ?? mobile;
        } else {
          return desktop;
        }
      },
    );
  }
}
```

### 2. Responsive Breakpoints

```dart
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;
}
```

### 3. Base Cubit Pattern

```dart
// projects_state.dart
abstract class ProjectsState extends Equatable {
  const ProjectsState();
}

class ProjectsInitial extends ProjectsState { ... }
class ProjectsLoading extends ProjectsState { ... }
class ProjectsLoaded extends ProjectsState {
  final List<ProjectEntity> projects;
  final int activeIndex;
  ...
}

// projects_cubit.dart
class ProjectsCubit extends Cubit<ProjectsState> {
  ProjectsCubit() : super(ProjectsInitial());

  void loadProjects() { ... }
  void setActiveProject(int index) { ... }
}
```

---

## 📅 Implementation Phases

### Phase 1: Base Infrastructure (Current Task)

- [ ] Create `core/responsive/` with ResponsiveBuilder
- [ ] Create `core/responsive/responsive_breakpoints.dart`
- [ ] Create `core/responsive/device_type.dart`
- [ ] Move constants to `core/constants/`
- [ ] Move theme to `core/theme/`
- [ ] Add flutter_bloc dependency

### Phase 2: Projects Feature (Sample Implementation)

- [ ] Create `features/projects/` folder structure
- [ ] Create `ProjectEntity` and `ProjectModel`
- [ ] Create `ProjectsCubit` and `ProjectsState`
- [ ] Create `ProjectsMobileView`
- [ ] Create `ProjectsTabletView`
- [ ] Create `ProjectsDesktopView`
- [ ] Create `ProjectsSection` router

### Phase 3: Hero Section

- [ ] Create `features/hero/` folder structure
- [ ] Create `HeroCubit` and `HeroState`
- [ ] Create responsive views for Hero

### Phase 4: Remaining Features

- [x] About section ✅
- [x] Expertise section ✅
- [x] Experience section ✅
- [x] Contact section ✅

### Phase 5: Integration & Cleanup

- [x] Update `main.dart` to use new Clean Architecture features
- [ ] Delete old widgets (Optional cleanup)

### Phase 5: Home Integration

- [ ] Update navigation

### Phase 6: Cleanup

- [ ] Remove old widget files
- [ ] Update imports
- [ ] Final testing

---

## 📦 Required Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  get_it: ^7.6.4 # For dependency injection
```

---

## ✅ Approval Checklist

Before starting implementation:

- [ ] Folder structure approved
- [ ] ResponsiveBuilder pattern approved
- [ ] Cubit pattern approved
- [ ] Phase order approved

---

## 🚀 Start Point

Once approved, we will:

1. Add required dependencies to pubspec.yaml
2. Create the `core/responsive/` infrastructure
3. Create a sample `features/projects/` implementation
4. Test the new architecture
5. Proceed with remaining features

---

_Created: 2026-01-23_
_Status: AWAITING APPROVAL_
