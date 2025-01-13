EasyPH Mobile Application

Welcome to the EasyPH mobile application, a property of Echobits Technologies. 
This application simplifies power management and payment processes, making it easy for users to 
manage their energy consumption efficiently.

About EasyPH

EasyPH is designed to offer a seamless solution for managing power-related services. It includes
features such as user registration, authentication, OTP verification, biodata management, and 
payment handling. The app aims to enhance user experience by providing intuitive navigation and 
efficient backend communication.

Project Setup Guide

Follow these steps to set up the EasyPH Flutter project:

Prerequisites
1.	Flutter SDK: Install the latest version of Flutter.
2.	Dart SDK: Ensure Dart is installed (comes with Flutter SDK).
3.	IDE: Use an IDE like VS Code or Android Studio.
4.	Dependencies:
•	Install dependencies using flutter pub get.
5.	API Server:
•	Ensure the EasyPH backend API is running and accessible.


Key Features
•	Authentication:
•	Login with email or phone number.
•	OTP verification for unverified accounts.
•	Biodata Management:
•	Complete user profile information after initial signup.
•	Token Management:
•	Secure storage of authentication and refresh tokens.
•	Error Handling:
•	Clear error messages for different scenarios.
•	Navigation:
•	Smooth routing with stacked architecture.

Important Packages

This project uses the following key packages:
•	stacked: For MVVM architecture and state management.
•	dio: For HTTP requests and API communication.
•	flutter_dotenv: For environment variable management.
•	flutter_secure_storage: For secure data storage (e.g., tokens).
•	intl: For date and number formatting.
•	validators: For input validation.

Folder Structure

The project follows the stacked architecture for better scalability and maintainability:
lib/
├── models/            # Data models
├── services/          # Business logic and API services
├── views/             # UI screens and widgets
├── viewmodels/        # State management for each view
├── utils/             # Utility functions and constants
└── main.dart          # Application entry point

Development Guidelines
1.	Coding Standards:
•	Follow Dart’s Effective Dart Guidelines.
•	Write modular and reusable code.
2.	API Integration:
•	Use dio for API calls.
•	Handle errors gracefully and display appropriate messages.
3.	Testing:
•	Write unit tests for business logic.
•	Test all edge cases for navigation and API calls.
4.	Environment-Specific Configurations:
•	Use .env for environment-specific settings.
•	Avoid hardcoding sensitive data.


Contribution Guidelines
1.	Fork the repository and create a feature branch.
2.	Commit changes with meaningful commit messages.
3.	Create a pull request for review.
4.	Ensure code adheres to the project’s coding standards.


License and Ownership

The EasyPH application is the exclusive property of Echonits Technologies. Unauthorized distribution
or reproduction is strictly prohibited. For inquiries, contact support@echobitstech.com.

Enjoy building with EasyPH! 🚀

