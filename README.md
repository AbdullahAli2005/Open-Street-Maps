# Free Map (OSM) with Route Directions in Flutter

## 🚀 Overview
This Flutter project integrates **OpenStreetMap (OSM)** using `flutter_map` and allows users to:
- 📍 **Set Start & End Points** by tapping on the map.
- 🚗 **Fetch and Display Routes** using OpenRouteService API.
- 🗺 **Display Maps without Google Maps API** (Free & Open Source).
- 🔎 **Secure API Key using .env** (Prevents key exposure).

---

## 📦 Dependencies
Add these dependencies to `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_map: ^7.0.0
  flutter_map_cancellable_tile_provider: ^1.0.2
  latlong2: ^0.9.0
  flutter_dotenv: ^5.1.0
  http: ^0.13.5
```

---

## 🔧 Installation & Setup
### 1️⃣ Install Dependencies
Run the following command:
```sh
flutter pub get
```

### 2️⃣ Set Up .env for API Key
Create a `.env` file in the **root directory** and add your OpenRouteService API key:
```
OPENROUTESERVICE_API_KEY=your_actual_api_key_here
```

### 3️⃣ Load .env in main.dart
Modify `main.dart`:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(); // Load .env file
  runApp(const MyApp());
}
```

### 4️⃣ Use API Key in Your Code
Replace hardcoded API keys with:
```dart
final String apiKey = dotenv.env['OPENROUTESERVICE_API_KEY'] ?? "";
```

---

## 🗺 Features
✅ **Interactive Map** - Tap to place markers.  
✅ **Route Directions** - Shows route between two points.  
✅ **Secure API Key** - Uses `.env` to hide API keys.  
✅ **Clear Route** - Button to remove markers & routes.  
✅ **Offline Tile Provider Support** - Improves performance.  

---

## 🏗 How to Use
1️⃣ **Run the app**
```sh
flutter run
```
2️⃣ **Tap on the map** to set the **start point** (Green marker).  
3️⃣ **Tap again** to set the **destination** (Red marker).  
4️⃣ Route will be fetched & displayed automatically! 🚗  
5️⃣ Press **"Clear Route"** to remove markers and routes.  

---

## 🛠 Troubleshooting
### API Key Not Working? 🔑
- Ensure you have a valid OpenRouteService API key.
- Check if you **copied the key correctly** in `.env`.
- Make sure you **restart** your app after changes.

### Routes Not Fetching? 🛣️
- Check your **console logs** for errors.
- Ensure **valid coordinates** are selected.
- Try different locations (some may not support routing).

---

## 🤝 Contributing
Feel free to contribute! Fork the repo, create a new branch, and submit a pull request. 🚀

---

## 📝 License
This project is **MIT Licensed**. You can freely use and modify it.

---

### 💡 Author
Developed by **Abdullah** ✨

---

🚀 **Enjoy building your own OpenStreetMap-based Flutter app!**

