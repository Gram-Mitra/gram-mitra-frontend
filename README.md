# 🌾 Gram Mitra (ग्राम मित्र) - Rural Empowerment & Smart Agriculture Mobile App

<p align="center">
  <img src="assets/icons/app_logo.png" alt="Gram Mitra Logo" width="130" height="130" />
</p>

<p align="center">
  <b>Bridging the Rural Digital Divide with Smart IoT, Government Schemes, Healthcare, and Market Access.</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart" alt="Dart" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20Web-green" alt="Platform" />
  <img src="https://img.shields.io/badge/Backend-Node.js%20%2F%20Express-339933?logo=node.js" alt="Node.js" />
  <img src="https://img.shields.io/badge/Cloud-AWS%20EC2-FF9900?logo=amazonec2" alt="AWS" />
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License" />
</p>

---

## 📖 Table of Contents

- [About the Project](#-about-the-project)
- [Key Features & Modules](#-key-features--modules)
- [System Architecture](#-system-architecture)
- [Folder Structure](#-folder-structure)
- [Backend & Cloud Integration](#-backend--cloud-integration)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Configuration](#configuration)
  - [Running the App](#running-the-app)
- [Building for Production (Android APK)](#-building-for-production-android-apk)
- [Testing & Quality Assurance](#-testing--quality-assurance)
- [Key Troubleshooting & FAQs](#-key-troubleshooting--faqs)
- [Contributors & License](#-contributors--license)

---

## 🌾 About the Project

**Gram Mitra** (*Village Friend*) is a comprehensive, human-centric mobile application developed with Flutter to empower Indian farmers and rural citizens. It tackles primary challenges faced in rural communities:

1. **Information Asymmetry**: Lack of awareness about high-subsidy government schemes and fair mandi market prices.
2. **Resource Inefficiency**: Water and electricity wastage due to lack of remote farm monitoring and precision irrigation.
3. **Healthcare Access**: Remote distance to primary health centers and delayed medical attention.
4. **Civic Governance**: Difficulty in escalating local village infrastructure problems (roads, drinking water, power supply).
5. **Myths & Superstitions**: Misleading beliefs that hinder modern scientific farming and healthcare.

Gram Mitra solves this with an intuitive, bilingual (English & Hindi) interface featuring large tap targets, dark/light themes, voice navigation, and real-time IoT integration.

---

## 🚀 Key Features & Modules

### 1. 💧 Smart Agriculture & IoT Field Telemetry
- **Live Soil Telemetry**: Visual gauges for Soil Moisture, Soil Temperature, and Water Tank levels.
- **NPK Nutrient Analysis**: Instant nitrogen (N), phosphorus (P), and potassium (K) readings in mg/kg.
- **Remote Pump Controller**: One-tap toggle for borewell irrigation pumps with active running status indicators.
- **Dynamic Crop Recommendations**: Real-time advice (e.g., target moisture ranges for Rice, Kolam, Wheat).

### 2. 🏛️ Government Schemes Navigator
- Direct access to central and state schemes: **PM-KISAN**, **PM Fasal Bima Yojana (PMFBY)**, **Kisan Credit Card (KCC)**, **Soil Health Card**, and **Solar Pump Subsidies**.
- Category filtering: Subsidies, Insurance, Credit, and Irrigation.
- Instant qualification guidelines, documentation checklists, and application steps.

### 3. 🏥 Rural Healthcare & Emergency Tele-Consult
- Quick directory of Primary Health Centers (PHCs), Community Health Centers, and Jan Aushadhi Kendras.
- One-touch emergency calling: **108 (Ambulance)**, **102 (Pregnancy/Child Helpline)**, and **104 (Health Information Helpline)**.
- Doctor consultation booking and seasonal epidemic health advisories.

### 4. 🛒 Direct Farmer Marketplace & Mandi Rates
- Connects local farmers directly to buyers and certified agricultural input vendors.
- Live APMC Mandi commodity rates (Wheat, Cotton, Soybean, Paddy, Onion).
- Certified seeds, organic bio-fertilizers, and farm equipment listings.

### 5. 📢 Village Problem & Grievance Reporting
- Allows villagers to log local infrastructure issues with photo attachments and location details.
- Categories: Water Supply, Electricity, Roads & Drainage, Sanitation, and Public Schools.
- Status tracking pipeline: `Submitted` ➔ `In Review` ➔ `In Progress` ➔ `Resolved`.

### 6. 🧠 Superstition & Myth Buster
- Science-backed awareness cards tackling prevalent rural myths (crop curses, snake bites, supernatural illnesses).
- Practical scientific explanations and safe modern practices.

### 7. 🎙️ Voice Assistant & Multilingual Support
- Built-in Voice Search & Assistant enabling hands-free queries for non-literate farmers.
- Language switcher supporting **English** and **Hindi (हिंदी)** with localized strings and iconography.

---

## 🏗️ System Architecture

```text
┌─────────────────────────────────────────────────────────────┐
│                 Gram Mitra Mobile App (Flutter)             │
│   ┌────────────────┐   ┌───────────────┐   ┌────────────┐   │
│   │  UI / Screens  │   │ Providers /   │   │  Storage & │   │
│   │  & Components  │◄─►│ State Manager │◄─►│ Local Prefs│   │
│   └────────────────┘   └───────┬───────┘   └────────────┘   │
└────────────────────────────────┼────────────────────────────┘
                                 │ HTTP / REST APIs (JSON)
                                 ▼
┌─────────────────────────────────────────────────────────────┐
│             AWS EC2 Cloud Backend (Port 30442)              │
│       URL: http://100.26.205.34:30442/api/v1                │
│                                                             │
│   ┌──────────────┐   ┌──────────────┐   ┌───────────────┐   │
│   │ Auth Service │   │ IoT Engine   │   │ Schemes &     │   │
│   │  (JWT / SMS) │   │ (MQTT / REST)│   │ Marketplace   │   │
│   └──────┬───────┘   └──────┬───────┘   └───────┬───────┘   │
│          └──────────────────┼───────────────────┘           │
│                             ▼                               │
│           PostgreSQL Database / Supabase Storage            │
└─────────────────────────────────────────────────────────────┘
```

---

## 📂 Folder Structure

```text
frontend/
├── android/                   # Native Android configuration, Gradle files & launcher icons
│   └── app/
│       ├── build.gradle       # App-level build config, signing & target SDKs
│       └── src/main/
│           ├── AndroidManifest.xml # Permissions (INTERNET, Cleartext traffic)
│           └── res/mipmap-*/  # High-resolution Gram Mitra branded launcher icons
├── assets/
│   └── icons/
│       └── app_logo.png       # 512x512 Master Brand Logo
├── lib/
│   ├── main.dart              # Application entry point & theme initialization
│   ├── core/
│   │   ├── constants/
│   │   │   ├── api_endpoints.dart  # Backend EC2 endpoint configurations
│   │   │   └── app_colors.dart     # Brand color palette (Emerald green, gold, dark tokens)
│   │   ├── localization/      # English & Hindi translation dictionaries
│   │   ├── storage/           # Token & session persistence
│   │   └── theme/             # Light & Dark theme definitions
│   ├── models/                # Typed data models (User, IoT, Scheme, Product, MythFact)
│   ├── providers/             # State management via Provider (AppStateProvider, AuthProvider)
│   ├── screens/
│   │   ├── auth/              # Login & Multi-field Registration screens
│   │   ├── home/              # Dashboard, Carousel & Quick-access actions
│   │   ├── iot/               # Connect IoT smart telemetry & pump controller
│   │   ├── language/          # Language selection screen
│   │   ├── profile/           # User account, settings & theme switcher
│   │   ├── services/          # Healthcare, Schemes, Marketplace, Problems, Support
│   │   ├── splash/            # Animated splash screen with logo
│   │   └── welcome/           # Onboarding walkthrough
│   ├── services/              # HTTP API services (Auth, Healthcare, Market, IoT, Voice)
│   └── widgets/               # Reusable UI cards, buttons, badges, and carousel sliders
├── test/
│   └── widget_test.dart       # Automated test suite (Smoke test, Dark mode, Search filter)
├── pubspec.yaml               # Flutter package dependencies and asset declarations
└── README.md                  # Comprehensive project documentation
```

---

## 🌐 Backend & Cloud Integration

The mobile app communicates with a live Node.js microservices backend deployed on **AWS EC2**:

- **Base URL**: `http://100.26.205.34:30442`
- **API Prefix**: `/api/v1`

### Key Endpoints:
| Module | Endpoint | Method | Description |
| :--- | :--- | :--- | :--- |
| **Auth** | `/api/v1/auth/login` | `POST` | User authentication via Phone & Password |
| **Auth** | `/api/v1/auth/register` | `POST` | Registers new user (`phone`, `email`, `age`, `state`, `district`, `village`) |
| **Schemes** | `/api/v1/schemes` | `GET` | Fetches active government schemes and eligibility |
| **Marketplace** | `/api/v1/marketplace/products` | `GET` | Retrieves mandi prices and agri-products |
| **Healthcare** | `/api/v1/healthcare/facilities` | `GET` | Nearby rural health clinics and emergency contacts |
| **Problems** | `/api/v1/problems` | `POST` / `GET` | Submits village grievance tickets |
| **IoT** | `/api/v1/iot/telemetry` | `GET` | Pulls live sensor readings and pump state |

> **Android Cleartext Traffic**: Because the EC2 instance uses raw HTTP over an IP address, `android:usesCleartextTraffic="true"` is enabled in `android/app/src/main/AndroidManifest.xml`.

---

## 🏁 Getting Started

### Prerequisites
- **Flutter SDK**: `>=3.3.0` (Dart SDK `>=3.3.0 <4.0.0`)
- **Android Studio / SDK**: Android SDK Tools, Build-Tools 34.0.0+
- **Physical Device or Android Emulator**: Android 8.0 (API 26) or higher.
- **Git**

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/<your-username>/gram-mitra.git
   cd gram-mitra/frontend
   ```

2. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

3. **Verify Flutter environment**:
   ```bash
   flutter doctor
   ```

### Configuration

The backend URL is centrally defined in [`lib/core/constants/api_endpoints.dart`](lib/core/constants/api_endpoints.dart):

```dart
class ApiEndpoints {
  // Production AWS EC2 Host
  static const String defaultHost = 'http://ec2_ip4_id:assigned_port';
  ...
}
```

If testing against a local backend, switch `defaultHost` to your local machine IP (e.g., `http://10.0.2.2:5000` for Android Emulator or your Wi-Fi LAN IP for physical devices).

---

### Running the App

#### A. Run on Connected Physical Phone (Recommended)
1. Enable **Developer Options** and **USB Debugging** on your phone.
2. Connect phone via USB cable and check device ID:
   ```bash
   flutter devices
   ```
3. Run the app:
   ```bash
   flutter run -d <DEVICE_ID>
   # Example: flutter run -d RZ8T403GHPF
   ```

#### B. Run on Android Emulator
```bash
flutter run
```

#### C. Run on Chrome (Web)
```bash
flutter run -d chrome
```

---

## 📦 Building for Production (Android APK)

To generate an optimized, standalone release APK for direct installation on Android devices:

```bash
flutter build apk --release
```

The compiled release APK will be located at:
```text
build/app/outputs/flutter-apk/app-release.apk
```

### To build split APKs (smaller file size per CPU architecture):
```bash
flutter build apk --split-per-abi
```
Outputs:
- `app-arm64-v8a-release.apk` (Modern 64-bit phones)
- `app-armeabi-v7a-release.apk` (Older 32-bit phones)

### To Install Directly on Phone via ADB:
```bash
flutter install
# or
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

---

## 🧪 Testing & Quality Assurance

The codebase adheres strictly to Flutter linting standards and includes unit/widget test suites.

### Run Code Analyzer:
```bash
flutter analyze
```
*(Expected: `No issues found!`)*

### Run Automated Tests:
```bash
flutter test
```

Test suites include:
- `Gram Mitra app launches smoke test`
- `Dark mode toggle updates ThemeMode correctly`
- `SearchServicesScreen filters results accurately based on query`
- `HomeScreen renders Daily Insights carousel and cards immediately`

---

## 💡 Key Troubleshooting & FAQs

### Q1: The app fails to connect to the backend on a physical phone.
- **Cause**: Android blocks plain HTTP traffic by default.
- **Fix**: Verify that `android/app/src/main/AndroidManifest.xml` includes:
  ```xml
  <application
      android:usesCleartextTraffic="true" ...>
  ```
  Also ensure your phone has active mobile data or Wi-Fi to reach the public EC2 IP `100.26.205.34:30442`.

### Q2: How do I change the App Launcher Icon?
- High-resolution icons have already been generated in:
  `android/app/src/main/res/mipmap-{mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi}/ic_launcher.png`
- Master logo is located in `assets/icons/app_logo.png`.
- Perform a clean build (`flutter clean && flutter run`) to refresh the launcher cache on your mobile device.

### Q3: `RenderFlex overflowed by X pixels` appears on small screens.
- All screen layouts are wrapped with `SingleChildScrollView` and dynamic text blocks are wrapped in `Expanded` or `FittedBox(fit: BoxFit.scaleDown)` to ensure responsive scaling across 320px–480px screen widths.

---

## 📄 License & Attribution

Distributed under the **MIT License**. See `LICENSE` for more information.

<p align="center">
  Made with ❤️ for Indian Agriculture and Rural Empowerment 🌱
</p>
