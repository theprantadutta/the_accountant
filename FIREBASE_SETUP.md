# Firebase Setup Instructions

## Android Setup

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select an existing one
3. Add an Android app to your Firebase project:
   - Package name: `com.example.the_accountant`
   - App nickname: `The Accountant`
   - Debug signing certificate SHA-1: (Optional for development)
4. Download the `google-services.json` file
5. Place the `google-services.json` file in the `android/app/` directory
6. Add the following to `android/build.gradle.kts`:
   ```kotlin
   buildscript {
       dependencies {
           classpath("com.google.gms:google-services:4.3.15")
       }
   }
   ```
7. Add the following to `android/app/build.gradle.kts`:
   ```kotlin
   plugins {
       id("com.google.gms.google-services")
   }
   
   dependencies {
       implementation(platform("com.google.firebase:firebase-bom:32.7.0"))
       implementation("com.google.firebase:firebase-analytics")
       implementation("com.google.firebase:firebase-auth")
   }
   ```

## iOS Setup

1. In the Firebase Console, add an iOS app to your Firebase project:
   - Bundle ID: `com.example.theAccountant`
   - App nickname: `The Accountant`
2. Download the `GoogleService-Info.plist` file
3. Place the `GoogleService-Info.plist` file in the `ios/Runner/` directory
4. Add the following to `ios/Podfile`:
   ```ruby
   pod 'Firebase/Core'
   pod 'Firebase/Auth'
   pod 'Firebase/Analytics'
   ```
5. Run `pod install` in the `ios/` directory

## Web Setup (if needed)

1. In the Firebase Console, add a web app to your Firebase project
2. Copy the Firebase configuration object
3. Create `web/firebase-config.js` with the configuration:
   ```javascript
   const firebaseConfig = {
     apiKey: "YOUR_API_KEY",
     authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
     projectId: "YOUR_PROJECT_ID",
     storageBucket: "YOUR_PROJECT_ID.appspot.com",
     messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
     appId: "YOUR_APP_ID",
     measurementId: "YOUR_MEASUREMENT_ID"
   };
   
   firebase.initializeApp(firebaseConfig);
   ```

## Initialize Firebase in Flutter

The Firebase initialization is already handled in the app through `firebase_core` package.