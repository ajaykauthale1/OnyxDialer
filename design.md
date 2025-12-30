# Implementation Plan: Onyx (Project Ghost)

**Version:** Final Master (v6.0)
**Goal:** Build a "Pro" Dialer with Samsung-parity features and a hidden Privacy Engine.

---

## Phase 1: Foundation & Bridge
*Goal: Setup the Hybrid Environment.*

- [x] **1.1 Initialize Project**
    - Dependencies: `flutter_riverpod`, `drift`, `sqlcipher_flutter_libs`, `permission_handler`, `shared_preferences`, `flutter_contacts`, `url_launcher`, `fl_chart`, `system_alert_window`.
- [x] **1.2 Android Manifest**
    - Permissions: `READ/WRITE_CALL_LOG`, `READ_CONTACTS`, `MANAGE_OWN_CALLS`, `SYSTEM_ALERT_WINDOW`, `SEND_SMS`, `FOREGROUND_SERVICE_PHONE_CALL`, `POST_NOTIFICATIONS`.
    - Service: Register `StealthCallService` (`InCallService`).
- [x] **1.3 MethodChannel Bridge**
    - `CallBridge`: `makeCall`, `endCall`, `rejectCall`.
    - `DataBridge`: `syncBlockList`, `syncGhostSettings` (Send rules from Flutter to Kotlin).
- [x] **1.4 Testing**
    - Unit Tests: `native_bridge_test.dart` (Dart side).
    - Widget Tests: `phase1_test.dart` (App Init).

---

## Phase 2: The Native Engine (Kotlin)
*Goal: The critical "InCallService" that handles the phone logic.*

- [x] **2.1 Blocking & Routing**
    - Implement `onCallAdded`:
        - **Block Check:** If in BlockList -> `call.reject()`.
        - **Ghost Check:** If in GhostSettings -> Launch `StealthCallActivity`.
        - **Standard:** Check "Display Mode" pref -> Launch `PublicCallActivity` (Full) or `FloatingService` (Pop-up).
- [x] **2.2 Auto-Clear Daemon**
    - Implement `onCallRemoved`:
        - Check `GhostSettings`.
        - If `autoClear == true`: Launch Coroutine -> Register `ContentObserver` on CallLog -> Wait for entry -> `contentResolver.delete()`.
- [x] **2.3 Testing**
    - Integration Test: `test/integration/data_sync_test.dart` (Verify Data Sync flow).
    - *Manual Test:* Verify `InCallService` triggers on real device.

---

## Phase 3: Standard Parity Features (Public UI)
*Goal: Match Samsung or Stock Android functionality and UX.*

- [ ] **3.1 Keypad Logic**
    - Implement **T9 Algorithm** (Trie structure) for instant contact search.
    - Implement **Speed Dial** (Long-press detector on keys 2-9).
- [ ] **3.2 Call Display Settings**
    - Build `FloatingCallService` (Android View) for the "Pop-up" overlay mode.
    - Build `PublicCallActivity` with support for custom Background Images (mimicking OneUI/Material You layout).
- [ ] **3.3 Carrier Integrations**
    - Wire Settings buttons to System Intents (`ACTION_WIFI_CALLING_SETTINGS`, etc.).
- [ ] **3.4 Quick Decline**
    - Build "Message" button in Incoming UI -> Sends SMS via `SmsManager`.
- [ ] **3.5 Testing**
    - Unit Tests: T9 Algorithm logic, Speed Dial logic.
    - Widget Tests: Keypad UI, Call Display UI.

---

## Phase 4: The Stealth Core (God Mode)
*Goal: The hidden layer.*

- [ ] **4.1 The Trigger**
    - Keypad Listener: Detect `*#[PIN]#`.
    - State: `ref.read(godModeProvider).state = true`.
- [ ] **4.2 The Vault**
    - Setup `Drift` DB with `SQLCipher`.
    - Implement "Move to Vault" logic (Copy from System -> Save to Vault -> Delete from System).
- [ ] **4.3 Analytics Module**
    - Build `StatsService`: Fetches data from System DB.
    - If `GodMode`: Fetches data from Vault DB and merges lists.
    - Render Pie/Bar charts.
- [ ] **4.4 Testing**
    - Unit Tests: Trigger logic, Vault DB operations (CRUD).
    - Integration Tests: "Move to Vault" flow (System -> Vault).

---

## Phase 5: UI & Polish ("Midnight Layers")
*Goal: Apply the "Grizzly" design language (Polished, Modern, Dark).*

- [ ] **5.1 Visual Identity**
    - Reference: **Grizzly Mobile App UI Kit**.
    - Implement deep dark theme with high-contrast accents and spacious layout.
    - Keypad: Soft-rounded keys, clean typography, and subtle micro-interactions.
- [ ] **5.2 Recents & Contacts**
    - Implement Filter Dropdowns (Missed, Rejected, etc.).
    - Implement Account Filters (Google vs SIM).
- [ ] **5.3 Settings Menu**
    - Build Grouped List UI (Samsung OneUI style).
- [ ] **5.4 Testing**
    - Widget Tests: Visual regression (golden tests) for Keypad and Settings.
    - User Acceptance Testing (UAT): Verify "Grizzly" theme consistency.

---

## Phase 6: Testing & Release
- [ ] **6.1 Critical Path Testing**
    - Test Emergency Calls (911) - **MUST PASS** (Ensure pass-through to System Dialer).
    - Test Auto-Clear timing.
    - Test "Pop-up" overlay permissions.
- [ ] **6.2 Hardening**
    - Ensure app locks (God Mode = false) when backgrounded (`WidgetsBindingObserver`).
    - Proguard rules to obfuscate the "Ghost" logic.
- [ ] **6.3 Final Verification**
    - Run all Unit, Widget, and Integration tests.
    - Verify release build configuration.