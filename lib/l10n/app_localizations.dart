import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'QuickRider'**
  String get appName;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get start;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @goOn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get goOn;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to QuickRider'**
  String get welcome;

  /// No description provided for @slogan.
  ///
  /// In en, this message translates to:
  /// **'Your Ride, On Demand.'**
  String get slogan;

  /// No description provided for @confirmPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Confirm Phone Number'**
  String get confirmPhoneNumber;

  /// No description provided for @otpMessage.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a 6-digit verification code to your mobile number for verification.'**
  String get otpMessage;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About QuickRider'**
  String get aboutApp;

  /// No description provided for @myRides.
  ///
  /// In en, this message translates to:
  /// **'My Rides'**
  String get myRides;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @socialMediaFolow.
  ///
  /// In en, this message translates to:
  /// **'Follow us on social media'**
  String get socialMediaFolow;

  /// No description provided for @privacyPolicyHeader.
  ///
  /// In en, this message translates to:
  /// **'At QuickRider, we are committed to protecting our users\' privacy in compliance with the regulations of the Kingdom of Saudi Arabia. By using our app, you agree to the terms outlined below.'**
  String get privacyPolicyHeader;

  /// No description provided for @profileScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileScreenTitle;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @rideHistory.
  ///
  /// In en, this message translates to:
  /// **'Ride History'**
  String get rideHistory;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No new notifications'**
  String get noNotifications;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'notifications'**
  String get notifications;

  /// First onboarding title
  ///
  /// In en, this message translates to:
  /// **'Request a Ride in Seconds'**
  String get onBoardingTitleOne;

  /// First onboarding description
  ///
  /// In en, this message translates to:
  /// **'Tap a button and get a driver heading your way.'**
  String get onBoardingDescriptionOne;

  /// Second onboarding title
  ///
  /// In en, this message translates to:
  /// **'Track Your Driver'**
  String get onBoardingTitleTwo;

  /// Second onboarding description
  ///
  /// In en, this message translates to:
  /// **'Watch your driver\'s location in real-time on the map.'**
  String get onBoardingDescriptionTwo;

  /// Third onboarding title
  ///
  /// In en, this message translates to:
  /// **'Arrive Safely'**
  String get onBoardingTitleThree;

  /// Third onboarding description
  ///
  /// In en, this message translates to:
  /// **'Relax and enjoy a quick and reliable ride to your destination.'**
  String get onBoardingDescriptionThree;

  /// A global title for safety and savings
  ///
  /// In en, this message translates to:
  /// **'Arrive Safely, Save Smartly'**
  String get arriveSafelySaveSmartlyTitle;

  /// A global description for safety and savings
  ///
  /// In en, this message translates to:
  /// **'Enjoy peace of mind on every trip with transparent fares that are easy on your wallet.'**
  String get arriveSafelySaveSmartlyDescription;

  /// No description provided for @homeScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeScreenTitle;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get userName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get otp;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @notificationsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsScreenTitle;

  /// No description provided for @uploadImageDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload Profile Picture'**
  String get uploadImageDialogTitle;

  /// No description provided for @uploadFromCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get uploadFromCamera;

  /// No description provided for @uploadFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get uploadFromGallery;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! Your account is ready.'**
  String get accountCreated;

  /// No description provided for @accountCreatedSub.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set to request your first ride with QuickRider.'**
  String get accountCreatedSub;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @fave.
  ///
  /// In en, this message translates to:
  /// **'Saved Places'**
  String get fave;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @requestRide.
  ///
  /// In en, this message translates to:
  /// **'Request a Ride'**
  String get requestRide;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorOccurred;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload Failed'**
  String get uploadFailed;

  /// No description provided for @operationFailed.
  ///
  /// In en, this message translates to:
  /// **'The operation could not be completed.'**
  String get operationFailed;

  /// No description provided for @congrats.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congrats;

  /// No description provided for @rideConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Your ride is confirmed and your driver is on the way!'**
  String get rideConfirmed;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterName;

  /// No description provided for @phoneNumberValidation.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number starting with 5'**
  String get phoneNumberValidation;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneNumber;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @driveWithUs.
  ///
  /// In en, this message translates to:
  /// **'Drive with us'**
  String get driveWithUs;

  /// Hint text for phone number input
  ///
  /// In en, this message translates to:
  /// **'Phone Number (e.g., 5xxxxxxxx)'**
  String get phoneHintText;

  /// Hint text for OTP input
  ///
  /// In en, this message translates to:
  /// **'Verification Code (Mock is 123456)'**
  String get otpHintText;

  /// Text for the 'Send Code' button
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCodeButton;

  /// Text for the 'Verify & Sign In' button
  ///
  /// In en, this message translates to:
  /// **'Verify & Sign In'**
  String get verifySignInButton;

  /// Text for 'Verifying...' during OTP submission
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get verifyingMessage;

  /// Prefix for resend timer
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// Text for the 'Resend Code' button
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCodeButton;

  /// Text for 'Didn't receive any code?' prompt
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive any code?'**
  String get didNotReceiveCode;

  /// Text for 'Request a new code' in timer
  ///
  /// In en, this message translates to:
  /// **'Request a new code'**
  String get requestNewCode;

  /// No description provided for @resendAgainButton.
  ///
  /// In en, this message translates to:
  /// **'Resend Again'**
  String get resendAgainButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
