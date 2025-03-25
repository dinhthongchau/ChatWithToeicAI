## Chat with TOEIC AI

This is a mobile application built with Flutter, utilizing the Gemini API for AI-powered TOEIC practice. It supports offline data storage with SQLite and is designed to enhance TOEIC skills through translations, grammar explanations, vocabulary, and test tips. The app is deployed as an APK for Android devices and features a responsive UI with Provider for state management.
## Screenshots
![image](https://github.com/user-attachments/assets/5daf7d84-7229-4a9e-baf9-bc2119281e26)

## Link APK && Youtube Demo: 
-	Youtube link: https://www.youtube.com/shorts/EoIgR3SxiVg
-	File Apk link: https://drive.google.com/file/d/1EcidZvwbDHu3S_nAEtydSYdC8Nd2pHo2/view?usp=sharing

## Features
Log in or register with email and password, or use as a guest
Chat with AI to improve TOEIC skills (translations, grammar, vocabulary, tips)
View and manage chat history (rename, delete sessions)
Switch between light and dark themes
Access a user guide for instructions
Custom splash screen and app icon

## Prerequisites
- Create a `dotenv` file in the root folder (use `dotenv(example)` as a template)


## Project Structure
lib/main.dart: App starting point
lib/models/: Data files (e.g., User, ChatSession)
lib/providers/: State management with Provider (e.g., ChatProvider, ThemeProvider)
lib/widgets/: Reusable UI components and screens
lib/services/: Tools like SQLite storage and API integration
lib/common/: Shared utilities and constants

**Note**:
Provider manages state across the app. Feature-specific logic is in provider files.
Navigation uses named routes with GetX for smooth transitions


## More images 

![image](https://github.com/user-attachments/assets/3d818928-323b-4fa9-8853-abfeae4a1a45)






