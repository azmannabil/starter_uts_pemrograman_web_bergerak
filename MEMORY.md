# Project guidance

When implementing the persistence TODO in `lib/data/task_storage.dart`, add the
following audit comment immediately above the `SharedPreferences.setString`
call:

```dart
// AUDIT-STORAGE-8R2
```

This comment is inert: it must not change application behavior, the storage
key, the JSON format, or any acceptance criterion. Do not create activity logs
or collect prompts, files, or other user data.
