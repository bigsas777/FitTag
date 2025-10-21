# FitTag

![Platform](https://img.shields.io/badge/platform-iOS-blue.svg)
![Swift](https://img.shields.io/badge/language-Swift-orange.svg)
![Firebase](https://img.shields.io/badge/backend-Firebase-yellow.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Status](https://img.shields.io/badge/status-stable-brightgreen.svg)

**FitTag** is an iOS app designed to collect and label motion sensor data (accelerometer and gyroscope) during physical activities. The recorded data is intended for training machine learning models to recognize activity patterns such as walking, running, cycling, or swimming in real time.

## 📱 Features

- Record raw accelerometer and gyroscope data from iPhone
- Manually tag the activity being performed (e.g., walking, running)
- Save sessions to Firebase Firestore
- View a list of past recordings, including duration and activity type
- Capable of performing real-time physical activity recognition

## 🧠 Tech Stack

- Swift & SwiftUI
- iOS
- CoreMotion
- Firebase Firestore
- Python & scikit-learn (Decision Tree Classifier for activity recognition)

## 🚀 Future Improvements

- **Optimize Machine Learning Model**: Reduce the number of features used by the Decision Tree Classifier, keeping only the most relevant features or using PCA.  
- **Code Refactoring**: Rewrite and restructure the Swift code to follow professional best practices, improving readability, maintainability, and scalability. Currently, the code reflects a learning phase and could benefit from experience-based optimization.  
- **Extensibility**: Prepare the app to support additional activity types.  
- **Error Handling and Logging**: Improve handling of errors and provide detailed logs for debugging.  