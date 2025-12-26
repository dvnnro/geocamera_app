# 📸 GeoCamera App

By : Davina Nur Oktavia

**GeoCamera App** is a mobile application built with **Flutter** that allows users to capture photos while automatically retrieving the precise geolocation data (Latitude & Longitude) of where the photo was taken.

## 🚀 Features

- **Camera Integration:** Capture images directly within the app using the device's camera.
- **Geolocation Tracking:** Automatically fetch current GPS coordinates (Latitude, Longitude) using high-accuracy location services.
- **Permission Handling:** Manages Android permissions for Camera and Location access seamlessly.
- **User Friendly UI:** Simple and intuitive interface for quick capturing and tagging.

## 🛠 Tech Stack

- **Framework:** [Flutter](https://flutter.dev/) (Dart)
- **Plugins used:**
  - [`image_picker`](https://pub.dev/packages/image_picker): For accessing the camera.
  - [`geolocator`](https://pub.dev/packages/geolocator): For accessing GPS services.

## ⚙️ Installation & Setup

Follow these steps to run the project locally on your machine.

### Prerequisites

- Flutter SDK installed ([Guide](https://docs.flutter.dev/get-started/install))
- Android Studio / VS Code
- Android Device or Emulator

### Steps

1.  **Install dependencies**

    ```bash
    flutter pub get
    ```

2.  **Run the App**
    Connect your device and run:
    ```bash
    flutter run
    ```

## 📱 Android Configuration (Important)

This project requires specific Android configurations to work correctly with the latest plugins.

**1. Permissions (`AndroidManifest.xml`)**
Ensure your `android/app/src/main/AndroidManifest.xml` includes:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```
