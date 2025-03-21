import java.util.Properties
import java.io.File

def keystorePropertiesFile = rootProject.file("key.properties")
def keystoreProperties = new Properties()

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            storeFile = keystoreProperties["storeFile"] ? file(keystoreProperties["storeFile"]) : null
            storePassword = keystoreProperties["storePassword"] ?: ""
            keyAlias = keystoreProperties["keyAlias"] ?: ""
            keyPassword = keystoreProperties["keyPassword"] ?: ""
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
