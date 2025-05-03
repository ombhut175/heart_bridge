
# 💖 Heart Bridge – Matrimony App for Marriage Bureaus

Heart Link is a powerful **matrimony management app** designed specifically for **people who run marriage bureaus**. With this application, a marriage bureau owner (admin user) can **Create, Read, Update, and Delete (CRUD)** different user profiles with ease and full control.

> ✅ **Shared Backend Architecture**: One unified backend serves both the **Flutter mobile application** and the **Next.js website** – with complete OTP-based authentication.

---

## 🌟 Features

### 🚀 Web App (Next.js)
- ✅ Built with **Next.js (latest)**, **Tailwind CSS**, and **TypeScript**
- 🗂️ **Zustand** for state management
- 🔄 **SWR** for efficient API fetching with **proper caching**
- 🌗 **Dark and Light Mode** support
- 🔐 **OTP Authentication** using **Nodemailer**
- 🌍 Shared backend with the Flutter app

### 📱 Mobile App (Flutter)
- 📦 Uses **Provider** for state management
- 💾 **Smart caching** for performance
- 🕹️ **Guest Mode (Offline support)** for unregistered browsing
- 🔐 Integrated OTP verification (shared backend)

### 🛠️ Backend (Shared)
- 🧩 Built with **Node.js**
- 🗄️ **MongoDB** for data storage
- 📧 Secure OTP-based verification using **Nodemailer**

---

## 📦 Installation & Run

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/ombhut175/heart_link.git
cd heart_link
```

---

### 2️⃣ Run Web (Next.js) App

```bash
cd nextjs_app
npm install
npm run dev
```

> ✨ Access it at: [https://matrimony-app-lac.vercel.app](https://matrimony-app-lac.vercel.app)

---

### 3️⃣ Run Flutter App

```bash
cd flutter_app
flutter pub get
flutter run
```

---

## 🧪 `.env` Files

### 📂 `/nextjs_app/.env`

```env
BACKEND_URL=
MONGODB_URI=
RESEND_API_KEY=
EMAIL_FV=
PASSKEY=
NEXTAUTH_SECRET=
JWT_SECRET=
SECRET_HEADER=
ORIGIN=
```

---

### 📂 `/flutter_app/.env`

```env
BACKEND_URL=
BACKEND_SECRET_HEADER=
```

---

## 🧩 Tech Stack

| Platform | Tech |
|----------|------|
| 🌐 Web | Next.js 15, Tailwind CSS, TypeScript, Zustand, SWR |
| 📱 Mobile | Flutter, Provider |
| 🧠 Backend | Node.js, Express, MongoDB, Nodemailer |
| 🔐 Auth | OTP-based login using Email |

---

## 🌐 Live Deployment

🔗 **Website**: [https://matrimony-app-lac.vercel.app](https://matrimony-app-lac.vercel.app)

---

## 🤝 Contributing

Feel free to fork this repository and suggest improvements! If you're interested in collaboration or enhancement, just open an issue or submit a PR.

---

## 📧 Contact

For any queries or collaboration: [patelom2026@gmail.com](mailto:patelom2026@gmail.com)

---

🧡 Thank you for checking out **Heart Link** – where matches are made with love and technology.
