# LinkdUp

**LinkdUp** is a next-generation social media app designed to bring people closer together by leveraging proximity-based friend discovery. Using Bluetooth for detecting nearby users and NFC for seamless exchange of profile information, LinkdUp makes connecting with new people effortless and fun.

---

## Features

- **Proximity Friend Finding via Bluetooth**  
  Detect and discover other LinkdUp users nearby in real time without needing an internet connection.

- **Instant Profile Exchange with NFC**  
  Share your profile instantly by tapping your device with another user's NFC-enabled phone.

- **Secure & Private**  
  All data exchanges happen directly device-to-device, minimizing data sharing with servers.

- **Customizable Profiles**  
  Showcase your interests, photos, and social links in a clean, user-friendly interface.

- **Friend Suggestions**  
  Get smart suggestions based on your proximity encounters and shared interests.

---

## Download

You can download the latest **APK** from the [Releases](https://github.com/adiirani/linkdup/releases) page.

1. Go to the [Releases](https://github.com/adiirani/linkdup/releases).  
2. Download the latest `LinkdUp.apk`.  
3. Install the APK on your Android device (ensure you allow installs from unknown sources).

*Currently, the app is available for Android only via APK.*

---

## How It Works

1. **Bluetooth Scanning:** LinkdUp continuously scans for nearby users running the app.  
2. **Discovery:** When two users come into Bluetooth range, their profiles are detected.  
3. **NFC Profile Sharing:** Users can tap phones to instantly exchange detailed profile info.  
4. **Connect & Chat:** Once connected, users can start conversations, add friends, or follow each other.

---

## Tech Stack

- **Mobile:** Flutter (cross-platform for iOS & Android)  
- **Bluetooth:** Flutter Blue plugin for scanning and detecting nearby devices  
- **NFC:** Flutter NFC plugin for profile info exchange  
- **Backend:** Firebase (optional, for user authentication and messaging)  
- **Database:** Firestore (cloud user data and friend lists)  

---

## DISCLAIMER

**WARNING:** This application was built in less than 24h for the 2025 DevLabs hackathon. In its current state, expect it to be extremely buggy. Kinks will be ironed out soon; feel free to contribute/open up a pull request.

---
## License

[Apache 2.0 License](LICENSE)

---

## Contact

Created by:
[Adi Irani](https://github.com/adiirani)
[Victoria Fan](https://github.com/vickydee)
[Alexander Gmyrek](https://github.com/Alexander-Gmyrek)

for DevLabs 2025.
