# Onyx Dialer

A privacy-focused phone dialer for Android, built with **Flutter** on top of a native **Kotlin `InCallService`**. It aims for feature parity with a modern OEM dialer (T9 keypad, contacts, recents, call stats) and adds a private-contacts layer that the stock dialer doesn't have.

## Features
- **Full dialer UI**: keypad with T9 contact matching, contacts with search and detail pages, recents, and settings
- **Native call handling**: a Kotlin `InCallService` (`StealthCallService`) becomes the default phone app and routes each incoming call
- **Block list**: blocked numbers are rejected before they ring
- **Private contacts (vault)**: chosen contacts get a discreet call screen, and their entries can be auto-cleared from the system call log after the call
- **Display modes**: full-screen call activity or a floating pop-up over other apps
- **Call statistics** charts (fl_chart)
- **Encrypted local storage**: Drift on top of SQLCipher

## Architecture
| Layer | Tech |
| --- | --- |
| UI & state | Flutter, Riverpod |
| Persistence | Drift + SQLCipher (`lib/database`) |
| Bridge | `MethodChannel`: `CallBridge` (make/end/reject) and `DataBridge` (sync block list & vault rules to Kotlin) |
| Native | Kotlin `InCallService`, `CallManager`, `PublicCallActivity` |

## Run
```bash
flutter pub get
dart run build_runner build   # generates Drift code
flutter run
```
Grant the requested phone, contacts and overlay permissions, and set Onyx as the default phone app.

Implementation roadmap: [design.md](design.md)
