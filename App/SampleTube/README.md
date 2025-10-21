# SampleTube iOS App (UIKit)

A small, recruiter-friendly demo iOS application showcasing clean MVC with programmatic UI, networking, and media playback.

## Highlights

- UIKit + MVC architecture
- Programmatic UI with SnapKit (no storyboards)
- Networking with Alamofire (async/await)
- Secure token storage via KeychainAccess
- Auth flow: Sign In / Sign Up
- Protected video list fetched from the bundled Node/Express backend
- Video thumbnails generated at 2s using AVFoundation
- Playback with AVPlayerViewController

## Tech Stack

- Language: Swift 5.10+
- Min iOS: 16.0
- UI: UIKit, SnapKit
- Networking: Alamofire
- Auth storage: KeychainAccess
- Media: AVFoundation, AVKit
- Dependency manager: CocoaPods

## Project Structure

- `Sources/Config` – configuration (API base URLs)
- `Sources/Networking` – `APIClient`, `TokenStore`
- `Sources/Models` – DTOs (`User`, `Video`, `AuthResponse`, `PagedVideos`)
- `Sources/Services` – `ThumbnailGenerator`
- `Sources/UI` – `Theme`, reusable UI components
- `Sources/Views` – screens: Auth, Video List, Player

## Getting Started

1. Install pods:
   ```bash
   cd App/SampleTube
   pod install
   ```
2. Open `SampleTube.xcworkspace` in Xcode 16+.
3. Ensure the backend is running at `http://localhost:4000` (see root README).
4. Build and run on Simulator. On device, set `AppConfig.serverBaseURLString` to your machine IP.

## Credentials

- Create an account on the Sign Up tab (Full name, Email, Password). Password policy applies only to Sign Up.
- Reuse those credentials on the Sign In tab.

## Notes for Reviewers (Recruiters/HR)

- Clear separation of concerns and small, readable types
- Minimal global state; token lives in Keychain only
- UI is fully programmatic for transparent diffs and review
- Uses common, production-ready UIKit patterns (MVC)

## Screens

- Welcome (Sign In / Sign Up segmented UI)
- Videos grid with thumbnails
- Inline video player

## Future Enhancements

- Pagination and pull to refresh
- Image caching with a disk layer
- Unit/UI tests
- Offline support
