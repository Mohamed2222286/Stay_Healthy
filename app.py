# Import Required Libraries
import pandas as pd
import numpy as np
from sklearn.neighbors import KNeighborsClassifier
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.model_selection import train_test_split
import joblib
from fastapi import FastAPI
from pydantic import BaseModel
import uvicorn


# Load Dataset
# df = pd.read_csv('//Users//mahmed//Downloads//ML Algorithms//heart_2020_cleaned.csv')
df = pd.read_csv('//Users//mahmed//StudioProjects//newmodel//lib//fastapi_app//heart_2020_cleaned.csv')
# Synthetic Data Generation
np.random.seed(42)
n_samples = 5000

data = {
    'BMI': np.random.normal(25, 5, n_samples),
    'Smoking': np.random.choice(['Yes', 'No'], n_samples),
    'AlcoholDrinking': np.random.choice(['Yes', 'No'], n_samples),
    'DiffWalking': np.random.choice(['Yes', 'No'], n_samples),
    'Sex': np.random.choice(['Male', 'Female'], n_samples),
    'AgeCategory': np.random.choice(['40-49', '50-59', '60-69', '70-79', '80+'], n_samples),
    'Diabetic': np.random.choice(['Yes', 'No'], n_samples),
    'PhysicalActivity': np.random.choice(['Yes', 'No'], n_samples),
    'Asthma': np.random.choice(['Yes', 'No'], n_samples),
    'KidneyDisease': np.random.choice(['Yes', 'No'], n_samples),
    'HeartDisease': np.random.choice([0, 1], n_samples, p=[0.6, 0.4])
}

df = pd.DataFrame(data)

# Encode Categorical Features
categorical_features = ['Smoking', 'AlcoholDrinking', 'DiffWalking', 'Sex', 'Diabetic', 'PhysicalActivity', 'Asthma', 'KidneyDisease', 'AgeCategory']
df = pd.get_dummies(df, columns=categorical_features, drop_first=True)

# Split Data
X = df.drop(columns=['HeartDisease'])
y = df['HeartDisease']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Feature Scaling
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Train Model
knn = KNeighborsClassifier(n_neighbors=5)
knn.fit(X_train_scaled, y_train)

# Save Model & Scaler
joblib.dump(knn, 'heart_disease_model.pkl')
joblib.dump(scaler, 'scaler.pkl')

# --- FastAPI Setup ---
app = FastAPI()

# Load Model & Scaler
knn = joblib.load('heart_disease_model.pkl')
scaler = joblib.load('scaler.pkl')

# Define Request/Response Schema
from fastapi import FastAPI
from pydantic import BaseModel, Field
import pandas as pd
import numpy as np
import joblib
from sklearn.preprocessing import StandardScaler
from fastapi.middleware.cors import CORSMiddleware

# Add this after creating the FastAPI app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

# Load Model & Scaler
knn = joblib.load('heart_disease_model.pkl')
scaler = joblib.load('scaler.pkl')

# --- FastAPI Setup ---
app = FastAPI()

# Define Request/Response Schema

class PatientInput(BaseModel):
    BMI: float
    Smoking: str = Field(..., pattern="^(Yes|No)$")
    AlcoholDrinking: str = Field(..., pattern="^(Yes|No)$")
    DiffWalking: str = Field(..., pattern="^(Yes|No)$")
    Sex: str = Field(..., pattern="^(Male|Female)$")
    AgeCategory: str
    Diabetic: str = Field(..., pattern="^(Yes|No)$")
    PhysicalActivity: str = Field(..., pattern="^(Yes|No)$")
    Asthma: str = Field(..., pattern="^(Yes|No)$")
    KidneyDisease: str = Field(..., pattern="^(Yes|No)$")

class PredictionOutput(BaseModel):
    prediction: str
    confidence: float
    risk_level: str

# Preprocessing Function
def preprocess_input(input_data: PatientInput):
    data_dict = {
        'BMI': [input_data.BMI],
        'Smoking_Yes': [1 if input_data.Smoking == 'Yes' else 0],
        'AlcoholDrinking_Yes': [1 if input_data.AlcoholDrinking == 'Yes' else 0],
        'DiffWalking_Yes': [1 if input_data.DiffWalking == 'Yes' else 0],
        'Sex_Male': [1 if input_data.Sex == 'Male' else 0],
        'Diabetic_Yes': [1 if input_data.Diabetic == 'Yes' else 0],
        'PhysicalActivity_Yes': [1 if input_data.PhysicalActivity == 'Yes' else 0],
        'Asthma_Yes': [1 if input_data.Asthma == 'Yes' else 0],
        'KidneyDisease_Yes': [1 if input_data.KidneyDisease == 'Yes' else 0],
        'AgeCategory_50-59': [1 if input_data.AgeCategory == '50-59' else 0],
        'AgeCategory_60-69': [1 if input_data.AgeCategory == '60-69' else 0],
        'AgeCategory_70-79': [1 if input_data.AgeCategory == '70-79' else 0],
        'AgeCategory_80+': [1 if input_data.AgeCategory == '80+' else 0]
    }
    return pd.DataFrame(data_dict)

# API Endpoint
@app.post("/predict", response_model=PredictionOutput)
async def predict(input_data: PatientInput):
    try:
        # Preprocess input
        processed_data = preprocess_input(input_data)

        # Scale features
        scaled_data = scaler.transform(processed_data)

        # Make prediction
        prediction = knn.predict(scaled_data)[0]
        proba = knn.predict_proba(scaled_data)[0][1]

        # Determine risk level
        risk_level = "Low" if proba < 0.3 else "Medium" if proba < 0.7 else "High"

        return PredictionOutput(
            prediction="Heart Disease" if prediction == 1 else "No Heart Disease",
            confidence=float(proba),
            risk_level=risk_level
        )
    except Exception as e:
        return {"error": str(e)}


# Run FastAPI Server
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
