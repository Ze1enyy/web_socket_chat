# WebSocket Chat App

A real-time chat application built with Flutter and WebSocket.

## Features

- Real-time messaging using WebSocket
- User authentication
- Clean architecture
- Dependency injection
- Route management with AutoRoute
- State management with BLoC pattern

## Setup Instructions

### Prerequisites

- Flutter SDK installed
- Node.js installed (for running the server)
- An IDE (VS Code, Android Studio, etc.)
- An Android emulator or iOS simulator

### Running the Server

1. Navigate to the server directory:

   ```bash
   cd my-node-server
   ```

2. Install dependencies:

   ```bash
   npm install
   ```

3. Start the server:
   ```bash
   npm start
   ```

### Running the Flutter App

1. Install Flutter dependencies:

   ```bash
   flutter pub get
   ```

2. Generate required code:

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Technical Details

- Minimum iOS version: 12.0
- Target Android SDK: Latest stable
- WebSocket server: Node.js with WS package
- State management: Flutter Bloc
- DI: GetIt + Injectable

## Assumptions and Limitations

- Stable internet connection required for real-time messaging
- Authentication implemented using JWT tokens
- Local server must be running for chat functionality
- Text messages only supported (no media files)
- Server runs on localhost (10.0.2.2:3001 for Android emulator)
- Maximum of 50 messages displayed per screen, older messages shift out as new ones arrive
