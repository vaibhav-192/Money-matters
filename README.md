# Money Matters 💰

**A Flutter-based personal finance and expense tracking application.**

Money Matters helps you manage your personal finances by tracking income, expenses, account balances, budgets, transfers, and recurring transactions in one place. It includes cloud backup and restore functionality to help you preserve your financial data.

## ✨ Features

- **Dashboard:** View your total balance and a summary of your finances.
- **Transaction Management:** Add, edit, delete, and view income and expense transactions.
- **Multiple Accounts:** Manage separate accounts such as cash, bank accounts, and wallets.
- **Categories:** Organize transactions using income and expense categories.
- **Budget Management:** Set budgets and track spending against your limits.
- **Transfers:** Record money transfers between accounts.
- **Recurring Transactions:** Set up repeating income and expenses with account and category selection.
- **Analytics Dashboard:** View monthly income, expenses, savings, transaction counts, largest transactions, and category-wise spending.
- **Authentication:** Sign in using the configured authentication provider.
- **Cloud Backup and Restore:** Back up and restore supported financial data using Firebase.
- **Automated Tests:** Run integration tests to check important app flows and reduce regressions.

> Features may depend on the current project configuration and Firebase setup.

## 🛠️ Technology Stack

- **Flutter** — Cross-platform application framework
- **Dart** — Programming language
- **Firebase Authentication** — Authentication
- **Cloud Firestore** — Cloud data and backup functionality
- **Flutter Integration Test** — Automated app testing

## 📋 Prerequisites

Install the following tools before running the project.

