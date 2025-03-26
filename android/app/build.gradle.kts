plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // Required for Firebase
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.maxframe"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.maxframe" // Must match Firebase package name
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase dependencies
    implementation(platform("com.google.firebase:firebase-bom:32.2.3")) // BOM manages versions
    implementation("com.google.firebase:firebase-auth-ktx") // Auth module
    implementation("com.google.firebase:firebase-firestore-ktx") // Firestore module (optional)
}