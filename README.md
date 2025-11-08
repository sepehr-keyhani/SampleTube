# SampleTube (iOS + Node/Express)

SampleTube is a compact, recruiter-friendly demo project consisting of:

- An iOS app (UIKit, MVC, programmatic UI) under `App/SampleTube`
- A Node/Express backend under `Server`

It demonstrates end-to-end auth (register/login), protected APIs, and streaming simple video files.

## Repository Layout

- `App/SampleTube` – iOS app (UIKit, SnapKit, Alamofire, AVKit)
- `Server` – Node/Express API (JWT auth, MongoDB via Mongoose)

## Quick Start

### Backend

1. Navigate to the server folder and install dependencies:
   ```bash
   cd Server
   npm install
   ```
2. Provide environment variables (create a `.env`):
   ```bash
   PORT=4000
   MONGO_URI=mongodb://127.0.0.1:27017/sampletube
   JWT_SECRET=dev_secret_change_me
   ```
3. Start the API:
   ```bash
   npm run dev
   ```
   API base: `http://localhost:4000/api/v1`
   Static videos: `http://localhost:4000/static/videos/...`

### iOS App

1. Install pods:
   ```bash
   cd App/SampleTube
   pod install
   ```
2. Open `SampleTube.xcworkspace` in Xcode 26+.
3. Ensure `App/SampleTube/SampleTube/Sources/Config/AppConfig.swift` points to your backend host.
4. Build & run. On device, replace `localhost` with your machine IP.

## iOS Tech Stack

- Swift 5.10+, iOS 26+
- UIKit (MVC), SnapKit (layout)
- Alamofire (networking, async/await)
- KeychainAccess (secure token)
- AVFoundation/AVKit (thumbnails/playback)

## Server Tech Stack

- Node 18+, Express 4
- MongoDB/Mongoose
- JWT (jsonwebtoken), bcrypt
- Helmet, CORS, express-validator, morgan

## Features

- Register / Login (JWT)
- Token-protected videos endpoint
- Grid of videos with thumbnails at 2s
- Inline video playback

## For Recruiters & HR

- Clean, readable code with small files and clear responsibilities
- Programmatic UI for easy code review and minimal boilerplate
- Simple, realistic client-server flow using common libraries

## License

This repository is provided for demonstration and interview purposes.