| Tool | Purpose | Download |
|---|---|---|
| Flutter SDK | Build and run the application | [Flutter installation guide](https://docs.flutter.dev/get-started/install) |
| Dart SDK | Included with Flutter | [Dart](https://dart.dev/get-dart) |
| Git | Clone the repository | [Git](https://git-scm.com/downloads) |
| Android Studio | Android SDK, emulator, and build tools | [Android Studio](https://developer.android.com/studio) |
| VS Code (optional) | Code editor | [VS Code](https://code.visualstudio.com/) |

For a physical Android phone, enable Developer Options and USB debugging.

Check your installation:

```bash
flutter doctor
```

Resolve any required Android toolchain or license issues reported by Flutter before building.

## 📥 1. Clone the Repository

Open a terminal or PowerShell window and run:

```bash
git clone https://github.com/vaibhav-192/Money-matters.git
cd Money-matters
```

If you have downloaded the repository as a ZIP file instead, extract it and open a terminal in the extracted project directory.

## 📦 2. Install Dependencies

Run the following commands from the project root:

```bash
flutter clean
flutter pub get
```

This removes generated build artifacts and downloads the dependencies defined by the project.

## 🔥 3. Configure Firebase

Money Matters uses Firebase functionality, so configure your own Firebase project before running the app if the repository does not already contain a usable configuration.

### Create a Firebase project

1. Open the [Firebase Console](https://console.firebase.google.com/).
2. Create a Firebase project.
3. Register an Android app using the Android application ID from the project's Gradle configuration.
4. Download the generated `google-services.json` file.
5. Place it in the Android app module, typically:

   ```text
   android/app/google-services.json
   ```

6. Enable the Firebase Authentication providers required by the application.
7. Enable Cloud Firestore if you want to use the cloud data features.
8. Configure any additional Firebase options required by the project's existing code.

If the project uses FlutterFire CLI configuration, follow the [FlutterFire setup guide](https://firebase.google.com/docs/flutter/setup) as well.

**Important:** The exact Firebase setup depends on the project's existing configuration. Check `android/app/build.gradle`, `android/app/build.gradle.kts`, `lib/main.dart`, and any Firebase initialization files before changing the setup.

Do not commit private credentials, service-account keys, or other sensitive configuration to a public repository. Firebase client configuration is not a substitute for Firestore security rules.

## 📱 4. Run on an Android Phone

### Step 1: Enable USB debugging

On your Android phone:

1. Open Settings → About phone.
2. Find Build number and tap it seven times to enable Developer Options. The exact steps may vary by manufacturer.
3. Open Developer Options.
4. Enable USB debugging.
5. Connect the phone to your computer using a USB data cable.
6. Accept the debugging authorization prompt on your phone.

### Step 2: Verify the device

From the project directory, run:

```bash
flutter devices
```

Your connected phone should appear in the device list.

If it does not appear, check the USB cable, debugging authorization, and Android USB drivers where applicable.

### Step 3: Run the app

```bash
flutter run
```

If multiple devices are connected, specify the device ID:

```bash
flutter run -d YOUR_DEVICE_ID
```

Replace `YOUR_DEVICE_ID` with the ID displayed by `flutter devices`.

Flutter will compile the Android application, install it on the phone, and launch it.

## 🖥️ 5. Run on an Android Emulator

1. Open Android Studio.
2. Open Device Manager.
3. Create an Android Virtual Device if you do not already have one.
4. Start the emulator.
5. Return to the project terminal.

Run:

```bash
flutter devices
flutter run
```

The emulator should appear as an available Flutter device.

## 🧪 6. Run Automated Tests

Money Matters includes integration tests under the `integration_test/` directory.

### Run a single test

For example:

```bash
flutter test integration_test/app_flow_test.dart
```

Other test files include:

```text
integration_test/
├── app_flow_test.dart
├── backup_restore_test.dart
├── budget_timeline_test.dart
├── cloud_sync_test.dart
├── transaction_test.dart
├── recurring_test.dart
├── logout_test.dart
├── dashboard_test.dart
├── navigation_test.dart
└── analytics_test.dart
```

The exact tests available may change as the project evolves.

### Run the complete integration test suite

Connect a supported Android device or start an emulator, then run:

```bash
flutter test integration_test
```

Review the output and confirm that the tests pass. Tests involving authentication, Firebase, cloud backup, or restore may require a correctly configured test environment.

### Check code formatting and static analysis

```bash
dart format lib test integration_test
flutter analyze
```

These commands help identify formatting issues and potential code problems.

## 📂 Project Structure

The main project directories are organized as follows:

```text
Money-matters/
├── android/             # Android platform configuration
├── integration_test/    # Integration tests
├── lib/
│   ├── core/            # Core application functionality
│   ├── features/
│   │   ├── dashboard/   # Dashboard
│   │   ├── transactions/# Transaction management
│   │   ├── budgets/     # Budget functionality
│   │   ├── recurring/   # Recurring transactions
│   │   ├── analytics/   # Analytics dashboard
│   │   └── settings/    # Application settings
│   ├── models/          # Data models
│   └── services/        # Data, cloud, and business logic
├── pubspec.yaml         # Dependencies and project metadata
└── README.md
```

Directory names may vary slightly with future changes to the codebase.

## 📦 7. Build an APK

To build an Android APK for installation on a compatible Android phone, run:

```bash
flutter build apk --release
```

When the build succeeds, the APK is typically generated at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

Transfer the APK to your phone and install it. Android may require you to permit installation from the source you use to open the file.

For a smaller set of APKs tailored to device architectures, you can also use:

```bash
flutter build apk --split-per-abi
```

Alternatively, build an Android App Bundle for distribution through Google Play:

```bash
flutter build appbundle
```

Release builds may require additional signing and Firebase configuration.

## 🔐 Data and Security

- Use your own Firebase project and authentication configuration when setting up a separate deployment.
- Configure Firestore security rules to ensure users can access only their authorized data.
- Keep service-account credentials and private keys out of source control.
- Test backup and restore carefully before importing important financial data.
- Do not use a production financial account or important personal data as test data.

## 🐛 Troubleshooting

### Flutter command not found

Make sure the Flutter SDK is installed and its `bin` directory is included in your system's PATH.

Verify with:

```bash
flutter --version
```

### Dependencies fail to resolve

Try:

```bash
flutter clean
flutter pub get
```

If the error persists, check the Flutter and Dart SDK versions supported by `pubspec.yaml`.

### Android device not detected

Run:

```bash
flutter devices
```

Confirm USB debugging is enabled and the phone has authorized your computer.

On Windows, check that the appropriate Android USB driver is installed if necessary.

### Firebase initialization or authentication fails

Verify that:

- Firebase configuration files are in the correct locations.
- The Android application ID matches the registered Firebase app.
- The required Firebase services and authentication providers are enabled.
- The device has internet access.
- Firestore rules permit the intended operation.

### Integration tests fail

Run the failing test individually first:

```bash
flutter test integration_test/transaction_test.dart
```

Read the first compilation or assertion error before changing code. A failed test can indicate either a real application bug or an outdated test expectation.

## 🤝 Contributing

Contributions, bug reports, and suggestions are welcome.

1. Fork the repository.
2. Create a feature branch.
3. Implement your changes.
4. Run formatting, analysis, and relevant tests.
5. Submit a pull request describing your changes.

## 📄 License

No license has been specified here. Unless a license is added to the repository, the project should not be assumed to permit unrestricted reuse, redistribution, or modification.

## 👨‍💻 Author

**Vaibhav Gupta**

GitHub: [vaibhav-192](https://github.com/vaibhav-192)

Repository: [Money Matters](https://github.com/vaibhav-192/Money-matters)
