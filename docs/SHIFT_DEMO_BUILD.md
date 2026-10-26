# ASSAB cashier shift demo — source handoff (2026-10-26)

This is a deliberately limited real-backend Android demo. Its entrypoint is
`lib/main_shift_demo.dart`; do not use `main_development.dart` or
`main_production.dart` for this delivery. The original application screens and
Firebase/Pusher startup are outside this demo path.

## Source and contract authority

- Repository: `mahmoudmagdy200000-code/AssabAPP`.
- Main verified on GitHub: `b2453481966fc1ae2cdfcac4161bbb29a3ba5828`.
- Recovered candidate/parent: `569eca4dfdb9faabeec3b5d16b47a4f7ae1b22cd`.
- Candidate tree: `641ad063ff79e1bdb8e982cfd25da96284291c60`.
- Candidate is two commits ahead of main, with main as merge base. The candidate
  object is recoverable by SHA, but its former named task branch was not found.
- Local task branch: `task/app-shift-demo-apk-ready-20261026`.
- Backend GitHub candidate verified at `26f86c683a17a8c5ebe19771186d6b35230d62cf`.
  Inspected `Modules/Shift/routes/api.php`, `ShiftEndController`,
  `ShiftCashCountService`, `CashierShiftController`, and cashier authentication.
- This verifies the source contract, not the deployed Coolify SHA. An unauthenticated
  GET to staging's cashier in-progress route returned HTTP 401 JSON. PHP response
  header reported 8.3.36. No database connection or deployed SHA was established.
- No authenticated staging calls, fixture creation, financial requests, deployment,
  infrastructure writes, push, merge, or backend changes were performed.

## Demo behavior

1. Cashier logs in with an already activated, approved synthetic account.
2. The app lists the server's assigned in-progress shifts and loads the chosen
   shift's current detail/status. Tokens remain in memory and are not logged.
3. Enter gross sales, card payments, actual counted drawer cash, and any included
   undecided inbound cash. Cash count zero is valid; blank/negative/nondecimal/
   nonfinite/overprecision inputs fail closed.
4. Request server reconciliation. Expected cash, confirmed opening, pending cash,
   signed variance, variance type and shortage come from the server.
5. If required, allocate the complete shortage to identified in-branch people.
   Allowed types: cashier, branch_manager, employee. The server determines branch
   eligibility. Duplicate identities, zero/negative shares, missing IDs, disallowed
   types and unequal totals cannot be submitted.
6. Confirm closure without handover. The resulting status comes from the close
   response and must be `completed`. No local success is simulated.
7. HTTP errors show status, backend code/message and field errors. Any failed or
   ambiguous closure requires a read-only shift refresh before another preview.
   There is no automatic transaction retry. Inputs and double submission are
   blocked while a request is in flight.

## Reproduce with a separate Android build agent

Use Flutter **3.35.7**, Dart **3.9.2** (the checked-in `.fvmrc`), JDK 17,
Android platform 36, build-tools 35.0.0, accepted Android SDK licenses, and the
NDK requested by Flutter. Gradle/Android dependencies require network access.
Use a clean checkout with no private `.env` or Firebase configuration.

The `demo` Android flavor has its own application ID
`com.erp.assab.shiftdemo.debug` for a debug APK. Its Google Services and Crashlytics
configuration tasks are disabled because this entrypoint never starts Firebase.
Debug signing uses the build machine's normal Android debug key; no release key
is needed. This APK is for sideloaded demonstrations, not store publication.

Required non-secret build input: `API_BASE_URL`, a verified staging HTTPS base URL
ending in `/api/v1/`. No production fallback exists. `DEMO_MODE=true` explicitly
selects this restricted entrypoint; it does not mock backend transactions.
Known legacy Hostinger production hosts are rejected for demo mode.
The staging address previously observed is:
`https://szkrjqiuo9s6d6nsy5fldc0j.62.72.19.141.sslip.io/api/v1/`.
Confirm its deployed identity before the authenticated demonstration.

The root asset declaration expects `.env`; create a comment-only placeholder.
This entrypoint never reads it. Never bundle an actual private `.env` for the demo.

