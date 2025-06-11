# Stay Healthy 🩺

**Stay Healthy** is a full-featured cross-platform health and wellness application built using Flutter and Python. It empowers users to manage their well-being through AI-driven heart disease prediction, BMI calculation, chatbot interaction, health news, and appointment booking.  

> Developed as a graduation project by **Mohamed Abd El Kareem**.

---

## 🧩 Features

### 💓 Heart Disease Prediction
- Machine learning model (`heart_disease_model.pkl`) assesses risk based on user metrics like cholesterol, blood pressure, age, and more.
- Prediction results returned via Flask API.

### 🔐 User Authentication
- Secure login and registration functionality.
- Persistent sessions for personalized health tracking.

### 🧠 Gemini Chatbot
- Built-in AI chatbot for general health-related inquiries.
- Handles user questions and provides friendly, conversational responses.

### 🗓️ Clinic Booking
- Book appointments with doctors directly from the app.
- Select preferred clinic, doctor, and time slot.
- (Optionally includes Mastercard payment integration.)

### 🧮 BMI Calculator
- Built-in Body Mass Index calculator using height and weight.
- Immediate feedback on BMI category (underweight, normal, overweight, obese).

### 🔔 Notifications
- Health reminders for medication, check-ups, hydration, and more.
- Local device notifications to keep users engaged and consistent.

### 📰 Health News API
- Live updates from trusted health news sources.
- Keeps users informed on wellness, fitness, nutrition, and research.

---

## 🏗️ Tech Stack

| Layer            | Technology         |
|------------------|--------------------|
| Frontend         | Flutter (Dart)     |
| Backend API      | Python + Flask     |
| AI/ML Model      | Scikit-learn       |
| Authentication   | (e.g., Firebase Auth / custom logic) |
| Notifications    | Flutter Local Notifications |
| News Integration | Health News API (e.g., NewsAPI) |
| Payments         | Mastercard (or simulation) |
| AI Chatbot       | Gemini (Google AI integration or mockup) |

---

## 📁 Project Structure
Stay_Healthy/
├── lib/ # Flutter app logic (UI, routes, services)
├── android/ios/ # Native Flutter project targets
├── app.py # Flask backend server
├── heart_disease_model.pkl
├── scaler.pkl
├── assets/ # Icons, images, logos
├── test/ # Flutter tests
├── pubspec.yaml
└── README.md


🧠 How It Works
User inputs health metrics via Flutter UI (e.g., age, cholesterol, blood pressure).

App posts this data as JSON to Flask API.

Pipelines the data through:

Input scaling (scaler.pkl)

ML prediction (heart_disease_model.pkl)

Returns prediction and displays results in the Flutter interface.



📞 Contact
Mohamed Abdel‑Kareem
📧 mohamedabdelkareem531@gmail.com

