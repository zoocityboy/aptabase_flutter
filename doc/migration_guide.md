# Migration Guid
This document gathered all breaking changes and migrations requirement between versions.

<!--
When new content need to be added to the migration guide, make sure they're following the format:
1. Add a version in the *Breaking versions* section, with a version anchor.
2. Use *Summary* and *Details* to introduce the migration.
-->

## Breaking versions

- [1.0.0](#100)

## 1.0.0

### Summary

- `Aptabase.init` now requires `AptabaseConfig` instead of `String` appKey.
- Original `trackEvent` method is now renamed to `customTrackEvent` to avoid confusion with `AptabaseTrackEvent` class.
### Details

```diff
- await Aptabase.init("A-DEV-000000");
+ await Aptabase.init(const AptabasConfig(
+    appKey: "A-DEV-000000",
+  ));
```

```diff
- Aptabase.instance.trackEvent("event_name", {
-  "key": "value",
- });

+ Aptabase.instance.customTrackEvent("event_name", {
+  "key": "value",
+ });
```


```diff
+ # Strong type event
+ class IncrementEvent extends AptabaseTrackEvent {
+   IncrementEvent(int counter) : super(eventName: "increment", props: <String, Object>{"counter": counter});
+ }
+ # Track event
+ Aptabase.instance.trackEvent(IncrementEvent(10));
```
