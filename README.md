# Stay Healthy 🩺

**Stay Healthy** is a full-featured, cross-platform health and wellness application built using **Flutter** and **Python**. It empowers users to manage their well-being through **AI-driven heart disease prediction**, **BMI calculation**, **intelligent chatbot interaction**, **live health news**, and **clinic appointment booking**.

> 🎓 Developed as a graduation project by **Mohamed Abd El Kareem**

---

## 🧩 Features

### 💓 Heart Disease Prediction
- Uses a **machine learning model** (`heart_disease_model.pkl`) to assess the risk of heart disease.
- Considers health metrics such as cholesterol, blood pressure, and age.
- Results are served via a **Flask REST API** and displayed within the app.

### 🔐 User Authentication
- Secure **login and registration** system.
- Persistent user sessions for personalized experiences.

### 🧠 Gemini Chatbot
- AI-powered chatbot for answering **general health-related inquiries**.
- Friendly and conversational UX for daily health tips.

### 🗓️ Clinic Booking
- Book appointments with doctors directly from the app.
- Select clinic, doctor, and available time slots.
- (Optional: Integrate **Mastercard** or simulation-based payment system.)

### 🧮 BMI Calculator
- Calculate **Body Mass Index** using user height and weight.
- Provides immediate categorization: underweight, normal, overweight, or obese.

### 🔔 Notifications
- Reminders for medication, hydration, physical activity, and check-ups.
- Local push notifications to keep users consistent and engaged.

### 📰 Health News Integration
- Live health news updates pulled from trusted public APIs (e.g. **NewsAPI**).
- Covers wellness, fitness, nutrition, and recent medical research.

---

## 🏗️ Tech Stack

| Layer             | Technology                          |
|-------------------|--------------------------------------|
| Frontend          | Flutter (Dart)                      |
| Backend API       | Python + Flask                     |
| Machine Learning  | Scikit-learn                        |
| User Auth         | Firebase Auth / Custom logic        |
| Notifications     | Flutter Local Notifications         |
| News Integration  | NewsAPI or custom health news API   |
| Payment (optional)| Mastercard API or simulation        |
| AI Chatbot        | Gemini (Google AI integration/mock) |

---

## 📁 Project Structure

Stay_Healthy/
├── lib/ # Flutter app UI, state, routing
├── android/ios/ # Native Flutter platform code
├── app.py # Flask backend server
├── heart_disease_model.pkl
├── scaler.pkl # Scikit-learn input scaler
├── assets/ # Images, icons, logos
├── test/ # Flutter unit and widget tests
├── pubspec.yaml # Flutter dependencies and assets
└── README.md

yaml
Copy
Edit

---

## 🧠 How It Works

1. Users input personal health metrics (e.g., age, blood pressure, cholesterol).
2. Flutter app sends a POST request to the Flask API.
3. Data is preprocessed using `scaler.pkl`.
4. Preprocessed data is passed into `heart_disease_model.pkl`.
5. Model returns a prediction (e.g., "Low Risk", "High Risk").
6. Results are shown clearly within the Flutter interface.

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Python 3.x](https://www.python.org/)
- Recommended: Android Studio or VS Code for Flutter development

### Running the App

#### 🔹 Frontend (Flutter)

```bash
git clone https://github.com/Mohamed2222286/Stay_Healthy.git
cd Stay_Healthy
flutter pub get
flutter run
🔹 Backend (Flask)
bash
Copy
Edit
cd Stay_Healthy
pip install -r requirements.txt
python app.py
Make sure the heart_disease_model.pkl and scaler.pkl are in the root directory of your Flask server.

🤝 Contributing
Contributions, bug reports, and suggestions are welcome!

Fork the repository

Create a new branch (git checkout -b feature/your-feature)

Commit your changes (git commit -m 'Add feature')

Push the branch (git push origin feature/your-feature)

Open a pull request

🗺️ Roadmap
 Dark/Light theme support

 Google Fit & Apple HealthKit integration

 Multi-language support

 Voice-enabled chatbot

 AI-driven diet planner

📞 Contact
Mohamed Abd El Kareem
📧 mohamedabdelkareem531@gmail.com
