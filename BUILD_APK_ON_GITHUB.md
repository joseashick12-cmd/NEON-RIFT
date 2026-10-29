# Build an installable Android APK

This workflow attempts to export a debug APK for testing. It has not yet been validated by a successful remote build.

1. Open the repository's Actions tab.
2. Select **Build NEON RIFT Android APK** and click **Run workflow**.
3. When the run succeeds, download artifact **NEON-RIFT-Android-APK** and extract `NEON_RIFT.apk`.
4. Transfer the APK to an Android phone and install it. This is a test build, not a Play Store release.

Application ID: `com.neonrift.game`. Change it to a unique permanent ID before publishing. The online multiplayer prototype is not production-ready and needs a deployed server and further testing.
