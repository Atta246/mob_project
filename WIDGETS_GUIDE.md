# Project Structure Documentation

## 📁 Folder Organization

```
lib/
├── constants/              # Application-wide constants
│   ├── app_colors.dart    # Color definitions
│   ├── app_text_styles.dart  # Text styles
│   ├── app_constants.dart # Spacing, radii, sizes
│   └── constants.dart     # Export all constants
│
├── widgets/               # Reusable UI components
│   ├── buttons/
│   │   ├── custom_button.dart        # Primary action button
│   │   └── social_login_button.dart  # Social media login buttons
│   │
│   ├── cards/
│   │   ├── trip_card.dart            # Simple trip card
│   │   ├── home_trip_card.dart       # Home screen trip card
│   │   └── enhanced_trip_card.dart   # Advanced trip card with animations
│   │
│   ├── inputs/
│   │   └── custom_text_field.dart    # Styled text input field
│   │
│   ├── common/
│   │   ├── menu_item.dart            # Settings menu item
│   │   ├── info_row.dart             # Label-value display row
│   │   ├── input_field.dart          # Profile input field
│   │   ├── price_row.dart            # Pricing display row
│   │   └── payment_option.dart       # Payment method selector
│   │
│   ├── custom_bottom_nav.dart        # Bottom navigation bar
│   └── widgets.dart       # Export all widgets (single import)
│
├── screens/               # Application screens
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   │
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── main_screen.dart
│   │
│   ├── trips/
│   │   ├── trips_screen.dart
│   │   ├── mytrips_screen.dart
│   │   ├── trip_details_screen.dart
│   │   ├── booking_screen.dart
│   │   ├── payment_screen.dart
│   │   └── ticket_screen.dart
│   │
│   └── settings/
│       ├── Settings_screen.dart
│       ├── Profile_screen.dart
│       ├── edit_profile_screen.dart
│       ├── change_password_screen.dart
│       ├── contact_us_screen.dart
│       └── support_screen.dart
│
└── main.dart              # Application entry point
```

## 🎨 Usage Examples

### Importing Widgets

**Single import for all widgets:**

```dart
import 'package:mob_project/widgets/widgets.dart';
```

**Or import specific widgets:**

```dart
import 'package:mob_project/widgets/buttons/custom_button.dart';
import 'package:mob_project/widgets/cards/trip_card.dart';
```

### Importing Constants

**Single import for all constants:**

```dart
import 'package:mob_project/constants/constants.dart';
```

**Or import specific constants:**

```dart
import 'package:mob_project/constants/app_colors.dart';
import 'package:mob_project/constants/app_text_styles.dart';
```

## 📦 Available Widgets

### Buttons

**CustomButton** - Primary action button with loading state

```dart
CustomButton(
  text: "Book Now",
  onPressed: () {},
  backgroundColor: AppColors.primary,
  height: 50,
)
```

**SocialLoginButton** - Social media login buttons

```dart
SocialLoginButton(
  text: "Continue with Google",
  icon: Icon(Icons.g_mobiledata),
  onPressed: () {},
)
```

### Cards

**TripCard** - Simple trip display card

```dart
TripCard(
  image: 'assets/images/trip.jpg',
  status: 'UPCOMING',
  location: 'Egypt, Luxor',
  dateRange: 'Sep 15 - Sep 22, 2026',
  people: '2 people',
  buttonText: 'View Details',
  buttonColor: Colors.blue,
)
```

**HomeTripCard** - Featured trip card for home screen

```dart
HomeTripCard(
  imagePath: 'assets/images/trip.jpg',
  title: 'Hot Air Balloon',
  description: 'Experience the magic...',
  tripId: '1',
  onBookNow: () {},
)
```

**EnhancedTripCard** - Advanced card with glassmorphism

```dart
EnhancedTripCard(
  imagePath: 'assets/images/balloon.png',
  title: 'Hot Air Balloon Adventure',
  subtitle: 'Egypt',
  date: 'Dec 15, 2025',
  time: '6:00 AM',
  price: '150',
  status: 'Upcoming',
  color: Colors.blue,
  onShowDetails: () {},
)
```

### Inputs

**CustomTextField** - Styled text input

```dart
CustomTextField(
  hintText: "Enter email",
  prefixIcon: Icon(Icons.email),
  keyboardType: TextInputType.emailAddress,
)
```

**InputField** - Profile-style input field

```dart
InputField(
  icon: Icons.person,
  label: 'Full Name',
  value: 'John Doe',
  onTap: () {},
)
```

### Common Widgets

**MenuItem** - Settings menu item

```dart
MenuItem(
  icon: Icons.person,
  label: 'Profile',
  onTap: () {},
)
```

**InfoRow** - Display label-value pairs

```dart
InfoRow(
  label: 'Duration',
  value: '3 hours',
  icon: Icons.access_time,
)
```

**PriceRow** - Display pricing information

```dart
PriceRow(
  label: 'Subtotal',
  amount: '\$150',
  isTotal: false,
)
```

**PaymentOption** - Payment method selector

```dart
PaymentOption(
  index: 0,
  selectedIndex: _selectedPayment,
  icon: Icons.credit_card,
  label: 'Credit Card',
  onTap: () => setState(() => _selectedPayment = 0),
)
```

## 🎨 Constants

### Colors

```dart
AppColors.primary          // #90E0FF
AppColors.textPrimary      // Black
AppColors.buttonPrimary    // #90E0FF
AppColors.success          // Green
```

### Text Styles

```dart
AppTextStyles.heading1     // 32px, bold
AppTextStyles.bodyLarge    // 16px, normal
AppTextStyles.button       // 16px, bold
```

### Constants

```dart
AppConstants.paddingMedium    // 16.0
AppConstants.radiusLarge      // 24.0
AppConstants.buttonHeightMedium  // 50.0
```

## ✅ Benefits

1. **Clean Architecture** - Separated concerns, easy to navigate
2. **Reusability** - Write once, use everywhere
3. **Consistency** - Uniform UI across the app
4. **Maintainability** - Changes in one place affect all instances
5. **Performance** - Smaller app size, no code duplication
6. **Scalability** - Easy to add new features
7. **Testing** - Each widget can be tested independently

## 🚀 Next Steps

To use these widgets in your screens:

1. Remove duplicate widget code from screens
2. Import widgets using `import 'package:mob_project/widgets/widgets.dart';`
3. Replace custom implementations with reusable widgets
4. Apply constants for colors, styles, and spacing
