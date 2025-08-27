# 💰 The Accountant

A beautiful, modern personal finance management application built with Flutter. Features a stunning glassmorphic design, smooth animations, and comprehensive financial tracking capabilities.

## ✨ Features

### 🎨 **Modern UI/UX Design**
- **Glassmorphic Design**: Beautiful frosted glass effects throughout the app
- **Gradient Theming**: Custom gradient system with primary and secondary color schemes
- **Smooth Animations**: Staggered animations, slide transitions, and micro-interactions
- **Responsive Layout**: Optimized for all screen sizes and orientations

### 📱 **Core Functionality**
- **Smart Dashboard**: Interactive financial overview with animated balance cards
- **Advanced Reports**: Comprehensive analytics with interactive charts and visualizations
- **AI Assistant**: Intelligent chat interface with financial insights and recommendations
- **User Profile**: Complete profile management with premium status and settings
- **Custom Navigation**: Floating glassmorphic bottom navigation with center AI button

### 📊 **Financial Features**
- Real-time balance tracking with animated counters
- Income and expense categorization
- Budget progress monitoring with visual indicators
- Interactive spending charts (line charts, pie charts)
- Transaction history with smart filtering
- Category breakdown and analysis
- Budget vs actual comparisons

### 🤖 **AI Integration**
- Intelligent financial assistant
- Personalized spending insights
- Budget recommendations
- Interactive chat interface with typing indicators
- Quick action buttons for common queries

## 🏗️ **Architecture**

### **Design Patterns**
- **Riverpod**: State management with provider pattern
- **Feature-Based Structure**: Clean, scalable architecture
- **Local-First**: Drift database for offline-first functionality
- **Responsive Design**: Adaptive layouts for different screen sizes

### **Key Technologies**
- **Flutter**: Cross-platform mobile development
- **Drift**: Local SQLite database with type-safe queries
- **fl_chart**: Beautiful, interactive charts and graphs
- **Riverpod**: Modern state management solution
- **Firebase**: Authentication and cloud services
- **Material 3**: Modern design system implementation

## 📁 **Project Structure**

```
lib/
├── app/                    # App configuration and routing
├── core/
│   ├── themes/            # App theme and styling
│   └── utils/             # Utility functions and helpers
├── features/
│   ├── ai_assistant/      # AI chat interface and logic
│   ├── authentication/   # User authentication and profiles
│   ├── dashboard/        # Main dashboard and widgets
│   ├── onboarding/       # App introduction and setup
│   ├── reports/          # Analytics and reporting
│   └── settings/         # App settings and preferences
├── shared/
│   └── widgets/          # Reusable UI components
└── main.dart             # App entry point
```

## 🚀 **Getting Started**

### **Prerequisites**
- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Git

### **Installation**

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/the_accountant.git
cd the_accountant
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run code generation**
```bash
flutter packages pub run build_runner build
```

4. **Run the app**
```bash
flutter run
```

### **Development Commands**

```bash
# Install dependencies
flutter pub get

# Run code generation
flutter packages pub run build_runner build

# Run in debug mode
flutter run

# Run tests
flutter test

# Build for production
flutter build apk --release
flutter build ios --release

# Analyze code
flutter analyze

# Format code
dart format lib/
```

## 📱 **Screens Overview**

### 🏠 **Dashboard**
- Animated balance cards with counter animations
- Quick action buttons with glassmorphic design
- Income/expense overview with progress indicators
- Interactive spending charts using fl_chart
- Recent transactions with smart categorization
- Budget progress visualization

### 📊 **Reports**
- Time frame selectors (Week, Month, Year)
- Interactive line and pie charts
- Financial summary cards with trend indicators
- Category breakdown with visual progress bars
- Budget vs actual comparison charts
- Export functionality for data analysis

### 🤖 **AI Assistant**
- Modern chat interface with message bubbles
- Typing indicators and smooth animations
- Quick action buttons for common queries
- Personalized financial insights and recommendations
- Context-aware responses based on user data
- Settings for AI personality and preferences

### 👤 **Profile**
- User information management
- Account statistics and achievements
- Premium membership status
- App settings and preferences
- Data export and privacy controls
- Elegant sign-out dialog with confirmation

## 🎨 **Design System**

### **Color Palette**
- **Primary Gradient**: `#667eea` → `#764ba2`
- **Secondary Gradient**: `#11998e` → `#38ef7d`
- **Background Gradient**: `#1e3c72` → `#2a5298`
- **Accent Colors**: Carefully selected for optimal contrast and accessibility

### **Typography**
- Modern, readable font system
- Consistent font weights and sizes
- Optimized for mobile readability

### **Components**
- **Glassmorphic Containers**: Frosted glass effect with backdrop blur
- **Gradient Buttons**: Beautiful gradient backgrounds with smooth transitions
- **Interactive Charts**: Responsive and animated data visualizations
- **Custom Navigation**: Floating bottom navigation with center AI button

## 🛠️ **Development**

### **Code Generation**
The app uses code generation for:
- Riverpod providers
- Drift database models
- JSON serialization

Run generation with:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### **State Management**
Uses Riverpod for:
- Global app state
- User authentication state
- Transaction data management
- Settings and preferences

### **Database**
Drift (SQLite) for:
- Local transaction storage
- User preferences
- Offline-first functionality
- Type-safe database queries

## 📋 **Development Guidelines**

- Follow Flutter and Dart style guidelines
- Use conventional commits for version control
- Implement responsive design patterns
- Ensure accessibility compliance
- Write comprehensive tests
- Document complex business logic
- Use meaningful variable and function names

## 🔄 **Recent Updates**

### **v2.0.0 - Complete UI/UX Overhaul**
- Implemented glassmorphic design system
- Added smooth animations and transitions
- Created comprehensive dashboard with real-time data
- Built interactive reports with advanced charts
- Designed modern AI assistant chat interface
- Enhanced user profile with premium features
- Added floating bottom navigation
- Integrated haptic feedback throughout

## 🤝 **Contributing**

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 💡 **Support**

If you have any questions or need help with setup, please:
- Check the [CLAUDE.md](CLAUDE.md) file for development commands
- Open an issue on GitHub
- Review the Flutter documentation

---

**Built with ❤️ using Flutter and modern design principles**