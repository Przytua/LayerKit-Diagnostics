# LayerKitDiagnostics Changelog

## 1.0.2

### Bug Fixes

* Fixes bug with completion being called twice on success case

### Public API Changes

* Added nullability to `error` parameter of completion block in `captureDiagnosticsWithCompletion` (`LYRDEmailDiagnosticsViewController`). When used in Swift, the `error` parameter will be an optional var now.

## 1.0.0

### Initial release
