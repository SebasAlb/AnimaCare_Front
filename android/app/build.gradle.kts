plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
<<<<<<< HEAD
<<<<<<< HEAD
    namespace = "com.mapa.mapa"
=======
    namespace = "com.historial.historial"
>>>>>>> 905a317050fcb6b6eb607bcee0094ef8735d2c5f
=======
    namespace = "com.example.animacare_front"
>>>>>>> b1d7e4d560bfa8cd64d513e98d765d751ae95b86
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
<<<<<<< HEAD
<<<<<<< HEAD
        applicationId = "com.mapa.mapa"
=======
        applicationId = "com.historial.historial"
>>>>>>> 905a317050fcb6b6eb607bcee0094ef8735d2c5f
=======
        applicationId = "com.example.animacare_front"
>>>>>>> b1d7e4d560bfa8cd64d513e98d765d751ae95b86
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
