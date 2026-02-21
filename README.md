<div align="center">

# 💸 Udharo

### A Peer-to-Peer Money Lending Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Node.js](https://img.shields.io/badge/Node.js-18.x-339933?logo=node.js&logoColor=white)](https://nodejs.org)
[![MongoDB](https://img.shields.io/badge/MongoDB-8.x-47A248?logo=mongodb&logoColor=white)](https://mongodb.com)
[![Express](https://img.shields.io/badge/Express-4.x-000000?logo=express&logoColor=white)](https://expressjs.com)
[![React](https://img.shields.io/badge/React-18.x-61DAFB?logo=react&logoColor=black)](https://react.dev)

> **Udharo** (उधारो) — a Nepali word meaning *"to lend/borrow"* — is a full-stack P2P money lending application that connects borrowers and lenders in a secure, transparent, and efficient way.

*Major Project · 8th Semester · NCIT (Nepal College of Information Technology)*

</div>

---

## 📑 Table of Contents

- [About the Project](#about-the-project)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Backend (Server)](#backend-server)
  - [Mobile App (Client)](#mobile-app-client)
  - [Admin Panel](#admin-panel)
- [Environment Variables](#environment-variables)
- [Contributing](#contributing)
- [License](#license)

---

## 📖 About the Project

Udharo is a mobile-first P2P (peer-to-peer) money lending platform built as a major academic project. It enables users to post borrow requests and allows other verified users to fulfil those requests — essentially cutting out traditional financial intermediaries.

The platform enforces identity verification through a **KYC (Know Your Customer)** workflow, integrates **Khalti** for digital payments, and uses **WebSockets** for real-time notifications.

---

## ✨ Features

| Feature | Description |
|---|---|
| 🔐 **Authentication** | Secure sign-up / sign-in with JWT-based session management |
| 📋 **KYC Verification** | Document upload and identity verification before lending/borrowing |
| 📝 **Borrow Requests** | Users can create, browse, and accept borrow requests |
| 💳 **Khalti Payments** | Integrated Khalti payment gateway for in-app transactions |
| 🕑 **Borrow History** | Full history of lending and borrowing activity |
| 👤 **Profile Management** | Update profile picture, personal details, and change password |
| 🔔 **Real-time Updates** | WebSocket-powered live notifications |
| 🛡️ **Admin Panel** | Dedicated dashboard for platform management and oversight |
| ☁️ **Cloud Media** | Profile and document images stored via Cloudinary |
| ✉️ **Email Notifications** | Transactional emails via Nodemailer |

---

## 🛠️ Tech Stack

### Mobile Client
| Technology | Purpose |
|---|---|
| **Flutter / Dart** | Cross-platform mobile UI |
| **flutter_bloc** | State management (BLoC pattern) |
| **Dio** | HTTP networking |
| **Khalti Flutter SDK** | Payment integration |
| **Cached Network Image** | Efficient image loading |
| **Google Fonts** | Custom typography |
| **Shared Preferences** | Local data persistence |

### Backend Server
| Technology | Purpose |
|---|---|
| **Node.js + Express.js** | REST API framework |
| **MongoDB + Mongoose** | NoSQL database & ODM |
| **JSON Web Tokens (JWT)** | Stateless authentication |
| **bcrypt** | Password hashing |
| **Multer + Cloudinary** | File upload & cloud storage |
| **Nodemailer** | Email delivery |
| **WebSocket** | Real-time bidirectional communication |

---

## 📂 Project Structure

```
Udharo/
├── client/                  # Flutter mobile application
│   ├── lib/
│   │   ├── assets/          # Images, icons, fonts
│   │   ├── constants/       # App-wide constants
│   │   ├── data/            # Data layer (repositories, models)
│   │   ├── service/         # API service classes
│   │   ├── theme/           # App theming
│   │   └── view/
│   │       ├── screens/     # Full-page screens
│   │       └── widget/      # Reusable UI components
│   └── pubspec.yaml
│
├── server/                  # Node.js REST API
│   ├── config/              # Database & app configuration
│   ├── constants/           # Server-side constants
│   ├── controllers/         # Business logic handlers
│   ├── middleware/          # Auth & upload middleware
│   ├── models/              # Mongoose data models
│   ├── routes/              # API route definitions
│   ├── utils/               # Helper utilities
│   ├── websocket.js         # WebSocket server
│   └── index.js             # Entry point
│
└── admin/
    └── udharo/              # React + Vite admin panel
        ├── src/             # Components, pages, routes
        └── package.json
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) ≥ 3.x
- [Node.js](https://nodejs.org) ≥ 18.x & npm
- [MongoDB](https://www.mongodb.com) (local or Atlas)
- A [Cloudinary](https://cloudinary.com) account
- A [Khalti](https://khalti.com) developer account

---

### Backend (Server)

```bash
# 1. Navigate to the server directory
cd server

# 2. Install dependencies
npm install

# 3. Create and configure your environment file
cp .env.example .env
# Edit .env with your credentials (see Environment Variables below)

# 4. Start the development server
npm run dev

# The API will be available at http://localhost:5000
```

---

### Mobile App (Client)

```bash
# 1. Navigate to the client directory
cd client

# 2. Install Flutter dependencies
flutter pub get

# 3. Run the app on a connected device or emulator
flutter run

# To build a release APK
flutter build apk --release
```

---

### Admin Panel

```bash
# 1. Navigate to the admin panel directory
cd admin/udharo

# 2. Install dependencies
npm install

# 3. Start the development server
npm run dev

# To build for production
npm run build
```

---

## 🔑 Environment Variables

Create a `.env` file inside the `server/` directory with the following keys:

```env
# Server
PORT=5000

# MongoDB
MONGO_URI=your_mongodb_connection_string

# Authentication
JWT_SECRET=your_jwt_secret_key

# Cloudinary
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret

# Email (Nodemailer)
EMAIL_HOST=smtp.your-provider.com
EMAIL_USER=your_email@example.com
EMAIL_PASS=your_email_password

# Khalti
KHALTI_SECRET_KEY=your_khalti_secret_key
```

> ⚠️ **Never commit your `.env` file to version control.** It is already listed in `.gitignore`.

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

1. **Fork** the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Commit your changes: `git commit -m "feat: add your feature"`
4. Push to the branch: `git push origin feature/your-feature-name`
5. Open a **Pull Request**

Please follow the existing code style and write meaningful commit messages.

---

## 📄 License

This project is developed as an academic major project at **NCIT (Nepal College of Information Technology)** and is intended for educational purposes.

---

<div align="center">
  Made with ❤️ by the Udharo Team &nbsp;·&nbsp; NCIT 8th Semester
</div>

