# MentoraX Mobile (Flutter)

MentoraX Mobile is a **Flutter-based learning and habit tracking app** that works with the MentoraX backend.

---

## 🚀 Features

* User login (JWT)
* Material creation & management
* Study plan creation
* Session tracking
* Dashboard with next session
* Progress & streak tracking
* Local notifications (reminders)

---

## 🧱 Architecture

* Flutter (Material UI)
* Riverpod (state management)
* Dio (API communication)
* Clean feature-based structure

```
lib/
├── core/
├── features/
│   ├── auth/
│   ├── materials/
│   ├── study_plans/
│   ├── sessions/
│   ├── dashboard/
│   └── settings/
```

---

## ⚙️ Requirements

* Flutter 3.38+
* Android SDK 34+ (recommended 36)
* Java 17
* Android Emulator or real device

---

## 🔧 Setup

### 1. Clone repo

```
git clone https://github.com/ethemserce/mentorax_mobile.git
cd mentorax_mobile
```

---

### 2. Install dependencies

```
flutter pub get
```

---

### 3. Configure API URL

File:

```
lib/core/config/app_config.dart
```

For Android emulator:

```dart
static const String baseUrl = 'http://10.0.2.2:5107';
```

For real device:

```dart
static const String baseUrl = 'http://YOUR_LOCAL_IP:5107';
```

---

### 4. Run app

```
flutter run
```

---

## 🔔 Notifications

Local notifications are used for:

* session reminders
* study planning alerts

---

## 🧪 Testing Flow

1. Login
2. Create material
3. Create study plan
4. Check dashboard (next session)
5. Start session
6. Complete session
7. Observe progress updates

---

## 📡 Backend Dependency

This app requires the backend:

https://github.com/ethemserce/MentoraX

Make sure backend is running before starting the app.

---

## 🧠 Future Improvements

* Firebase Push Notifications
* Offline mode
* Dark theme
* Advanced analytics
* Gamification

---

## 👤 Author

Ethem Serçe