```bash
export CI=true FLUTTER_SUPPRESS_ANALYTICS=true
export API_BASE_URL='https://<verified-staging-host>/api/v1/'
bash scripts/build-shift-demo.sh
```

Exact APK command after dependencies/tests:

```bash
flutter build apk --debug --flavor demo --target lib/main_shift_demo.dart \
  --dart-define=DEMO_MODE=true \
  --dart-define=API_BASE_URL=https://<verified-staging-host>/api/v1/
```

Expected output: `build/app/outputs/flutter-apk/app-demo-debug.apk`.
The build script uses the committed lockfile and creates a non-secret placeholder
asset. On restricted container filesystems, `TAR_OPTIONS=--no-same-owner` may be
needed for Flutter's SDK artifact extraction.

Manual checks (no staging writes):

```bash
flutter pub get --enforce-lockfile
flutter analyze lib/main_shift_demo.dart lib/shift_demo test/shift_demo
flutter test test/shift_demo test/core/network/api_base_url_test.dart
flutter analyze
flutter test
```

`CI=true` prevents Flutter's automatic Azure instance-metadata probe. An initial
version command was rejected by automatic review for that probe; SDK source
inspection identified its cause, and subsequent commands disable it through
Flutter's supported CI environment detection. No metadata read was authorized.

## Limits and acceptance gate

- This demo lists already running assigned shifts. Account activation, shift
  assignment/start and initial cash receipt must be prepared separately using
  approved synthetic fixtures. This task does not provision them.
- Use fixtures with **no delivery-platform sales**. Aggregator entry, receipt
  uploads, cashier handover, reassignment, report correction, accounting approval,
  daily close and the rest of the ERP are not exposed by this demo entrypoint.
- Allocation recipients use approved IDs supplied by the demo operator; this
  limited screen has no employee-directory picker. Backend validation is final.
- No credentials or approved synthetic fixtures were supplied here. Live login,
  reconciliation and closure are NOT_RUN; no E2E acceptance is claimed.
- Original candidate UI remains in the source history. This delivery's guarantees
  apply to the dedicated demo entrypoint. Full-app modernization is not implied.
- Final validation results and final Git identities are in the transfer handoff.

## Executed validation (2026-10-26)

| Gate | Result | Evidence |
|---|---|---|
| Exact source recovery/ancestry | PASS | main unchanged; candidate recovered by SHA |
| Dedicated demo + changed network files analyzer | PASS | 6 targets, no issues |
| Focused demo/network tests | PASS | 27 tests |
| Complete repository test suite | PASS | 39 tests, no failures |
| Full repository analyzer | FAIL | 552 existing diagnostics, including missing original `lib/firebase_options.dart`; no diagnostics in changed/new demo/network/test files |
| Android APK build | FAIL | Gradle could not resolve `org.gradle.kotlin.kotlin-dsl` plugin 5.2.0 from the Gradle Plugin Repository; no APK produced |
| Live deployed SHA/database identity | NOT_RUN | no authorized Coolify/DB connection available |
| Authenticated staging/E2E | NOT_RUN | no credentials/approved synthetic fixtures; no staging writes authorized |
| GitHub publication | NOT_RUN | not authorized |

The full analyzer failure is not hidden by the dedicated entrypoint. The original
Firebase-dependent application entrypoints remain outside this demo's acceptance.
The first Android attempt could not download Gradle through Java's direct network
path. Gradle 8.13 was subsequently downloaded and its official SHA256 verified;
the next build reached plugin resolution and failed as recorded above. A curl
read of that plugin's marker POM returned HTTP 200, so its exact Gradle-specific
resolution failure remains an environment/build-agent investigation gate.

The lockfile was aligned to Flutter 3.35.7/Dart 3.9.2: Flutter's pinned
`characters`, `matcher`, `material_color_utilities`, `meta`, and `test_api`
versions replaced incompatible pins that required Dart 3.10. No direct app
dependencies were upgraded. Preserve the delivered lockfile.

**Delivery decision:** source/tests ready for an independent build attempt;
Android compilation and real-backend demonstration remain unverified. This is
not a claim that an APK is built, installed, E2E-tested, or accepted.
