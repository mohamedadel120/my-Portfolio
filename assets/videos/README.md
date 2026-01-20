# Video Assets

Place your project demo videos in this folder.

## Naming Convention

You can name them whatever you like, as long as you match the path in `lib/constants/app_data.dart`.

## Usage

In `lib/constants/app_data.dart`, add the `videoUrl` parameter to your Project object:

```dart
Project(
  title: 'Adruse Mobile App',
  // ... other fields
  videoUrl: 'assets/videos/your_video.mp4',
),
```

## Supported Formats

- .mp4 (Recommended for web)
- .webm
