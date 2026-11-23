
# Bacus Desktop for iOS

A custom desktop environment for iOS.

## Project goals

- Custom desktop interface
- Window management
- Dock
- Menu bar
- Application launcher
- Widgets
- Custom themes
- Compatibility adaptations for iOS 10 through iOS 18, iOS 26 and iOS 27

## Technology

- Objective-C
- UIKit
- Theos
- Logos

## Build

Traditional package:

```bash
make clean package
```

Rootless package:

```bash
make clean
make package THEOS_PACKAGE_SCHEME=rootless
```

## License

GNU General Public License v3.0 or later.
