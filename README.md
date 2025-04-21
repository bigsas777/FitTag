# FitTag

![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20watchOS-blue.svg)
![Swift](https://img.shields.io/badge/language-Swift-orange.svg)
![Firebase](https://img.shields.io/badge/backend-Firebase-yellow.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Status](https://img.shields.io/badge/status-in%20development-lightgrey.svg)

**FitTag** is a watchOS and iOS app designed to collect and label motion sensor data (accelerometer and gyroscope) during physical activities. The recorded data is intended for training machine learning models to recognize activity patterns such as walking, running, cycling, or swimming in real time.

## 📱 Features

- Record raw accelerometer and gyroscope data from Apple Watch or iPhone
- Manually tag the activity being performed (e.g., walking, running)
- Save sessions to Firebase Firestore
- View a list of past recordings, including duration and activity type
- Capable of performing real-time physical activity recognition

## 🧠 Tech Stack

- Swift & SwiftUI
- watchOS & iOS
- CoreMotion
- Firebase Firestore

## 🚧 Status

FitTag is currently under development. More features and improvements will be added soon, including:
- Model integration for real-time activity recognition
- Optimize database queries for better performance and scalability
