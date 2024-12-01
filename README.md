# frontend

A new Flutter project.

flutter build appbundle

# first time init android
cd android
keytool -genkey -v -keystore ./app/keystore.jkss -keyalg RSA -keysize 2048 -validity 10000 -alias upload

edit ./key.properties 

storePassword=sosolid38
keyPassword=sosolid38
keyAlias=upload
storeFile=./keystore.jkss

android/app/build.gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file("key.propertiess")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
android{
    ...
    namespace "guide.aqua.calc"
    applicationId "guide.aqua.calc"
         signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled false
            shrinkResources false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
android/app/src/main/kotlin/com/example/calculator/MainActivity.kt
    package guide.aqua.calc
    

# Flutter Project

## Publishing Android

- **pubspec.yaml** dosyasında **version** yükselt
- **android/app/build.gradle** dosyası içinde **versionCode** yükselt
- terminal'de > **flutter build appbundle**
- https://play.google.com/console/u/1/developers/6782429409886191490/app/4973925128162264744/tracks/production sitesine gir.
- Yeni sürüm oluştur.
- build alınan appbundle dosyasını buraya yükle (**build/app/outputs/bundle/release/app-release.aab**).
- Sürüm adının versiyon adının aynısı olması lazım (ör. 1.0.7).
- Sürüm notları önceki sürümlerden kopya butonu ile alınıp değiştirilmeli.

## Publishing iOS

- XCode sol menü içerisindeki **Runner**'a tıklayıp ekranın ortasındaki **Targets > Runner Version** ve **Build**'i yükselt. **Any iOS device**'ın seçili olması lazım.
- Aynı yerde en yukarı menüden **Product > Archive**'a tıkla,
  -Arşiv bitince listeden son versiyonu distribute app >
- varsayılan seçeneklerle sihirbazı bitir.
- 15 dakika sonra https://appstoreconnect.apple.com/ adresinde **App** klasörü içerisindeki **Predixi UI**'a tıkla, daha sonra **TestFlight** menüsü içinde XCode ile gönderilen build görünecektir.
- **Manage** yazısı olacak, ona tıklayıp **No** deyin **TestFlight** aktif olacaktır.
- **AppStoreConnect**'teki uygulama anasayfasında sol menüde sürüm bilgileri üstünde **+** işareti ile yeni versiyon oluşuyor, **pop-up** açılıyor versiyonu yazınca.
- Altta XCode ile gelen build burada seçiliyor. Daha sonra devam deyip kapatıyoru, **build** yükleniyor. Orada bir metin alanı var, orada yeni eklenen özellikler yazılıyor.
- **Android**'dekinin aynısı yazılıyor ve sağ yukarıdan mavi buton ile gönderiliyor.

örnek sürüm notu:
Siz kullanıcılarımıza daha güzel bir deneyim sağlamak için özenle çalışıyoruz. Bu güncellemede;

- Bilinen hatalar giderildi.
- Verim ekranı eklendi.

### init ios

1- Open the Flutter project's Xcode target with
open ios/Runner.xcworkspace
2- Select the 'Runner' project in the navigator then the 'Runner' target
in the project settings
3- Make sure a 'Development Team' is selected under Signing & Capabilities >
Team.
You may need to: - Log in with your Apple ID in Xcode first - Ensure you have a valid unique Bundle ID - Register your device with your Apple Developer Account - Let Xcode automatically provision a profile for your app
4- Build or run your project again
5- Trust your newly created Development Certificate on your iOS device
via Settings > General > Device Management > [your new certificate] > Trust

## Getting Started

flutter upgrade
flutter clean
flutter create .
flutter pub get
rm -rf ./ios/Pods && rm -rf ./ios/Podfile.lock
export GEM_HOME=~/.gems
export PATH=$GEM_HOME/bin:$PATH
gem install cocoapods -V