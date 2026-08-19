plugins {
    id("com.android.library")
}

android {
    namespace = "com.quanneggaes4d.native"
    compileSdk = 36

    defaultConfig {
        minSdk = 26
    }

    sourceSets["main"].jniLibs.srcDirs("src/main/jniLibs")
}
