plugins {
    id("com.android.application")
    id("kotlin-android")
    // O Flutter Gradle Plugin deve vir depois do Android e Kotlin
    id("dev.flutter.flutter-gradle-plugin")
    // Plugin do Firebase
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.mercado_zap"
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
        applicationId = "Mercado.zap"
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
    // Firebase BoM (gerencia automaticamente as versões dos SDKs)
    implementation(platform("com.google.firebase:firebase-bom:34.8.0"))

    // Firebase Analytics
    implementation("com.google.firebase:firebase-analytics")

    // Exemplo de outros SDKs que você pode adicionar:
    // implementation("com.google.firebase:firebase-auth")
    // implementation("com.google.firebase:firebase-firestore")
}
