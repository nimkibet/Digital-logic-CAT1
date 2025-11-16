Process Documentation: Development and Deployment Log
Project Title: Number Converter Application
Team: Nimrod Kibet (and group members)
Date: September 2025

1. Collaboration and Version Control
The team utilized Git for version control and GitHub for collaborative hosting. This ensured all team members and the lecturer could access the most current codebase, review changes, and manage contributions efficiently.

1.1 Repository Setup and Access
Action: A private repository named number_converter_app was initialized and the initial Flutter project files were pushed.

Requirement Fulfillment: The lecturer and all group members were successfully added as collaborators on the GitHub repository, fulfilling the access requirement.

Key Security Step: The .gitignore file was correctly configured to exclude large, auto-generated files (like the build/ folder) and, critically, to protect sensitive files like android/key.properties, ensuring passwords were never uploaded to the public repository.

1.2 Initial Deployment Hurdle: Corrupted Gradle Wrapper
Upon attempting the first build, the team encountered a recurring dependency error that prevented the app from compiling:

|

| Error Type | Description | Resolution |
| java.util.zip.ZipException: zip END header not found | This error indicates that the Gradle distribution file, necessary for compiling the Android app, was incomplete or corrupted during an initial download attempt (likely due to unstable internet). | The team manually navigated to the local Gradle cache (C:\Users\Sharon\.gradle\wrapper\dists), deleted the corrupted distribution folders, and ran flutter clean before attempting the build again. This forced a clean download and resolved the issue. |

2. Android Deployment (Release Build)
The primary goal of this phase was to generate a signed, release-ready Android APK file (.apk), a mandatory requirement for submission. This process required configuring the native Android build system (Gradle) to use a private signing key.

2.1 Keystore Generation Challenges
Creating the necessary private key (key.jks) involved using the keytool utility. This presented two initial, non-fatal command-line challenges:

| Challenge | Error Message | Resolution |
| Tool Not Found | keytool: The term 'keytool' is not recognized... | The system path did not include the JDK directory. The team resolved this by using the full, quoted path to the executable with the PowerShell call operator: & "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" ... |
| Destination Not Found | java.io.FileNotFoundException: C:\Users\Sharon\upload-keystore\key.jks (The system cannot find the path specified) | The keytool utility cannot create intermediate directories. The team manually created the secure destination folder (upload-keystore) using mkdir before rerunning the command successfully. |

2.2 Gradle Configuration Errors
After successfully generating the key.jks file, the team created the secure android/key.properties file and attempted to configure the android/app/build.gradle.kts file.

| Challenge | Error Message | Resolution |
| Incorrect DSL Syntax | Unresolved reference: storeFile, Too many characters in a character literal | The code added to build.gradle.kts was written in Groovy DSL, but the file required Kotlin DSL. The configuration was rewritten using correct Kotlin syntax (signingConfigs { create("release") { ... } }, signingConfig = signingConfigs.getByName("release")) to resolve numerous compilation errors. |
| Missing Properties File | localProperties.getProperty("storeFile") must not be null | This final error indicated that the build system could not find the required key.properties file. This was due to the file being incorrectly saved as key.txt or similar. |

2.3 Final Success
After resolving all configuration issues, the final command ran successfully:

flutter build apk --release
√ Built build\app\outputs\flutter-apk\app-release.apk (43.2MB)


The team has successfully deployed the application to the Android platform, producing a signed, release-ready APK, and fulfilling the requirement to be deployable on Android.

3. iOS Deployment (Pending)
The requirement for iOS deployment remains pending due to the need for a macOS environment and an active Apple Developer Program membership, which are external dependencies. Should these resources become available, the team is prepared to proceed with the flutter build ipa --release command and the subsequent Xcode archival process.