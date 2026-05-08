# Weekend Workstation Setup

## Prerequisites (install once)
```bash
# 1. Flutter SDK — follow https://docs.flutter.dev/get-started/install
# 2. Node.js v18+ — needed for Firebase CLI
# 3. Firebase CLI
npm install -g firebase-tools
# 4. FlutterFire CLI
dart pub global activate flutterfire_cli
export PATH="$PATH":"$HOME/.pub-cache/bin"   # add to ~/.bashrc to make permanent
```

## Every time on new machine

```bash
# 1. Clone repo
git clone https://github.com/mamawpsg16/flutter-relearn.git
cd flutter-relearn

# 2. Install Flutter deps
flutter pub get

# 3. Login to Firebase
firebase login

# 4. Regenerate firebase_options.dart + google-services.json (gitignored — not in repo)
flutterfire configure --project=flutter-relearn-c841e
# Select: android only

# 5. Run app
flutter run
```

## Why firebase_options.dart is not in git
Contains API keys. Repo is public — committing keys = anyone can use your Firebase project.
Always regenerate with `flutterfire configure` on each machine.

---

## Learning approach (tell Claude this at home)
"Teach me step by step. Explain concepts before code. Let me implement first, then review.
Don't build everything for me — guide me so I learn to do it myself."

## Current progress

### Done
- Persistence section: SharedPreferences, File I/O, SQLite, Firebase Auth (register)
- JSON Serialization section
- State management: Provider, Riverpod screens

### Firebase Auth — next steps
- [ ] Sign in (login) with existing account
- [ ] Auth state listener — detect if user logged in/out
- [ ] Show logged-in user info (email, uid)
- [ ] Sign out button
- [ ] Firestore — save/read user data from cloud database

### Key concepts learned
- SQLite: local DB, CRUD, offline-first + sync pattern
- Firebase Auth: `createUserWithEmailAndPassword`, `signInWithEmailAndPassword`
- `FirebaseAuthException` — catch Firebase-specific errors
- `mounted` check — always check after `await` before using `context`
- `finally` block — runs whether success or error, good for resetting loading state
- Private methods `_buildX()` — extract when `build()` too long to read
