// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'QuickRider';

  @override
  String get next => 'Next';

  @override
  String get start => 'Get Started';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get submit => 'Submit';

  @override
  String get delete => 'delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get upload => 'Upload';

  @override
  String get edit => 'Edit';

  @override
  String get report => 'Report';

  @override
  String get remove => 'Remove';

  @override
  String get done => 'Done';

  @override
  String get profile => 'Profile';

  @override
  String get goOn => 'Continue';

  @override
  String get welcome => 'Welcome to QuickRider';

  @override
  String get slogan => 'Your Ride, On Demand.';

  @override
  String get confirmPhoneNumber => 'Confirm Phone Number';

  @override
  String get otpMessage =>
      'We\'ve sent a 6-digit verification code to your mobile number for verification.';

  @override
  String get shareApp => 'Share App';

  @override
  String get rateApp => 'Rate App';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get aboutApp => 'About QuickRider';

  @override
  String get myRides => 'My Rides';

  @override
  String get settings => 'Settings';

  @override
  String get socialMediaFolow => 'Follow us on social media';

  @override
  String get privacyPolicyHeader =>
      'At QuickRider, we are committed to protecting our users\' privacy in compliance with the regulations of the Kingdom of Saudi Arabia. By using our app, you agree to the terms outlined below.';

  @override
  String get profileScreenTitle => 'Profile';

  @override
  String get paymentMethods => 'Payment Methods';

  @override
  String get rideHistory => 'Ride History';

  @override
  String get language => 'Language';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get faq => 'FAQ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get logout => 'Log Out';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'No new notifications';

  @override
  String get faqScreenTitle => 'Frequently Asked Questions';

  @override
  String get privacyPolicyScreenTitle => 'Privacy Policy';

  @override
  String get failedToLaunchApp => 'Failed to launch WhatsApp';

  @override
  String get logoutTitle => 'Logout';

  @override
  String get logoutConfirmation => 'Are you sure you want to log out?';

  @override
  String get faqQuestion1 => 'What is QuickRider?';

  @override
  String get faqAnswer1 =>
      'QuickRider is a ride-hailing app that connects passengers with nearby drivers for convenient and reliable transportation.';

  @override
  String get faqQuestion2 => 'How do I request a ride?';

  @override
  String get faqAnswer2 =>
      'Simply open the app, enter your destination, select your preferred ride type, and confirm your request. A driver will be assigned to you shortly.';

  @override
  String get faqQuestion3 => 'What payment methods are accepted?';

  @override
  String get faqAnswer3 =>
      'We accept various payment methods including credit/debit cards and cash. You can add your preferred method in the \'Payment Methods\' section of your profile.';

  @override
  String get faqQuestion4 => 'How can I contact customer support?';

  @override
  String get faqAnswer4 =>
      'You can reach our customer support through the \'Help & Support\' section in the app, or by emailing us at support@quickrider.com.';

  @override
  String get privacyPolicyContent =>
      '# Privacy Policy for QuickRider\n\n**Last Updated:** October 26, 2023\n\nQuickRider is committed to protecting your privacy. This Privacy Policy describes how QuickRider collects, uses, and discloses information, and what choices you have with respect to the information.\n\n## 1. Information We Collect\n\nWe collect information to provide better services to all our users. The types of information we collect include:\n\n* **Personal Information:** Such as your name, email address, phone number, payment information, and profile picture.\n* **Location Information:** We collect precise location data when the app is running in the foreground or background to enable ride services, track progress, and improve pickup/dropoff.\n* **Usage Information:** Details about how you use our services, including ride requests, duration, distance, and interactions with the app.\n* **Device Information:** Information about your mobile device, including the hardware model, operating system, and unique device identifiers.\n\n## 2. How We Use Your Information\n\nWe use the information we collect to:\n\n* Provide, maintain, and improve our services, including facilitating rides, processing payments, and personalizing user experience.\n* Communicate with you about our services, promotions, and updates.\n* Ensure safety and security for all users and comply with legal obligations.\n* Perform internal operations, such as data analysis, testing, and research to improve service quality.\n\n## 3. Information Sharing and Disclosure\n\nWe may share your information:\n\n* **With drivers/passengers:** To facilitate ride services (e.g., driver\'s name, vehicle details, location to passenger).\n* **With service providers:** To perform services on our behalf, such as payment processing, analytics, and customer support.\n* **For legal reasons:** If required by law, regulation, legal process, or governmental request.\n* **With your consent:** We may share your information for other purposes with your explicit consent.\n\n## 4. Your Choices\n\n* **Location Information:** You can enable or disable location services through your device settings.\n* **Push Notifications:** You can opt-out of receiving push notifications through your device settings.\n* **Account Information:** You may update your profile information at any time through the app.\n\n## 5. Data Security\n\nWe implement reasonable security measures to protect your information from unauthorized access, alteration, disclosure, or destruction.\n\n## 6. Changes to This Policy\n\nWe may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy on this page and updating the \'Last Updated\' date.\n\n## 7. Contact Us\n\nIf you have any questions about this Privacy Policy, please contact us at support@quickrider.com.';

  @override
  String get cardAddedSuccess => 'Card added successfully!';

  @override
  String get cardNumber => 'Card Number';

  @override
  String get expiryDate => 'Expiry Date';

  @override
  String get cvvCode => 'CVV';

  @override
  String get cardHolder => 'Card Holder';

  @override
  String get verifyingMessage => 'Verifying...';

  @override
  String get addCard => 'Add Card';

  @override
  String get cash => 'Cash';

  @override
  String get defaultLabel => 'Default';

  @override
  String get setAsDefault => 'Set as Default';

  @override
  String get deleteCardTitle => 'Delete Card';

  @override
  String deleteCardConfirmation(String lastFourDigits) {
    return 'Are you sure you want to delete the card ending in $lastFourDigits?';
  }

  @override
  String get cannotLaunchWhatsapp =>
      'Could not launch WhatsApp. Please ensure it is installed.';

  @override
  String get onBoardingTitleOne => 'Request a Ride in Seconds';

  @override
  String get onBoardingDescriptionOne =>
      'Tap a button and get a driver heading your way.';

  @override
  String get onBoardingTitleTwo => 'Track Your Driver';

  @override
  String get onBoardingDescriptionTwo =>
      'Watch your driver\'s location in real-time on the map.';

  @override
  String get onBoardingTitleThree => 'Arrive Safely';

  @override
  String get onBoardingDescriptionThree =>
      'Relax and enjoy a quick and reliable ride to your destination.';

  @override
  String get arriveSafelySaveSmartlyTitle => 'Arrive Safely, Save Smartly';

  @override
  String get arriveSafelySaveSmartlyDescription =>
      'Enjoy peace of mind on every trip with transparent fares that are easy on your wallet.';

  @override
  String get homeScreenTitle => 'Home';

  @override
  String get userName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get otp => 'Verification Code';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get notificationsScreenTitle => 'Notifications';

  @override
  String get uploadImageDialogTitle => 'Upload Profile Picture';

  @override
  String get uploadFromCamera => 'Camera';

  @override
  String get uploadFromGallery => 'Gallery';

  @override
  String get accountCreated => 'Congratulations! Your account is ready.';

  @override
  String get accountCreatedSub =>
      'You\'re all set to request your first ride with QuickRider.';

  @override
  String get city => 'City';

  @override
  String get fave => 'Saved Places';

  @override
  String get close => 'Close';

  @override
  String get requestRide => 'Request a Ride';

  @override
  String get errorOccurred => 'Something went wrong';

  @override
  String get uploadFailed => 'Upload Failed';

  @override
  String get operationFailed => 'The operation could not be completed.';

  @override
  String get congrats => 'Congratulations!';

  @override
  String get rideConfirmed =>
      'Your ride is confirmed and your driver is on the way!';

  @override
  String get enterName => 'Enter your name';

  @override
  String get phoneNumberValidation =>
      'Enter a valid phone number starting with 5';

  @override
  String get enterPhoneNumber => 'Enter phone number';

  @override
  String get home => 'Home';

  @override
  String get account => 'Account';

  @override
  String get driveWithUs => 'Drive with us';

  @override
  String get phoneHintText => 'Phone Number (e.g., 5xxxxxxxx)';

  @override
  String get otpHintText => 'Verification Code (Mock is 123456)';

  @override
  String get sendCodeButton => 'Send Code';

  @override
  String get verifySignInButton => 'Verify & Sign In';

  @override
  String get resend => 'Resend';

  @override
  String get resendCodeButton => 'Resend Code';

  @override
  String get didNotReceiveCode => 'Didn\'t receive any code?';

  @override
  String get requestNewCode => 'Request a new code';

  @override
  String get resendAgainButton => 'Resend Again';
}
