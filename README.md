# 📘 QuoteVault — Full-Featured Quote App

## Overview
QuoteVault is an iOS application built with SwiftUI (iOS 17+) and a Supabase backend for discovering, organizing, and sharing quotes.
The app includes authentication, cloud sync, personalization, favorites, daily quotes, and sharing features.

This project also showcases AI-assisted development, including ChatGPT, GitHub Copilot, Claude Code, and Cursor, to accelerate development and maintain clean architecture.

## Features

### 1️⃣ Authentication & User Accounts
- Sign up with email/password ✅ (SignUpView.swift)
- Login/logout functionality ✅ (LoginView.swift)
- Password reset flow ✅ (ResetPasswordView.swift)
- Session persistence using KeychainHelper ✅ (AuthViewModel.swift)
- User profile support (planned for future)

**Tech:** Supabase Auth

### 2️⃣ Quote Browsing & Discovery
- Home feed displaying quotes ✅ (HomeView.swift)
- Browse quotes by category: Motivation, Love, Success, Wisdom, Humor ✅
- Search quotes by keyword and author ✅ (QuoteViewModel.swift)
- Pull-to-refresh and empty/loading states ✅

**Tech:** Supabase Database (seeded with 120 quotes)

### 3️⃣ Favorites
- Save quotes to favorites (heart/bookmark) ✅ (FavoriteViewModel.swift)
- View all favorited quotes ✅ (FavoritesView.swift)
- Cloud sync across devices ✅

### 4️⃣ Daily Quote
- "Quote of the Day" displayed prominently ✅ (QuoteOfTheDayTab.swift, QuoteOfTheDayView.swift)
- Daily quote logic implemented locally using extension on array ✅ (QuoteOfTheDayHelper.swift)

### 5️⃣ Sharing
- Share quote as text via system share sheet ✅ (HomeView.swift)
- Generate shareable quote card (light, dark, colorful) ✅ (QuoteCardView.swift)
- Save quote card as image ✅

### 6️⃣ Personalization & Settings
- Dark/Light mode toggle ✅ (SettingsView.swift)
- Font size adjustment ✅
- Settings persist locally via @AppStorage ✅ (SettingsViewModel.swift)

## Planned Features
- Home screen widget
- Local push notifications for daily quotes
- Custom collections of quotes

These are planned for future iterations.

## Setup Instructions

### 1. Clone the repository
git clone https://github.com/letisbezerra/quotevault-app.git
cd quotevault-app

### 2. Install Dependencies
- Open the project in Xcode 15+
- Dependencies are managed via Swift Package Manager (Supabase Swift)

### 3. Supabase Setup
1. Create a project at https://supabase.com/
2. Enable uuid-ossp extension
3. Create tables: quotes, favorites
4. Enable Row Level Security (RLS) on favorites
5. Create policies for SELECT, INSERT, DELETE (user-specific)
6. Seed database with 120 quotes
7. Update credentials in SupabaseService.swift:

enum SupabaseService {
    static let client = SupabaseClient(
        supabaseURL: URL(string: "YOUR_SUPABASE_URL")!,
        supabaseKey: "YOUR_SUPABASE_ANON_KEY"
    )
}

### 4. Run the App
- Open QuoteVault.xcodeproj in Xcode
- Select your target device or simulator
- Press Cmd+R to build and run

## AI Tools & Workflow
AI tools were crucial for development speed, code quality, and architecture guidance:

- ChatGPT: planning, architecture, MVVM guidance, SwiftUI code snippets, SQL queries
- GitHub Copilot: code autocompletion and boilerplate generation
- Claude Code & Cursor: debugging assistance and code suggestions

Workflow: Plan → AI-assisted code generation → manual refinement → debug → integrate → document

## Known Limitations
- Widget, push notifications, and custom collections are planned for future updates

## Project Status
- ✅ Core features implemented: Authentication (LoginView, SignUpView, ResetPasswordView), Quote Feed (HomeView), Favorites (FavoritesView), Quote Sharing (ShareSheet + QuoteCardView), Quote of the Day (QuoteOfTheDayTab), Dark/Light Mode and Font Personalization (SettingsView)
- ✅ Fully integrated with Supabase backend and RLS
- ✅ AI workflow documented and leveraged effectively

## 🤖 AI Tools & Workflow

AI tools played a key role in accelerating development, maintaining code quality, and ensuring clean architecture throughout the project.

**Tools Used:**
- ChatGPT: Architecture planning (MVVM), SwiftUI code snippets, SQL scripts, debugging guidance
- GitHub Copilot: Autocomplete, boilerplate generation, rapid View/ViewModel implementation
- Claude Code & Cursor: Debugging assistance, code suggestions, and optimizations

**Workflow Example:**
1. Plan features and project architecture using ChatGPT
2. Generate initial SwiftUI code and SQL seed scripts
3. Implement the generated code in Xcode
4. Debug and refine code using Claude Code and Cursor
5. Integrate features and test functionality
6. Document workflow in README

> This AI-assisted workflow allowed rapid development while keeping the project clean, structured, and maintainable.


## Credits
- Developed by Letícia Bezerra
- AI assistance: ChatGPT, Copilot, Perplexty 
