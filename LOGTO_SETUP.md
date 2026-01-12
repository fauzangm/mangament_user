# Setup Logto untuk Flutter

Panduan lengkap mengintegrasikan Logto authentication ke aplikasi Flutter Anda.

## 1. Daftar Akun Logto

1. Kunjungi [https://cloud.logto.io](https://cloud.logto.io)
2. Buat akun dan login
3. Buat project baru
4. Catat **Endpoint** dan **Client ID** Anda

## 2. Konfigurasi Logto di Flutter

### Update Logto Config

Edit file `lib/core/constants/logto_config.dart`:

```dart
class LogtoConfig {
  static const String endpoint = 'https://your-app.logto.app'; // Ganti dengan endpoint Anda
  static const String clientId = 'YOUR_CLIENT_ID'; // Ganti dengan Client ID Anda
  static const String appScheme = 'io.logto.flutter';
  static const String redirectUrl = '$appScheme://callback';

  static const List<String> scopes = [
    'openid',
    'profile',
    'email',
  ];
}
```

### Konfigurasi Android

Edit `android/app/build.gradle.kts` dan tambahkan:

```gradle
android {
    ...
    defaultConfig {
        ...
        manifestPlaceholders["logtoScheme"] = "io.logto.flutter"
    }
}
```

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<activity
    android:name=".MainActivity"
    android:exported="true">
    
    <intent-filter>
        <action android:name="android.intent.action.MAIN" />
        <category android:name="android.intent.category.LAUNCHER" />
    </intent-filter>

    <!-- Tambahkan intent filter ini untuk OAuth redirect -->
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data
            android:scheme="io.logto.flutter"
            android:host="callback" />
    </intent-filter>
</activity>
```

### Konfigurasi iOS

Edit `ios/Runner/Info.plist`:

```xml
<dict>
    ...
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLName</key>
            <string>logto</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>io.logto.flutter</string>
            </array>
        </dict>
    </array>
    ...
</dict>
```

Edit `ios/Runner/GeneratedPluginRegistrant.swift` jika diperlukan (biasanya auto-generated).

## 3. Konfigurasi Logto Dashboard

1. Login ke [Logto Dashboard](https://cloud.logto.io)
2. Pilih Application Anda
3. Di bagian **Redirect URIs**, tambahkan:
   - Android: `io.logto.flutter://callback`
   - iOS: `io.logto.flutter://callback`
   - Web: `http://localhost:3000/callback` (jika ada)

## 4. Fitur Logto di Aplikasi

### Login dengan Logto

Di LoginPage, ada tombol "Sign in with Logto" yang:
- Membuka OAuth flow
- Redirect ke Logto login
- Mengambil user info setelah authentication
- Menyimpan user state di AuthBloc

```dart
context.read<AuthBloc>().add(
  const LoginWithLogtoRequested(),
);
```

### Logout

```dart
context.read<AuthBloc>().add(
  LogoutRequested(),
);
```

### Check Authentication Status

```dart
context.read<AuthBloc>().add(
  AuthCheckRequested(),
);
```

## 5. Troubleshooting

### Error: "Invalid redirect URI"
- Pastikan redirect URL di Logto Dashboard sesuai dengan app scheme Anda
- Format: `io.logto.flutter://callback`

### OAuth Flow tidak terbuka
- Verifikasi `endpoint` dan `clientId` di LogtoConfig
- Pastikan internet connection aktif
- Check logcat (Android) atau Xcode console (iOS)

### User info tidak terambil
- Verifikasi scopes di LogtoConfig sudah benar
- Check Logto Dashboard untuk permission settings

## 6. Testing

```bash
# Run app di Android
flutter run -d emulator-5554

# Run app di iOS
flutter run -d iPhone
```

Test flow:
1. Buka app
2. Klik tombol "Sign in with Logto"
3. Login menggunakan akun Logto
4. Verifikasi user info muncul di dashboard
5. Klik logout untuk sign out

## 7. Production Setup

Sebelum release ke production:

1. Update `LogtoConfig` dengan credentials production Anda
2. Update redirect URIs di Logto Dashboard untuk domain production
3. Update app signing credentials (Android/iOS)
4. Test secara menyeluruh di environment production

## Referensi

- [Logto Documentation](https://docs.logto.io)
- [Logto Dart SDK](https://pub.dev/packages/logto_dart_sdk)
- [Flutter OAuth Flow](https://docs.logto.io/docs/recipes/integrate-logto/flutter)
