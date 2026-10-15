// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `activate Account`
  String get activateAccount {
    return Intl.message(
      'activate Account',
      name: 'activateAccount',
      desc: '',
      args: [],
    );
  }

  /// `By continuing, You agree to our `
  String get byContinuingYouAgreeToOur {
    return Intl.message(
      'By continuing, You agree to our ',
      name: 'byContinuingYouAgreeToOur',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Terms of Service `
  String get termsOfService {
    return Intl.message(
      'Terms of Service ',
      name: 'termsOfService',
      desc: '',
      args: [],
    );
  }

  /// `and `
  String get and {
    return Intl.message('and ', name: 'and', desc: '', args: []);
  }

  /// `Manage Your Restaurant/\nCafe Like a Pro`
  String get manageYourRestaurantCafeLikeAPro {
    return Intl.message(
      'Manage Your Restaurant/\nCafe Like a Pro',
      name: 'manageYourRestaurantCafeLikeAPro',
      desc: '',
      args: [],
    );
  }

  /// `Control sales, inventory, and staff — all in one app.`
  String get onboardingOneDesc {
    return Intl.message(
      'Control sales, inventory, and staff — all in one app.',
      name: 'onboardingOneDesc',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get changeLanguage {
    return Intl.message(
      'Change Language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `The selected language will be the main language for the whole app.`
  String get changeLanguageDescription {
    return Intl.message(
      'The selected language will be the main language for the whole app.',
      name: 'changeLanguageDescription',
      desc: '',
      args: [],
    );
  }

  /// `See Everything, Miss Nothing`
  String get seeEverythingMissNothing {
    return Intl.message(
      'See Everything, Miss Nothing',
      name: 'seeEverythingMissNothing',
      desc: '',
      args: [],
    );
  }

  /// `Track performance and get real-time updates across all branches.`
  String get onboardingTwoDesc {
    return Intl.message(
      'Track performance and get real-time updates across all branches.',
      name: 'onboardingTwoDesc',
      desc: '',
      args: [],
    );
  }

  /// `Know What’s Working, Fix What’s Not`
  String get knowWhatWorkingFixWhatNot {
    return Intl.message(
      'Know What’s Working, Fix What’s Not',
      name: 'knowWhatWorkingFixWhatNot',
      desc: '',
      args: [],
    );
  }

  /// `Get smart reports and insights to grow your business faster.`
  String get onboardingThreeDesc {
    return Intl.message(
      'Get smart reports and insights to grow your business faster.',
      name: 'onboardingThreeDesc',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Assab`
  String get welcomeToAssab {
    return Intl.message(
      'Welcome to Assab',
      name: 'welcomeToAssab',
      desc: '',
      args: [],
    );
  }

  /// `Enter your default login details below to check if your account is active.`
  String get enterYourDefaultLoginDetailsBelow {
    return Intl.message(
      'Enter your default login details below to check if your account is active.',
      name: 'enterYourDefaultLoginDetailsBelow',
      desc: '',
      args: [],
    );
  }

  /// `Once confirmed, you’ll update your password and start using the platform.`
  String get onceConfirmedYouUpdateYourPassword {
    return Intl.message(
      'Once confirmed, you’ll update your password and start using the platform.',
      name: 'onceConfirmedYouUpdateYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `E.g Busniessname@domain.sa`
  String get hintEmail {
    return Intl.message(
      'E.g Busniessname@domain.sa',
      name: 'hintEmail',
      desc: '',
      args: [],
    );
  }

  /// `Default Password`
  String get defaultPassword {
    return Intl.message(
      'Default Password',
      name: 'defaultPassword',
      desc: '',
      args: [],
    );
  }

  /// `Registered email`
  String get registeredEmail {
    return Intl.message(
      'Registered email',
      name: 'registeredEmail',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Don’t have an account yet?`
  String get doNotHaveAnAccountYet {
    return Intl.message(
      'Don’t have an account yet?',
      name: 'doNotHaveAnAccountYet',
      desc: '',
      args: [],
    );
  }

  /// `How to create an account`
  String get howToCreateAnAccount {
    return Intl.message(
      'How to create an account',
      name: 'howToCreateAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Verify Account`
  String get verifyAccount {
    return Intl.message(
      'Verify Account',
      name: 'verifyAccount',
      desc: '',
      args: [],
    );
  }

  /// `Email Not Valid`
  String get emailNotValid {
    return Intl.message(
      'Email Not Valid',
      name: 'emailNotValid',
      desc: '',
      args: [],
    );
  }

  /// `Password must be 8+ characters and include a-z, A-Z, 0-9, and one of $, &, @`
  String get passwordNotValid {
    return Intl.message(
      'Password must be 8+ characters and include a-z, A-Z, 0-9, and one of \$, &, @',
      name: 'passwordNotValid',
      desc: '',
      args: [],
    );
  }

  /// `Account Verified`
  String get accountVerified {
    return Intl.message(
      'Account Verified',
      name: 'accountVerified',
      desc: '',
      args: [],
    );
  }

  /// `Change your default account password to enhance your account security.`
  String get accountVerifiedDescription {
    return Intl.message(
      'Change your default account password to enhance your account security.',
      name: 'accountVerifiedDescription',
      desc: '',
      args: [],
    );
  }

  /// `Create New Password`
  String get createNewPassword {
    return Intl.message(
      'Create New Password',
      name: 'createNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `1pP10@Zx`
  String get passwordHint {
    return Intl.message('1pP10@Zx', name: 'passwordHint', desc: '', args: []);
  }

  /// `The password you entered does not match the one above.`
  String get passwordNoMatch {
    return Intl.message(
      'The password you entered does not match the one above.',
      name: 'passwordNoMatch',
      desc: '',
      args: [],
    );
  }

  /// `Complete Account Activation`
  String get completeAccountActivation {
    return Intl.message(
      'Complete Account Activation',
      name: 'completeAccountActivation',
      desc: '',
      args: [],
    );
  }

  /// `Password Reset Successful`
  String get passwordResetSuccessful {
    return Intl.message(
      'Password Reset Successful',
      name: 'passwordResetSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Your password has been reset successfully!\nYou can now log in to access your account.`
  String get passwordResetDesc {
    return Intl.message(
      'Your password has been reset successfully!\nYou can now log in to access your account.',
      name: 'passwordResetDesc',
      desc: '',
      args: [],
    );
  }

  /// `Log In to my account`
  String get logInToMyAccount {
    return Intl.message(
      'Log In to my account',
      name: 'logInToMyAccount',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back!`
  String get welcomeBack {
    return Intl.message(
      'Welcome Back!',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Login to access your account to get started!`
  String get loginToAccessYourAccountToGetStarted {
    return Intl.message(
      'Login to access your account to get started!',
      name: 'loginToAccessYourAccountToGetStarted',
      desc: '',
      args: [],
    );
  }

  /// `Save login details to device`
  String get saveLoginDetailsToDevice {
    return Intl.message(
      'Save login details to device',
      name: 'saveLoginDetailsToDevice',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Email/Phone`
  String get emailOrPhone {
    return Intl.message(
      'Email/Phone',
      name: 'emailOrPhone',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get logIn {
    return Intl.message('Log In', name: 'logIn', desc: '', args: []);
  }

  /// `Account Related Quick Links`
  String get accountRelatedQuickLinks {
    return Intl.message(
      'Account Related Quick Links',
      name: 'accountRelatedQuickLinks',
      desc: '',
      args: [],
    );
  }

  /// `Create New Account`
  String get createNewAccount {
    return Intl.message(
      'Create New Account',
      name: 'createNewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Login With Email`
  String get loginWithEmail {
    return Intl.message(
      'Login With Email',
      name: 'loginWithEmail',
      desc: '',
      args: [],
    );
  }

  /// `Login With Phone`
  String get loginWithPhone {
    return Intl.message(
      'Login With Phone',
      name: 'loginWithPhone',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Phone`
  String get phone {
    return Intl.message('Phone', name: 'phone', desc: '', args: []);
  }

  /// `5XXXXXXXX`
  String get hintPhone {
    return Intl.message('5XXXXXXXX', name: 'hintPhone', desc: '', args: []);
  }

  /// `Phone Not Valid`
  String get phoneNotValid {
    return Intl.message(
      'Phone Not Valid',
      name: 'phoneNotValid',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get forgotYourPassword {
    return Intl.message(
      'Forgot your password?',
      name: 'forgotYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email or phone number below to reset it!`
  String get forgotYourPasswordDesc {
    return Intl.message(
      'Enter your email or phone number below to reset it!',
      name: 'forgotYourPasswordDesc',
      desc: '',
      args: [],
    );
  }

  /// `Request OTP`
  String get requestOTP {
    return Intl.message('Request OTP', name: 'requestOTP', desc: '', args: []);
  }

  /// `Last Reset:`
  String get lastReset {
    return Intl.message('Last Reset:', name: 'lastReset', desc: '', args: []);
  }

  /// `Did not receive OTP?`
  String get didNotReceiveOTP {
    return Intl.message(
      'Did not receive OTP?',
      name: 'didNotReceiveOTP',
      desc: '',
      args: [],
    );
  }

  /// `Resend In`
  String get resendIn {
    return Intl.message('Resend In', name: 'resendIn', desc: '', args: []);
  }

  /// `secs`
  String get secs {
    return Intl.message('secs', name: 'secs', desc: '', args: []);
  }

  /// `Registered Phone`
  String get registeredPhone {
    return Intl.message(
      'Registered Phone',
      name: 'registeredPhone',
      desc: '',
      args: [],
    );
  }

  /// `Reset With Email`
  String get resetWithEmail {
    return Intl.message(
      'Reset With Email',
      name: 'resetWithEmail',
      desc: '',
      args: [],
    );
  }

  /// `Reset With Phone`
  String get resetWithPhone {
    return Intl.message(
      'Reset With Phone',
      name: 'resetWithPhone',
      desc: '',
      args: [],
    );
  }

  /// `Verify Your Identity`
  String get verifyYourIdentity {
    return Intl.message(
      'Verify Your Identity',
      name: 'verifyYourIdentity',
      desc: '',
      args: [],
    );
  }

  /// `To ensure security, we have sent a one-time passcode (OTP) to `
  String get verifyYourIdentityDescPart1 {
    return Intl.message(
      'To ensure security, we have sent a one-time passcode (OTP) to ',
      name: 'verifyYourIdentityDescPart1',
      desc: '',
      args: [],
    );
  }

  /// `Enter it in the field below to proceed.`
  String get verifyYourIdentityDescPart2 {
    return Intl.message(
      'Enter it in the field below to proceed.',
      name: 'verifyYourIdentityDescPart2',
      desc: '',
      args: [],
    );
  }

  /// `Confirm OTP`
  String get confirmOTP {
    return Intl.message('Confirm OTP', name: 'confirmOTP', desc: '', args: []);
  }

  /// `Create a new password that’s strong and easy for you to remember!`
  String get createNewPasswordDesc {
    return Intl.message(
      'Create a new password that’s strong and easy for you to remember!',
      name: 'createNewPasswordDesc',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password Reset`
  String get confirmPasswordReset {
    return Intl.message(
      'Confirm Password Reset',
      name: 'confirmPasswordReset',
      desc: '',
      args: [],
    );
  }

  /// `Weak Password`
  String get weakPassword {
    return Intl.message(
      'Weak Password',
      name: 'weakPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password is Ok`
  String get passwordIsOk {
    return Intl.message(
      'Password is Ok',
      name: 'passwordIsOk',
      desc: '',
      args: [],
    );
  }

  /// `Password is Perfect`
  String get passwordIsPerfect {
    return Intl.message(
      'Password is Perfect',
      name: 'passwordIsPerfect',
      desc: '',
      args: [],
    );
  }

  /// `Ready to Join ASEB? Let’s Get You Set Up!`
  String get createAccountTitle {
    return Intl.message(
      'Ready to Join ASEB? Let’s Get You Set Up!',
      name: 'createAccountTitle',
      desc: '',
      args: [],
    );
  }

  /// `We’re excited to have you onboard — Assab is built to help restaurants and cafés like yours run smoother, smarter, and more profitably.`
  String get createAccountDesc {
    return Intl.message(
      'We’re excited to have you onboard — Assab is built to help restaurants and cafés like yours run smoother, smarter, and more profitably.',
      name: 'createAccountDesc',
      desc: '',
      args: [],
    );
  }

  /// `To ensure everything’s tailored to your brand from day one, account creation starts with us.`
  String get createAccountDesc2 {
    return Intl.message(
      'To ensure everything’s tailored to your brand from day one, account creation starts with us.',
      name: 'createAccountDesc2',
      desc: '',
      args: [],
    );
  }

  /// `Let’s set things in motion — reach out and we’ll get your account up and running in no time.`
  String get createAccountDesc3 {
    return Intl.message(
      'Let’s set things in motion — reach out and we’ll get your account up and running in no time.',
      name: 'createAccountDesc3',
      desc: '',
      args: [],
    );
  }

  /// `Contact Our Team`
  String get createAccountTitleItem1 {
    return Intl.message(
      'Contact Our Team',
      name: 'createAccountTitleItem1',
      desc: '',
      args: [],
    );
  }

  /// `Reach out and let us know you’re ready to get started.`
  String get createAccountDescItem1 {
    return Intl.message(
      'Reach out and let us know you’re ready to get started.',
      name: 'createAccountDescItem1',
      desc: '',
      args: [],
    );
  }

  /// `We’ll Talk Details`
  String get createAccountTitleItem2 {
    return Intl.message(
      'We’ll Talk Details',
      name: 'createAccountTitleItem2',
      desc: '',
      args: [],
    );
  }

  /// `We’ll walk through your brand setup, number of outlets, and goals.`
  String get createAccountDescItem2 {
    return Intl.message(
      'We’ll walk through your brand setup, number of outlets, and goals.',
      name: 'createAccountDescItem2',
      desc: '',
      args: [],
    );
  }

  /// `We Create Your Account`
  String get createAccountTitleItem3 {
    return Intl.message(
      'We Create Your Account',
      name: 'createAccountTitleItem3',
      desc: '',
      args: [],
    );
  }

  /// `We’ll walk through your brand setup, number of outlets, and goals.`
  String get createAccountDescItem3 {
    return Intl.message(
      'We’ll walk through your brand setup, number of outlets, and goals.',
      name: 'createAccountDescItem3',
      desc: '',
      args: [],
    );
  }

  /// `Contact us today:`
  String get contactUsToday {
    return Intl.message(
      'Contact us today:',
      name: 'contactUsToday',
      desc: '',
      args: [],
    );
  }

  /// `Call Us`
  String get callUs {
    return Intl.message('Call Us', name: 'callUs', desc: '', args: []);
  }

  /// `Email Us`
  String get emailUs {
    return Intl.message('Email Us', name: 'emailUs', desc: '', args: []);
  }

  /// `Resend`
  String get resend {
    return Intl.message('Resend', name: 'resend', desc: '', args: []);
  }

  /// `Code Send Successfully`
  String get codeSendSuccessfully {
    return Intl.message(
      'Code Send Successfully',
      name: 'codeSendSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Field To Send Code`
  String get fieldToSendCode {
    return Intl.message(
      'Field To Send Code',
      name: 'fieldToSendCode',
      desc: '',
      args: [],
    );
  }

  /// `Cashier list ({number})`
  String cashierList(int number) {
    return Intl.message(
      'Cashier list ($number)',
      name: 'cashierList',
      desc: 'Displays the cashier list number',
      args: [number],
    );
  }

  /// `Cashier list ({branchName})`
  String cashiersInStore(String branchName) {
    return Intl.message(
      'Cashier list ($branchName)',
      name: 'cashiersInStore',
      desc: 'Displays the cashier in which Branch',
      args: [branchName],
    );
  }

  /// `Modify Asset Status`
  String get modifyAssetStatusTitle {
    return Intl.message(
      'Modify Asset Status',
      name: 'modifyAssetStatusTitle',
      desc: '',
      args: [],
    );
  }

  /// `Asset Details`
  String get assetDetails {
    return Intl.message(
      'Asset Details',
      name: 'assetDetails',
      desc: '',
      args: [],
    );
  }

  /// `Cashier List`
  String get cashierListTitle {
    return Intl.message(
      'Cashier List',
      name: 'cashierListTitle',
      desc: '',
      args: [],
    );
  }

  /// `See Workday's & Stages`
  String get seeWorkdaysAndStages {
    return Intl.message(
      'See Workday\'s & Stages',
      name: 'seeWorkdaysAndStages',
      desc: '',
      args: [],
    );
  }

  /// `Once more cashiers are added, you'll be able to view a timeline of everyone's shifts and workdays here.`
  String get cashierListDescription {
    return Intl.message(
      'Once more cashiers are added, you\'ll be able to view a timeline of everyone\'s shifts and workdays here.',
      name: 'cashierListDescription',
      desc: '',
      args: [],
    );
  }

  /// `Role:`
  String get roleLabel {
    return Intl.message('Role:', name: 'roleLabel', desc: '', args: []);
  }

  /// `Store Branch`
  String get storeBranchLabel {
    return Intl.message(
      'Store Branch',
      name: 'storeBranchLabel',
      desc: '',
      args: [],
    );
  }

  /// `Workdays:`
  String get workdaysLabel {
    return Intl.message('Workdays:', name: 'workdaysLabel', desc: '', args: []);
  }

  /// `Shift:`
  String get shiftLabel {
    return Intl.message('Shift:', name: 'shiftLabel', desc: '', args: []);
  }

  /// `Hand's Over To:`
  String get handsOverToLabel {
    return Intl.message(
      'Hand\'s Over To:',
      name: 'handsOverToLabel',
      desc: '',
      args: [],
    );
  }

  /// `New Status`
  String get newStatus {
    return Intl.message('New Status', name: 'newStatus', desc: '', args: []);
  }

  /// `Actions`
  String get actions {
    return Intl.message('Actions', name: 'actions', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Reason for Change`
  String get reasonForChange {
    return Intl.message(
      'Reason for Change',
      name: 'reasonForChange',
      desc: '',
      args: [],
    );
  }

  /// `E.g. Strange noises; performance drop`
  String get eGStrangeNoises {
    return Intl.message(
      'E.g. Strange noises; performance drop',
      name: 'eGStrangeNoises',
      desc: '',
      args: [],
    );
  }

  /// `Documentation Photos`
  String get documentationPhotos {
    return Intl.message(
      'Documentation Photos',
      name: 'documentationPhotos',
      desc: '',
      args: [],
    );
  }

  /// `You can upload optional Videos too.`
  String get youCanUploadOptionalVideosToo {
    return Intl.message(
      'You can upload optional Videos too.',
      name: 'youCanUploadOptionalVideosToo',
      desc: '',
      args: [],
    );
  }

  /// `Take a Photo`
  String get takeAPhoto {
    return Intl.message('Take a Photo', name: 'takeAPhoto', desc: '', args: []);
  }

  /// `From Files`
  String get fromFiles {
    return Intl.message('From Files', name: 'fromFiles', desc: '', args: []);
  }

  /// `Required Actions`
  String get requiredActions {
    return Intl.message(
      'Required Actions',
      name: 'requiredActions',
      desc: '',
      args: [],
    );
  }

  /// `Done:`
  String get doneActions {
    return Intl.message('Done:', name: 'doneActions', desc: '', args: []);
  }

  /// `Next:`
  String get nextActions {
    return Intl.message('Next:', name: 'nextActions', desc: '', args: []);
  }

  /// `Need Technician`
  String get needTechnician {
    return Intl.message(
      'Need Technician',
      name: 'needTechnician',
      desc: '',
      args: [],
    );
  }

  /// `Halt`
  String get halt {
    return Intl.message('Halt', name: 'halt', desc: '', args: []);
  }

  /// `Replace`
  String get replace {
    return Intl.message('Replace', name: 'replace', desc: '', args: []);
  }

  /// `Approval Request: Owner`
  String get approvalRequestOwner {
    return Intl.message(
      'Approval Request: Owner',
      name: 'approvalRequestOwner',
      desc: '',
      args: [],
    );
  }

  /// `E.g. Minor issues, requires inspection.`
  String get eGMinorIssues {
    return Intl.message(
      'E.g. Minor issues, requires inspection.',
      name: 'eGMinorIssues',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `No Cashiers Yet`
  String get no_cashiers {
    return Intl.message(
      'No Cashiers Yet',
      name: 'no_cashiers',
      desc: '',
      args: [],
    );
  }

  /// `To manage cashier shifts, you’ll need to add at least one cashier to this branch.\n\nOnce added, you can assign shifts, monitor handovers, and track daily sales activity.`
  String get no_cashiers_desc {
    return Intl.message(
      'To manage cashier shifts, you’ll need to add at least one cashier to this branch.\n\nOnce added, you can assign shifts, monitor handovers, and track daily sales activity.',
      name: 'no_cashiers_desc',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `My Shift's`
  String get myShifts {
    return Intl.message('My Shift\'s', name: 'myShifts', desc: '', args: []);
  }

  /// `Requests`
  String get requests {
    return Intl.message('Requests', name: 'requests', desc: '', args: []);
  }

  /// `Expenses`
  String get expenses {
    return Intl.message('Expenses', name: 'expenses', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Total expenses added`
  String get totalExpensesAdded {
    return Intl.message(
      'Total expenses added',
      name: 'totalExpensesAdded',
      desc: '',
      args: [],
    );
  }

  /// `Total Expenses`
  String get totalExpenses {
    return Intl.message(
      'Total Expenses',
      name: 'totalExpenses',
      desc: '',
      args: [],
    );
  }

  /// `Quick Cash Expense`
  String get quickCashExpense {
    return Intl.message(
      'Quick Cash Expense',
      name: 'quickCashExpense',
      desc: '',
      args: [],
    );
  }

  /// `(Small, fast expense ≤ 500 SAR e.g., taxi, staff meal)`
  String get quickCashExpenseDesc {
    return Intl.message(
      '(Small, fast expense ≤ 500 SAR e.g., taxi, staff meal)',
      name: 'quickCashExpenseDesc',
      desc: '',
      args: [],
    );
  }

  /// `Single Invoice`
  String get singleInvoice {
    return Intl.message(
      'Single Invoice',
      name: 'singleInvoice',
      desc: '',
      args: [],
    );
  }

  /// `(A detailed invoice scanned or entered manually)`
  String get singleInvoiceDesc {
    return Intl.message(
      '(A detailed invoice scanned or entered manually)',
      name: 'singleInvoiceDesc',
      desc: '',
      args: [],
    );
  }

  /// `Grouped Invoices`
  String get groupedInvoices {
    return Intl.message(
      'Grouped Invoices',
      name: 'groupedInvoices',
      desc: '',
      args: [],
    );
  }

  /// `(Multiple invoices entered together in one session)`
  String get groupedInvoicesDesc {
    return Intl.message(
      '(Multiple invoices entered together in one session)',
      name: 'groupedInvoicesDesc',
      desc: '',
      args: [],
    );
  }

  /// `Pre-Approval Request`
  String get preApprovalRequest {
    return Intl.message(
      'Pre-Approval Request',
      name: 'preApprovalRequest',
      desc: '',
      args: [],
    );
  }

  /// `(For upcoming large expenses needing prior approval)`
  String get preApprovalRequestDesc {
    return Intl.message(
      '(For upcoming large expenses needing prior approval)',
      name: 'preApprovalRequestDesc',
      desc: '',
      args: [],
    );
  }

  /// `See Expense History`
  String get seeExpenseHistory {
    return Intl.message(
      'See Expense History',
      name: 'seeExpenseHistory',
      desc: '',
      args: [],
    );
  }

  /// `Top 10 Recent Expenses`
  String get top10RecentExpenses {
    return Intl.message(
      'Top 10 Recent Expenses',
      name: 'top10RecentExpenses',
      desc: '',
      args: [],
    );
  }

  /// `Draft`
  String get draft {
    return Intl.message('Draft', name: 'draft', desc: '', args: []);
  }

  /// `Approved`
  String get approved {
    return Intl.message('Approved', name: 'approved', desc: '', args: []);
  }

  /// `Rejected`
  String get rejected {
    return Intl.message('Rejected', name: 'rejected', desc: '', args: []);
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Manage, Sort and view details of expenses`
  String get manageSortAndViewDetailsOfExpenses {
    return Intl.message(
      'Manage, Sort and view details of expenses',
      name: 'manageSortAndViewDetailsOfExpenses',
      desc: '',
      args: [],
    );
  }

  /// `Expense History`
  String get expenseHistory {
    return Intl.message(
      'Expense History',
      name: 'expenseHistory',
      desc: '',
      args: [],
    );
  }

  /// `Invoice Expense`
  String get invoiceExpense {
    return Intl.message(
      'Invoice Expense',
      name: 'invoiceExpense',
      desc: '',
      args: [],
    );
  }

  /// `Cash Expense`
  String get cashExpense {
    return Intl.message(
      'Cash Expense',
      name: 'cashExpense',
      desc: '',
      args: [],
    );
  }

  /// `What kind of expense are you adding?`
  String get whatKindOfExpenseAreYouAdding {
    return Intl.message(
      'What kind of expense are you adding?',
      name: 'whatKindOfExpenseAreYouAdding',
      desc: '',
      args: [],
    );
  }

  /// `Add Expense`
  String get addExpense {
    return Intl.message('Add Expense', name: 'addExpense', desc: '', args: []);
  }

  /// `Add New Expense`
  String get addNewExpense {
    return Intl.message(
      'Add New Expense',
      name: 'addNewExpense',
      desc: '',
      args: [],
    );
  }

  /// `No expenses yet`
  String get noExpensesYet {
    return Intl.message(
      'No expenses yet',
      name: 'noExpensesYet',
      desc: '',
      args: [],
    );
  }

  /// `Start logging your spending and everything will appear here.`
  String get noExpensesYetDesc {
    return Intl.message(
      'Start logging your spending and everything will appear here.',
      name: 'noExpensesYetDesc',
      desc: '',
      args: [],
    );
  }

  /// `Nothing in Drafts`
  String get nothingInDrafts {
    return Intl.message(
      'Nothing in Drafts',
      name: 'nothingInDrafts',
      desc: '',
      args: [],
    );
  }

  /// `Save an expense as a draft if you’re not ready to submit.`
  String get nothingInDraftsDesc {
    return Intl.message(
      'Save an expense as a draft if you’re not ready to submit.',
      name: 'nothingInDraftsDesc',
      desc: '',
      args: [],
    );
  }

  /// `No quick cash expenses recorded`
  String get noQuickCashExpensesRecorded {
    return Intl.message(
      'No quick cash expenses recorded',
      name: 'noQuickCashExpensesRecorded',
      desc: '',
      args: [],
    );
  }

  /// `Submit one to track immediate out-of-pocket costs.`
  String get noQuickCashExpensesRecordedDesc {
    return Intl.message(
      'Submit one to track immediate out-of-pocket costs.',
      name: 'noQuickCashExpensesRecordedDesc',
      desc: '',
      args: [],
    );
  }

  /// `No single invoices uploaded. Add an invoice to see it listed here.`
  String get noSingleInvoicesDesc {
    return Intl.message(
      'No single invoices uploaded. Add an invoice to see it listed here.',
      name: 'noSingleInvoicesDesc',
      desc: '',
      args: [],
    );
  }

  /// `Grouped invoices will show up here once you upload multiple related invoices.`
  String get noGroupInvoicesDesc {
    return Intl.message(
      'Grouped invoices will show up here once you upload multiple related invoices.',
      name: 'noGroupInvoicesDesc',
      desc: '',
      args: [],
    );
  }

  /// `No pre-approval requests yet`
  String get noPreApprovalRequestsYet {
    return Intl.message(
      'No pre-approval requests yet',
      name: 'noPreApprovalRequestsYet',
      desc: '',
      args: [],
    );
  }

  /// `Create one before you spend to keep things compliant.`
  String get noPreApprovalRequestsYetDesc {
    return Intl.message(
      'Create one before you spend to keep things compliant.',
      name: 'noPreApprovalRequestsYetDesc',
      desc: '',
      args: [],
    );
  }

  /// `Select Month`
  String get selectMonth {
    return Intl.message(
      'Select Month',
      name: 'selectMonth',
      desc: '',
      args: [],
    );
  }

  /// `Select Year`
  String get selectYear {
    return Intl.message('Select Year', name: 'selectYear', desc: '', args: []);
  }

  /// `Filter expense list by:`
  String get filterExpenseListBy {
    return Intl.message(
      'Filter expense list by:',
      name: 'filterExpenseListBy',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message('Type', name: 'type', desc: '', args: []);
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `Sort by Date added`
  String get sortByDateAdded {
    return Intl.message(
      'Sort by Date added',
      name: 'sortByDateAdded',
      desc: '',
      args: [],
    );
  }

  /// `Last 24 hours`
  String get last24Hours {
    return Intl.message(
      'Last 24 hours',
      name: 'last24Hours',
      desc: '',
      args: [],
    );
  }

  /// `Last 7 days`
  String get last7Days {
    return Intl.message('Last 7 days', name: 'last7Days', desc: '', args: []);
  }

  /// `Last 30 days`
  String get last30Days {
    return Intl.message('Last 30 days', name: 'last30Days', desc: '', args: []);
  }

  /// `Default Settings`
  String get defaultSettings {
    return Intl.message(
      'Default Settings',
      name: 'defaultSettings',
      desc: '',
      args: [],
    );
  }

  /// `Show results`
  String get showResults {
    return Intl.message(
      'Show results',
      name: 'showResults',
      desc: '',
      args: [],
    );
  }

  /// `No Results`
  String get noResults {
    return Intl.message('No Results', name: 'noResults', desc: '', args: []);
  }

  /// `Please refine your search filter selections for improved results.`
  String get noResultsDesc {
    return Intl.message(
      'Please refine your search filter selections for improved results.',
      name: 'noResultsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Expense Date`
  String get expenseDate {
    return Intl.message(
      'Expense Date',
      name: 'expenseDate',
      desc: '',
      args: [],
    );
  }

  /// `Expense Title`
  String get expenseTitle {
    return Intl.message(
      'Expense Title',
      name: 'expenseTitle',
      desc: '',
      args: [],
    );
  }

  /// `e.g Taxi fare for supply run`
  String get expenseTitleHint {
    return Intl.message(
      'e.g Taxi fare for supply run',
      name: 'expenseTitleHint',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount`
  String get totalAmount {
    return Intl.message(
      'Total Amount',
      name: 'totalAmount',
      desc: '',
      args: [],
    );
  }

  /// `How much did you spend?`
  String get totalAmountHint {
    return Intl.message(
      'How much did you spend?',
      name: 'totalAmountHint',
      desc: '',
      args: [],
    );
  }

  /// `Add Item/Expense`
  String get addItemExpense {
    return Intl.message(
      'Add Item/Expense',
      name: 'addItemExpense',
      desc: '',
      args: [],
    );
  }

  /// `This Expense Includes VAT (15%)`
  String get thisExpenseIncludesVat {
    return Intl.message(
      'This Expense Includes VAT (15%)',
      name: 'thisExpenseIncludesVat',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Choose`
  String get choose {
    return Intl.message('Choose', name: 'choose', desc: '', args: []);
  }

  /// `Upload Expense/Invoice Receipt`
  String get uploadExpenseInvoiceReceipt {
    return Intl.message(
      'Upload Expense/Invoice Receipt',
      name: 'uploadExpenseInvoiceReceipt',
      desc: '',
      args: [],
    );
  }

  /// `View Summary`
  String get viewSummary {
    return Intl.message(
      'View Summary',
      name: 'viewSummary',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get calendar {
    return Intl.message('Calendar', name: 'calendar', desc: '', args: []);
  }

  /// `Choose when the expense occurred.`
  String get chooseWhenTheExpenseOccurred {
    return Intl.message(
      'Choose when the expense occurred.',
      name: 'chooseWhenTheExpenseOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Date`
  String get confirmDate {
    return Intl.message(
      'Confirm Date',
      name: 'confirmDate',
      desc: '',
      args: [],
    );
  }

  /// `How was this expense paid?`
  String get howWasThisExpensePaid {
    return Intl.message(
      'How was this expense paid?',
      name: 'howWasThisExpensePaid',
      desc: '',
      args: [],
    );
  }

  /// `Custody Balance`
  String get custodyBalance {
    return Intl.message(
      'Custody Balance',
      name: 'custodyBalance',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get balance {
    return Intl.message('Balance', name: 'balance', desc: '', args: []);
  }

  /// `Supplier Credit ({count})`
  String supplierCredit(int count) {
    return Intl.message(
      'Supplier Credit ($count)',
      name: 'supplierCredit',
      desc: 'Supplier Credit count',
      args: [count],
    );
  }

  /// `e.g Name example of a supplier`
  String get searchHint {
    return Intl.message(
      'e.g Name example of a supplier',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `Confirm selection`
  String get confirmSelection {
    return Intl.message(
      'Confirm selection',
      name: 'confirmSelection',
      desc: '',
      args: [],
    );
  }

  /// `Custody balance too low.`
  String get custodyBalanceTooLow {
    return Intl.message(
      'Custody balance too low.',
      name: 'custodyBalanceTooLow',
      desc: '',
      args: [],
    );
  }

  /// `Please select a different payment method.`
  String get pleaseSelectADifferentPaymentMethod {
    return Intl.message(
      'Please select a different payment method.',
      name: 'pleaseSelectADifferentPaymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `To increase your custody balance, you can complete a sales handover or request a cash advance.`
  String get increaseCustodyBalance {
    return Intl.message(
      'To increase your custody balance, you can complete a sales handover or request a cash advance.',
      name: 'increaseCustodyBalance',
      desc: '',
      args: [],
    );
  }

  /// `Cash`
  String get cash {
    return Intl.message('Cash', name: 'cash', desc: '', args: []);
  }

  /// `Supplier Credit/`
  String get supplierCredit2 {
    return Intl.message(
      'Supplier Credit/',
      name: 'supplierCredit2',
      desc: '',
      args: [],
    );
  }

  /// `KB`
  String get kB {
    return Intl.message('KB', name: 'kB', desc: '', args: []);
  }

  /// `MB`
  String get mB {
    return Intl.message('MB', name: 'mB', desc: '', args: []);
  }

  /// `Fill out the details below for the compensatory order request flow, based on the created variance.`
  String get fillOutCompensatoryOrderDetails {
    return Intl.message(
      'Fill out the details below for the compensatory order request flow, based on the created variance.',
      name: 'fillOutCompensatoryOrderDetails',
      desc: '',
      args: [],
    );
  }

  /// `Qty To Reorder`
  String get qtyToReorder {
    return Intl.message(
      'Qty To Reorder',
      name: 'qtyToReorder',
      desc: '',
      args: [],
    );
  }

  /// `Re-order Source`
  String get reorderSource {
    return Intl.message(
      'Re-order Source',
      name: 'reorderSource',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Urgency Deadline`
  String get deliveryUrgencyDeadline {
    return Intl.message(
      'Delivery Urgency Deadline',
      name: 'deliveryUrgencyDeadline',
      desc: '',
      args: [],
    );
  }

  /// `Attach Photo Evidence`
  String get attachPhotoEvidence {
    return Intl.message(
      'Attach Photo Evidence',
      name: 'attachPhotoEvidence',
      desc: '',
      args: [],
    );
  }

  /// `To proceed with a VAT expense, provide the invoice details by scanning or manual input.`
  String get vatDesc {
    return Intl.message(
      'To proceed with a VAT expense, provide the invoice details by scanning or manual input.',
      name: 'vatDesc',
      desc: '',
      args: [],
    );
  }

  /// `Manual Entry`
  String get manualEntry {
    return Intl.message(
      'Manual Entry',
      name: 'manualEntry',
      desc: '',
      args: [],
    );
  }

  /// `Scan Code`
  String get scanCode {
    return Intl.message('Scan Code', name: 'scanCode', desc: '', args: []);
  }

  /// `Invoice Number`
  String get invoiceNumber {
    return Intl.message(
      'Invoice Number',
      name: 'invoiceNumber',
      desc: '',
      args: [],
    );
  }

  /// `e.g INV-12345`
  String get invoiceNumberHint {
    return Intl.message(
      'e.g INV-12345',
      name: 'invoiceNumberHint',
      desc: '',
      args: [],
    );
  }

  /// `Net Amount`
  String get netAmount {
    return Intl.message('Net Amount', name: 'netAmount', desc: '', args: []);
  }

  /// `VAT Amount`
  String get vatAmount {
    return Intl.message('VAT Amount', name: 'vatAmount', desc: '', args: []);
  }

  /// `Total (Incl. VAT)`
  String get totalInclVat {
    return Intl.message(
      'Total (Incl. VAT)',
      name: 'totalInclVat',
      desc: '',
      args: [],
    );
  }

  /// `Selected`
  String get selected {
    return Intl.message('Selected', name: 'selected', desc: '', args: []);
  }

  /// `Photos`
  String get photos {
    return Intl.message('Photos', name: 'photos', desc: '', args: []);
  }

  /// `Files`
  String get files {
    return Intl.message('Files', name: 'files', desc: '', args: []);
  }

  /// `Confirm Selections`
  String get confirmSelections {
    return Intl.message(
      'Confirm Selections',
      name: 'confirmSelections',
      desc: '',
      args: [],
    );
  }

  /// `No PDF files found`
  String get noPdfFilesFound {
    return Intl.message(
      'No PDF files found',
      name: 'noPdfFilesFound',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `Unselect All`
  String get unselectAll {
    return Intl.message(
      'Unselect All',
      name: 'unselectAll',
      desc: '',
      args: [],
    );
  }

  /// `Selection`
  String get selection {
    return Intl.message('Selection', name: 'selection', desc: '', args: []);
  }

  /// `Item Title`
  String get itemTitle {
    return Intl.message('Item Title', name: 'itemTitle', desc: '', args: []);
  }

  /// `This Item’s Amount`
  String get thisItemAmount {
    return Intl.message(
      'This Item’s Amount',
      name: 'thisItemAmount',
      desc: '',
      args: [],
    );
  }

  /// `Camera Permission Required`
  String get cameraPermissionRequired {
    return Intl.message(
      'Camera Permission Required',
      name: 'cameraPermissionRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enable camera permission in settings to scan QR codes.`
  String get qrDesc {
    return Intl.message(
      'Please enable camera permission in settings to scan QR codes.',
      name: 'qrDesc',
      desc: '',
      args: [],
    );
  }

  /// `Open Settings`
  String get openSettings {
    return Intl.message(
      'Open Settings',
      name: 'openSettings',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Qr`
  String get invalidQr {
    return Intl.message('Invalid Qr', name: 'invalidQr', desc: '', args: []);
  }

  /// `Qr Data is Empty`
  String get qrDataIsEmpty {
    return Intl.message(
      'Qr Data is Empty',
      name: 'qrDataIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Amount exceeds the limit for quick expenses (≤ 500 SAR). Please reduce the amount or select a different expense type.`
  String get amount500Desc {
    return Intl.message(
      'Amount exceeds the limit for quick expenses (≤ 500 SAR). Please reduce the amount or select a different expense type.',
      name: 'amount500Desc',
      desc: '',
      args: [],
    );
  }

  /// `Expense Submitted Successfully`
  String get expenseSubmittedSuccessfully {
    return Intl.message(
      'Expense Submitted Successfully',
      name: 'expenseSubmittedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Your quick expense has been saved and added to your records.`
  String get expenseSubmittedSuccessfullyDesc1 {
    return Intl.message(
      'Your quick expense has been saved and added to your records.',
      name: 'expenseSubmittedSuccessfullyDesc1',
      desc: '',
      args: [],
    );
  }

  /// `You’ll be notified once it’s reviewed or approved.`
  String get expenseSubmittedSuccessfullyDesc2 {
    return Intl.message(
      'You’ll be notified once it’s reviewed or approved.',
      name: 'expenseSubmittedSuccessfullyDesc2',
      desc: '',
      args: [],
    );
  }

  /// `Review Expense Summary`
  String get reviewExpenseSummary {
    return Intl.message(
      'Review Expense Summary',
      name: 'reviewExpenseSummary',
      desc: '',
      args: [],
    );
  }

  /// `You can save this expense as a draft or submit now.`
  String get reviewExpenseSummaryDesc {
    return Intl.message(
      'You can save this expense as a draft or submit now.',
      name: 'reviewExpenseSummaryDesc',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message('Title', name: 'title', desc: '', args: []);
  }

  /// `Expense/Invoice Receipt`
  String get expenseInvoiceReceipt {
    return Intl.message(
      'Expense/Invoice Receipt',
      name: 'expenseInvoiceReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Submit expense`
  String get submitExpense {
    return Intl.message(
      'Submit expense',
      name: 'submitExpense',
      desc: '',
      args: [],
    );
  }

  /// `Save to draft`
  String get saveToDraft {
    return Intl.message(
      'Save to draft',
      name: 'saveToDraft',
      desc: '',
      args: [],
    );
  }

  /// `Expense Summary`
  String get expenseSummary {
    return Intl.message(
      'Expense Summary',
      name: 'expenseSummary',
      desc: '',
      args: [],
    );
  }

  /// `Back to dashboard`
  String get backToDashboard {
    return Intl.message(
      'Back to dashboard',
      name: 'backToDashboard',
      desc: '',
      args: [],
    );
  }

  /// `See Details`
  String get seeDetails {
    return Intl.message('See Details', name: 'seeDetails', desc: '', args: []);
  }

  /// `Details`
  String get details {
    return Intl.message('Details', name: 'details', desc: '', args: []);
  }

  /// `Items`
  String get items {
    return Intl.message('Items', name: 'items', desc: '', args: []);
  }

  /// `Payment`
  String get payment {
    return Intl.message('Payment', name: 'payment', desc: '', args: []);
  }

  /// `Summary`
  String get summary {
    return Intl.message('Summary', name: 'summary', desc: '', args: []);
  }

  /// `Invoice details`
  String get invoiceDetails {
    return Intl.message(
      'Invoice details',
      name: 'invoiceDetails',
      desc: '',
      args: [],
    );
  }

  /// `Fill in the required invoice information to proceed.`
  String get invoiceDetailsDesc {
    return Intl.message(
      'Fill in the required invoice information to proceed.',
      name: 'invoiceDetailsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Reuse Past Request`
  String get reusePastRequest {
    return Intl.message(
      'Reuse Past Request',
      name: 'reusePastRequest',
      desc: '',
      args: [],
    );
  }

  /// `Supplier`
  String get supplier {
    return Intl.message('Supplier', name: 'supplier', desc: '', args: []);
  }

  /// `Issue date`
  String get issueDate {
    return Intl.message('Issue date', name: 'issueDate', desc: '', args: []);
  }

  /// `When was this invoice issued`
  String get whenWasThisInvoiceIssued {
    return Intl.message(
      'When was this invoice issued',
      name: 'whenWasThisInvoiceIssued',
      desc: '',
      args: [],
    );
  }

  /// `Tax Invoice?`
  String get taxInvoice {
    return Intl.message('Tax Invoice?', name: 'taxInvoice', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Upload Invoice Receipt`
  String get uploadInvoiceReceipt {
    return Intl.message(
      'Upload Invoice Receipt',
      name: 'uploadInvoiceReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Past Request`
  String get pastRequest {
    return Intl.message(
      'Past Request',
      name: 'pastRequest',
      desc: '',
      args: [],
    );
  }

  /// `Choose from your past Single Invoices to quickly reuse items, descriptions, and attached notes.`
  String get pastRequestDesc {
    return Intl.message(
      'Choose from your past Single Invoices to quickly reuse items, descriptions, and attached notes.',
      name: 'pastRequestDesc',
      desc: '',
      args: [],
    );
  }

  /// `Search for pre-approval requests`
  String get searchForPreApprovalRequests {
    return Intl.message(
      'Search for pre-approval requests',
      name: 'searchForPreApprovalRequests',
      desc: '',
      args: [],
    );
  }

  /// `Supplier List`
  String get supplierList {
    return Intl.message(
      'Supplier List',
      name: 'supplierList',
      desc: '',
      args: [],
    );
  }

  /// `Select the supplier associated with this invoice from the store data:`
  String get supplierListDesc {
    return Intl.message(
      'Select the supplier associated with this invoice from the store data:',
      name: 'supplierListDesc',
      desc: '',
      args: [],
    );
  }

  /// `Tax ID e.g 1234567890`
  String get taxIdHint {
    return Intl.message(
      'Tax ID e.g 1234567890',
      name: 'taxIdHint',
      desc: '',
      args: [],
    );
  }

  /// `Supplier's name`
  String get supplierName {
    return Intl.message(
      'Supplier\'s name',
      name: 'supplierName',
      desc: '',
      args: [],
    );
  }

  /// `Save details`
  String get saveDetails {
    return Intl.message(
      'Save details',
      name: 'saveDetails',
      desc: '',
      args: [],
    );
  }

  /// `Permission Required`
  String get permissionRequired {
    return Intl.message(
      'Permission Required',
      name: 'permissionRequired',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get tryAgain {
    return Intl.message('Try Again', name: 'tryAgain', desc: '', args: []);
  }

  /// `Invoice Items`
  String get invoiceItems {
    return Intl.message(
      'Invoice Items',
      name: 'invoiceItems',
      desc: '',
      args: [],
    );
  }

  /// `List the items or services on this invoice.`
  String get invoiceItemsDesc {
    return Intl.message(
      'List the items or services on this invoice.',
      name: 'invoiceItemsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Select the payment method used for this invoice.`
  String get selectPaymentMethodDesc {
    return Intl.message(
      'Select the payment method used for this invoice.',
      name: 'selectPaymentMethodDesc',
      desc: '',
      args: [],
    );
  }

  /// `Select Date`
  String get selectDate {
    return Intl.message('Select Date', name: 'selectDate', desc: '', args: []);
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Purchases`
  String get purchases {
    return Intl.message('Purchases', name: 'purchases', desc: '', args: []);
  }

  /// `Qty`
  String get qty {
    return Intl.message('Qty', name: 'qty', desc: '', args: []);
  }

  /// `Unit Price`
  String get unitPrice {
    return Intl.message('Unit Price', name: 'unitPrice', desc: '', args: []);
  }

  /// `Unit`
  String get unit {
    return Intl.message('Unit', name: 'unit', desc: '', args: []);
  }

  /// `Category`
  String get category {
    return Intl.message('Category', name: 'category', desc: '', args: []);
  }

  /// `Add Item`
  String get addItem {
    return Intl.message('Add Item', name: 'addItem', desc: '', args: []);
  }

  /// `Show Sub-Category`
  String get showSubCategory {
    return Intl.message(
      'Show Sub-Category',
      name: 'showSubCategory',
      desc: '',
      args: [],
    );
  }

  /// `Item List`
  String get itemList {
    return Intl.message('Item List', name: 'itemList', desc: '', args: []);
  }

  /// `Choose from the items listed below.`
  String get itemListDesc {
    return Intl.message(
      'Choose from the items listed below.',
      name: 'itemListDesc',
      desc: '',
      args: [],
    );
  }

  /// `Search for items by name`
  String get searchForItemsByName {
    return Intl.message(
      'Search for items by name',
      name: 'searchForItemsByName',
      desc: '',
      args: [],
    );
  }

  /// `Item`
  String get item {
    return Intl.message('Item', name: 'item', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Full`
  String get full {
    return Intl.message('Full', name: 'full', desc: '', args: []);
  }

  /// `Partial`
  String get partial {
    return Intl.message('Partial', name: 'partial', desc: '', args: []);
  }

  /// `Deferred`
  String get deferred {
    return Intl.message('Deferred', name: 'deferred', desc: '', args: []);
  }

  /// `Amount`
  String get amount {
    return Intl.message('Amount', name: 'amount', desc: '', args: []);
  }

  /// `Amount Paid Now`
  String get amountPaidNow {
    return Intl.message(
      'Amount Paid Now',
      name: 'amountPaidNow',
      desc: '',
      args: [],
    );
  }

  /// `Amount paid via Cash or Custody`
  String get amountPaidViaCashOrCustody {
    return Intl.message(
      'Amount paid via Cash or Custody',
      name: 'amountPaidViaCashOrCustody',
      desc: '',
      args: [],
    );
  }

  /// `Total Invoice Amount`
  String get totalInvoiceAmount {
    return Intl.message(
      'Total Invoice Amount',
      name: 'totalInvoiceAmount',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method for Paid Amount`
  String get paymentMethodForPaidAmount {
    return Intl.message(
      'Payment Method for Paid Amount',
      name: 'paymentMethodForPaidAmount',
      desc: '',
      args: [],
    );
  }

  /// `Remaining Balance (Auto-calculated)`
  String get remainingBalanceAutoCalculated {
    return Intl.message(
      'Remaining Balance (Auto-calculated)',
      name: 'remainingBalanceAutoCalculated',
      desc: '',
      args: [],
    );
  }

  /// `Due Date for Credit Balance`
  String get dueDateForCreditBalance {
    return Intl.message(
      'Due Date for Credit Balance',
      name: 'dueDateForCreditBalance',
      desc: '',
      args: [],
    );
  }

  /// `When is the remaining balance expected to be paid?`
  String get whenIsTheRemainingBalanceExpectedToBePaid {
    return Intl.message(
      'When is the remaining balance expected to be paid?',
      name: 'whenIsTheRemainingBalanceExpectedToBePaid',
      desc: '',
      args: [],
    );
  }

  /// `This invoice will be paid later. The entire amount is marked as Supplier Credit.`
  String get deferredPaymentDesc {
    return Intl.message(
      'This invoice will be paid later. The entire amount is marked as Supplier Credit.',
      name: 'deferredPaymentDesc',
      desc: '',
      args: [],
    );
  }

  /// `Submit Invoice`
  String get submitInvoice {
    return Intl.message(
      'Submit Invoice',
      name: 'submitInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Review Invoice Summary`
  String get reviewInvoiceSummary {
    return Intl.message(
      'Review Invoice Summary',
      name: 'reviewInvoiceSummary',
      desc: '',
      args: [],
    );
  }

  /// `You can save this invoice as a draft or submit now.`
  String get reviewInvoiceSummaryDesc {
    return Intl.message(
      'You can save this invoice as a draft or submit now.',
      name: 'reviewInvoiceSummaryDesc',
      desc: '',
      args: [],
    );
  }

  /// `Tax ID`
  String get taxId {
    return Intl.message('Tax ID', name: 'taxId', desc: '', args: []);
  }

  /// `Total Invoice Items`
  String get totalInvoiceItems {
    return Intl.message(
      'Total Invoice Items',
      name: 'totalInvoiceItems',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount Paid`
  String get totalAmountPaid {
    return Intl.message(
      'Total Amount Paid',
      name: 'totalAmountPaid',
      desc: '',
      args: [],
    );
  }

  /// `Add, Edit & Delete Item Sub-Categories`
  String get addEditDeleteItemExpenses {
    return Intl.message(
      'Add, Edit & Delete Item Sub-Categories',
      name: 'addEditDeleteItemExpenses',
      desc: '',
      args: [],
    );
  }

  /// `Edit this Item List\n& Sub-category details below`
  String get editItemListAndSubCategoryDetails {
    return Intl.message(
      'Edit this Item List\n& Sub-category details below',
      name: 'editItemListAndSubCategoryDetails',
      desc: '',
      args: [],
    );
  }

  /// `Item Sub-Categories`
  String get itemSubCategories {
    return Intl.message(
      'Item Sub-Categories',
      name: 'itemSubCategories',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `{count} Shifts Daily`
  String shiftCountsDaily(int count) {
    return Intl.message(
      '$count Shifts Daily',
      name: 'shiftCountsDaily',
      desc: 'Displays shifts\' count',
      args: [count],
    );
  }

  /// `Search for cashiers by name`
  String get searchByCashierName {
    return Intl.message(
      'Search for cashiers by name',
      name: 'searchByCashierName',
      desc: '',
      args: [],
    );
  }

  /// `Filter cashier list by:`
  String get filterCashierListBy {
    return Intl.message(
      'Filter cashier list by:',
      name: 'filterCashierListBy',
      desc: '',
      args: [],
    );
  }

  /// `Date Added`
  String get dateAdded {
    return Intl.message('Date Added', name: 'dateAdded', desc: '', args: []);
  }

  /// `Account Status`
  String get accountStatus {
    return Intl.message(
      'Account Status',
      name: 'accountStatus',
      desc: '',
      args: [],
    );
  }

  /// `Server Error!!!`
  String get server_error {
    return Intl.message(
      'Server Error!!!',
      name: 'server_error',
      desc: '',
      args: [],
    );
  }

  /// `Oops! The server had a problem. Tap refresh to try again.`
  String get server_error_desc {
    return Intl.message(
      'Oops! The server had a problem. Tap refresh to try again.',
      name: 'server_error_desc',
      desc: '',
      args: [],
    );
  }

  /// `You are not authorized to perform this action. Please log in again.`
  String get unauthorized_error_desc {
    return Intl.message(
      'You are not authorized to perform this action. Please log in again.',
      name: 'unauthorized_error_desc',
      desc: '',
      args: [],
    );
  }

  /// `info`
  String get info {
    return Intl.message('info', name: 'info', desc: '', args: []);
  }

  /// `Working Shift`
  String get workingShift {
    return Intl.message(
      'Working Shift',
      name: 'workingShift',
      desc: '',
      args: [],
    );
  }

  /// `Add Cashier`
  String get addCashier {
    return Intl.message('Add Cashier', name: 'addCashier', desc: '', args: []);
  }

  /// `Deleting this sub-category will permanently remove it from the system.`
  String get deleteSubCategoryWarning {
    return Intl.message(
      'Deleting this sub-category will permanently remove it from the system.',
      name: 'deleteSubCategoryWarning',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to proceed?`
  String get areYouSureYouWantToProceed {
    return Intl.message(
      'Are you sure you want to proceed?',
      name: 'areYouSureYouWantToProceed',
      desc: '',
      args: [],
    );
  }

  /// `Delete Forever`
  String get deleteForever {
    return Intl.message(
      'Delete Forever',
      name: 'deleteForever',
      desc: '',
      args: [],
    );
  }

  /// `Submit an expense request requiring prior administrative approval`
  String get submitAnExpenseRequestRequiringPriorAdministrativeApproval {
    return Intl.message(
      'Submit an expense request requiring prior administrative approval',
      name: 'submitAnExpenseRequestRequiringPriorAdministrativeApproval',
      desc: '',
      args: [],
    );
  }

  /// `Describe what this request is for`
  String get describeWhatThisRequestIsFor {
    return Intl.message(
      'Describe what this request is for',
      name: 'describeWhatThisRequestIsFor',
      desc: '',
      args: [],
    );
  }

  /// `Purpose`
  String get purpose {
    return Intl.message('Purpose', name: 'purpose', desc: '', args: []);
  }

  /// `Estimated Amount`
  String get estimatedAmount {
    return Intl.message(
      'Estimated Amount',
      name: 'estimatedAmount',
      desc: '',
      args: [],
    );
  }

  /// `How much will this expense cost?`
  String get howMuchWillThisExpenseCost {
    return Intl.message(
      'How much will this expense cost?',
      name: 'howMuchWillThisExpenseCost',
      desc: '',
      args: [],
    );
  }

  /// `Priority`
  String get priority {
    return Intl.message('Priority', name: 'priority', desc: '', args: []);
  }

  /// `Low`
  String get low {
    return Intl.message('Low', name: 'low', desc: '', args: []);
  }

  /// `Medium`
  String get medium {
    return Intl.message('Medium', name: 'medium', desc: '', args: []);
  }

  /// `High`
  String get high {
    return Intl.message('High', name: 'high', desc: '', args: []);
  }

  /// `Cashier’s Store Branch`
  String get cashierStoreBranch {
    return Intl.message(
      'Cashier’s Store Branch',
      name: 'cashierStoreBranch',
      desc: '',
      args: [],
    );
  }

  /// `The location this cashier will be assigned to and work from. All shifts, sales, and reports are tracked under selected store.`
  String get cashierStoreBranchDesc {
    return Intl.message(
      'The location this cashier will be assigned to and work from. All shifts, sales, and reports are tracked under selected store.',
      name: 'cashierStoreBranchDesc',
      desc: '',
      args: [],
    );
  }

  /// `Choose Employee’s Shift`
  String get chooseEmplyeeShift {
    return Intl.message(
      'Choose Employee’s Shift',
      name: 'chooseEmplyeeShift',
      desc: '',
      args: [],
    );
  }

  /// `The assigned workdays and hours for this branch {BranchName} are listed below:`
  String chooseEmplyeeShiftDesc(String BranchName) {
    return Intl.message(
      'The assigned workdays and hours for this branch $BranchName are listed below:',
      name: 'chooseEmplyeeShiftDesc',
      desc: 'Displays shifts',
      args: [BranchName],
    );
  }

  /// `Work Hours {fromTime} - {toTime}`
  String workHoursFrom_t0(String fromTime, String toTime) {
    return Intl.message(
      'Work Hours $fromTime - $toTime',
      name: 'workHoursFrom_t0',
      desc: 'Displays shifts',
      args: [fromTime, toTime],
    );
  }

  /// `Shift assigned to another cashier`
  String get shiftAssignedToAnotherCashier {
    return Intl.message(
      'Shift assigned to another cashier',
      name: 'shiftAssignedToAnotherCashier',
      desc: '',
      args: [],
    );
  }

  /// `Review Before You Proceed`
  String get reviewBeforeProceed {
    return Intl.message(
      'Review Before You Proceed',
      name: 'reviewBeforeProceed',
      desc: '',
      args: [],
    );
  }

  /// `Please cross-check all account details before continuing. Once created, the employee will be assigned to the selected store and shift`
  String get reviewBeforeProceedDesc {
    return Intl.message(
      'Please cross-check all account details before continuing. Once created, the employee will be assigned to the selected store and shift',
      name: 'reviewBeforeProceedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Make sure all shift details are correct before reassigning to another employee. This action can’t be undone.`
  String get reviewBeforeProceedReassignDesc {
    return Intl.message(
      'Make sure all shift details are correct before reassigning to another employee. This action can’t be undone.',
      name: 'reviewBeforeProceedReassignDesc',
      desc: '',
      args: [],
    );
  }

  /// `Account Details`
  String get accountDetails {
    return Intl.message(
      'Account Details',
      name: 'accountDetails',
      desc: '',
      args: [],
    );
  }

  /// `Shift Details`
  String get shiftDetails {
    return Intl.message(
      'Shift Details',
      name: 'shiftDetails',
      desc: '',
      args: [],
    );
  }

  /// `Employee Name:`
  String get employeeNameTitle {
    return Intl.message(
      'Employee Name:',
      name: 'employeeNameTitle',
      desc: '',
      args: [],
    );
  }

  /// `Email:`
  String get emailTitle {
    return Intl.message('Email:', name: 'emailTitle', desc: '', args: []);
  }

  /// `Role:`
  String get roleTitle {
    return Intl.message('Role:', name: 'roleTitle', desc: '', args: []);
  }

  /// `Store Branch:`
  String get storeBranch {
    return Intl.message(
      'Store Branch:',
      name: 'storeBranch',
      desc: '',
      args: [],
    );
  }

  /// `Work Days:`
  String get workDays {
    return Intl.message('Work Days:', name: 'workDays', desc: '', args: []);
  }

  /// `Shift:`
  String get shiftTitle {
    return Intl.message('Shift:', name: 'shiftTitle', desc: '', args: []);
  }

  /// `Account Created`
  String get accountCreated {
    return Intl.message(
      'Account Created',
      name: 'accountCreated',
      desc: '',
      args: [],
    );
  }

  /// `An account activation link has been sent to the employee's email `
  String get accountCreatedDesc_before {
    return Intl.message(
      'An account activation link has been sent to the employee\'s email ',
      name: 'accountCreatedDesc_before',
      desc: '',
      args: [],
    );
  }

  /// ` They will be able to start once they activate their account.`
  String get accountCreatedDesc_after {
    return Intl.message(
      ' They will be able to start once they activate their account.',
      name: 'accountCreatedDesc_after',
      desc: '',
      args: [],
    );
  }

  /// `Back to Cashier List`
  String get backToCashierList {
    return Intl.message(
      'Back to Cashier List',
      name: 'backToCashierList',
      desc: '',
      args: [],
    );
  }

  /// `No suppliers found`
  String get noSuppliersFound {
    return Intl.message(
      'No suppliers found',
      name: 'noSuppliersFound',
      desc: '',
      args: [],
    );
  }

  /// `Items amount must be equal to total amount`
  String get itemsAmountMustBeEqualToTotalAmount {
    return Intl.message(
      'Items amount must be equal to total amount',
      name: 'itemsAmountMustBeEqualToTotalAmount',
      desc: '',
      args: [],
    );
  }

  /// `No sub-categories found`
  String get noSubCategories {
    return Intl.message(
      'No sub-categories found',
      name: 'noSubCategories',
      desc: '',
      args: [],
    );
  }

  /// `Entered amount exceeds total invoice amount or less than one`
  String get enteredAmountExceedsTotalInvoiceAmountOrLessThanOne {
    return Intl.message(
      'Entered amount exceeds total invoice amount or less than one',
      name: 'enteredAmountExceedsTotalInvoiceAmountOrLessThanOne',
      desc: '',
      args: [],
    );
  }

  /// `Expense Details`
  String get expenseDetails {
    return Intl.message(
      'Expense Details',
      name: 'expenseDetails',
      desc: '',
      args: [],
    );
  }

  /// `View every action and update made to this expense, from creation to final approval.`
  String get expenseDetailsDesc {
    return Intl.message(
      'View every action and update made to this expense, from creation to final approval.',
      name: 'expenseDetailsDesc',
      desc: '',
      args: [],
    );
  }

  /// `You saved this expense to draft on:`
  String get youSavedThisExpenseToDraftOn {
    return Intl.message(
      'You saved this expense to draft on:',
      name: 'youSavedThisExpenseToDraftOn',
      desc: '',
      args: [],
    );
  }

  /// `Continue editing`
  String get continueEditing {
    return Intl.message(
      'Continue editing',
      name: 'continueEditing',
      desc: '',
      args: [],
    );
  }

  /// `Delete Invoice Draft?`
  String get deleteInvoiceDraft {
    return Intl.message(
      'Delete Invoice Draft?',
      name: 'deleteInvoiceDraft',
      desc: '',
      args: [],
    );
  }

  /// `This action is permanent and cannot be undone.`
  String get thisActionIsPermanentAndCannotBeUndone {
    return Intl.message(
      'This action is permanent and cannot be undone.',
      name: 'thisActionIsPermanentAndCannotBeUndone',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this draft?`
  String get areYouSureYouWantToDeleteThisDraft {
    return Intl.message(
      'Are you sure you want to delete this draft?',
      name: 'areYouSureYouWantToDeleteThisDraft',
      desc: '',
      args: [],
    );
  }

  /// `View details, timelines, and statuses.`
  String get viewDetailsTimelinesAndStatuses {
    return Intl.message(
      'View details, timelines, and statuses.',
      name: 'viewDetailsTimelinesAndStatuses',
      desc: '',
      args: [],
    );
  }

  /// `Timelines`
  String get timelines {
    return Intl.message('Timelines', name: 'timelines', desc: '', args: []);
  }

  /// `Approval`
  String get approval {
    return Intl.message('Approval', name: 'approval', desc: '', args: []);
  }

  /// `Your expense requires approval from one of the following individuals. Only one approval is needed to proceed.`
  String get approvalDesc {
    return Intl.message(
      'Your expense requires approval from one of the following individuals. Only one approval is needed to proceed.',
      name: 'approvalDesc',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending_name {
    return Intl.message('Pending', name: 'pending_name', desc: '', args: []);
  }

  /// `No Pending Cashiers`
  String get no_pending_cashiers_title {
    return Intl.message(
      'No Pending Cashiers',
      name: 'no_pending_cashiers_title',
      desc: '',
      args: [],
    );
  }

  /// `{CashierName} has no pending shifts.`
  String no_pending_cashiers_desc(String CashierName) {
    return Intl.message(
      '$CashierName has no pending shifts.',
      name: 'no_pending_cashiers_desc',
      desc: 'Desc',
      args: [CashierName],
    );
  }

  /// `Completed`
  String get completed_name {
    return Intl.message(
      'Completed',
      name: 'completed_name',
      desc: '',
      args: [],
    );
  }

  /// `No Completed shift`
  String get completed_cashiers_title {
    return Intl.message(
      'No Completed shift',
      name: 'completed_cashiers_title',
      desc: '',
      args: [],
    );
  }

  /// `{CashierName} has not completed any shift yet.`
  String completed_cashiers_desc(String CashierName) {
    return Intl.message(
      '$CashierName has not completed any shift yet.',
      name: 'completed_cashiers_desc',
      desc: 'Desc',
      args: [CashierName],
    );
  }

  /// `In Progress`
  String get in_progress_name {
    return Intl.message(
      'In Progress',
      name: 'in_progress_name',
      desc: '',
      args: [],
    );
  }

  /// `No shifts are in progress`
  String get no_inProgress_cashiers_title {
    return Intl.message(
      'No shifts are in progress',
      name: 'no_inProgress_cashiers_title',
      desc: '',
      args: [],
    );
  }

  /// `{CashierName} has not started any shift yet. Check “Pending” to see a list of upcoming shifts`
  String no_inProgress_cashiers_desc(String CashierName) {
    return Intl.message(
      '$CashierName has not started any shift yet. Check “Pending” to see a list of upcoming shifts',
      name: 'no_inProgress_cashiers_desc',
      desc: 'Desc',
      args: [CashierName],
    );
  }

  /// `Reassigned`
  String get reassigned_name {
    return Intl.message(
      'Reassigned',
      name: 'reassigned_name',
      desc: '',
      args: [],
    );
  }

  /// `No Reassigned shift`
  String get reassigned_cashiers_title {
    return Intl.message(
      'No Reassigned shift',
      name: 'reassigned_cashiers_title',
      desc: '',
      args: [],
    );
  }

  /// `You have not reassigned any shifts to {CashierName}`
  String reassigned_cashiers_desc(String CashierName) {
    return Intl.message(
      'You have not reassigned any shifts to $CashierName',
      name: 'reassigned_cashiers_desc',
      desc: 'Desc',
      args: [CashierName],
    );
  }

  /// `Deactivated`
  String get deactivated {
    return Intl.message('Deactivated', name: 'deactivated', desc: '', args: []);
  }

  /// `Active`
  String get active {
    return Intl.message('Active', name: 'active', desc: '', args: []);
  }

  /// `Select Branch`
  String get selectBranch {
    return Intl.message(
      'Select Branch',
      name: 'selectBranch',
      desc: '',
      args: [],
    );
  }

  /// `Last 24 Hours`
  String get dateFilterLast24Hours {
    return Intl.message(
      'Last 24 Hours',
      name: 'dateFilterLast24Hours',
      desc: '',
      args: [],
    );
  }

  /// `Last 7 Days`
  String get dateFilterLast7Days {
    return Intl.message(
      'Last 7 Days',
      name: 'dateFilterLast7Days',
      desc: '',
      args: [],
    );
  }

  /// `Last 14 Days`
  String get dateFilterLast14Days {
    return Intl.message(
      'Last 14 Days',
      name: 'dateFilterLast14Days',
      desc: '',
      args: [],
    );
  }

  /// `Last 30 Days`
  String get dateFilterLast30Days {
    return Intl.message(
      'Last 30 Days',
      name: 'dateFilterLast30Days',
      desc: '',
      args: [],
    );
  }

  /// `Last 1 Year`
  String get dateFilterLast1Year {
    return Intl.message(
      'Last 1 Year',
      name: 'dateFilterLast1Year',
      desc: '',
      args: [],
    );
  }

  /// `Custom Range`
  String get dateFilterCustomRange {
    return Intl.message(
      'Custom Range',
      name: 'dateFilterCustomRange',
      desc: '',
      args: [],
    );
  }

  /// `Review Request Summary`
  String get reviewRequestSummary {
    return Intl.message(
      'Review Request Summary',
      name: 'reviewRequestSummary',
      desc: '',
      args: [],
    );
  }

  /// `Request Summary`
  String get requestSummary {
    return Intl.message(
      'Request Summary',
      name: 'requestSummary',
      desc: '',
      args: [],
    );
  }

  /// `You can save this request as a draft or submit now.`
  String get requestSummaryDesc {
    return Intl.message(
      'You can save this request as a draft or submit now.',
      name: 'requestSummaryDesc',
      desc: '',
      args: [],
    );
  }

  /// `Attachment`
  String get attachment {
    return Intl.message('Attachment', name: 'attachment', desc: '', args: []);
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Rate`
  String get rate {
    return Intl.message('Rate', name: 'rate', desc: '', args: []);
  }

  /// `Expense List`
  String get expenseList {
    return Intl.message(
      'Expense List',
      name: 'expenseList',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message('Price', name: 'price', desc: '', args: []);
  }

  /// `Default Supplier`
  String get defaultSupplier {
    return Intl.message(
      'Default Supplier',
      name: 'defaultSupplier',
      desc: '',
      args: [],
    );
  }

  /// `Select a supplier to be used by default for all invoices in this session. You can change it later for each invoice if needed.`
  String get defaultSupplierDesc {
    return Intl.message(
      'Select a supplier to be used by default for all invoices in this session. You can change it later for each invoice if needed.',
      name: 'defaultSupplierDesc',
      desc: '',
      args: [],
    );
  }

  /// `Default Payment Method`
  String get defaultPaymentMethod {
    return Intl.message(
      'Default Payment Method',
      name: 'defaultPaymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Choose the payment method that will be applied by default. You can still update it per invoice in the next step.`
  String get defaultPaymentMethodDesc {
    return Intl.message(
      'Choose the payment method that will be applied by default. You can still update it per invoice in the next step.',
      name: 'defaultPaymentMethodDesc',
      desc: '',
      args: [],
    );
  }

  /// `Session Setup`
  String get sessionSetup {
    return Intl.message(
      'Session Setup',
      name: 'sessionSetup',
      desc: '',
      args: [],
    );
  }

  /// `Invoices`
  String get invoices {
    return Intl.message('Invoices', name: 'invoices', desc: '', args: []);
  }

  /// `When is the invoice due for payment?`
  String get whenIsTheInvoiceDueForPayment {
    return Intl.message(
      'When is the invoice due for payment?',
      name: 'whenIsTheInvoiceDueForPayment',
      desc: '',
      args: [],
    );
  }

  /// `Add New Invoice Group`
  String get addNewInvoiceGroup {
    return Intl.message(
      'Add New Invoice Group',
      name: 'addNewInvoiceGroup',
      desc: '',
      args: [],
    );
  }

  /// `Total Invoice Summary`
  String get totalInvoiceSummary {
    return Intl.message(
      'Total Invoice Summary',
      name: 'totalInvoiceSummary',
      desc: '',
      args: [],
    );
  }

  /// `Total Grouped Invoice`
  String get totalGroupedInvoice {
    return Intl.message(
      'Total Grouped Invoice',
      name: 'totalGroupedInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Attachments`
  String get attachments {
    return Intl.message('Attachments', name: 'attachments', desc: '', args: []);
  }

  /// `Not yet recorded`
  String get not_recorded_yet {
    return Intl.message(
      'Not yet recorded',
      name: 'not_recorded_yet',
      desc: '',
      args: [],
    );
  }

  /// `Start time:`
  String get start_time {
    return Intl.message('Start time:', name: 'start_time', desc: '', args: []);
  }

  /// `End time:`
  String get end_time {
    return Intl.message('End time:', name: 'end_time', desc: '', args: []);
  }

  /// `End:`
  String get end {
    return Intl.message('End:', name: 'end', desc: '', args: []);
  }

  /// `Closing balance:`
  String get closing_balance {
    return Intl.message(
      'Closing balance:',
      name: 'closing_balance',
      desc: '',
      args: [],
    );
  }

  /// `Opening balance:`
  String get openingBalance {
    return Intl.message(
      'Opening balance:',
      name: 'openingBalance',
      desc: '',
      args: [],
    );
  }

  /// `Assigned to:`
  String get assigned_to {
    return Intl.message(
      'Assigned to:',
      name: 'assigned_to',
      desc: '',
      args: [],
    );
  }

  /// `Next Cashier:`
  String get next_cashier {
    return Intl.message(
      'Next Cashier:',
      name: 'next_cashier',
      desc: '',
      args: [],
    );
  }

  /// `Cash given:`
  String get cash_given {
    return Intl.message('Cash given:', name: 'cash_given', desc: '', args: []);
  }

  /// `Variance:`
  String get variance {
    return Intl.message('Variance:', name: 'variance', desc: '', args: []);
  }

  /// `Not Started`
  String get not_started {
    return Intl.message('Not Started', name: 'not_started', desc: '', args: []);
  }

  /// `End Shift`
  String get end_shift {
    return Intl.message('End Shift', name: 'end_shift', desc: '', args: []);
  }

  /// `Start Shift`
  String get start_shift {
    return Intl.message('Start Shift', name: 'start_shift', desc: '', args: []);
  }

  /// `Shift Reassigned To You`
  String get reassigned_to_u {
    return Intl.message(
      'Shift Reassigned To You',
      name: 'reassigned_to_u',
      desc: '',
      args: [],
    );
  }

  /// `This shift has been reassigned to another staff by you.`
  String get reassigned_by_u {
    return Intl.message(
      'This shift has been reassigned to another staff by you.',
      name: 'reassigned_by_u',
      desc: '',
      args: [],
    );
  }

  /// `This shift has been reassigned to another staff by {cashierName}`
  String reassigned_by_another_cashier(String cashierName) {
    return Intl.message(
      'This shift has been reassigned to another staff by $cashierName',
      name: 'reassigned_by_another_cashier',
      desc: 'Desc',
      args: [cashierName],
    );
  }

  /// `Reassigned From:`
  String get reassigned_from {
    return Intl.message(
      'Reassigned From:',
      name: 'reassigned_from',
      desc: '',
      args: [],
    );
  }

  /// `Reassigned To:`
  String get reassigned_to {
    return Intl.message(
      'Reassigned To:',
      name: 'reassigned_to',
      desc: '',
      args: [],
    );
  }

  /// `Reassigned By:`
  String get reassigned_by {
    return Intl.message(
      'Reassigned By:',
      name: 'reassigned_by',
      desc: '',
      args: [],
    );
  }

  /// `Assigned By:`
  String get assigned_by {
    return Intl.message(
      'Assigned By:',
      name: 'assigned_by',
      desc: '',
      args: [],
    );
  }

  /// `No Name`
  String get no_name {
    return Intl.message('No Name', name: 'no_name', desc: '', args: []);
  }

  /// `Upcoming Shift`
  String get upcomingShift {
    return Intl.message(
      'Upcoming Shift',
      name: 'upcomingShift',
      desc: '',
      args: [],
    );
  }

  /// `Starts in {hours}h`
  String hoursRemaining(int hours) {
    return Intl.message(
      'Starts in ${hours}h',
      name: 'hoursRemaining',
      desc: 'Desc',
      args: [hours],
    );
  }

  /// `Starts in {minutes}m`
  String minutesRemaining(int minutes) {
    return Intl.message(
      'Starts in ${minutes}m',
      name: 'minutesRemaining',
      desc: 'Desc',
      args: [minutes],
    );
  }

  /// `Cashier`
  String get cashier {
    return Intl.message('Cashier', name: 'cashier', desc: '', args: []);
  }

  /// `Cashier Profile`
  String get cashierProfile {
    return Intl.message(
      'Cashier Profile',
      name: 'cashierProfile',
      desc: '',
      args: [],
    );
  }

  /// `Quick access and quick information to links for managing this profile.`
  String get quickAccessToProfileInfo {
    return Intl.message(
      'Quick access and quick information to links for managing this profile.',
      name: 'quickAccessToProfileInfo',
      desc: '',
      args: [],
    );
  }

  /// `Sales & Handover`
  String get salesAndHandovers {
    return Intl.message(
      'Sales & Handover',
      name: 'salesAndHandovers',
      desc: '',
      args: [],
    );
  }

  /// `Reassign Shift`
  String get reassign_shift {
    return Intl.message(
      'Reassign Shift',
      name: 'reassign_shift',
      desc: '',
      args: [],
    );
  }

  /// `{cashierName}'s Shift Details`
  String cashierShiftDetails(String cashierName) {
    return Intl.message(
      '$cashierName\'s Shift Details',
      name: 'cashierShiftDetails',
      desc: 'Desc',
      args: [cashierName],
    );
  }

  /// `Opening Balance`
  String get openingBalanceTitle {
    return Intl.message(
      'Opening Balance',
      name: 'openingBalanceTitle',
      desc: '',
      args: [],
    );
  }

  /// `Monitor the total hours worked and the remaining hours until the shift concludes.`
  String get totalHoursDesc {
    return Intl.message(
      'Monitor the total hours worked and the remaining hours until the shift concludes.',
      name: 'totalHoursDesc',
      desc: '',
      args: [],
    );
  }

  /// `Shift progress`
  String get shiftProgress {
    return Intl.message(
      'Shift progress',
      name: 'shiftProgress',
      desc: '',
      args: [],
    );
  }

  /// `Total sales`
  String get totalSales {
    return Intl.message('Total sales', name: 'totalSales', desc: '', args: []);
  }

  /// `Delivery Apps`
  String get deliveryApps {
    return Intl.message(
      'Delivery Apps',
      name: 'deliveryApps',
      desc: '',
      args: [],
    );
  }

  /// `Card Payment`
  String get cardPayment {
    return Intl.message(
      'Card Payment',
      name: 'cardPayment',
      desc: '',
      args: [],
    );
  }

  /// `Cash Collected`
  String get cashCollected {
    return Intl.message(
      'Cash Collected',
      name: 'cashCollected',
      desc: '',
      args: [],
    );
  }

  /// `Handover`
  String get handover {
    return Intl.message('Handover', name: 'handover', desc: '', args: []);
  }

  /// `Hand Over To`
  String get handoverTo {
    return Intl.message('Hand Over To', name: 'handoverTo', desc: '', args: []);
  }

  /// `Cash Handover Amount`
  String get cashHandoverAmount {
    return Intl.message(
      'Cash Handover Amount',
      name: 'cashHandoverAmount',
      desc: '',
      args: [],
    );
  }

  /// `Enter the amount of cash you are handing over to the next cashier.`
  String get cashHandoverAmountDesc {
    return Intl.message(
      'Enter the amount of cash you are handing over to the next cashier.',
      name: 'cashHandoverAmountDesc',
      desc: '',
      args: [],
    );
  }

  /// `Pending Approval`
  String get pendingApproval {
    return Intl.message(
      'Pending Approval',
      name: 'pendingApproval',
      desc: '',
      args: [],
    );
  }

  /// `Handover accepted by {cashierName} on: {dateAndTime}`
  String handoverAcceptedDesc(String cashierName, String dateAndTime) {
    return Intl.message(
      'Handover accepted by $cashierName on: $dateAndTime',
      name: 'handoverAcceptedDesc',
      desc: 'Desc',
      args: [cashierName, dateAndTime],
    );
  }

  /// `Rejected by {cashierName}. This issue has been escalated and is now waiting for your review and final decision.`
  String handoverRejectedDesc(String cashierName) {
    return Intl.message(
      'Rejected by $cashierName. This issue has been escalated and is now waiting for your review and final decision.',
      name: 'handoverRejectedDesc',
      desc: 'Desc',
      args: [cashierName],
    );
  }

  /// `Waiting for approval from {cashierName}.`
  String handoverPendingDesc(String cashierName) {
    return Intl.message(
      'Waiting for approval from $cashierName.',
      name: 'handoverPendingDesc',
      desc: 'Desc',
      args: [cashierName],
    );
  }

  /// `Shift Completed`
  String get shiftCompleted {
    return Intl.message(
      'Shift Completed',
      name: 'shiftCompleted',
      desc: '',
      args: [],
    );
  }

  /// `How would you like to proceed?`
  String get endShiftOptionDesc {
    return Intl.message(
      'How would you like to proceed?',
      name: 'endShiftOptionDesc',
      desc: '',
      args: [],
    );
  }

  /// `End Shift & Handover`
  String get endShiftAndHandover {
    return Intl.message(
      'End Shift & Handover',
      name: 'endShiftAndHandover',
      desc: '',
      args: [],
    );
  }

  /// `Close your shift and hand over the cash now. The next person will receive this as their opening balance.`
  String get endShiftAndHandoverDesc {
    return Intl.message(
      'Close your shift and hand over the cash now. The next person will receive this as their opening balance.',
      name: 'endShiftAndHandoverDesc',
      desc: '',
      args: [],
    );
  }

  /// `End Shift Only`
  String get endShiftOnly {
    return Intl.message(
      'End Shift Only',
      name: 'endShiftOnly',
      desc: '',
      args: [],
    );
  }

  /// `Record sales and close your shift.\nYou’ll hand over the cash later.`
  String get endShiftOnlyDesc {
    return Intl.message(
      'Record sales and close your shift.\nYou’ll hand over the cash later.',
      name: 'endShiftOnlyDesc',
      desc: '',
      args: [],
    );
  }

  /// `Procced`
  String get procced {
    return Intl.message('Procced', name: 'procced', desc: '', args: []);
  }

  /// `New Shift Details`
  String get newShiftDetails {
    return Intl.message(
      'New Shift Details',
      name: 'newShiftDetails',
      desc: '',
      args: [],
    );
  }

  /// `Previous Cashier:`
  String get previousCasherTitle {
    return Intl.message(
      'Previous Cashier:',
      name: 'previousCasherTitle',
      desc: '',
      args: [],
    );
  }

  /// `New Cashier:`
  String get newCasherTitle {
    return Intl.message(
      'New Cashier:',
      name: 'newCasherTitle',
      desc: '',
      args: [],
    );
  }

  /// `Shift Date:`
  String get shiftDateTitle {
    return Intl.message(
      'Shift Date:',
      name: 'shiftDateTitle',
      desc: '',
      args: [],
    );
  }

  /// `Optional`
  String get optional {
    return Intl.message('Optional', name: 'optional', desc: '', args: []);
  }

  /// `Reason For Reassignment:`
  String get reasonforReassign {
    return Intl.message(
      'Reason For Reassignment:',
      name: 'reasonforReassign',
      desc: '',
      args: [],
    );
  }

  /// `Who will take over this shift`
  String get whoWillTakeTheShift {
    return Intl.message(
      'Who will take over this shift',
      name: 'whoWillTakeTheShift',
      desc: '',
      args: [],
    );
  }

  /// `Select an employee to take over this shift.`
  String get selectEmployeetoTakeTheShift {
    return Intl.message(
      'Select an employee to take over this shift.',
      name: 'selectEmployeetoTakeTheShift',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm availability before reassigning.`
  String get confirmAvailabilityBeforeReassigning {
    return Intl.message(
      'Please confirm availability before reassigning.',
      name: 'confirmAvailabilityBeforeReassigning',
      desc: '',
      args: [],
    );
  }

  /// `This action is irreversible — the selected person won’t be able to reject or reassign the shift again.`
  String get theActionIsIrreversible {
    return Intl.message(
      'This action is irreversible — the selected person won’t be able to reject or reassign the shift again.',
      name: 'theActionIsIrreversible',
      desc: '',
      args: [],
    );
  }

  /// `Shift Reassigned`
  String get shiftReassigned {
    return Intl.message(
      'Shift Reassigned',
      name: 'shiftReassigned',
      desc: '',
      args: [],
    );
  }

  /// `The new cashier has been notified and their approval is currently pending.`
  String get shiftReassignedDesc {
    return Intl.message(
      'The new cashier has been notified and their approval is currently pending.',
      name: 'shiftReassignedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Go To Dashboard`
  String get goToDashBoard {
    return Intl.message(
      'Go To Dashboard',
      name: 'goToDashBoard',
      desc: '',
      args: [],
    );
  }

  /// `Something Went Wrong`
  String get somethingWentWrong {
    return Intl.message(
      'Something Went Wrong',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Please try again later.`
  String get pleaseTryAgainLater {
    return Intl.message(
      'Please try again later.',
      name: 'pleaseTryAgainLater',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message('Ok', name: 'ok', desc: '', args: []);
  }

  /// `Restart App`
  String get restartApp {
    return Intl.message('Restart App', name: 'restartApp', desc: '', args: []);
  }

  /// `We've detected a variance in your order. How would you like to proceed?`
  String get varianceDetected {
    return Intl.message(
      'We\'ve detected a variance in your order. How would you like to proceed?',
      name: 'varianceDetected',
      desc: '',
      args: [],
    );
  }

  /// `Please provide a reason for the variance to continue. A breakdown is shown below.`
  String get varianceDetectedDesc {
    return Intl.message(
      'Please provide a reason for the variance to continue. A breakdown is shown below.',
      name: 'varianceDetectedDesc',
      desc: '',
      args: [],
    );
  }

  /// `You can’t proceed until variance details are provided.`
  String get cannotProceedWithoutVarianceDetails {
    return Intl.message(
      'You can’t proceed until variance details are provided.',
      name: 'cannotProceedWithoutVarianceDetails',
      desc: '',
      args: [],
    );
  }

  /// `Variance Breakdown`
  String get varianceBreakdown {
    return Intl.message(
      'Variance Breakdown',
      name: 'varianceBreakdown',
      desc: '',
      args: [],
    );
  }

  /// `Cash Handover`
  String get cashHandover {
    return Intl.message(
      'Cash Handover',
      name: 'cashHandover',
      desc: '',
      args: [],
    );
  }

  /// `Variance Amount`
  String get varianceAmount {
    return Intl.message(
      'Variance Amount',
      name: 'varianceAmount',
      desc: '',
      args: [],
    );
  }

  /// `Variance Type`
  String get varianceType {
    return Intl.message(
      'Variance Type',
      name: 'varianceType',
      desc: '',
      args: [],
    );
  }

  /// `More info about variance type`
  String get moreInfoAboutVarianceType {
    return Intl.message(
      'More info about variance type',
      name: 'moreInfoAboutVarianceType',
      desc: '',
      args: [],
    );
  }

  /// `What’s the cause of the variance?`
  String get whatTheCauseOfVariance {
    return Intl.message(
      'What’s the cause of the variance?',
      name: 'whatTheCauseOfVariance',
      desc: '',
      args: [],
    );
  }

  /// `Short`
  String get short {
    return Intl.message('Short', name: 'short', desc: '', args: []);
  }

  /// `Over`
  String get over {
    return Intl.message('Over', name: 'over', desc: '', args: []);
  }

  /// `Choose Variance Reason`
  String get chooseVarianceReason {
    return Intl.message(
      'Choose Variance Reason',
      name: 'chooseVarianceReason',
      desc: '',
      args: [],
    );
  }

  /// `I was responsible`
  String get iWasResponsible {
    return Intl.message(
      'I was responsible',
      name: 'iWasResponsible',
      desc: '',
      args: [],
    );
  }

  /// `The variance was due to my own actions or errors during the shift.`
  String get iWasResponsibleDesc {
    return Intl.message(
      'The variance was due to my own actions or errors during the shift.',
      name: 'iWasResponsibleDesc',
      desc: '',
      args: [],
    );
  }

  /// `Me and/or Other Employee(s)`
  String get meAndOrOtherEmployees {
    return Intl.message(
      'Me and/or Other Employee(s)',
      name: 'meAndOrOtherEmployees',
      desc: '',
      args: [],
    );
  }

  /// `Assign responsibility to yourself, other employees, or both, and enter the amount each is responsible for.`
  String get meAndOrOtherEmployeesDesc {
    return Intl.message(
      'Assign responsibility to yourself, other employees, or both, and enter the amount each is responsible for.',
      name: 'meAndOrOtherEmployeesDesc',
      desc: '',
      args: [],
    );
  }

  /// `Other Factor`
  String get otherFactor {
    return Intl.message(
      'Other Factor',
      name: 'otherFactor',
      desc: '',
      args: [],
    );
  }

  /// `The variance was caused by something else, e.g., system issue, hardware failure, unexpected adjustment, Customers.`
  String get otherFactorDesc {
    return Intl.message(
      'The variance was caused by something else, e.g., system issue, hardware failure, unexpected adjustment, Customers.',
      name: 'otherFactorDesc',
      desc: '',
      args: [],
    );
  }

  /// `Mixed Factors`
  String get mixeFactors {
    return Intl.message(
      'Mixed Factors',
      name: 'mixeFactors',
      desc: '',
      args: [],
    );
  }

  /// `The variance resulted from a combination of employee actions (including mine) and external factors.`
  String get mixedFactorsDesc {
    return Intl.message(
      'The variance resulted from a combination of employee actions (including mine) and external factors.',
      name: 'mixedFactorsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Select Responsible Employee`
  String get selectResponsibleEmployee {
    return Intl.message(
      'Select Responsible Employee',
      name: 'selectResponsibleEmployee',
      desc: '',
      args: [],
    );
  }

  /// `Reason for Variance`
  String get reasonForVariance {
    return Intl.message(
      'Reason for Variance',
      name: 'reasonForVariance',
      desc: '',
      args: [],
    );
  }

  /// `Please explain the reason for the variance...`
  String get hintReasonForVariance {
    return Intl.message(
      'Please explain the reason for the variance...',
      name: 'hintReasonForVariance',
      desc: '',
      args: [],
    );
  }

  /// `Add Attachments`
  String get addAttachments {
    return Intl.message(
      'Add Attachments',
      name: 'addAttachments',
      desc: '',
      args: [],
    );
  }

  /// `Choose Employees`
  String get chooseEmployees {
    return Intl.message(
      'Choose Employees',
      name: 'chooseEmployees',
      desc: '',
      args: [],
    );
  }

  /// `Choose the employee(s) responsible and enter how much each caused.`
  String get chooseEmployeesDesc {
    return Intl.message(
      'Choose the employee(s) responsible and enter how much each caused.',
      name: 'chooseEmployeesDesc',
      desc: '',
      args: [],
    );
  }

  /// `Add More Employees`
  String get addMoreEmployees {
    return Intl.message(
      'Add More Employees',
      name: 'addMoreEmployees',
      desc: '',
      args: [],
    );
  }

  /// `Search for employee’s by name`
  String get searchForEmployeeByName {
    return Intl.message(
      'Search for employee’s by name',
      name: 'searchForEmployeeByName',
      desc: '',
      args: [],
    );
  }

  /// `You need to select at least 2 people`
  String get youNeedToSelectAtLeastTwoPeople {
    return Intl.message(
      'You need to select at least 2 people',
      name: 'youNeedToSelectAtLeastTwoPeople',
      desc: '',
      args: [],
    );
  }

  /// `From Device`
  String get fromDevice {
    return Intl.message('From Device', name: 'fromDevice', desc: '', args: []);
  }

  /// `Upload`
  String get upload {
    return Intl.message('Upload', name: 'upload', desc: '', args: []);
  }

  /// `Tap to `
  String get tapTo {
    return Intl.message('Tap to ', name: 'tapTo', desc: '', args: []);
  }

  /// `Max size`
  String get maxSize {
    return Intl.message('Max size', name: 'maxSize', desc: '', args: []);
  }

  /// `Sales Breakdown`
  String get salesBreakDown {
    return Intl.message(
      'Sales Breakdown',
      name: 'salesBreakDown',
      desc: '',
      args: [],
    );
  }

  /// `Sales & Handover Breakdown`
  String get SalesAndHandoverBreakdownTitle {
    return Intl.message(
      'Sales & Handover Breakdown',
      name: 'SalesAndHandoverBreakdownTitle',
      desc: '',
      args: [],
    );
  }

  /// `Amount (Total sales + Vat)`
  String get totalSalesHintText {
    return Intl.message(
      'Amount (Total sales + Vat)',
      name: 'totalSalesHintText',
      desc: '',
      args: [],
    );
  }

  /// `Add the sales recorded so far and the amount to be handed over to the {cashierName}.`
  String SalesAndHandoverBreakdownDesc(String cashierName) {
    return Intl.message(
      'Add the sales recorded so far and the amount to be handed over to the $cashierName.',
      name: 'SalesAndHandoverBreakdownDesc',
      desc: 'Desc',
      args: [cashierName],
    );
  }

  /// `Payment Aggregators ({count}).`
  String paymentAggregtors(int count) {
    return Intl.message(
      'Payment Aggregators ($count).',
      name: 'paymentAggregtors',
      desc: 'Desc',
      args: [count],
    );
  }

  /// `({count}) Employees Selected.`
  String countEmployeesSelected(int count) {
    return Intl.message(
      '($count) Employees Selected.',
      name: 'countEmployeesSelected',
      desc: 'Desc',
      args: [count],
    );
  }

  /// `Handover Amount`
  String get handoverAmountTitle {
    return Intl.message(
      'Handover Amount',
      name: 'handoverAmountTitle',
      desc: '',
      args: [],
    );
  }

  /// `Amount the next cashier will receive`
  String get handoverAmountHintText {
    return Intl.message(
      'Amount the next cashier will receive',
      name: 'handoverAmountHintText',
      desc: '',
      args: [],
    );
  }

  /// `Payment Methods`
  String get paymentMethods {
    return Intl.message(
      'Payment Methods',
      name: 'paymentMethods',
      desc: '',
      args: [],
    );
  }

  /// `Enter payment breakdowns based on total sales.`
  String get paymentMethodsDesc {
    return Intl.message(
      'Enter payment breakdowns based on total sales.',
      name: 'paymentMethodsDesc',
      desc: '',
      args: [],
    );
  }

  /// `mada`
  String get mada {
    return Intl.message('mada', name: 'mada', desc: '', args: []);
  }

  /// `Choose Delivery App`
  String get chooseDeliveryApp {
    return Intl.message(
      'Choose Delivery App',
      name: 'chooseDeliveryApp',
      desc: '',
      args: [],
    );
  }

  /// `Select the delivery platform you received payments from and enter the amount collected.`
  String get chooseDeliveryAppDesc {
    return Intl.message(
      'Select the delivery platform you received payments from and enter the amount collected.',
      name: 'chooseDeliveryAppDesc',
      desc: '',
      args: [],
    );
  }

  /// `Search for delivery app’s by name`
  String get chooseDeliveryAppHintText {
    return Intl.message(
      'Search for delivery app’s by name',
      name: 'chooseDeliveryAppHintText',
      desc: '',
      args: [],
    );
  }

  /// `Amount Collected`
  String get amountCollected {
    return Intl.message(
      'Amount Collected',
      name: 'amountCollected',
      desc: '',
      args: [],
    );
  }

  /// `Pending Time`
  String get pendingTime {
    return Intl.message(
      'Pending Time',
      name: 'pendingTime',
      desc: '',
      args: [],
    );
  }

  /// `End Shift Early`
  String get endShiftEarly {
    return Intl.message(
      'End Shift Early',
      name: 'endShiftEarly',
      desc: '',
      args: [],
    );
  }

  /// `You’re about to end this shift before its scheduled time.`
  String get endShiftEarlyDesc {
    return Intl.message(
      'You’re about to end this shift before its scheduled time.',
      name: 'endShiftEarlyDesc',
      desc: '',
      args: [],
    );
  }

  /// `You can either `
  String get youCanEither {
    return Intl.message(
      'You can either ',
      name: 'youCanEither',
      desc: '',
      args: [],
    );
  }

  /// `reassign it to another employee `
  String get reassignToAnother {
    return Intl.message(
      'reassign it to another employee ',
      name: 'reassignToAnother',
      desc: '',
      args: [],
    );
  }

  /// `or end it now.`
  String get orEndItNow {
    return Intl.message(
      'or end it now.',
      name: 'orEndItNow',
      desc: '',
      args: [],
    );
  }

  /// `If you choose to end it, the shift will be marked as completed, and no further changes can be made.`
  String get ifYouChooseToEndTheShiftWillBeCompleted {
    return Intl.message(
      'If you choose to end it, the shift will be marked as completed, and no further changes can be made.',
      name: 'ifYouChooseToEndTheShiftWillBeCompleted',
      desc: '',
      args: [],
    );
  }

  /// `How much did you sell in your shift today? (Total amount, including VAT).`
  String get howMuchDidUSell {
    return Intl.message(
      'How much did you sell in your shift today? (Total amount, including VAT).',
      name: 'howMuchDidUSell',
      desc: '',
      args: [],
    );
  }

  /// `Net Sales (excluding VAT)`
  String get netSalesExcludingVar {
    return Intl.message(
      'Net Sales (excluding VAT)',
      name: 'netSalesExcludingVar',
      desc: '',
      args: [],
    );
  }

  /// `Net Value`
  String get netVal {
    return Intl.message('Net Value', name: 'netVal', desc: '', args: []);
  }

  /// `We calculate VAT (15%) automatically from your total.`
  String get weCalculateVatAuto {
    return Intl.message(
      'We calculate VAT (15%) automatically from your total.',
      name: 'weCalculateVatAuto',
      desc: '',
      args: [],
    );
  }

  /// `Upload Receipt`
  String get uploadReceipt {
    return Intl.message(
      'Upload Receipt',
      name: 'uploadReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Handoff Cash Now`
  String get handOffCashNow {
    return Intl.message(
      'Handoff Cash Now',
      name: 'handOffCashNow',
      desc: '',
      args: [],
    );
  }

  /// `Shift Counts`
  String get shiftCounts {
    return Intl.message(
      'Shift Counts',
      name: 'shiftCounts',
      desc: '',
      args: [],
    );
  }

  /// `Confirm who will receive the cash next.`
  String get confirmWhoWillReceiveCash {
    return Intl.message(
      'Confirm who will receive the cash next.',
      name: 'confirmWhoWillReceiveCash',
      desc: '',
      args: [],
    );
  }

  /// `Who are you handing over to?`
  String get whoAreUHandingTo {
    return Intl.message(
      'Who are you handing over to?',
      name: 'whoAreUHandingTo',
      desc: '',
      args: [],
    );
  }

  /// `Handover Recipient`
  String get handoverRecipient {
    return Intl.message(
      'Handover Recipient',
      name: 'handoverRecipient',
      desc: '',
      args: [],
    );
  }

  /// `Handover Amount`
  String get handOverAmount {
    return Intl.message(
      'Handover Amount',
      name: 'handOverAmount',
      desc: '',
      args: [],
    );
  }

  /// `Additional Note`
  String get additionalNote {
    return Intl.message(
      'Additional Note',
      name: 'additionalNote',
      desc: '',
      args: [],
    );
  }

  /// `Optional Note`
  String get optionalNote {
    return Intl.message(
      'Optional Note',
      name: 'optionalNote',
      desc: '',
      args: [],
    );
  }

  /// `Choose Recipient`
  String get chooseRecipient {
    return Intl.message(
      'Choose Recipient',
      name: 'chooseRecipient',
      desc: '',
      args: [],
    );
  }

  /// `Handover Details`
  String get handoverDetails {
    return Intl.message(
      'Handover Details',
      name: 'handoverDetails',
      desc: '',
      args: [],
    );
  }

  /// `No Available Cashiers`
  String get noAvailableCashiers {
    return Intl.message(
      'No Available Cashiers',
      name: 'noAvailableCashiers',
      desc: '',
      args: [],
    );
  }

  /// `This could be the next cashier or Branch Manager.`
  String get thisCouldBeTheNextCashier {
    return Intl.message(
      'This could be the next cashier or Branch Manager.',
      name: 'thisCouldBeTheNextCashier',
      desc: '',
      args: [],
    );
  }

  /// `No Search Results Found`
  String get noSearchResultsFound {
    return Intl.message(
      'No Search Results Found',
      name: 'noSearchResultsFound',
      desc: '',
      args: [],
    );
  }

  /// `No Categories Found`
  String get noCategoriesFound {
    return Intl.message(
      'No Categories Found',
      name: 'noCategoriesFound',
      desc: '',
      args: [],
    );
  }

  /// `No Sub-Categories Found`
  String get noSubCategoriesFound {
    return Intl.message(
      'No Sub-Categories Found',
      name: 'noSubCategoriesFound',
      desc: '',
      args: [],
    );
  }

  /// `No Items Found`
  String get noItemsFound {
    return Intl.message(
      'No Items Found',
      name: 'noItemsFound',
      desc: '',
      args: [],
    );
  }

  /// `Choose Sub-Category`
  String get chooseSubCategory {
    return Intl.message(
      'Choose Sub-Category',
      name: 'chooseSubCategory',
      desc: '',
      args: [],
    );
  }

  /// `No Cashiers Are available`
  String get noCashiersAreAvailable {
    return Intl.message(
      'No Cashiers Are available',
      name: 'noCashiersAreAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get available {
    return Intl.message('Available', name: 'available', desc: '', args: []);
  }

  /// `Currently Working`
  String get currentlyWorking {
    return Intl.message(
      'Currently Working',
      name: 'currentlyWorking',
      desc: '',
      args: [],
    );
  }

  /// `No Store`
  String get noStore {
    return Intl.message('No Store', name: 'noStore', desc: '', args: []);
  }

  /// `Assab Store`
  String get assabStore {
    return Intl.message('Assab Store', name: 'assabStore', desc: '', args: []);
  }

  /// `Missing Information`
  String get missingInformation {
    return Intl.message(
      'Missing Information',
      name: 'missingInformation',
      desc: '',
      args: [],
    );
  }

  /// `Completed form`
  String get completedForm {
    return Intl.message(
      'Completed form',
      name: 'completedForm',
      desc: '',
      args: [],
    );
  }

  /// `Unauthorized`
  String get unauthorized {
    return Intl.message(
      'Unauthorized',
      name: 'unauthorized',
      desc: '',
      args: [],
    );
  }

  /// `Response Statistics`
  String get responseStatistics {
    return Intl.message(
      'Response Statistics',
      name: 'responseStatistics',
      desc: '',
      args: [],
    );
  }

  /// `Supplier Avg Response Time`
  String get supplierAvgResponseTime {
    return Intl.message(
      'Supplier Avg Response Time',
      name: 'supplierAvgResponseTime',
      desc: '',
      args: [],
    );
  }

  /// `Expect response within 6 hours`
  String get expectResponseWithin {
    return Intl.message(
      'Expect response within 6 hours',
      name: 'expectResponseWithin',
      desc: '',
      args: [],
    );
  }

  /// `You'll receive notifications for any updates`
  String get youllReceiveNotificationsForAnyUpdates {
    return Intl.message(
      'You\'ll receive notifications for any updates',
      name: 'youllReceiveNotificationsForAnyUpdates',
      desc: '',
      args: [],
    );
  }

  /// `Track status from "My Orders"`
  String get trackStatusFromMyOrders {
    return Intl.message(
      'Track status from "My Orders"',
      name: 'trackStatusFromMyOrders',
      desc: '',
      args: [],
    );
  }

  /// `Automatic reminder if no response`
  String get automaticReminderIfNoResponse {
    return Intl.message(
      'Automatic reminder if no response',
      name: 'automaticReminderIfNoResponse',
      desc: '',
      args: [],
    );
  }

  /// `within 24 hours`
  String get within24Hours {
    return Intl.message(
      'within 24 hours',
      name: 'within24Hours',
      desc: '',
      args: [],
    );
  }

  /// `What's Next?`
  String get whatsNext {
    return Intl.message('What\'s Next?', name: 'whatsNext', desc: '', args: []);
  }

  /// `Officer`
  String get officer {
    return Intl.message('Officer', name: 'officer', desc: '', args: []);
  }

  /// `Delete Order Request Draft?`
  String get deleteOrderRequestDraft {
    return Intl.message(
      'Delete Order Request Draft?',
      name: 'deleteOrderRequestDraft',
      desc: '',
      args: [],
    );
  }

  /// `You saved this request to draft on: {dateAndTime}`
  String youSavedThisRequestToDraftOn(Object dateAndTime) {
    return Intl.message(
      'You saved this request to draft on: $dateAndTime',
      name: 'youSavedThisRequestToDraftOn',
      desc: '',
      args: [dateAndTime],
    );
  }

  /// `Supplier Settings`
  String get supplierSettings {
    return Intl.message(
      'Supplier Settings',
      name: 'supplierSettings',
      desc: '',
      args: [],
    );
  }

  /// `Order Date`
  String get orderDate {
    return Intl.message('Order Date', name: 'orderDate', desc: '', args: []);
  }

  /// `Required Delivery`
  String get requiredDelivery {
    return Intl.message(
      'Required Delivery',
      name: 'requiredDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Branch`
  String get branch {
    return Intl.message('Branch', name: 'branch', desc: '', args: []);
  }

  /// `Cancel Order`
  String get cancelOrder {
    return Intl.message(
      'Cancel Order',
      name: 'cancelOrder',
      desc: '',
      args: [],
    );
  }

  /// `Reject Item`
  String get rejectItem {
    return Intl.message('Reject Item', name: 'rejectItem', desc: '', args: []);
  }

  /// `Main Actions`
  String get mainActions {
    return Intl.message(
      'Main Actions',
      name: 'mainActions',
      desc: '',
      args: [],
    );
  }

  /// `Map To Store`
  String get mapToStore {
    return Intl.message('Map To Store', name: 'mapToStore', desc: '', args: []);
  }

  /// `How would you like to proceed with this item?`
  String get howWouldYouLikeToProceedWithThisItem {
    return Intl.message(
      'How would you like to proceed with this item?',
      name: 'howWouldYouLikeToProceedWithThisItem',
      desc: '',
      args: [],
    );
  }

  /// `Alternative Options`
  String get alternativeOptions {
    return Intl.message(
      'Alternative Options',
      name: 'alternativeOptions',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Requested Quantity`
  String get confirmRequestedQuantity {
    return Intl.message(
      'Confirm Requested Quantity',
      name: 'confirmRequestedQuantity',
      desc: '',
      args: [],
    );
  }

  /// `I can fulfill the full quantity as requested, no changes needed.`
  String get iCanFulfillTheFullQuantityAsRequestedNoChangesNeeded {
    return Intl.message(
      'I can fulfill the full quantity as requested, no changes needed.',
      name: 'iCanFulfillTheFullQuantityAsRequestedNoChangesNeeded',
      desc: '',
      args: [],
    );
  }

  /// `Propose New Quantity`
  String get proposeNewQuantity {
    return Intl.message(
      'Propose New Quantity',
      name: 'proposeNewQuantity',
      desc: '',
      args: [],
    );
  }

  /// `I can't provide the full Qty, I'll enter what I have. Requires buyer approval.`
  String get iCantProvideTheFullQtyIllEnterWhatIHaveRequiresBuyerApproval {
    return Intl.message(
      'I can\'t provide the full Qty, I\'ll enter what I have. Requires buyer approval.',
      name: 'iCantProvideTheFullQtyIllEnterWhatIHaveRequiresBuyerApproval',
      desc: '',
      args: [],
    );
  }

  /// `Low Stock — Need Time`
  String get lowStockNeedTime {
    return Intl.message(
      'Low Stock — Need Time',
      name: 'lowStockNeedTime',
      desc: '',
      args: [],
    );
  }

  /// `I need more time to procure and deliver the full quantity. Requires buyer approval`
  String
  get iNeedMoreTimeToProcureAndDeliverTheFullQuantityRequiresBuyerApproval {
    return Intl.message(
      'I need more time to procure and deliver the full quantity. Requires buyer approval',
      name:
          'iNeedMoreTimeToProcureAndDeliverTheFullQuantityRequiresBuyerApproval',
      desc: '',
      args: [],
    );
  }

  /// `Propose Alternative Product`
  String get proposeAlternativeProduct {
    return Intl.message(
      'Propose Alternative Product',
      name: 'proposeAlternativeProduct',
      desc: '',
      args: [],
    );
  }

  /// `The item is unavailable. I will suggest a substitute for the buyer.Requires buyer approval`
  String
  get theItemIsUnavailableIWillSuggestASubstituteForTheBuyerRequiresBuyerApproval {
    return Intl.message(
      'The item is unavailable. I will suggest a substitute for the buyer.Requires buyer approval',
      name:
          'theItemIsUnavailableIWillSuggestASubstituteForTheBuyerRequiresBuyerApproval',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continue_c {
    return Intl.message('Continue', name: 'continue_c', desc: '', args: []);
  }

  /// `Once confirmed, the order will be marked as canceled and this action cannot be reversed.`
  String get cancelOrderConfirmDesc {
    return Intl.message(
      'Once confirmed, the order will be marked as canceled and this action cannot be reversed.',
      name: 'cancelOrderConfirmDesc',
      desc: '',
      args: [],
    );
  }

  /// `Please provide a reason. It will be shared with the requesting branch.`
  String get rejectOrderItemDesc {
    return Intl.message(
      'Please provide a reason. It will be shared with the requesting branch.',
      name: 'rejectOrderItemDesc',
      desc: '',
      args: [],
    );
  }

  /// `View Cancellation Details`
  String get viewCancellationDetails {
    return Intl.message(
      'View Cancellation Details',
      name: 'viewCancellationDetails',
      desc: '',
      args: [],
    );
  }

  /// `Order Rejected by You`
  String get orderRejectedByYou {
    return Intl.message(
      'Order Rejected by You',
      name: 'orderRejectedByYou',
      desc: '',
      args: [],
    );
  }

  /// `Approve All Items ({count})`
  String approveAllItems(Object count) {
    return Intl.message(
      'Approve All Items ($count)',
      name: 'approveAllItems',
      desc: '',
      args: [count],
    );
  }

  /// `All items in this list will be automatically approved, and the order status will be updated to Confirmed.`
  String get approveAllItemsDesc {
    return Intl.message(
      'All items in this list will be automatically approved, and the order status will be updated to Confirmed.',
      name: 'approveAllItemsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Order is now ready for next phase.`
  String get orderReadyForNextPhase {
    return Intl.message(
      'Order is now ready for next phase.',
      name: 'orderReadyForNextPhase',
      desc: '',
      args: [],
    );
  }

  /// `Order Approved`
  String get orderApproved {
    return Intl.message(
      'Order Approved',
      name: 'orderApproved',
      desc: '',
      args: [],
    );
  }

  /// `What Comes Next`
  String get whatComesNext {
    return Intl.message(
      'What Comes Next',
      name: 'whatComesNext',
      desc: '',
      args: [],
    );
  }

  /// `Upload all required documents before preparing the order:`
  String get uploadAllRequiredDocumentsBeforePreparingTheOrder {
    return Intl.message(
      'Upload all required documents before preparing the order:',
      name: 'uploadAllRequiredDocumentsBeforePreparingTheOrder',
      desc: '',
      args: [],
    );
  }

  /// `Quality Certificate`
  String get qualityCertificate {
    return Intl.message(
      'Quality Certificate',
      name: 'qualityCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Mark All As Preparing`
  String get markAllAsPreparing {
    return Intl.message(
      'Mark All As Preparing',
      name: 'markAllAsPreparing',
      desc: '',
      args: [],
    );
  }

  /// `Mark as Preparing`
  String get markAsPreparing {
    return Intl.message(
      'Mark as Preparing',
      name: 'markAsPreparing',
      desc: '',
      args: [],
    );
  }

  /// `Preparing`
  String get preparing {
    return Intl.message('Preparing', name: 'preparing', desc: '', args: []);
  }

  /// `Track`
  String get track {
    return Intl.message('Track', name: 'track', desc: '', args: []);
  }

  /// `Track Delivery`
  String get trackDelivery {
    return Intl.message(
      'Track Delivery',
      name: 'trackDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Item Rejected`
  String get itemRejected {
    return Intl.message(
      'Item Rejected',
      name: 'itemRejected',
      desc: '',
      args: [],
    );
  }

  /// `You’ve successfully rejected item. Your reason has been shared with the requesting branch.`
  String get itemRejectedDesc {
    return Intl.message(
      'You’ve successfully rejected item. Your reason has been shared with the requesting branch.',
      name: 'itemRejectedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Your request requires approval from the individual below:`
  String get approvalRequiredBy {
    return Intl.message(
      'Your request requires approval from the individual below:',
      name: 'approvalRequiredBy',
      desc: '',
      args: [],
    );
  }

  /// `Recipient Details`
  String get recipientDetails {
    return Intl.message(
      'Recipient Details',
      name: 'recipientDetails',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Cashier Shifts`
  String get cashierShifts {
    return Intl.message(
      'Cashier Shifts',
      name: 'cashierShifts',
      desc: '',
      args: [],
    );
  }

  /// `Workday Management`
  String get workDayManagement {
    return Intl.message(
      'Workday Management',
      name: 'workDayManagement',
      desc: '',
      args: [],
    );
  }

  /// `My shift & Handoff details (Branch Manager)`
  String get myShiftAndHandOffDetails {
    return Intl.message(
      'My shift & Handoff details (Branch Manager)',
      name: 'myShiftAndHandOffDetails',
      desc: '',
      args: [],
    );
  }

  /// `Your session has expired or you have been logged out. Please log in again to continue.`
  String get unauthorizedDesc {
    return Intl.message(
      'Your session has expired or you have been logged out. Please log in again to continue.',
      name: 'unauthorizedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Head Cashier`
  String get headCashier {
    return Intl.message(
      'Head Cashier',
      name: 'headCashier',
      desc: '',
      args: [],
    );
  }

  /// `Me\n(Branch Manager)`
  String get assignedToMeBranchManager {
    return Intl.message(
      'Me\n(Branch Manager)',
      name: 'assignedToMeBranchManager',
      desc: '',
      args: [],
    );
  }

  /// `Shop Owner`
  String get shopOwner {
    return Intl.message('Shop Owner', name: 'shopOwner', desc: '', args: []);
  }

  /// `Final Approval By`
  String get finalApprovalBy {
    return Intl.message(
      'Final Approval By',
      name: 'finalApprovalBy',
      desc: '',
      args: [],
    );
  }

  /// `Petty Cash`
  String get pettyCash {
    return Intl.message('Petty Cash', name: 'pettyCash', desc: '', args: []);
  }

  /// `Last Deposit`
  String get lastDeposit {
    return Intl.message(
      'Last Deposit',
      name: 'lastDeposit',
      desc: '',
      args: [],
    );
  }

  /// `Start Handover`
  String get startHandover {
    return Intl.message(
      'Start Handover',
      name: 'startHandover',
      desc: '',
      args: [],
    );
  }

  /// `Handover From`
  String get handoverFrom {
    return Intl.message(
      'Handover From',
      name: 'handoverFrom',
      desc: '',
      args: [],
    );
  }

  /// `Handover Date`
  String get handoverDate {
    return Intl.message(
      'Handover Date',
      name: 'handoverDate',
      desc: '',
      args: [],
    );
  }

  /// `Handover Time`
  String get handoverTime {
    return Intl.message(
      'Handover Time',
      name: 'handoverTime',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for your approval`
  String get waitingForYourApproval {
    return Intl.message(
      'Waiting for your approval',
      name: 'waitingForYourApproval',
      desc: '',
      args: [],
    );
  }

  /// `Approve`
  String get approve {
    return Intl.message('Approve', name: 'approve', desc: '', args: []);
  }

  /// `You’ve requested {cashierName} to make corrections to the submitted variance.`
  String youRequestedEmployeeToCorrect(String cashierName) {
    return Intl.message(
      'You’ve requested $cashierName to make corrections to the submitted variance.',
      name: 'youRequestedEmployeeToCorrect',
      desc: 'Desc',
      args: [cashierName],
    );
  }

  /// `Handover Approved by YOU on: {approveDate}`
  String handoverApprovedByYou(String approveDate) {
    return Intl.message(
      'Handover Approved by YOU on: $approveDate',
      name: 'handoverApprovedByYou',
      desc: 'Desc',
      args: [approveDate],
    );
  }

  /// ` / {hours} hrs`
  String slashWithTotalHrs(String hours) {
    return Intl.message(
      ' / $hours hrs',
      name: 'slashWithTotalHrs',
      desc: 'Desc',
      args: [hours],
    );
  }

  /// `Final HandOver`
  String get finalHandOver {
    return Intl.message(
      'Final HandOver',
      name: 'finalHandOver',
      desc: '',
      args: [],
    );
  }

  /// `Handoffs Received`
  String get handoffsReceived {
    return Intl.message(
      'Handoffs Received',
      name: 'handoffsReceived',
      desc: '',
      args: [],
    );
  }

  /// `No handovers submitted yet. Click the “Start Handover” button to get started.`
  String get noHandoverSubmittedYet {
    return Intl.message(
      'No handovers submitted yet. Click the “Start Handover” button to get started.',
      name: 'noHandoverSubmittedYet',
      desc: '',
      args: [],
    );
  }

  /// `Pending Handover`
  String get pendingHandover {
    return Intl.message(
      'Pending Handover',
      name: 'pendingHandover',
      desc: '',
      args: [],
    );
  }

  /// ` The cash handover is awaiting confirmation from {selectedCashierName}. You’ll be notified once they approve it.`
  String handOverDesc(String selectedCashierName) {
    return Intl.message(
      ' The cash handover is awaiting confirmation from $selectedCashierName. You’ll be notified once they approve it.',
      name: 'handOverDesc',
      desc: 'Desc',
      args: [selectedCashierName],
    );
  }

  /// `Pending Recipient Approval`
  String get handoverRecipientApproval {
    return Intl.message(
      'Pending Recipient Approval',
      name: 'handoverRecipientApproval',
      desc: '',
      args: [],
    );
  }

  /// `End Shift First`
  String get EndShiftFirst {
    return Intl.message(
      'End Shift First',
      name: 'EndShiftFirst',
      desc: '',
      args: [],
    );
  }

  /// `You need to end your shift before proceeding with the final handover.`
  String get youNeedToEndYourShiftBeforeFinalHandOver {
    return Intl.message(
      'You need to end your shift before proceeding with the final handover.',
      name: 'youNeedToEndYourShiftBeforeFinalHandOver',
      desc: '',
      args: [],
    );
  }

  /// `Wrap up your shift activities, then return here to complete the process.`
  String get wrapUpYourShiftActivities {
    return Intl.message(
      'Wrap up your shift activities, then return here to complete the process.',
      name: 'wrapUpYourShiftActivities',
      desc: '',
      args: [],
    );
  }

  /// `Shift not Started`
  String get shiftNotStarted {
    return Intl.message(
      'Shift not Started',
      name: 'shiftNotStarted',
      desc: '',
      args: [],
    );
  }

  /// `You haven’t started your shift yet`
  String get uHaventStartedYourShiftYet {
    return Intl.message(
      'You haven’t started your shift yet',
      name: 'uHaventStartedYourShiftYet',
      desc: '',
      args: [],
    );
  }

  /// `You’ll need to begin your shift before you can complete a final handover.`
  String get uNeedToBeginTheShift {
    return Intl.message(
      'You’ll need to begin your shift before you can complete a final handover.',
      name: 'uNeedToBeginTheShift',
      desc: '',
      args: [],
    );
  }

  /// `Accountant Name`
  String get accountantName {
    return Intl.message(
      'Accountant Name',
      name: 'accountantName',
      desc: '',
      args: [],
    );
  }

  /// `Accountant`
  String get Accountant {
    return Intl.message('Accountant', name: 'Accountant', desc: '', args: []);
  }

  /// `Set Workday`
  String get setWorkDay {
    return Intl.message('Set Workday', name: 'setWorkDay', desc: '', args: []);
  }

  /// `Final Handover Summary`
  String get finalHandoverSummary {
    return Intl.message(
      'Final Handover Summary',
      name: 'finalHandoverSummary',
      desc: '',
      args: [],
    );
  }

  /// `Review the list of cashiers who have completed their handoffs.`
  String get finalHandoverSummaryDesc {
    return Intl.message(
      'Review the list of cashiers who have completed their handoffs.',
      name: 'finalHandoverSummaryDesc',
      desc: '',
      args: [],
    );
  }

  /// `Cashier Handover Not Submitted`
  String get cashierHandoffNotSubmitted {
    return Intl.message(
      'Cashier Handover Not Submitted',
      name: 'cashierHandoffNotSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `The final cashier has not handed over to you yet. Please check in with them to complete the process before continuing.`
  String get cashierHandoffNotSubmittedDesc {
    return Intl.message(
      'The final cashier has not handed over to you yet. Please check in with them to complete the process before continuing.',
      name: 'cashierHandoffNotSubmittedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Handoff Not Approved`
  String get handoffNotApproved {
    return Intl.message(
      'Handoff Not Approved',
      name: 'handoffNotApproved',
      desc: '',
      args: [],
    );
  }

  /// `You haven’t approved the final cashier’s handover.`
  String get uHaventApprovedTheFinalCashierHandOver {
    return Intl.message(
      'You haven’t approved the final cashier’s handover.',
      name: 'uHaventApprovedTheFinalCashierHandOver',
      desc: '',
      args: [],
    );
  }

  /// `Please return to the handoffs list, approve their submission, and then end your shift.`
  String get pleaseReturnToHandoffListToApprove {
    return Intl.message(
      'Please return to the handoffs list, approve their submission, and then end your shift.',
      name: 'pleaseReturnToHandoffListToApprove',
      desc: '',
      args: [],
    );
  }

  /// `Not Submitted`
  String get notSubmitted {
    return Intl.message(
      'Not Submitted',
      name: 'notSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Define which day your branch’s data belongs to, even for late-night operations.`
  String get defineWhichDayYourBranchDataBelongsTo {
    return Intl.message(
      'Define which day your branch’s data belongs to, even for late-night operations.',
      name: 'defineWhichDayYourBranchDataBelongsTo',
      desc: '',
      args: [],
    );
  }

  /// `Current Time Summary`
  String get currentTimeSummary {
    return Intl.message(
      'Current Time Summary',
      name: 'currentTimeSummary',
      desc: '',
      args: [],
    );
  }

  /// `Set Business Date To:`
  String get setBusinessDateTo {
    return Intl.message(
      'Set Business Date To:',
      name: 'setBusinessDateTo',
      desc: '',
      args: [],
    );
  }

  /// `All handovers, shifts, and sales will be recorded under today’s workday.`
  String get allHandoversShiftsAndSalesWillBeRecordedUnderTodayWorkday {
    return Intl.message(
      'All handovers, shifts, and sales will be recorded under today’s workday.',
      name: 'allHandoversShiftsAndSalesWillBeRecordedUnderTodayWorkday',
      desc: '',
      args: [],
    );
  }

  /// `Sunday - Thursday`
  String get sundayThursday {
    return Intl.message(
      'Sunday - Thursday',
      name: 'sundayThursday',
      desc: '',
      args: [],
    );
  }

  /// `Today: {date}`
  String todayWithDate(String date) {
    return Intl.message(
      'Today: $date',
      name: 'todayWithDate',
      desc: 'Desc',
      args: [date],
    );
  }

  /// `Yesterday: {date}`
  String yesterdayWithDate(String date) {
    return Intl.message(
      'Yesterday: $date',
      name: 'yesterdayWithDate',
      desc: 'Desc',
      args: [date],
    );
  }

  /// `Final Daily Close`
  String get finalDailyClose {
    return Intl.message(
      'Final Daily Close',
      name: 'finalDailyClose',
      desc: '',
      args: [],
    );
  }

  /// `Review all handover and shift details carefully before submitting.`
  String get reviewAllHandoverBeforeSubmitting {
    return Intl.message(
      'Review all handover and shift details carefully before submitting.',
      name: 'reviewAllHandoverBeforeSubmitting',
      desc: '',
      args: [],
    );
  }

  /// `Payment Details View`
  String get paymentDetailsView {
    return Intl.message(
      'Payment Details View',
      name: 'paymentDetailsView',
      desc: '',
      args: [],
    );
  }

  /// `Total Variance`
  String get totalVariance {
    return Intl.message(
      'Total Variance',
      name: 'totalVariance',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Apps Total`
  String get deliveryAppsTotal {
    return Intl.message(
      'Delivery Apps Total',
      name: 'deliveryAppsTotal',
      desc: '',
      args: [],
    );
  }

  /// `A variance reason was added during handover. Tap to view.`
  String get varianceReasonWasAddedDuringHandover {
    return Intl.message(
      'A variance reason was added during handover. Tap to view.',
      name: 'varianceReasonWasAddedDuringHandover',
      desc: '',
      args: [],
    );
  }

  /// `Cash from`
  String get cashFrom {
    return Intl.message('Cash from', name: 'cashFrom', desc: '', args: []);
  }

  /// `See the details of {managerName}’s handover breakdown below:`
  String seeDetailsOfManagerHandover(String managerName) {
    return Intl.message(
      'See the details of $managerName’s handover breakdown below:',
      name: 'seeDetailsOfManagerHandover',
      desc: 'Desc',
      args: [managerName],
    );
  }

  /// `{managerName}’s Handover`
  String managersHandover(String managerName) {
    return Intl.message(
      '$managerName’s Handover',
      name: 'managersHandover',
      desc: 'Desc',
      args: [managerName],
    );
  }

  /// `No Sup Categories`
  String get noSupCategories {
    return Intl.message(
      'No Sup Categories',
      name: 'noSupCategories',
      desc: '',
      args: [],
    );
  }

  /// `Not Available`
  String get notAvailable {
    return Intl.message(
      'Not Available',
      name: 'notAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message('Welcome', name: 'welcome', desc: '', args: []);
  }

  /// `Branch Manager’s Dashboard for...`
  String get branchManagersDashboardFor {
    return Intl.message(
      'Branch Manager’s Dashboard for...',
      name: 'branchManagersDashboardFor',
      desc: '',
      args: [],
    );
  }

  /// `Today’s Summary`
  String get todaysSummary {
    return Intl.message(
      'Today’s Summary',
      name: 'todaysSummary',
      desc: '',
      args: [],
    );
  }

  /// `Orders in progress`
  String get ordersInProgress {
    return Intl.message(
      'Orders in progress',
      name: 'ordersInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Today’s Receipt`
  String get todaysReceipt {
    return Intl.message(
      'Today’s Receipt',
      name: 'todaysReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Go to Stocks`
  String get goToStocks {
    return Intl.message('Go to Stocks', name: 'goToStocks', desc: '', args: []);
  }

  /// `New Order`
  String get newOrder {
    return Intl.message('New Order', name: 'newOrder', desc: '', args: []);
  }

  /// `Transfers/Handover`
  String get transfershandover {
    return Intl.message(
      'Transfers/Handover',
      name: 'transfershandover',
      desc: '',
      args: [],
    );
  }

  /// `Receive Goods`
  String get receiveGoods {
    return Intl.message(
      'Receive Goods',
      name: 'receiveGoods',
      desc: '',
      args: [],
    );
  }

  /// `View Reports`
  String get viewReports {
    return Intl.message(
      'View Reports',
      name: 'viewReports',
      desc: '',
      args: [],
    );
  }

  /// `More Actions`
  String get moreActions {
    return Intl.message(
      'More Actions',
      name: 'moreActions',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get viewAll {
    return Intl.message('View All', name: 'viewAll', desc: '', args: []);
  }

  /// `Custody Management`
  String get custodyManagement {
    return Intl.message(
      'Custody Management',
      name: 'custodyManagement',
      desc: '',
      args: [],
    );
  }

  /// `Purchase History`
  String get purchaseHistory {
    return Intl.message(
      'Purchase History',
      name: 'purchaseHistory',
      desc: '',
      args: [],
    );
  }

  /// `Returns Management`
  String get returnsManagement {
    return Intl.message(
      'Returns Management',
      name: 'returnsManagement',
      desc: '',
      args: [],
    );
  }

  /// `Recurring Orders`
  String get recurringOrders {
    return Intl.message(
      'Recurring Orders',
      name: 'recurringOrders',
      desc: '',
      args: [],
    );
  }

  /// `My Ledger`
  String get myLedger {
    return Intl.message('My Ledger', name: 'myLedger', desc: '', args: []);
  }

  /// `Cashiers List`
  String get cashiersList {
    return Intl.message(
      'Cashiers List',
      name: 'cashiersList',
      desc: '',
      args: [],
    );
  }

  /// `Account Statement`
  String get accountStatement {
    return Intl.message(
      'Account Statement',
      name: 'accountStatement',
      desc: '',
      args: [],
    );
  }

  /// `Inventory Management`
  String get inventoryManagement {
    return Intl.message(
      'Inventory Management',
      name: 'inventoryManagement',
      desc: '',
      args: [],
    );
  }

  /// `Fixed Assets`
  String get fixedAssets {
    return Intl.message(
      'Fixed Assets',
      name: 'fixedAssets',
      desc: '',
      args: [],
    );
  }

  /// `Branch Manager Settings`
  String get branchManagerSettings {
    return Intl.message(
      'Branch Manager Settings',
      name: 'branchManagerSettings',
      desc: '',
      args: [],
    );
  }

  /// `Branch Settings & Aggregators`
  String get branchSettingsAggregators {
    return Intl.message(
      'Branch Settings & Aggregators',
      name: 'branchSettingsAggregators',
      desc: '',
      args: [],
    );
  }

  /// `Account & Password`
  String get accountPassword {
    return Intl.message(
      'Account & Password',
      name: 'accountPassword',
      desc: '',
      args: [],
    );
  }

  /// `My account details`
  String get myAccountDetails {
    return Intl.message(
      'My account details',
      name: 'myAccountDetails',
      desc: '',
      args: [],
    );
  }

  /// `Reset my password`
  String get resetMyPassword {
    return Intl.message(
      'Reset my password',
      name: 'resetMyPassword',
      desc: '',
      args: [],
    );
  }

  /// `Notifications & alerts`
  String get notificationsAlerts {
    return Intl.message(
      'Notifications & alerts',
      name: 'notificationsAlerts',
      desc: '',
      args: [],
    );
  }

  /// `System settings`
  String get systemSettings {
    return Intl.message(
      'System settings',
      name: 'systemSettings',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `System Preference`
  String get systemPreference {
    return Intl.message(
      'System Preference',
      name: 'systemPreference',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `New Purchase Order`
  String get newPurchaseOrder {
    return Intl.message(
      'New Purchase Order',
      name: 'newPurchaseOrder',
      desc: '',
      args: [],
    );
  }

  /// `Choose products & Order Sources`
  String get chooseProductsOrderSources {
    return Intl.message(
      'Choose products & Order Sources',
      name: 'chooseProductsOrderSources',
      desc: '',
      args: [],
    );
  }

  /// `All Items`
  String get allItems {
    return Intl.message('All Items', name: 'allItems', desc: '', args: []);
  }

  /// `Choose items and required quantity.`
  String get chooseItemsAndRequiredQuantity {
    return Intl.message(
      'Choose items and required quantity.',
      name: 'chooseItemsAndRequiredQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Search for items`
  String get searchForItems {
    return Intl.message(
      'Search for items',
      name: 'searchForItems',
      desc: '',
      args: [],
    );
  }

  /// `Recent Selections`
  String get recentSelections {
    return Intl.message(
      'Recent Selections',
      name: 'recentSelections',
      desc: '',
      args: [],
    );
  }

  /// `Items Added`
  String get itemsAdded {
    return Intl.message('Items Added', name: 'itemsAdded', desc: '', args: []);
  }

  /// `Choose Sources`
  String get chooseSources {
    return Intl.message(
      'Choose Sources',
      name: 'chooseSources',
      desc: '',
      args: [],
    );
  }

  /// `Filter Item List by`
  String get filterItemListBy {
    return Intl.message(
      'Filter Item List by',
      name: 'filterItemListBy',
      desc: '',
      args: [],
    );
  }

  /// `Results will include Sub-categories of the selected Item`
  String get resultsWillIncludeSubcategoriesOfTheSelectedItem {
    return Intl.message(
      'Results will include Sub-categories of the selected Item',
      name: 'resultsWillIncludeSubcategoriesOfTheSelectedItem',
      desc: '',
      args: [],
    );
  }

  /// `e.g Beverages or meat`
  String get egBeveragesOrMeat {
    return Intl.message(
      'e.g Beverages or meat',
      name: 'egBeveragesOrMeat',
      desc: '',
      args: [],
    );
  }

  /// `Results will include Item list associated to the selected supplier`
  String get resultsWillIncludeItemListAssociatedToTheSelectedSupplier {
    return Intl.message(
      'Results will include Item list associated to the selected supplier',
      name: 'resultsWillIncludeItemListAssociatedToTheSelectedSupplier',
      desc: '',
      args: [],
    );
  }

  /// `e.g Supplier\'s Name`
  String get egSuppliersName {
    return Intl.message(
      'e.g Supplier\\\'s Name',
      name: 'egSuppliersName',
      desc: '',
      args: [],
    );
  }

  /// `Clear Filter`
  String get clearFilter {
    return Intl.message(
      'Clear Filter',
      name: 'clearFilter',
      desc: '',
      args: [],
    );
  }

  /// `Clear All Selections`
  String get clearAllSelections {
    return Intl.message(
      'Clear All Selections',
      name: 'clearAllSelections',
      desc: '',
      args: [],
    );
  }

  /// `Choose the optimal source for each of your order:`
  String get chooseTheOptimalSourceForEachOfYourOrder {
    return Intl.message(
      'Choose the optimal source for each of your order:',
      name: 'chooseTheOptimalSourceForEachOfYourOrder',
      desc: '',
      args: [],
    );
  }

  /// `Kg`
  String get kg {
    return Intl.message('Kg', name: 'kg', desc: '', args: []);
  }

  /// `Choose Order Source`
  String get chooseOrderSource {
    return Intl.message(
      'Choose Order Source',
      name: 'chooseOrderSource',
      desc: '',
      args: [],
    );
  }

  /// `Order Source`
  String get orderSource {
    return Intl.message(
      'Order Source',
      name: 'orderSource',
      desc: '',
      args: [],
    );
  }

  /// `Select where or how this item will be purchased`
  String get selectWhereOrHowThisItemWillBePurchased {
    return Intl.message(
      'Select where or how this item will be purchased',
      name: 'selectWhereOrHowThisItemWillBePurchased',
      desc: '',
      args: [],
    );
  }

  /// `Direct Supplier Order`
  String get directSupplierOrder {
    return Intl.message(
      'Direct Supplier Order',
      name: 'directSupplierOrder',
      desc: '',
      args: [],
    );
  }

  /// `Choose This Option`
  String get chooseThisOption {
    return Intl.message(
      'Choose This Option',
      name: 'chooseThisOption',
      desc: '',
      args: [],
    );
  }

  /// `Traditional supplier order`
  String get traditionalSupplierOrder {
    return Intl.message(
      'Traditional supplier order',
      name: 'traditionalSupplierOrder',
      desc: '',
      args: [],
    );
  }

  /// `Individual pricing - fast delivery`
  String get individualPricingFastDelivery {
    return Intl.message(
      'Individual pricing - fast delivery',
      name: 'individualPricingFastDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Suitable for small quantities`
  String get suitableForSmallQuantities {
    return Intl.message(
      'Suitable for small quantities',
      name: 'suitableForSmallQuantities',
      desc: '',
      args: [],
    );
  }

  /// `Smart Tip`
  String get smartTip {
    return Intl.message('Smart Tip', name: 'smartTip', desc: '', args: []);
  }

  /// `We suggest ordering through Direct Supplier for the best value.`
  String get weSuggestOrderingThroughDirectSupplierForTheBestValue {
    return Intl.message(
      'We suggest ordering through Direct Supplier for the best value.',
      name: 'weSuggestOrderingThroughDirectSupplierForTheBestValue',
      desc: '',
      args: [],
    );
  }

  /// `Compare Prices`
  String get comparePrices {
    return Intl.message(
      'Compare Prices',
      name: 'comparePrices',
      desc: '',
      args: [],
    );
  }

  /// `Order via Purchasing Officer`
  String get orderViaPurchasingOfficer {
    return Intl.message(
      'Order via Purchasing Officer',
      name: 'orderViaPurchasingOfficer',
      desc: '',
      args: [],
    );
  }

  /// `Consolidated orders - better prices`
  String get consolidatedOrdersBetterPrices {
    return Intl.message(
      'Consolidated orders - better prices',
      name: 'consolidatedOrdersBetterPrices',
      desc: '',
      args: [],
    );
  }

  /// `Bulk discounts (10-20%)`
  String get bulkDiscounts1020 {
    return Intl.message(
      'Bulk discounts (10-20%)',
      name: 'bulkDiscounts1020',
      desc: '',
      args: [],
    );
  }

  /// `Guaranteed quality & reliable supplier`
  String get guaranteedQualityReliableSupplier {
    return Intl.message(
      'Guaranteed quality & reliable supplier',
      name: 'guaranteedQualityReliableSupplier',
      desc: '',
      args: [],
    );
  }

  /// `Internal Transfer from Another Branch.`
  String get internalTransferFromAnotherBranch {
    return Intl.message(
      'Internal Transfer from Another Branch.',
      name: 'internalTransferFromAnotherBranch',
      desc: '',
      args: [],
    );
  }

  /// `Stock transfer - no cost`
  String get stockTransferNoCost {
    return Intl.message(
      'Stock transfer - no cost',
      name: 'stockTransferNoCost',
      desc: '',
      args: [],
    );
  }

  /// `Fast delivery - limited quantities`
  String get fastDeliveryLimitedQuantities {
    return Intl.message(
      'Fast delivery - limited quantities',
      name: 'fastDeliveryLimitedQuantities',
      desc: '',
      args: [],
    );
  }

  /// `Suitable for emergencies`
  String get suitableForEmergencies {
    return Intl.message(
      'Suitable for emergencies',
      name: 'suitableForEmergencies',
      desc: '',
      args: [],
    );
  }

  /// `Compare sources in real-time to choose the most cost-effective option.`
  String get compareSourcesInRealtimeToChooseTheMostCosteffectiveOption {
    return Intl.message(
      'Compare sources in real-time to choose the most cost-effective option.',
      name: 'compareSourcesInRealtimeToChooseTheMostCosteffectiveOption',
      desc: '',
      args: [],
    );
  }

  /// `Product`
  String get product {
    return Intl.message('Product', name: 'product', desc: '', args: []);
  }

  /// `Quantity`
  String get quantity {
    return Intl.message('Quantity', name: 'quantity', desc: '', args: []);
  }

  /// `Period`
  String get period {
    return Intl.message('Period', name: 'period', desc: '', args: []);
  }

  /// `Detailed Comparison`
  String get detailedComparison {
    return Intl.message(
      'Detailed Comparison',
      name: 'detailedComparison',
      desc: '',
      args: [],
    );
  }

  /// `Delivery`
  String get delivery {
    return Intl.message('Delivery', name: 'delivery', desc: '', args: []);
  }

  /// `Rating`
  String get rating {
    return Intl.message('Rating', name: 'rating', desc: '', args: []);
  }

  /// `Direct`
  String get direct {
    return Intl.message('Direct', name: 'direct', desc: '', args: []);
  }

  /// `Purchasing Officer`
  String get purchasingOfficer {
    return Intl.message(
      'Purchasing Officer',
      name: 'purchasingOfficer',
      desc: '',
      args: [],
    );
  }

  /// `Branch Transfer`
  String get branchTransfer {
    return Intl.message(
      'Branch Transfer',
      name: 'branchTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Additional Factors`
  String get additionalFactors {
    return Intl.message(
      'Additional Factors',
      name: 'additionalFactors',
      desc: '',
      args: [],
    );
  }

  /// `Ordering via Brand Manager`
  String get orderingViaBrandManager {
    return Intl.message(
      'Ordering via Brand Manager',
      name: 'orderingViaBrandManager',
      desc: '',
      args: [],
    );
  }

  /// `context.tr.orderingViaBrandManager`
  String get contexttrorderingviabrandmanager {
    return Intl.message(
      'context.tr.orderingViaBrandManager',
      name: 'contexttrorderingviabrandmanager',
      desc: '',
      args: [],
    );
  }

  /// `Save 600 SAR (3 SAR/kg)`
  String get save600Sar3Sarkg {
    return Intl.message(
      'Save 600 SAR (3 SAR/kg)',
      name: 'save600Sar3Sarkg',
      desc: '',
      args: [],
    );
  }

  /// `Guaranteed high quality`
  String get guaranteedHighQuality {
    return Intl.message(
      'Guaranteed high quality',
      name: 'guaranteedHighQuality',
      desc: '',
      args: [],
    );
  }

  /// `Trusted and stable relationship`
  String get trustedAndStableRelationship {
    return Intl.message(
      'Trusted and stable relationship',
      name: 'trustedAndStableRelationship',
      desc: '',
      args: [],
    );
  }

  /// `Priority supply access`
  String get prioritySupplyAccess {
    return Intl.message(
      'Priority supply access',
      name: 'prioritySupplyAccess',
      desc: '',
      args: [],
    );
  }

  /// `Benefits Analysis`
  String get benefitsAnalysis {
    return Intl.message(
      'Benefits Analysis',
      name: 'benefitsAnalysis',
      desc: '',
      args: [],
    );
  }

  /// `Best Compliance`
  String get bestCompliance {
    return Intl.message(
      'Best Compliance',
      name: 'bestCompliance',
      desc: '',
      args: [],
    );
  }

  /// `Fastest Delivery`
  String get fastestDelivery {
    return Intl.message(
      'Fastest Delivery',
      name: 'fastestDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Lowest Price`
  String get lowestPrice {
    return Intl.message(
      'Lowest Price',
      name: 'lowestPrice',
      desc: '',
      args: [],
    );
  }

  /// `Smart Recommendation`
  String get smartRecommendation {
    return Intl.message(
      'Smart Recommendation',
      name: 'smartRecommendation',
      desc: '',
      args: [],
    );
  }

  /// `The ⭐ icon is system-generated based on real-time analysis.`
  String get theIconIsSystemgeneratedBasedOnRealtimeAnalysis {
    return Intl.message(
      'The ⭐ icon is system-generated based on real-time analysis.',
      name: 'theIconIsSystemgeneratedBasedOnRealtimeAnalysis',
      desc: '',
      args: [],
    );
  }

  /// `Order via Brand Manager - Best overall value (competitive price + excellent compliance)`
  String get orderViaBrandManagerBestOverallValueCompetitivePriceExcellent {
    return Intl.message(
      'Order via Brand Manager - Best overall value (competitive price + excellent compliance)',
      name: 'orderViaBrandManagerBestOverallValueCompetitivePriceExcellent',
      desc: '',
      args: [],
    );
  }

  /// `Save Comparison`
  String get saveComparison {
    return Intl.message(
      'Save Comparison',
      name: 'saveComparison',
      desc: '',
      args: [],
    );
  }

  /// `Use Recommendation`
  String get useRecommendation {
    return Intl.message(
      'Use Recommendation',
      name: 'useRecommendation',
      desc: '',
      args: [],
    );
  }

  /// `Search for branch by name`
  String get searchForBranchByName {
    return Intl.message(
      'Search for branch by name',
      name: 'searchForBranchByName',
      desc: '',
      args: [],
    );
  }

  /// `Manager`
  String get manager {
    return Intl.message('Manager', name: 'manager', desc: '', args: []);
  }

  /// `Available in branch`
  String get availableInBranch {
    return Intl.message(
      'Available in branch',
      name: 'availableInBranch',
      desc: '',
      args: [],
    );
  }

  /// `Store Details`
  String get storeDetails {
    return Intl.message(
      'Store Details',
      name: 'storeDetails',
      desc: '',
      args: [],
    );
  }

  /// `Distance`
  String get distance {
    return Intl.message('Distance', name: 'distance', desc: '', args: []);
  }

  /// `Response Rate`
  String get responseRate {
    return Intl.message(
      'Response Rate',
      name: 'responseRate',
      desc: '',
      args: [],
    );
  }

  /// `last Update`
  String get lastUpdate {
    return Intl.message('last Update', name: 'lastUpdate', desc: '', args: []);
  }

  /// `Select this store`
  String get selectThisStore {
    return Intl.message(
      'Select this store',
      name: 'selectThisStore',
      desc: '',
      args: [],
    );
  }

  /// `Filter Branch list by`
  String get filterBranchListBy {
    return Intl.message(
      'Filter Branch list by',
      name: 'filterBranchListBy',
      desc: '',
      args: [],
    );
  }

  /// `Availability`
  String get availability {
    return Intl.message(
      'Availability',
      name: 'availability',
      desc: '',
      args: [],
    );
  }

  /// `Show branches with at least 80% of requested items`
  String get showBranchesWithAtLeast80OfRequestedItems {
    return Intl.message(
      'Show branches with at least 80% of requested items',
      name: 'showBranchesWithAtLeast80OfRequestedItems',
      desc: '',
      args: [],
    );
  }

  /// `Response Time`
  String get responseTime {
    return Intl.message(
      'Response Time',
      name: 'responseTime',
      desc: '',
      args: [],
    );
  }

  /// `Branches that respond or fulfill requests quickly, ideal for urgent orders.`
  String get branchesThatRespondOrFulfillRequestsQuicklyIdealForUrgent {
    return Intl.message(
      'Branches that respond or fulfill requests quickly, ideal for urgent orders.',
      name: 'branchesThatRespondOrFulfillRequestsQuicklyIdealForUrgent',
      desc: '',
      args: [],
    );
  }

  /// `Fast (80% – 100%)`
  String get fast80100 {
    return Intl.message(
      'Fast (80% – 100%)',
      name: 'fast80100',
      desc: '',
      args: [],
    );
  }

  /// `Normal (50% – 80%)`
  String get normal5080 {
    return Intl.message(
      'Normal (50% – 80%)',
      name: 'normal5080',
      desc: '',
      args: [],
    );
  }

  /// `Slow Below 50%`
  String get slowBelow50 {
    return Intl.message(
      'Slow Below 50%',
      name: 'slowBelow50',
      desc: '',
      args: [],
    );
  }

  /// `60%`
  String get mod60 {
    return Intl.message('60%', name: 'mod60', desc: '', args: []);
  }

  /// `70%`
  String get mod70 {
    return Intl.message('70%', name: 'mod70', desc: '', args: []);
  }

  /// `80%`
  String get mod80 {
    return Intl.message('80%', name: 'mod80', desc: '', args: []);
  }

  /// `90%`
  String get mod90 {
    return Intl.message('90%', name: 'mod90', desc: '', args: []);
  }

  /// `100%`
  String get mod100 {
    return Intl.message('100%', name: 'mod100', desc: '', args: []);
  }

  /// `Only show branches within 5km`
  String get onlyShowBranchesWithin5km {
    return Intl.message(
      'Only show branches within 5km',
      name: 'onlyShowBranchesWithin5km',
      desc: '',
      args: [],
    );
  }

  /// `Km`
  String get km {
    return Intl.message('Km', name: 'km', desc: '', args: []);
  }

  /// `Mins`
  String get mins {
    return Intl.message('Mins', name: 'mins', desc: '', args: []);
  }

  /// `PK`
  String get pk {
    return Intl.message('PK', name: 'pk', desc: '', args: []);
  }

  /// `Request Justification`
  String get requestJustification {
    return Intl.message(
      'Request Justification',
      name: 'requestJustification',
      desc: '',
      args: [],
    );
  }

  /// `e.g Unexpected increase in demand during weekend holiday. Current stock insufficient for dinner rush period.`
  String get egUnexpectedIncreaseInDemandDuringWeekendHolidayCurrentStock {
    return Intl.message(
      'e.g Unexpected increase in demand during weekend holiday. Current stock insufficient for dinner rush period.',
      name: 'egUnexpectedIncreaseInDemandDuringWeekendHolidayCurrentStock',
      desc: '',
      args: [],
    );
  }

  /// `Normal`
  String get normal {
    return Intl.message('Normal', name: 'normal', desc: '', args: []);
  }

  /// `Request no`
  String get requestNo {
    return Intl.message('Request no', name: 'requestNo', desc: '', args: []);
  }

  /// `From`
  String get from {
    return Intl.message('From', name: 'from', desc: '', args: []);
  }

  /// `Requested by`
  String get requestedBy {
    return Intl.message(
      'Requested by',
      name: 'requestedBy',
      desc: '',
      args: [],
    );
  }

  /// `Request Date`
  String get requestDate {
    return Intl.message(
      'Request Date',
      name: 'requestDate',
      desc: '',
      args: [],
    );
  }

  /// `Product details`
  String get productDetails {
    return Intl.message(
      'Product details',
      name: 'productDetails',
      desc: '',
      args: [],
    );
  }

  /// `Requested Qty`
  String get requestedQty {
    return Intl.message(
      'Requested Qty',
      name: 'requestedQty',
      desc: '',
      args: [],
    );
  }

  /// `Available in`
  String get availableIn {
    return Intl.message(
      'Available in',
      name: 'availableIn',
      desc: '',
      args: [],
    );
  }

  /// `Balance after`
  String get balanceAfter {
    return Intl.message(
      'Balance after',
      name: 'balanceAfter',
      desc: '',
      args: [],
    );
  }

  /// `Quality grade`
  String get qualityGrade {
    return Intl.message(
      'Quality grade',
      name: 'qualityGrade',
      desc: '',
      args: [],
    );
  }

  /// `Expiry date`
  String get expiryDate {
    return Intl.message('Expiry date', name: 'expiryDate', desc: '', args: []);
  }

  /// `Cooling Status`
  String get coolingStatus {
    return Intl.message(
      'Cooling Status',
      name: 'coolingStatus',
      desc: '',
      args: [],
    );
  }

  /// `Transport details`
  String get transportDetails {
    return Intl.message(
      'Transport details',
      name: 'transportDetails',
      desc: '',
      args: [],
    );
  }

  /// `Method`
  String get method {
    return Intl.message('Method', name: 'method', desc: '', args: []);
  }

  /// `Estimated delivery time`
  String get estimatedDeliveryTime {
    return Intl.message(
      'Estimated delivery time',
      name: 'estimatedDeliveryTime',
      desc: '',
      args: [],
    );
  }

  /// `Driver`
  String get driver {
    return Intl.message('Driver', name: 'driver', desc: '', args: []);
  }

  /// `Temperature`
  String get temperature {
    return Intl.message('Temperature', name: 'temperature', desc: '', args: []);
  }

  /// `Submit Order`
  String get submitOrder {
    return Intl.message(
      'Submit Order',
      name: 'submitOrder',
      desc: '',
      args: [],
    );
  }

  /// `Purchasing Officer Benefits`
  String get purchasingOfficerBenefits {
    return Intl.message(
      'Purchasing Officer Benefits',
      name: 'purchasingOfficerBenefits',
      desc: '',
      args: [],
    );
  }

  /// `Premium trusted supplier relations`
  String get premiumTrustedSupplierRelations {
    return Intl.message(
      'Premium trusted supplier relations',
      name: 'premiumTrustedSupplierRelations',
      desc: '',
      args: [],
    );
  }

  /// `Coordinated delivery & quality assurance`
  String get coordinatedDeliveryQualityAssurance {
    return Intl.message(
      'Coordinated delivery & quality assurance',
      name: 'coordinatedDeliveryQualityAssurance',
      desc: '',
      args: [],
    );
  }

  /// `Priority supply during shortages`
  String get prioritySupplyDuringShortages {
    return Intl.message(
      'Priority supply during shortages',
      name: 'prioritySupplyDuringShortages',
      desc: '',
      args: [],
    );
  }

  /// `Total Expected Savings`
  String get totalExpectedSavings {
    return Intl.message(
      'Total Expected Savings',
      name: 'totalExpectedSavings',
      desc: '',
      args: [],
    );
  }

  /// `Preferred Delivery`
  String get preferredDelivery {
    return Intl.message(
      'Preferred Delivery',
      name: 'preferredDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Latest Delivery`
  String get latestDelivery {
    return Intl.message(
      'Latest Delivery',
      name: 'latestDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Quality`
  String get quality {
    return Intl.message('Quality', name: 'quality', desc: '', args: []);
  }

  /// `Special Instruction`
  String get specialInstruction {
    return Intl.message(
      'Special Instruction',
      name: 'specialInstruction',
      desc: '',
      args: [],
    );
  }

  /// `Price Comparison`
  String get priceComparison {
    return Intl.message(
      'Price Comparison',
      name: 'priceComparison',
      desc: '',
      args: [],
    );
  }

  /// `Direct Supplier`
  String get directSupplier {
    return Intl.message(
      'Direct Supplier',
      name: 'directSupplier',
      desc: '',
      args: [],
    );
  }

  /// `SAR`
  String get sar {
    return Intl.message('SAR', name: 'sar', desc: '', args: []);
  }

  /// `Via Purchasing Officer`
  String get viaPurchasingOfficer {
    return Intl.message(
      'Via Purchasing Officer',
      name: 'viaPurchasingOfficer',
      desc: '',
      args: [],
    );
  }

  /// `Savings`
  String get savings {
    return Intl.message('Savings', name: 'savings', desc: '', args: []);
  }

  /// `Order No`
  String get orderNo {
    return Intl.message('Order No', name: 'orderNo', desc: '', args: []);
  }

  /// `Online`
  String get online {
    return Intl.message('Online', name: 'online', desc: '', args: []);
  }

  /// `Message`
  String get message {
    return Intl.message('Message', name: 'message', desc: '', args: []);
  }

  /// `Contact Modes`
  String get contactModes {
    return Intl.message(
      'Contact Modes',
      name: 'contactModes',
      desc: '',
      args: [],
    );
  }

  /// `WhatsApp`
  String get whatsapp {
    return Intl.message('WhatsApp', name: 'whatsapp', desc: '', args: []);
  }

  /// `Text message with details link`
  String get textMessageWithDetailsLink {
    return Intl.message(
      'Text message with details link',
      name: 'textMessageWithDetailsLink',
      desc: '',
      args: [],
    );
  }

  /// `Preview Whatsapp Message`
  String get previewWhatsappMessage {
    return Intl.message(
      'Preview Whatsapp Message',
      name: 'previewWhatsappMessage',
      desc: '',
      args: [],
    );
  }

  /// `Send detailed PDF copy`
  String get sendDetailedPdfCopy {
    return Intl.message(
      'Send detailed PDF copy',
      name: 'sendDetailedPdfCopy',
      desc: '',
      args: [],
    );
  }

  /// `Preview Email PDF Message`
  String get previewEmailPdfMessage {
    return Intl.message(
      'Preview Email PDF Message',
      name: 'previewEmailPdfMessage',
      desc: '',
      args: [],
    );
  }

  /// `In-App Notification`
  String get inappNotification {
    return Intl.message(
      'In-App Notification',
      name: 'inappNotification',
      desc: '',
      args: [],
    );
  }

  /// `SMS (Backup)`
  String get smsBackup {
    return Intl.message('SMS (Backup)', name: 'smsBackup', desc: '', args: []);
  }

  /// `Multi Order Submitted`
  String get multiOrderSubmitted {
    return Intl.message(
      'Multi Order Submitted',
      name: 'multiOrderSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Track requests you submitted or received.`
  String get trackRequestsYouSubmittedOrReceived {
    return Intl.message(
      'Track requests you submitted or received.',
      name: 'trackRequestsYouSubmittedOrReceived',
      desc: '',
      args: [],
    );
  }

  /// `Multiple Sources`
  String get multipleSources {
    return Intl.message(
      'Multiple Sources',
      name: 'multipleSources',
      desc: '',
      args: [],
    );
  }

  /// `Sources`
  String get sources {
    return Intl.message('Sources', name: 'sources', desc: '', args: []);
  }

  /// `Justification`
  String get justification {
    return Intl.message(
      'Justification',
      name: 'justification',
      desc: '',
      args: [],
    );
  }

  /// `Unexpected increase in demand during weekend holiday. Current stock insufficient for dinner rush period.`
  String
  get unexpectedIncreaseInDemandDuringWeekendHolidayCurrentStockInsufficient {
    return Intl.message(
      'Unexpected increase in demand during weekend holiday. Current stock insufficient for dinner rush period.',
      name:
          'unexpectedIncreaseInDemandDuringWeekendHolidayCurrentStockInsufficient',
      desc: '',
      args: [],
    );
  }

  /// `Manage, Sort and view completed orders`
  String get manageSortAndViewCompletedOrders {
    return Intl.message(
      'Manage, Sort and view completed orders',
      name: 'manageSortAndViewCompletedOrders',
      desc: '',
      args: [],
    );
  }

  /// `e.g Beef Order`
  String get egBeefOrder {
    return Intl.message(
      'e.g Beef Order',
      name: 'egBeefOrder',
      desc: '',
      args: [],
    );
  }

  /// `No Approved Orders Yet`
  String get noApprovedOrdersYet {
    return Intl.message(
      'No Approved Orders Yet',
      name: 'noApprovedOrdersYet',
      desc: '',
      args: [],
    );
  }

  /// `None of your requests have been approved yet.`
  String get noneOfYourRequestsHaveBeenApprovedYet {
    return Intl.message(
      'None of your requests have been approved yet.',
      name: 'noneOfYourRequestsHaveBeenApprovedYet',
      desc: '',
      args: [],
    );
  }

  /// `Keep an eye out for updates or start a new request to begin.`
  String get keepAnEyeOutForUpdatesOrStartANew {
    return Intl.message(
      'Keep an eye out for updates or start a new request to begin.',
      name: 'keepAnEyeOutForUpdatesOrStartANew',
      desc: '',
      args: [],
    );
  }

  /// `Pending Orders`
  String get pendingOrders {
    return Intl.message(
      'Pending Orders',
      name: 'pendingOrders',
      desc: '',
      args: [],
    );
  }

  /// `Quick Links`
  String get quickLinks {
    return Intl.message('Quick Links', name: 'quickLinks', desc: '', args: []);
  }

  /// `Access all purchasing and goods-related actions in one view.`
  String get accessAllPurchasingAndGoodsrelatedActionsInOneView {
    return Intl.message(
      'Access all purchasing and goods-related actions in one view.',
      name: 'accessAllPurchasingAndGoodsrelatedActionsInOneView',
      desc: '',
      args: [],
    );
  }

  /// `Out of Stock`
  String get outOfStock {
    return Intl.message('Out of Stock', name: 'outOfStock', desc: '', args: []);
  }

  /// `Track Orders`
  String get trackOrders {
    return Intl.message(
      'Track Orders',
      name: 'trackOrders',
      desc: '',
      args: [],
    );
  }

  /// `Statistics/Analytics`
  String get statisticsanalytics {
    return Intl.message(
      'Statistics/Analytics',
      name: 'statisticsanalytics',
      desc: '',
      args: [],
    );
  }

  /// `Supplier Analysis and Comparison`
  String get supplierAnalysisAndComparison {
    return Intl.message(
      'Supplier Analysis and Comparison',
      name: 'supplierAnalysisAndComparison',
      desc: '',
      args: [],
    );
  }

  /// `Filter Purchase History list by`
  String get filterPurchaseHistoryListBy {
    return Intl.message(
      'Filter Purchase History list by',
      name: 'filterPurchaseHistoryListBy',
      desc: '',
      args: [],
    );
  }

  /// `Request Perspective`
  String get requestPerspective {
    return Intl.message(
      'Request Perspective',
      name: 'requestPerspective',
      desc: '',
      args: [],
    );
  }

  /// `I Submitted`
  String get iSubmitted {
    return Intl.message('I Submitted', name: 'iSubmitted', desc: '', args: []);
  }

  /// `I Received`
  String get iReceived {
    return Intl.message('I Received', name: 'iReceived', desc: '', args: []);
  }

  /// `Sort By Date`
  String get sortByDate {
    return Intl.message('Sort By Date', name: 'sortByDate', desc: '', args: []);
  }

  /// `Custom`
  String get custom {
    return Intl.message('Custom', name: 'custom', desc: '', args: []);
  }

  /// `Approve Request`
  String get approveRequest {
    return Intl.message(
      'Approve Request',
      name: 'approveRequest',
      desc: '',
      args: [],
    );
  }

  /// `Select one of the options below to approve this request.`
  String get selectOneOfTheOptionsBelowToApproveThisRequest {
    return Intl.message(
      'Select one of the options below to approve this request.',
      name: 'selectOneOfTheOptionsBelowToApproveThisRequest',
      desc: '',
      args: [],
    );
  }

  /// `Approve All`
  String get approveAll {
    return Intl.message('Approve All', name: 'approveAll', desc: '', args: []);
  }

  /// `All 3 requested products & Quantities will be approved, when you click `
  String get all3RequestedProductsQuantitiesWillBeApprovedWhenYou {
    return Intl.message(
      'All 3 requested products & Quantities will be approved, when you click ',
      name: 'all3RequestedProductsQuantitiesWillBeApprovedWhenYou',
      desc: '',
      args: [],
    );
  }

  /// `Partial approval`
  String get partialApproval {
    return Intl.message(
      'Partial approval',
      name: 'partialApproval',
      desc: '',
      args: [],
    );
  }

  /// `Choose what product quantities to approve`
  String get chooseWhatProductQuantitiesToApprove {
    return Intl.message(
      'Choose what product quantities to approve',
      name: 'chooseWhatProductQuantitiesToApprove',
      desc: '',
      args: [],
    );
  }

  /// `Reject All`
  String get rejectAll {
    return Intl.message('Reject All', name: 'rejectAll', desc: '', args: []);
  }

  /// `This request will be rejected when you click `
  String get thisRequestWillBeRejectedWhenYouClickConfirm {
    return Intl.message(
      'This request will be rejected when you click ',
      name: 'thisRequestWillBeRejectedWhenYouClickConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Choose when this order will be delivered:`
  String get chooseWhenThisOrderWillBeDelivered {
    return Intl.message(
      'Choose when this order will be delivered:',
      name: 'chooseWhenThisOrderWillBeDelivered',
      desc: '',
      args: [],
    );
  }

  /// `order will be ready in`
  String get orderWillBeReadyIn {
    return Intl.message(
      'order will be ready in',
      name: 'orderWillBeReadyIn',
      desc: '',
      args: [],
    );
  }

  /// `Change choice`
  String get changeChoice {
    return Intl.message(
      'Change choice',
      name: 'changeChoice',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Time`
  String get deliveryTime {
    return Intl.message(
      'Delivery Time',
      name: 'deliveryTime',
      desc: '',
      args: [],
    );
  }

  /// `Hr`
  String get hr {
    return Intl.message('Hr', name: 'hr', desc: '', args: []);
  }

  /// `Hrs`
  String get hrs {
    return Intl.message('Hrs', name: 'hrs', desc: '', args: []);
  }

  /// `Approve All Request`
  String get approveAllRequest {
    return Intl.message(
      'Approve All Request',
      name: 'approveAllRequest',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Request Approved`
  String get requestApproved {
    return Intl.message(
      'Request Approved',
      name: 'requestApproved',
      desc: '',
      args: [],
    );
  }

  /// `Transfer requester has been notified that the order will be delivered in 1 hr and stock balance has been updated.`
  String get transferRequesterHasBeenNotifiedThatTheOrderWillBe {
    return Intl.message(
      'Transfer requester has been notified that the order will be delivered in 1 hr and stock balance has been updated.',
      name: 'transferRequesterHasBeenNotifiedThatTheOrderWillBe',
      desc: '',
      args: [],
    );
  }

  /// `Original Requested Qty`
  String get originalRequestedQty {
    return Intl.message(
      'Original Requested Qty',
      name: 'originalRequestedQty',
      desc: '',
      args: [],
    );
  }

  /// `New Qty`
  String get newQty {
    return Intl.message('New Qty', name: 'newQty', desc: '', args: []);
  }

  /// `Our Current stock`
  String get ourCurrentStock {
    return Intl.message(
      'Our Current stock',
      name: 'ourCurrentStock',
      desc: '',
      args: [],
    );
  }

  /// `After Transfer`
  String get afterTransfer {
    return Intl.message(
      'After Transfer',
      name: 'afterTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Our Daily Consumption`
  String get ourDailyConsumption {
    return Intl.message(
      'Our Daily Consumption',
      name: 'ourDailyConsumption',
      desc: '',
      args: [],
    );
  }

  /// `Weekend Forecast`
  String get weekendForecast {
    return Intl.message(
      'Weekend Forecast',
      name: 'weekendForecast',
      desc: '',
      args: [],
    );
  }

  /// `Next Supply`
  String get nextSupply {
    return Intl.message('Next Supply', name: 'nextSupply', desc: '', args: []);
  }

  /// `Warning`
  String get warning {
    return Intl.message('Warning', name: 'warning', desc: '', args: []);
  }

  /// `Fulfilling this request will drop available stock below the minimum safe level of 75 kg.`
  String get fulfillingThisRequestWillDropAvailableStockBelowTheMinimum {
    return Intl.message(
      'Fulfilling this request will drop available stock below the minimum safe level of 75 kg.',
      name: 'fulfillingThisRequestWillDropAvailableStockBelowTheMinimum',
      desc: '',
      args: [],
    );
  }

  /// `Choose delivery Time`
  String get chooseDeliveryTime {
    return Intl.message(
      'Choose delivery Time',
      name: 'chooseDeliveryTime',
      desc: '',
      args: [],
    );
  }

  /// `Reject Request`
  String get rejectRequest {
    return Intl.message(
      'Reject Request',
      name: 'rejectRequest',
      desc: '',
      args: [],
    );
  }

  /// `You’re about to reject this transfer request from another branch. Please provide a reason so the requesting team can understand or make adjustments.`
  String get youreAboutToRejectThisTransferRequestFromAnotherBranch {
    return Intl.message(
      'You’re about to reject this transfer request from another branch. Please provide a reason so the requesting team can understand or make adjustments.',
      name: 'youreAboutToRejectThisTransferRequestFromAnotherBranch',
      desc: '',
      args: [],
    );
  }

  /// `Reason for Rejection`
  String get reasonForRejection {
    return Intl.message(
      'Reason for Rejection',
      name: 'reasonForRejection',
      desc: '',
      args: [],
    );
  }

  /// `e.g. Item unavailable, low stock, or not authorized for transfer.`
  String get egItemUnavailableLowStockOrNotAuthorizedForTransfer {
    return Intl.message(
      'e.g. Item unavailable, low stock, or not authorized for transfer.',
      name: 'egItemUnavailableLowStockOrNotAuthorizedForTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Reject`
  String get reject {
    return Intl.message('Reject', name: 'reject', desc: '', args: []);
  }

  /// `Manage requests and view history.`
  String get manageRequestsAndViewHistory {
    return Intl.message(
      'Manage requests and view history.',
      name: 'manageRequestsAndViewHistory',
      desc: '',
      args: [],
    );
  }

  /// `Branch custody balance`
  String get branchCustodyBalance {
    return Intl.message(
      'Branch custody balance',
      name: 'branchCustodyBalance',
      desc: '',
      args: [],
    );
  }

  /// `Personal Custody Balance`
  String get personalCustodyBalance {
    return Intl.message(
      'Personal Custody Balance',
      name: 'personalCustodyBalance',
      desc: '',
      args: [],
    );
  }

  /// `Total Cash In`
  String get totalCashIn {
    return Intl.message(
      'Total Cash In',
      name: 'totalCashIn',
      desc: '',
      args: [],
    );
  }

  /// `Total Cash Out`
  String get totalCashOut {
    return Intl.message(
      'Total Cash Out',
      name: 'totalCashOut',
      desc: '',
      args: [],
    );
  }

  /// `Recent Activities`
  String get recentActivities {
    return Intl.message(
      'Recent Activities',
      name: 'recentActivities',
      desc: '',
      args: [],
    );
  }

  /// `See All`
  String get seeAll {
    return Intl.message('See All', name: 'seeAll', desc: '', args: []);
  }

  /// `Recent Branch Custody Requests`
  String get recentBranchCustodyRequests {
    return Intl.message(
      'Recent Branch Custody Requests',
      name: 'recentBranchCustodyRequests',
      desc: '',
      args: [],
    );
  }

  /// `Transactions`
  String get transactions {
    return Intl.message(
      'Transactions',
      name: 'transactions',
      desc: '',
      args: [],
    );
  }

  /// `Cash Transfer & Handovers`
  String get cashTransferHandovers {
    return Intl.message(
      'Cash Transfer & Handovers',
      name: 'cashTransferHandovers',
      desc: '',
      args: [],
    );
  }

  /// `Request Cash-in`
  String get requestCashin {
    return Intl.message(
      'Request Cash-in',
      name: 'requestCashin',
      desc: '',
      args: [],
    );
  }

  /// `Ask owner to top-up branch custody balance`
  String get askOwnerToTopupBranchCustodyBalance {
    return Intl.message(
      'Ask owner to top-up branch custody balance',
      name: 'askOwnerToTopupBranchCustodyBalance',
      desc: '',
      args: [],
    );
  }

  /// `More Links`
  String get moreLinks {
    return Intl.message('More Links', name: 'moreLinks', desc: '', args: []);
  }

  /// `Balance Trends`
  String get balanceTrends {
    return Intl.message(
      'Balance Trends',
      name: 'balanceTrends',
      desc: '',
      args: [],
    );
  }

  /// `See daily, weekly or monthly details`
  String get seeDailyWeeklyOrMonthlyDetails {
    return Intl.message(
      'See daily, weekly or monthly details',
      name: 'seeDailyWeeklyOrMonthlyDetails',
      desc: '',
      args: [],
    );
  }

  /// `Expenses Logs`
  String get expensesLogs {
    return Intl.message(
      'Expenses Logs',
      name: 'expensesLogs',
      desc: '',
      args: [],
    );
  }

  /// `Track Pending, Approved or Rejected/returned logs`
  String get trackPendingApprovedOrRejectedreturnedLogs {
    return Intl.message(
      'Track Pending, Approved or Rejected/returned logs',
      name: 'trackPendingApprovedOrRejectedreturnedLogs',
      desc: '',
      args: [],
    );
  }

  /// `Transfer funds to Owner or branch custody balance`
  String get transferFundsToOwnerOrBranchCustodyBalance {
    return Intl.message(
      'Transfer funds to Owner or branch custody balance',
      name: 'transferFundsToOwnerOrBranchCustodyBalance',
      desc: '',
      args: [],
    );
  }

  /// `Transfer funds to a cashier to be recorded as an opening balance`
  String get transferFundsToACashierToBeRecordedAsAn {
    return Intl.message(
      'Transfer funds to a cashier to be recorded as an opening balance',
      name: 'transferFundsToACashierToBeRecordedAsAn',
      desc: '',
      args: [],
    );
  }

  /// `Custody Requests`
  String get custodyRequests {
    return Intl.message(
      'Custody Requests',
      name: 'custodyRequests',
      desc: '',
      args: [],
    );
  }

  /// `Manage, Sort and view details of requests`
  String get manageSortAndViewDetailsOfRequests {
    return Intl.message(
      'Manage, Sort and view details of requests',
      name: 'manageSortAndViewDetailsOfRequests',
      desc: '',
      args: [],
    );
  }

  /// `Filter Custody request list by:`
  String get filterCustodyRequestListBy {
    return Intl.message(
      'Filter Custody request list by:',
      name: 'filterCustodyRequestListBy',
      desc: '',
      args: [],
    );
  }

  /// `Recent Branch Custody Transactions`
  String get recentBranchCustodyTransactions {
    return Intl.message(
      'Recent Branch Custody Transactions',
      name: 'recentBranchCustodyTransactions',
      desc: '',
      args: [],
    );
  }

  /// `Custody Statement`
  String get custodyStatement {
    return Intl.message(
      'Custody Statement',
      name: 'custodyStatement',
      desc: '',
      args: [],
    );
  }

  /// `Sort and view details of transactions`
  String get sortAndViewDetailsOfTransactions {
    return Intl.message(
      'Sort and view details of transactions',
      name: 'sortAndViewDetailsOfTransactions',
      desc: '',
      args: [],
    );
  }

  /// `Filter Custody Statements list by:`
  String get filterCustodyStatementsListBy {
    return Intl.message(
      'Filter Custody Statements list by:',
      name: 'filterCustodyStatementsListBy',
      desc: '',
      args: [],
    );
  }

  /// `Bank Transfer`
  String get bankTransfer {
    return Intl.message(
      'Bank Transfer',
      name: 'bankTransfer',
      desc: '',
      args: [],
    );
  }

  /// `See all incoming and outgoing activity.`
  String get seeAllIncomingAndOutgoingActivity {
    return Intl.message(
      'See all incoming and outgoing activity.',
      name: 'seeAllIncomingAndOutgoingActivity',
      desc: '',
      args: [],
    );
  }

  /// `Daily`
  String get daily {
    return Intl.message('Daily', name: 'daily', desc: '', args: []);
  }

  /// `Detailed`
  String get detailed {
    return Intl.message('Detailed', name: 'detailed', desc: '', args: []);
  }

  /// `Export as PDF`
  String get exportAsPdf {
    return Intl.message(
      'Export as PDF',
      name: 'exportAsPdf',
      desc: '',
      args: [],
    );
  }

  /// `Export Account Statement`
  String get exportAccountStatement {
    return Intl.message(
      'Export Account Statement',
      name: 'exportAccountStatement',
      desc: '',
      args: [],
    );
  }

  /// `Choose your preferred file format and select a timeframe to download your account activity.`
  String get chooseYourPreferredFileFormatAndSelectATimeframeTo {
    return Intl.message(
      'Choose your preferred file format and select a timeframe to download your account activity.',
      name: 'chooseYourPreferredFileFormatAndSelectATimeframeTo',
      desc: '',
      args: [],
    );
  }

  /// `Export Format`
  String get exportFormat {
    return Intl.message(
      'Export Format',
      name: 'exportFormat',
      desc: '',
      args: [],
    );
  }

  /// `Daily View`
  String get dailyView {
    return Intl.message('Daily View', name: 'dailyView', desc: '', args: []);
  }

  /// `Detailed View`
  String get detailedView {
    return Intl.message(
      'Detailed View',
      name: 'detailedView',
      desc: '',
      args: [],
    );
  }

  /// `Export Time Frame`
  String get exportTimeFrame {
    return Intl.message(
      'Export Time Frame',
      name: 'exportTimeFrame',
      desc: '',
      args: [],
    );
  }

  /// `Last 6 Months`
  String get last6Months {
    return Intl.message(
      'Last 6 Months',
      name: 'last6Months',
      desc: '',
      args: [],
    );
  }

  /// `Filter Transaction history by:`
  String get filterTransactionHistoryBy {
    return Intl.message(
      'Filter Transaction history by:',
      name: 'filterTransactionHistoryBy',
      desc: '',
      args: [],
    );
  }

  /// `Custody Request form`
  String get custodyRequestForm {
    return Intl.message(
      'Custody Request form',
      name: 'custodyRequestForm',
      desc: '',
      args: [],
    );
  }

  /// `Request funds from the Store Owner to replenish your custody balance.`
  String get requestFundsFromTheStoreOwnerToReplenishYourCustody {
    return Intl.message(
      'Request funds from the Store Owner to replenish your custody balance.',
      name: 'requestFundsFromTheStoreOwnerToReplenishYourCustody',
      desc: '',
      args: [],
    );
  }

  /// `Requested Amount`
  String get requestedAmount {
    return Intl.message(
      'Requested Amount',
      name: 'requestedAmount',
      desc: '',
      args: [],
    );
  }

  /// `How much do you want?`
  String get howMuchDoYouWant {
    return Intl.message(
      'How much do you want?',
      name: 'howMuchDoYouWant',
      desc: '',
      args: [],
    );
  }

  /// `e.g Replenish custody for daily expenses`
  String get egReplenishCustodyForDailyExpenses {
    return Intl.message(
      'e.g Replenish custody for daily expenses',
      name: 'egReplenishCustodyForDailyExpenses',
      desc: '',
      args: [],
    );
  }

  /// `Preferred Receipt Method`
  String get preferredReceiptMethod {
    return Intl.message(
      'Preferred Receipt Method',
      name: 'preferredReceiptMethod',
      desc: '',
      args: [],
    );
  }

  /// `( e.g previous expense report)`
  String get egPreviousExpenseReport {
    return Intl.message(
      '( e.g previous expense report)',
      name: 'egPreviousExpenseReport',
      desc: '',
      args: [],
    );
  }

  /// `Additional Notes`
  String get additionalNotes {
    return Intl.message(
      'Additional Notes',
      name: 'additionalNotes',
      desc: '',
      args: [],
    );
  }

  /// `Add any details regarding this request`
  String get addAnyDetailsRegardingThisRequest {
    return Intl.message(
      'Add any details regarding this request',
      name: 'addAnyDetailsRegardingThisRequest',
      desc: '',
      args: [],
    );
  }

  /// `Handover To Custody/Owner`
  String get handoverToCustodyowner {
    return Intl.message(
      'Handover To Custody/Owner',
      name: 'handoverToCustodyowner',
      desc: '',
      args: [],
    );
  }

  /// `Handover To Cashier`
  String get handoverToCashier {
    return Intl.message(
      'Handover To Cashier',
      name: 'handoverToCashier',
      desc: '',
      args: [],
    );
  }

  /// `Submit Request`
  String get submitRequest {
    return Intl.message(
      'Submit Request',
      name: 'submitRequest',
      desc: '',
      args: [],
    );
  }

  /// `Add file`
  String get addFile {
    return Intl.message('Add file', name: 'addFile', desc: '', args: []);
  }

  /// `Request Submitted`
  String get requestSubmitted {
    return Intl.message(
      'Request Submitted',
      name: 'requestSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `You’ve requested [Amount] from the Store Owner. Waiting for approval.`
  String get youveRequestedAmountFromTheStoreOwnerWaitingForApproval {
    return Intl.message(
      'You’ve requested [Amount] from the Store Owner. Waiting for approval.',
      name: 'youveRequestedAmountFromTheStoreOwnerWaitingForApproval',
      desc: '',
      args: [],
    );
  }

  /// `cash Transfer to Custody`
  String get cashTransferToCustody {
    return Intl.message(
      'cash Transfer to Custody',
      name: 'cashTransferToCustody',
      desc: '',
      args: [],
    );
  }

  /// `Transfer from your personal custody to the branch custody to fund upcoming expenses.`
  String get transferFromYourPersonalCustodyToTheBranchCustodyTo {
    return Intl.message(
      'Transfer from your personal custody to the branch custody to fund upcoming expenses.',
      name: 'transferFromYourPersonalCustodyToTheBranchCustodyTo',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Amount`
  String get transferAmount {
    return Intl.message(
      'Transfer Amount',
      name: 'transferAmount',
      desc: '',
      args: [],
    );
  }

  /// `Transfer All`
  String get transferAll {
    return Intl.message(
      'Transfer All',
      name: 'transferAll',
      desc: '',
      args: [],
    );
  }

  /// `Transfer`
  String get transfer {
    return Intl.message('Transfer', name: 'transfer', desc: '', args: []);
  }

  /// `Transfer Completed`
  String get transferCompleted {
    return Intl.message(
      'Transfer Completed',
      name: 'transferCompleted',
      desc: '',
      args: [],
    );
  }

  /// `You’ve successfully transferred {Amount} to Branch Custody.`
  String youveSuccessfullyTransferredAmountToBranchCustody(Object Amount) {
    return Intl.message(
      'You’ve successfully transferred $Amount to Branch Custody.',
      name: 'youveSuccessfullyTransferredAmountToBranchCustody',
      desc: '',
      args: [Amount],
    );
  }

  /// `Both balances have been updated accordingly.`
  String get bothBalancesHaveBeenUpdatedAccordingly {
    return Intl.message(
      'Both balances have been updated accordingly.',
      name: 'bothBalancesHaveBeenUpdatedAccordingly',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Handover`
  String get confirmHandover {
    return Intl.message(
      'Confirm Handover',
      name: 'confirmHandover',
      desc: '',
      args: [],
    );
  }

  /// `Confirm who will receive the cash and amount`
  String get confirmWhoWillReceiveTheCashAndAmount {
    return Intl.message(
      'Confirm who will receive the cash and amount',
      name: 'confirmWhoWillReceiveTheCashAndAmount',
      desc: '',
      args: [],
    );
  }

  /// `Who are you handing over to?`
  String get whoAreYouHandingOverTo {
    return Intl.message(
      'Who are you handing over to?',
      name: 'whoAreYouHandingOverTo',
      desc: '',
      args: [],
    );
  }

  /// `Handover Amount`
  String get handoverAmount {
    return Intl.message(
      'Handover Amount',
      name: 'handoverAmount',
      desc: '',
      args: [],
    );
  }

  /// `Optional Notes...`
  String get optionalNotes {
    return Intl.message(
      'Optional Notes...',
      name: 'optionalNotes',
      desc: '',
      args: [],
    );
  }

  /// `This could be the next Store Owner, Brand Manager or Branch Custody Balance.`
  String get thisCouldBeTheNextStoreOwnerBrandManagerOr {
    return Intl.message(
      'This could be the next Store Owner, Brand Manager or Branch Custody Balance.',
      name: 'thisCouldBeTheNextStoreOwnerBrandManagerOr',
      desc: '',
      args: [],
    );
  }

  /// `No Approval Required`
  String get noApprovalRequired {
    return Intl.message(
      'No Approval Required',
      name: 'noApprovalRequired',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Recipient`
  String get confirmRecipient {
    return Intl.message(
      'Confirm Recipient',
      name: 'confirmRecipient',
      desc: '',
      args: [],
    );
  }

  /// `Handover Method`
  String get handoverMethod {
    return Intl.message(
      'Handover Method',
      name: 'handoverMethod',
      desc: '',
      args: [],
    );
  }

  /// `Recipient`
  String get recipient {
    return Intl.message('Recipient', name: 'recipient', desc: '', args: []);
  }

  /// `All Branches`
  String get allBranches {
    return Intl.message(
      'All Branches',
      name: 'allBranches',
      desc: '',
      args: [],
    );
  }

  /// `Choose the branch for this order request`
  String get chooseTheBranchForThisOrderRequest {
    return Intl.message(
      'Choose the branch for this order request',
      name: 'chooseTheBranchForThisOrderRequest',
      desc: '',
      args: [],
    );
  }

  /// `Search for suppliers by name`
  String get searchForSuppliersByName {
    return Intl.message(
      'Search for suppliers by name',
      name: 'searchForSuppliersByName',
      desc: '',
      args: [],
    );
  }

  /// `All Suppliers`
  String get allSuppliers {
    return Intl.message(
      'All Suppliers',
      name: 'allSuppliers',
      desc: '',
      args: [],
    );
  }

  /// `Choose supplier for this order request`
  String get chooseSupplierForThisOrderRequest {
    return Intl.message(
      'Choose supplier for this order request',
      name: 'chooseSupplierForThisOrderRequest',
      desc: '',
      args: [],
    );
  }

  /// `When Would You Like It Delivered`
  String get whenWouldYouLikeItDelivered {
    return Intl.message(
      'When Would You Like It Delivered',
      name: 'whenWouldYouLikeItDelivered',
      desc: '',
      args: [],
    );
  }

  /// `Complete Request details form below`
  String get completeRequestDetailsFormBelow {
    return Intl.message(
      'Complete Request details form below',
      name: 'completeRequestDetailsFormBelow',
      desc: '',
      args: [],
    );
  }

  /// `What\'s the final delivery date you can accept`
  String get whatsTheFinalDeliveryDateYouCanAccept {
    return Intl.message(
      'What\\\'s the final delivery date you can accept',
      name: 'whatsTheFinalDeliveryDateYouCanAccept',
      desc: '',
      args: [],
    );
  }

  /// `Special Instructions`
  String get specialInstructions {
    return Intl.message(
      'Special Instructions',
      name: 'specialInstructions',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Details`
  String get confirmDetails {
    return Intl.message(
      'Confirm Details',
      name: 'confirmDetails',
      desc: '',
      args: [],
    );
  }

  /// `Available On:`
  String get availableOn {
    return Intl.message(
      'Available On:',
      name: 'availableOn',
      desc: '',
      args: [],
    );
  }

  /// `Select This Supplier`
  String get selectThisSupplier {
    return Intl.message(
      'Select This Supplier',
      name: 'selectThisSupplier',
      desc: '',
      args: [],
    );
  }

  /// `Filter Suppliers List By:`
  String get filterSuppliersListBy {
    return Intl.message(
      'Filter Suppliers List By:',
      name: 'filterSuppliersListBy',
      desc: '',
      args: [],
    );
  }

  /// `Away`
  String get away {
    return Intl.message('Away', name: 'away', desc: '', args: []);
  }

  /// `Offline`
  String get offline {
    return Intl.message('Offline', name: 'offline', desc: '', args: []);
  }

  /// `Processing Time`
  String get processingTime {
    return Intl.message(
      'Processing Time',
      name: 'processingTime',
      desc: '',
      args: [],
    );
  }

  /// `Standard`
  String get standard {
    return Intl.message('Standard', name: 'standard', desc: '', args: []);
  }

  /// `Urgent`
  String get urgent {
    return Intl.message('Urgent', name: 'urgent', desc: '', args: []);
  }

  /// `Grade`
  String get grade {
    return Intl.message('Grade', name: 'grade', desc: '', args: []);
  }

  /// `Economy`
  String get economy {
    return Intl.message('Economy', name: 'economy', desc: '', args: []);
  }

  /// `Premium`
  String get premium {
    return Intl.message('Premium', name: 'premium', desc: '', args: []);
  }

  /// `Piece`
  String get piece {
    return Intl.message('Piece', name: 'piece', desc: '', args: []);
  }

  /// `Sk`
  String get sk {
    return Intl.message('Sk', name: 'sk', desc: '', args: []);
  }

  /// `Liter`
  String get liter {
    return Intl.message('Liter', name: 'liter', desc: '', args: []);
  }

  /// `Bottle`
  String get bottle {
    return Intl.message('Bottle', name: 'bottle', desc: '', args: []);
  }

  /// `Pg`
  String get pg {
    return Intl.message('Pg', name: 'pg', desc: '', args: []);
  }

  /// `Associated Items`
  String get associatedItems {
    return Intl.message(
      'Associated Items',
      name: 'associatedItems',
      desc: '',
      args: [],
    );
  }

  /// `Transfer From`
  String get transferFrom {
    return Intl.message(
      'Transfer From',
      name: 'transferFrom',
      desc: '',
      args: [],
    );
  }

  /// `Me`
  String get me {
    return Intl.message('Me', name: 'me', desc: '', args: []);
  }

  /// `Internal Transfer (No Cost)`
  String get internalTransferNoCost {
    return Intl.message(
      'Internal Transfer (No Cost)',
      name: 'internalTransferNoCost',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Ready`
  String get transferReady {
    return Intl.message(
      'Transfer Ready',
      name: 'transferReady',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Not Ready`
  String get transferNotReady {
    return Intl.message(
      'Transfer Not Ready',
      name: 'transferNotReady',
      desc: '',
      args: [],
    );
  }

  /// `Away, Notifications Active`
  String get awayNotificationsActive {
    return Intl.message(
      'Away, Notifications Active',
      name: 'awayNotificationsActive',
      desc: '',
      args: [],
    );
  }

  /// `Order via Supplier`
  String get orderViaSupplier {
    return Intl.message(
      'Order via Supplier',
      name: 'orderViaSupplier',
      desc: '',
      args: [],
    );
  }

  /// `How Should supplier be notified`
  String get howShouldSupplierBeNotified {
    return Intl.message(
      'How Should supplier be notified',
      name: 'howShouldSupplierBeNotified',
      desc: '',
      args: [],
    );
  }

  /// `Backup`
  String get backup {
    return Intl.message('Backup', name: 'backup', desc: '', args: []);
  }

  /// `In-App Notification`
  String get inAppNotification {
    return Intl.message(
      'In-App Notification',
      name: 'inAppNotification',
      desc: '',
      args: [],
    );
  }

  /// `SMS`
  String get sms {
    return Intl.message('SMS', name: 'sms', desc: '', args: []);
  }

  /// `Suppliers will receive instant notifications in the app`
  String get supplWil {
    return Intl.message(
      'Suppliers will receive instant notifications in the app',
      name: 'supplWil',
      desc: '',
      args: [],
    );
  }

  /// `Short text message quick alert`
  String get shortTextMessageQuickAlert {
    return Intl.message(
      'Short text message quick alert',
      name: 'shortTextMessageQuickAlert',
      desc: '',
      args: [],
    );
  }

  /// `Order Submitted`
  String get orderSubmitted {
    return Intl.message(
      'Order Submitted',
      name: 'orderSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Your order request has been added to your records.`
  String get orderSubmittedDesc {
    return Intl.message(
      'Your order request has been added to your records.',
      name: 'orderSubmittedDesc',
      desc: '',
      args: [],
    );
  }

  /// `You’ll be notified once it’s reviewed or approved.`
  String get orderSubmittedDesc2 {
    return Intl.message(
      'You’ll be notified once it’s reviewed or approved.',
      name: 'orderSubmittedDesc2',
      desc: '',
      args: [],
    );
  }

  /// `Handovers`
  String get handovers {
    return Intl.message('Handovers', name: 'handovers', desc: '', args: []);
  }

  /// `Orders`
  String get orders {
    return Intl.message('Orders', name: 'orders', desc: '', args: []);
  }

  /// `Variances`
  String get variances {
    return Intl.message('Variances', name: 'variances', desc: '', args: []);
  }

  /// `Items Required`
  String get itemsRequired {
    return Intl.message(
      'Items Required',
      name: 'itemsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Closed`
  String get closed {
    return Intl.message('Closed', name: 'closed', desc: '', args: []);
  }

  /// `Confirmed`
  String get confirmed {
    return Intl.message('Confirmed', name: 'confirmed', desc: '', args: []);
  }

  /// `Canceled`
  String get canceled {
    return Intl.message('Canceled', name: 'canceled', desc: '', args: []);
  }

  /// `Partial Confirmation`
  String get partialConfirmation {
    return Intl.message(
      'Partial Confirmation',
      name: 'partialConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong. Please try again later.`
  String get somethingWentWrongPleaseTryAgain {
    return Intl.message(
      'Something went wrong. Please try again later.',
      name: 'somethingWentWrongPleaseTryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Last 3 Months`
  String get last3Months {
    return Intl.message(
      'Last 3 Months',
      name: 'last3Months',
      desc: '',
      args: [],
    );
  }

  /// `Days`
  String get days {
    return Intl.message('Days', name: 'days', desc: '', args: []);
  }

  /// `Branch Manager`
  String get branchManager {
    return Intl.message(
      'Branch Manager',
      name: 'branchManager',
      desc: '',
      args: [],
    );
  }

  /// `Other Supplier`
  String get otherSupplier {
    return Intl.message(
      'Other Supplier',
      name: 'otherSupplier',
      desc: '',
      args: [],
    );
  }

  /// `No Source To Choose`
  String get noSourceToChoose {
    return Intl.message(
      'No Source To Choose',
      name: 'noSourceToChoose',
      desc: '',
      args: [],
    );
  }

  /// `Partial Approved`
  String get partialApproved {
    return Intl.message(
      'Partial Approved',
      name: 'partialApproved',
      desc: '',
      args: [],
    );
  }

  /// `Fully Approved`
  String get fullyApproved {
    return Intl.message(
      'Fully Approved',
      name: 'fullyApproved',
      desc: '',
      args: [],
    );
  }

  /// `Order Transfer Request`
  String get orderTransferRequest {
    return Intl.message(
      'Order Transfer Request',
      name: 'orderTransferRequest',
      desc: '',
      args: [],
    );
  }

  /// `Hours`
  String get hours {
    return Intl.message('Hours', name: 'hours', desc: '', args: []);
  }

  /// `Not Ready`
  String get notReady {
    return Intl.message('Not Ready', name: 'notReady', desc: '', args: []);
  }

  /// `No Source`
  String get noSource {
    return Intl.message('No Source', name: 'noSource', desc: '', args: []);
  }

  /// `No Date Available`
  String get noDateAvailable {
    return Intl.message(
      'No Date Available',
      name: 'noDateAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Partial Confirmed`
  String get partialConfirmed {
    return Intl.message(
      'Partial Confirmed',
      name: 'partialConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `We have enough stock to fulfill this request without going below the safe threshold.`
  String get safeStockLevelMaintained {
    return Intl.message(
      'We have enough stock to fulfill this request without going below the safe threshold.',
      name: 'safeStockLevelMaintained',
      desc: '',
      args: [],
    );
  }

  /// `Stock Level`
  String get stockLevel {
    return Intl.message('Stock Level', name: 'stockLevel', desc: '', args: []);
  }

  /// `Healthy`
  String get helthy {
    return Intl.message('Healthy', name: 'helthy', desc: '', args: []);
  }

  /// `Transfer Request Rejected`
  String get transferRequestRejected {
    return Intl.message(
      'Transfer Request Rejected',
      name: 'transferRequestRejected',
      desc: '',
      args: [],
    );
  }

  /// `You’ve successfully rejected the request. Your reason has been shared with the requesting branch. No further action is required unless they resubmit.`
  String get transferRequestRejectedDesc {
    return Intl.message(
      'You’ve successfully rejected the request. Your reason has been shared with the requesting branch. No further action is required unless they resubmit.',
      name: 'transferRequestRejectedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Approve Pending quantity Balances`
  String get approvePendingQuantityBalances {
    return Intl.message(
      'Approve Pending quantity Balances',
      name: 'approvePendingQuantityBalances',
      desc: '',
      args: [],
    );
  }

  /// `Submitted By Me`
  String get submittedByMe {
    return Intl.message(
      'Submitted By Me',
      name: 'submittedByMe',
      desc: '',
      args: [],
    );
  }

  /// `Purchase request details`
  String get purchaseRequestDetails {
    return Intl.message(
      'Purchase request details',
      name: 'purchaseRequestDetails',
      desc: '',
      args: [],
    );
  }

  /// `View every action and update made to this request, from creation to final approval.`
  String
  get viewEveryActionAndUpdateMadeToThisRequestFromCreationToFinalApproval {
    return Intl.message(
      'View every action and update made to this request, from creation to final approval.',
      name:
          'viewEveryActionAndUpdateMadeToThisRequestFromCreationToFinalApproval',
      desc: '',
      args: [],
    );
  }

  /// `Canceled by Branch`
  String get canceledByBranch {
    return Intl.message(
      'Canceled by Branch',
      name: 'canceledByBranch',
      desc: '',
      args: [],
    );
  }

  /// `Canceled by Supplier`
  String get canceledBySupplier {
    return Intl.message(
      'Canceled by Supplier',
      name: 'canceledBySupplier',
      desc: '',
      args: [],
    );
  }

  /// `Cancel this item`
  String get cancelThisItem {
    return Intl.message(
      'Cancel this item',
      name: 'cancelThisItem',
      desc: '',
      args: [],
    );
  }

  /// `Duplicate & Change Source`
  String get duplicateAndChangeSource {
    return Intl.message(
      'Duplicate & Change Source',
      name: 'duplicateAndChangeSource',
      desc: '',
      args: [],
    );
  }

  /// `Cancellation Details`
  String get cancellationDetails {
    return Intl.message(
      'Cancellation Details',
      name: 'cancellationDetails',
      desc: '',
      args: [],
    );
  }

  /// `This item was canceled. As a result, it has been voided and will not be processed further.`
  String
  get thisItemWasCanceledAsAResultItHasBeenVoidedAndWillNotBeProcessedFurther {
    return Intl.message(
      'This item was canceled. As a result, it has been voided and will not be processed further.',
      name:
          'thisItemWasCanceledAsAResultItHasBeenVoidedAndWillNotBeProcessedFurther',
      desc: '',
      args: [],
    );
  }

  /// `Review Modification`
  String get reviewModification {
    return Intl.message(
      'Review Modification',
      name: 'reviewModification',
      desc: '',
      args: [],
    );
  }

  /// `Modification Details`
  String get modificationDetails {
    return Intl.message(
      'Modification Details',
      name: 'modificationDetails',
      desc: '',
      args: [],
    );
  }

  /// `Compare Between Original order Vs new Proposal`
  String get compareOriginalVsProposal {
    return Intl.message(
      'Compare Between Original order Vs new Proposal',
      name: 'compareOriginalVsProposal',
      desc: '',
      args: [],
    );
  }

  /// `Supplier modified this item, pending your  approval`
  String get supplierModifiedThisItemPendingYourApproval {
    return Intl.message(
      'Supplier modified this item, pending your  approval',
      name: 'supplierModifiedThisItemPendingYourApproval',
      desc: '',
      args: [],
    );
  }

  /// `Original Order`
  String get originalOrder {
    return Intl.message(
      'Original Order',
      name: 'originalOrder',
      desc: '',
      args: [],
    );
  }

  /// `Supplier’s Proposal`
  String get suppliersProposal {
    return Intl.message(
      'Supplier’s Proposal',
      name: 'suppliersProposal',
      desc: '',
      args: [],
    );
  }

  /// `Modification Notes`
  String get modificationNotes {
    return Intl.message(
      'Modification Notes',
      name: 'modificationNotes',
      desc: '',
      args: [],
    );
  }

  /// `Modified Total`
  String get modifiedTotal {
    return Intl.message(
      'Modified Total',
      name: 'modifiedTotal',
      desc: '',
      args: [],
    );
  }

  /// `Difference`
  String get difference {
    return Intl.message('Difference', name: 'difference', desc: '', args: []);
  }

  /// `Proposed Qty`
  String get proposedQty {
    return Intl.message(
      'Proposed Qty',
      name: 'proposedQty',
      desc: '',
      args: [],
    );
  }

  /// `Shortage`
  String get shortage {
    return Intl.message('Shortage', name: 'shortage', desc: '', args: []);
  }

  /// `Original`
  String get original {
    return Intl.message('Original', name: 'original', desc: '', args: []);
  }

  /// `New`
  String get new_n {
    return Intl.message('New', name: 'new_n', desc: '', args: []);
  }

  /// `Reject this quantity update`
  String get rejectQtyUpdate {
    return Intl.message(
      'Reject this quantity update',
      name: 'rejectQtyUpdate',
      desc: '',
      args: [],
    );
  }

  /// `This will cancel the item from the order, stopping processing and preventing the supplier from delivering it.`
  String get rejectQtyUpdateDesc {
    return Intl.message(
      'This will cancel the item from the order, stopping processing and preventing the supplier from delivering it.',
      name: 'rejectQtyUpdateDesc',
      desc: '',
      args: [],
    );
  }

  /// `Reject Modification`
  String get rejectModification {
    return Intl.message(
      'Reject Modification',
      name: 'rejectModification',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Date`
  String get deliveryDate {
    return Intl.message(
      'Delivery Date',
      name: 'deliveryDate',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Details`
  String get deliveryDetails {
    return Intl.message(
      'Delivery Details',
      name: 'deliveryDetails',
      desc: '',
      args: [],
    );
  }

  /// `Qty To deliver`
  String get qtyToDeliver {
    return Intl.message(
      'Qty To deliver',
      name: 'qtyToDeliver',
      desc: '',
      args: [],
    );
  }

  /// `New Delivery Date`
  String get newDeliveryDate {
    return Intl.message(
      'New Delivery Date',
      name: 'newDeliveryDate',
      desc: '',
      args: [],
    );
  }

  /// `Reject this request for extra time`
  String get rejectExtraTimeRequest {
    return Intl.message(
      'Reject this request for extra time',
      name: 'rejectExtraTimeRequest',
      desc: '',
      args: [],
    );
  }

  /// `Reject this alternative`
  String get rejectAlternative {
    return Intl.message(
      'Reject this alternative',
      name: 'rejectAlternative',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Approval`
  String get confirmApproval {
    return Intl.message(
      'Confirm Approval',
      name: 'confirmApproval',
      desc: '',
      args: [],
    );
  }

  /// `You’re approving the requested quantity for this item with no changes.`
  String get youreApprovingTheRequestedQuantityForThisItemWithNo {
    return Intl.message(
      'You’re approving the requested quantity for this item with no changes.',
      name: 'youreApprovingTheRequestedQuantityForThisItemWithNo',
      desc: '',
      args: [],
    );
  }

  /// `Once confirmed, the supplier will be notified and can begin processing the item.`
  String get onceConfirmedTheSupplierWillBeNotifiedAndCanBegin {
    return Intl.message(
      'Once confirmed, the supplier will be notified and can begin processing the item.',
      name: 'onceConfirmedTheSupplierWillBeNotifiedAndCanBegin',
      desc: '',
      args: [],
    );
  }

  /// `Confirm & Approve Item`
  String get confirmApproveItem {
    return Intl.message(
      'Confirm & Approve Item',
      name: 'confirmApproveItem',
      desc: '',
      args: [],
    );
  }

  /// `Edit the order details from Riyadh Branch - Malqa`
  String get editTheOrderDetailsFromRiyadhBranchMalqa {
    return Intl.message(
      'Edit the order details from Riyadh Branch - Malqa',
      name: 'editTheOrderDetailsFromRiyadhBranchMalqa',
      desc: '',
      args: [],
    );
  }

  /// `Edit the quantity you can supply, then review and submit it for approval by the requesting branch.`
  String get editTheQuantityYouCanSupplyThenReviewAndSubmit {
    return Intl.message(
      'Edit the quantity you can supply, then review and submit it for approval by the requesting branch.',
      name: 'editTheQuantityYouCanSupplyThenReviewAndSubmit',
      desc: '',
      args: [],
    );
  }

  /// `New Proposal`
  String get newProposal {
    return Intl.message(
      'New Proposal',
      name: 'newProposal',
      desc: '',
      args: [],
    );
  }

  /// `e.g Sorry for beef shortage due to high demand this week. We can provide 180 kg now.`
  String get egSorryForBeefShortageDueToHighDemandThis {
    return Intl.message(
      'e.g Sorry for beef shortage due to high demand this week. We can provide 180 kg now.',
      name: 'egSorryForBeefShortageDueToHighDemandThis',
      desc: '',
      args: [],
    );
  }

  /// `Re-review`
  String get rereview {
    return Intl.message('Re-review', name: 'rereview', desc: '', args: []);
  }

  /// `Modification Summary`
  String get modificationSummary {
    return Intl.message(
      'Modification Summary',
      name: 'modificationSummary',
      desc: '',
      args: [],
    );
  }

  /// `Send Modification`
  String get sendModification {
    return Intl.message(
      'Send Modification',
      name: 'sendModification',
      desc: '',
      args: [],
    );
  }

  /// `Modification Submitted`
  String get modificationSubmitted {
    return Intl.message(
      'Modification Submitted',
      name: 'modificationSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `You have modification request has been submitted.  Riyadh Branch - Malqa Branch manager will review and let you know.`
  String get youHaveModificationRequestHasBeenSubmittedRiyadhBranchMalqa {
    return Intl.message(
      'You have modification request has been submitted.  Riyadh Branch - Malqa Branch manager will review and let you know.',
      name: 'youHaveModificationRequestHasBeenSubmittedRiyadhBranchMalqa',
      desc: '',
      args: [],
    );
  }

  /// `See Order Details & Modification`
  String get seeOrderDetailsModification {
    return Intl.message(
      'See Order Details & Modification',
      name: 'seeOrderDetailsModification',
      desc: '',
      args: [],
    );
  }

  /// `View Modification Details`
  String get viewModificationDetails {
    return Intl.message(
      'View Modification Details',
      name: 'viewModificationDetails',
      desc: '',
      args: [],
    );
  }

  /// `Order Rejected`
  String get orderRejected {
    return Intl.message(
      'Order Rejected',
      name: 'orderRejected',
      desc: '',
      args: [],
    );
  }

  /// `Item Cancelled`
  String get itemCancelled {
    return Intl.message(
      'Item Cancelled',
      name: 'itemCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Order Rejected by Branch`
  String get orderRejectedByBranch {
    return Intl.message(
      'Order Rejected by Branch',
      name: 'orderRejectedByBranch',
      desc: '',
      args: [],
    );
  }

  /// `Original delivery date`
  String get originalDeliveryDate {
    return Intl.message(
      'Original delivery date',
      name: 'originalDeliveryDate',
      desc: '',
      args: [],
    );
  }

  /// `Choose how soon you can restock and deliver the full quantity. This timeline will be sent to the buyer for approval.`
  String get chooseHowSoonYouCanRestockAndDeliverTheFull {
    return Intl.message(
      'Choose how soon you can restock and deliver the full quantity. This timeline will be sent to the buyer for approval.',
      name: 'chooseHowSoonYouCanRestockAndDeliverTheFull',
      desc: '',
      args: [],
    );
  }

  /// `Similar Items`
  String get similarItems {
    return Intl.message(
      'Similar Items',
      name: 'similarItems',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for Buyer’s Approval`
  String get waitingForBuyersApproval {
    return Intl.message(
      'Waiting for Buyer’s Approval',
      name: 'waitingForBuyersApproval',
      desc: '',
      args: [],
    );
  }

  /// `Pending Your Approval`
  String get pendingYourApproval {
    return Intl.message(
      'Pending Your Approval',
      name: 'pendingYourApproval',
      desc: '',
      args: [],
    );
  }

  /// `Re-review Replacement`
  String get rereviewReplacement {
    return Intl.message(
      'Re-review Replacement',
      name: 'rereviewReplacement',
      desc: '',
      args: [],
    );
  }

  /// `Your proposal`
  String get yourProposal {
    return Intl.message(
      'Your proposal',
      name: 'yourProposal',
      desc: '',
      args: [],
    );
  }

  /// `New Quantity`
  String get newQuantity {
    return Intl.message(
      'New Quantity',
      name: 'newQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Modified On`
  String get modifiedOn {
    return Intl.message('Modified On', name: 'modifiedOn', desc: '', args: []);
  }

  /// `Order Cancelled`
  String get orderCancelled {
    return Intl.message(
      'Order Cancelled',
      name: 'orderCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Order was just approved, proceed to mark as Preparing?`
  String get orderWasJustApprovedProceedToMarkAsPreparing {
    return Intl.message(
      'Order was just approved, proceed to mark as Preparing?',
      name: 'orderWasJustApprovedProceedToMarkAsPreparing',
      desc: '',
      args: [],
    );
  }

  /// `To proceed, please upload the Quality Certificate to ensure transparency and compliance before dispatch.`
  String get toProceedPleaseUploadTheQualityCertificateToEnsureTransparency {
    return Intl.message(
      'To proceed, please upload the Quality Certificate to ensure transparency and compliance before dispatch.',
      name: 'toProceedPleaseUploadTheQualityCertificateToEnsureTransparency',
      desc: '',
      args: [],
    );
  }

  /// `Click to upload file`
  String get clickToUploadFile {
    return Intl.message(
      'Click to upload file',
      name: 'clickToUploadFile',
      desc: '',
      args: [],
    );
  }

  /// `Update Status`
  String get updateStatus {
    return Intl.message(
      'Update Status',
      name: 'updateStatus',
      desc: '',
      args: [],
    );
  }

  /// `No Images Found`
  String get noImagesFound {
    return Intl.message(
      'No Images Found',
      name: 'noImagesFound',
      desc: '',
      args: [],
    );
  }

  /// `Report Delay`
  String get reportDelay {
    return Intl.message(
      'Report Delay',
      name: 'reportDelay',
      desc: '',
      args: [],
    );
  }

  /// `Mark All for delivery`
  String get markAllForDelivery {
    return Intl.message(
      'Mark All for delivery',
      name: 'markAllForDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Mark All As delivered`
  String get markAllAsDelivered {
    return Intl.message(
      'Mark All As delivered',
      name: 'markAllAsDelivered',
      desc: '',
      args: [],
    );
  }

  /// `Out for Delivery`
  String get outForDelivery {
    return Intl.message(
      'Out for Delivery',
      name: 'outForDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Please Complete the delivery details below`
  String get pleaseCompleteTheDeliveryDetailsBelow {
    return Intl.message(
      'Please Complete the delivery details below',
      name: 'pleaseCompleteTheDeliveryDetailsBelow',
      desc: '',
      args: [],
    );
  }

  /// `Review carefully before confirming — changes can’t be made after this point.`
  String get reviewCarefullyBeforeConfirmingChangesCantBeMadeAfterThis {
    return Intl.message(
      'Review carefully before confirming — changes can’t be made after this point.',
      name: 'reviewCarefullyBeforeConfirmingChangesCantBeMadeAfterThis',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Address`
  String get deliveryAddress {
    return Intl.message(
      'Delivery Address',
      name: 'deliveryAddress',
      desc: '',
      args: [],
    );
  }

  /// `Drivers Name`
  String get driversName {
    return Intl.message(
      'Drivers Name',
      name: 'driversName',
      desc: '',
      args: [],
    );
  }

  /// `First Name - Last Name`
  String get firstNameLastName {
    return Intl.message(
      'First Name - Last Name',
      name: 'firstNameLastName',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Number`
  String get vehicleNumber {
    return Intl.message(
      'Vehicle Number',
      name: 'vehicleNumber',
      desc: '',
      args: [],
    );
  }

  /// `Plate number e.g ABJ | 8742`
  String get plateNumberEgAbj8742 {
    return Intl.message(
      'Plate number e.g ABJ | 8742',
      name: 'plateNumberEgAbj8742',
      desc: '',
      args: [],
    );
  }

  /// `Expected delivery Time`
  String get expectedDeliveryTime {
    return Intl.message(
      'Expected delivery Time',
      name: 'expectedDeliveryTime',
      desc: '',
      args: [],
    );
  }

  /// `Pick time`
  String get pickTime {
    return Intl.message('Pick time', name: 'pickTime', desc: '', args: []);
  }

  /// `Driver's Picture`
  String get driversPicture {
    return Intl.message(
      'Driver\'s Picture',
      name: 'driversPicture',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Notes`
  String get deliveryNotes {
    return Intl.message(
      'Delivery Notes',
      name: 'deliveryNotes',
      desc: '',
      args: [],
    );
  }

  /// `This action is irreversible, so please ensure the goods have been fully handed over.`
  String get thisActionIsIrreversibleSoPleaseEnsureTheGoodsHave {
    return Intl.message(
      'This action is irreversible, so please ensure the goods have been fully handed over.',
      name: 'thisActionIsIrreversibleSoPleaseEnsureTheGoodsHave',
      desc: '',
      args: [],
    );
  }

  /// `To complete the process, upload the final invoice or delivery receipt as proof of delivery.`
  String get toCompleteTheProcessUploadTheFinalInvoiceOrDelivery {
    return Intl.message(
      'To complete the process, upload the final invoice or delivery receipt as proof of delivery.',
      name: 'toCompleteTheProcessUploadTheFinalInvoiceOrDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Tap to upload from device`
  String get tapToUploadFromDevice {
    return Intl.message(
      'Tap to upload from device',
      name: 'tapToUploadFromDevice',
      desc: '',
      args: [],
    );
  }

  /// `View all attachments`
  String get viewAllAttachments {
    return Intl.message(
      'View all attachments',
      name: 'viewAllAttachments',
      desc: '',
      args: [],
    );
  }

  /// `Order details have been finalized, and the delivery is currently en route.`
  String get orderDetailsHaveBeenFinalizedAndTheDeliveryIsCurrently {
    return Intl.message(
      'Order details have been finalized, and the delivery is currently en route.',
      name: 'orderDetailsHaveBeenFinalizedAndTheDeliveryIsCurrently',
      desc: '',
      args: [],
    );
  }

  /// `Final Delivery Receipt or Invoice`
  String get finalDeliveryReceiptOrInvoice {
    return Intl.message(
      'Final Delivery Receipt or Invoice',
      name: 'finalDeliveryReceiptOrInvoice',
      desc: '',
      args: [],
    );
  }

  /// `See delivery details`
  String get seeDeliveryDetails {
    return Intl.message(
      'See delivery details',
      name: 'seeDeliveryDetails',
      desc: '',
      args: [],
    );
  }

  /// `View all attached quality certificates`
  String get viewAllAttachedQualityCertificates {
    return Intl.message(
      'View all attached quality certificates',
      name: 'viewAllAttachedQualityCertificates',
      desc: '',
      args: [],
    );
  }

  /// `Order Delivery details`
  String get orderDeliveryDetails {
    return Intl.message(
      'Order Delivery details',
      name: 'orderDeliveryDetails',
      desc: '',
      args: [],
    );
  }

  /// `If you’re experiencing a delay, please complete the required fields below to notify the branch.`
  String get ifYoureExperiencingADelayPleaseCompleteTheRequiredFields {
    return Intl.message(
      'If you’re experiencing a delay, please complete the required fields below to notify the branch.',
      name: 'ifYoureExperiencingADelayPleaseCompleteTheRequiredFields',
      desc: '',
      args: [],
    );
  }

  /// `Be clear and specific so they can adjust accordingly.`
  String get beClearAndSpecificSoTheyCanAdjustAccordingly {
    return Intl.message(
      'Be clear and specific so they can adjust accordingly.',
      name: 'beClearAndSpecificSoTheyCanAdjustAccordingly',
      desc: '',
      args: [],
    );
  }

  /// `e.g. “Stock issue,” “Transport breakdown,” “Weather,” etc.`
  String get egStockIssueTransportBreakdownWeatherEtc {
    return Intl.message(
      'e.g. “Stock issue,” “Transport breakdown,” “Weather,” etc.',
      name: 'egStockIssueTransportBreakdownWeatherEtc',
      desc: '',
      args: [],
    );
  }

  /// `Delay Details`
  String get delayDetails {
    return Intl.message(
      'Delay Details',
      name: 'delayDetails',
      desc: '',
      args: [],
    );
  }

  /// `New Expected delivery date`
  String get newExpectedDeliveryDate {
    return Intl.message(
      'New Expected delivery date',
      name: 'newExpectedDeliveryDate',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message('Today', name: 'today', desc: '', args: []);
  }

  /// `New Time`
  String get newTime {
    return Intl.message('New Time', name: 'newTime', desc: '', args: []);
  }

  /// `New Date`
  String get newDate {
    return Intl.message('New Date', name: 'newDate', desc: '', args: []);
  }

  /// `Submit Update`
  String get submitUpdate {
    return Intl.message(
      'Submit Update',
      name: 'submitUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Tap to View delay request details`
  String get tapToViewDelayRequestDetails {
    return Intl.message(
      'Tap to View delay request details',
      name: 'tapToViewDelayRequestDetails',
      desc: '',
      args: [],
    );
  }

  /// `Delivered`
  String get delivered {
    return Intl.message('Delivered', name: 'delivered', desc: '', args: []);
  }

  /// `Delay Reported`
  String get delayReported {
    return Intl.message(
      'Delay Reported',
      name: 'delayReported',
      desc: '',
      args: [],
    );
  }

  /// `Fully Quantity`
  String get fullyQuantity {
    return Intl.message(
      'Fully Quantity',
      name: 'fullyQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Order Status Updated`
  String get orderStatusUpdated {
    return Intl.message(
      'Order Status Updated',
      name: 'orderStatusUpdated',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully marked Order as preparing.`
  String get youHaveSuccessfullyMarkedOrderAsPreparing {
    return Intl.message(
      'You have successfully marked Order as preparing.',
      name: 'youHaveSuccessfullyMarkedOrderAsPreparing',
      desc: '',
      args: [],
    );
  }

  /// `Add delivery details before dispatching:`
  String get addDeliveryDetailsBeforeDispatching {
    return Intl.message(
      'Add delivery details before dispatching:',
      name: 'addDeliveryDetailsBeforeDispatching',
      desc: '',
      args: [],
    );
  }

  /// `Driver Name`
  String get driverName {
    return Intl.message('Driver Name', name: 'driverName', desc: '', args: []);
  }

  /// `Vehicle Information`
  String get vehicleInformation {
    return Intl.message(
      'Vehicle Information',
      name: 'vehicleInformation',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully marked Order as out for delivery.`
  String get youHaveSuccessfullyMarkedOrderAsOutForDelivery {
    return Intl.message(
      'You have successfully marked Order as out for delivery.',
      name: 'youHaveSuccessfullyMarkedOrderAsOutForDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Order Confirmation`
  String get orderConfirmation {
    return Intl.message(
      'Order Confirmation',
      name: 'orderConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully marked Order as delivered. has been notified to confirm delivery.`
  String get youHaveSuccessfullyMarkedOrderAsDeliveredHasBeenNotified {
    return Intl.message(
      'You have successfully marked Order as delivered. has been notified to confirm delivery.',
      name: 'youHaveSuccessfullyMarkedOrderAsDeliveredHasBeenNotified',
      desc: '',
      args: [],
    );
  }

  /// `After delivery is complete, the requester must confirm receipt of the order.`
  String get afterDeliveryIsCompleteTheRequesterMustConfirmReceiptOf {
    return Intl.message(
      'After delivery is complete, the requester must confirm receipt of the order.',
      name: 'afterDeliveryIsCompleteTheRequesterMustConfirmReceiptOf',
      desc: '',
      args: [],
    );
  }

  /// `Order Delivered`
  String get orderDelivered {
    return Intl.message(
      'Order Delivered',
      name: 'orderDelivered',
      desc: '',
      args: [],
    );
  }

  /// `Update Submitted`
  String get updateSubmitted {
    return Intl.message(
      'Update Submitted',
      name: 'updateSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `You have submitted a request. You will be notified when they respond.`
  String get youHaveSubmittedARequestYouWillBeNotifiedWhen {
    return Intl.message(
      'You have submitted a request. You will be notified when they respond.',
      name: 'youHaveSubmittedARequestYouWillBeNotifiedWhen',
      desc: '',
      args: [],
    );
  }

  /// `Modification Approved`
  String get modificationApproved {
    return Intl.message(
      'Modification Approved',
      name: 'modificationApproved',
      desc: '',
      args: [],
    );
  }

  /// `The item has been updated with the approved details.`
  String get theItemHasBeenUpdatedWithTheApprovedDetails {
    return Intl.message(
      'The item has been updated with the approved details.',
      name: 'theItemHasBeenUpdatedWithTheApprovedDetails',
      desc: '',
      args: [],
    );
  }

  /// `You can view the original request and the new modification by clicking the “Modifications & Tracking” button.`
  String get youCanViewTheOriginalRequestAndTheNewModification {
    return Intl.message(
      'You can view the original request and the new modification by clicking the “Modifications & Tracking” button.',
      name: 'youCanViewTheOriginalRequestAndTheNewModification',
      desc: '',
      args: [],
    );
  }

  /// `You modified this item, Pending approval from requester`
  String get youModifiedThisItemPendingApprovalFromRequester {
    return Intl.message(
      'You modified this item, Pending approval from requester',
      name: 'youModifiedThisItemPendingApprovalFromRequester',
      desc: '',
      args: [],
    );
  }

  /// `Modifications rejected. Item has been canceled & will not be processed.`
  String get modificationsRejectedItemHasBeenCanceledWillNotBeProcessed {
    return Intl.message(
      'Modifications rejected. Item has been canceled & will not be processed.',
      name: 'modificationsRejectedItemHasBeenCanceledWillNotBeProcessed',
      desc: '',
      args: [],
    );
  }

  /// `Brand Owner`
  String get brandOwner {
    return Intl.message('Brand Owner', name: 'brandOwner', desc: '', args: []);
  }

  /// `View active orders and confirm delivery`
  String get viewActiveOrdersAndConfirmDelivery {
    return Intl.message(
      'View active orders and confirm delivery',
      name: 'viewActiveOrdersAndConfirmDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message('Completed', name: 'completed', desc: '', args: []);
  }

  /// `Missing`
  String get missing {
    return Intl.message('Missing', name: 'missing', desc: '', args: []);
  }

  /// `In Progress`
  String get inProgress {
    return Intl.message('In Progress', name: 'inProgress', desc: '', args: []);
  }

  /// `Expected Deliveries Today ({count})`
  String expectedDeliveriesTodayCount(Object count) {
    return Intl.message(
      'Expected Deliveries Today ($count)',
      name: 'expectedDeliveriesTodayCount',
      desc: '',
      args: [count],
    );
  }

  /// `Incomplete Inspection`
  String get incompleteInspection {
    return Intl.message(
      'Incomplete Inspection',
      name: 'incompleteInspection',
      desc: '',
      args: [],
    );
  }

  /// `Receipts that are Missing documents`
  String get receiptsThatAreMissingDocuments {
    return Intl.message(
      'Receipts that are Missing documents',
      name: 'receiptsThatAreMissingDocuments',
      desc: '',
      args: [],
    );
  }

  /// `Purchase History & Returns`
  String get purchaseHistoryReturns {
    return Intl.message(
      'Purchase History & Returns',
      name: 'purchaseHistoryReturns',
      desc: '',
      args: [],
    );
  }

  /// `View all your completed purchases and request a return if needed.`
  String get viewAllYourCompletedPurchasesAndRequestAReturnIf {
    return Intl.message(
      'View all your completed purchases and request a return if needed.',
      name: 'viewAllYourCompletedPurchasesAndRequestAReturnIf',
      desc: '',
      args: [],
    );
  }

  /// `Click the button below to see full details.`
  String get clickTheButtonBelowToSeeFullDetails {
    return Intl.message(
      'Click the button below to see full details.',
      name: 'clickTheButtonBelowToSeeFullDetails',
      desc: '',
      args: [],
    );
  }

  /// `Create Return`
  String get createReturn {
    return Intl.message(
      'Create Return',
      name: 'createReturn',
      desc: '',
      args: [],
    );
  }

  /// `Receive Without Prior Order`
  String get receiveWithoutPriorOrder {
    return Intl.message(
      'Receive Without Prior Order',
      name: 'receiveWithoutPriorOrder',
      desc: '',
      args: [],
    );
  }

  /// `Review`
  String get review {
    return Intl.message('Review', name: 'review', desc: '', args: []);
  }

  /// `Receive This Order`
  String get receiveThisOrder {
    return Intl.message(
      'Receive This Order',
      name: 'receiveThisOrder',
      desc: '',
      args: [],
    );
  }

  /// `Order From {sourceName}`
  String orderFromSourceName(Object sourceName) {
    return Intl.message(
      'Order From $sourceName',
      name: 'orderFromSourceName',
      desc: '',
      args: [sourceName],
    );
  }

  /// `Order From {sourceName}`
  String orderFromSourcename(Object sourceName) {
    return Intl.message(
      'Order From $sourceName',
      name: 'orderFromSourcename',
      desc: '',
      args: [sourceName],
    );
  }

  /// `Receive {supplierName}`
  String receiveSuppliername(Object supplierName) {
    return Intl.message(
      'Receive $supplierName',
      name: 'receiveSuppliername',
      desc: '',
      args: [supplierName],
    );
  }

  /// `Document Type`
  String get documentType {
    return Intl.message(
      'Document Type',
      name: 'documentType',
      desc: '',
      args: [],
    );
  }

  /// `Inspection`
  String get inspection {
    return Intl.message('Inspection', name: 'inspection', desc: '', args: []);
  }

  /// `Review all delivery details of the items below:`
  String get reviewAllDeliveryDetailsOfTheItemsBelow {
    return Intl.message(
      'Review all delivery details of the items below:',
      name: 'reviewAllDeliveryDetailsOfTheItemsBelow',
      desc: '',
      args: [],
    );
  }

  /// `Contact Number`
  String get contactNumber {
    return Intl.message(
      'Contact Number',
      name: 'contactNumber',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle`
  String get vehicle {
    return Intl.message('Vehicle', name: 'vehicle', desc: '', args: []);
  }

  /// `Arrival Time`
  String get arrivalTime {
    return Intl.message(
      'Arrival Time',
      name: 'arrivalTime',
      desc: '',
      args: [],
    );
  }

  /// `Goods Inspection:`
  String get goodsInspection {
    return Intl.message(
      'Goods Inspection:',
      name: 'goodsInspection',
      desc: '',
      args: [],
    );
  }

  /// `No Active Orders`
  String get noActiveOrders {
    return Intl.message(
      'No Active Orders',
      name: 'noActiveOrders',
      desc: '',
      args: [],
    );
  }

  /// `Once a supplier confirms shipment, you’ll see the order here to begin the receiving process.`
  String get onceASupplierConfirmsShipmentYoullSeeTheOrderHere {
    return Intl.message(
      'Once a supplier confirms shipment, you’ll see the order here to begin the receiving process.',
      name: 'onceASupplierConfirmsShipmentYoullSeeTheOrderHere',
      desc: '',
      args: [],
    );
  }

  /// `Qty Ordered`
  String get qtyOrdered {
    return Intl.message('Qty Ordered', name: 'qtyOrdered', desc: '', args: []);
  }

  /// `Qty Received`
  String get qtyReceived {
    return Intl.message(
      'Qty Received',
      name: 'qtyReceived',
      desc: '',
      args: [],
    );
  }

  /// `Expiration date`
  String get expirationDate {
    return Intl.message(
      'Expiration date',
      name: 'expirationDate',
      desc: '',
      args: [],
    );
  }

  /// `Select Quality`
  String get selectQuality {
    return Intl.message(
      'Select Quality',
      name: 'selectQuality',
      desc: '',
      args: [],
    );
  }

  /// `Add Photo of item`
  String get addPhotoOfItem {
    return Intl.message(
      'Add Photo of item',
      name: 'addPhotoOfItem',
      desc: '',
      args: [],
    );
  }

  /// `Open Camera`
  String get openCamera {
    return Intl.message('Open Camera', name: 'openCamera', desc: '', args: []);
  }

  /// `Add Note`
  String get addNote {
    return Intl.message('Add Note', name: 'addNote', desc: '', args: []);
  }

  /// `Describe the issue e.g., “Visible spoilage, unusable`
  String get describeTheIssueEgVisibleSpoilageUnusable {
    return Intl.message(
      'Describe the issue e.g., “Visible spoilage, unusable',
      name: 'describeTheIssueEgVisibleSpoilageUnusable',
      desc: '',
      args: [],
    );
  }

  /// `Continue to Document Registration`
  String get continueToDocumentRegistration {
    return Intl.message(
      'Continue to Document Registration',
      name: 'continueToDocumentRegistration',
      desc: '',
      args: [],
    );
  }

  /// `Order`
  String get order {
    return Intl.message('Order', name: 'order', desc: '', args: []);
  }

  /// `Value`
  String get value {
    return Intl.message('Value', name: 'value', desc: '', args: []);
  }

  /// `Official accounting document`
  String get officialAccountingDocument {
    return Intl.message(
      'Official accounting document',
      name: 'officialAccountingDocument',
      desc: '',
      args: [],
    );
  }

  /// `Invoice`
  String get invoice {
    return Intl.message('Invoice', name: 'invoice', desc: '', args: []);
  }

  /// `Receipt Without Documents`
  String get receiptWithoutDocuments {
    return Intl.message(
      'Receipt Without Documents',
      name: 'receiptWithoutDocuments',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Note`
  String get deliveryNote {
    return Intl.message(
      'Delivery Note',
      name: 'deliveryNote',
      desc: '',
      args: [],
    );
  }

  /// `Includes VAT`
  String get includesVat {
    return Intl.message(
      'Includes VAT',
      name: 'includesVat',
      desc: '',
      args: [],
    );
  }

  /// `Required for payment & accounting`
  String get requiredForPaymentAccounting {
    return Intl.message(
      'Required for payment & accounting',
      name: 'requiredForPaymentAccounting',
      desc: '',
      args: [],
    );
  }

  /// `Receipt document only`
  String get receiptDocumentOnly {
    return Intl.message(
      'Receipt document only',
      name: 'receiptDocumentOnly',
      desc: '',
      args: [],
    );
  }

  /// `No financial values`
  String get noFinancialValues {
    return Intl.message(
      'No financial values',
      name: 'noFinancialValues',
      desc: '',
      args: [],
    );
  }

  /// `Invoice will come later`
  String get invoiceWillComeLater {
    return Intl.message(
      'Invoice will come later',
      name: 'invoiceWillComeLater',
      desc: '',
      args: [],
    );
  }

  /// `Temporary receipt`
  String get temporaryReceipt {
    return Intl.message(
      'Temporary receipt',
      name: 'temporaryReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for official docs`
  String get waitingForOfficialDocs {
    return Intl.message(
      'Waiting for official docs',
      name: 'waitingForOfficialDocs',
      desc: '',
      args: [],
    );
  }

  /// `Automatic follow-up reminder`
  String get automaticFollowupReminder {
    return Intl.message(
      'Automatic follow-up reminder',
      name: 'automaticFollowupReminder',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note {
    return Intl.message('Note', name: 'note', desc: '', args: []);
  }

  /// `Document type can be updated later if circumstances change`
  String get documentTypeCanBeUpdatedLaterIfCircumstancesChange {
    return Intl.message(
      'Document type can be updated later if circumstances change',
      name: 'documentTypeCanBeUpdatedLaterIfCircumstancesChange',
      desc: '',
      args: [],
    );
  }

  /// `Inventory`
  String get inventory {
    return Intl.message('Inventory', name: 'inventory', desc: '', args: []);
  }

  /// `Manage your inventory`
  String get manageYourInventory {
    return Intl.message(
      'Manage your inventory',
      name: 'manageYourInventory',
      desc: '',
      args: [],
    );
  }

  /// `Search inventory...`
  String get searchInventory {
    return Intl.message(
      'Search inventory...',
      name: 'searchInventory',
      desc: '',
      args: [],
    );
  }

  /// `No inventory items`
  String get noInventoryItems {
    return Intl.message(
      'No inventory items',
      name: 'noInventoryItems',
      desc: '',
      args: [],
    );
  }

  /// `Low Stock`
  String get lowStock {
    return Intl.message('Low Stock', name: 'lowStock', desc: '', args: []);
  }

  /// `In Stock`
  String get inStock {
    return Intl.message('In Stock', name: 'inStock', desc: '', args: []);
  }

  /// `Barcode`
  String get barcode {
    return Intl.message('Barcode', name: 'barcode', desc: '', args: []);
  }

  /// `Cost Price`
  String get costPrice {
    return Intl.message('Cost Price', name: 'costPrice', desc: '', args: []);
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Current Stock`
  String get currentStock {
    return Intl.message(
      'Current Stock',
      name: 'currentStock',
      desc: '',
      args: [],
    );
  }

  /// `Min`
  String get min {
    return Intl.message('Min', name: 'min', desc: '', args: []);
  }

  /// `Max`
  String get max {
    return Intl.message('Max', name: 'max', desc: '', args: []);
  }

  /// `Recent Transactions`
  String get recentTransactions {
    return Intl.message(
      'Recent Transactions',
      name: 'recentTransactions',
      desc: '',
      args: [],
    );
  }

  /// `Update Quantity`
  String get updateQuantity {
    return Intl.message(
      'Update Quantity',
      name: 'updateQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Enter quantity`
  String get enterQuantity {
    return Intl.message(
      'Enter quantity',
      name: 'enterQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Reason`
  String get reason {
    return Intl.message('Reason', name: 'reason', desc: '', args: []);
  }

  /// `Enter reason (optional)`
  String get enterReason {
    return Intl.message(
      'Enter reason (optional)',
      name: 'enterReason',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `Net 7 Days`
  String get net7days {
    return Intl.message('Net 7 Days', name: 'net7days', desc: '', args: []);
  }

  /// `Net 15 Days`
  String get net15days {
    return Intl.message('Net 15 Days', name: 'net15days', desc: '', args: []);
  }

  /// `Net 30 Days`
  String get net30days {
    return Intl.message('Net 30 Days', name: 'net30days', desc: '', args: []);
  }

  /// `Net 45 Days`
  String get net45days {
    return Intl.message('Net 45 Days', name: 'net45days', desc: '', args: []);
  }

  /// `Accept Variance As Is`
  String get acceptVarianceAsIs {
    return Intl.message(
      'Accept Variance As Is',
      name: 'acceptVarianceAsIs',
      desc: '',
      args: [],
    );
  }

  /// `Create compensatory order for missing quantity`
  String get createCompensatoryOrderForMissingQuantity {
    return Intl.message(
      'Create compensatory order for missing quantity',
      name: 'createCompensatoryOrderForMissingQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Deduct from invoice value`
  String get deductFromInvoiceValue {
    return Intl.message(
      'Deduct from invoice value',
      name: 'deductFromInvoiceValue',
      desc: '',
      args: [],
    );
  }

  /// `Complete the required Invoice Registration fields:`
  String get completeTheRequiredInvoiceRegistrationFields {
    return Intl.message(
      'Complete the required Invoice Registration fields:',
      name: 'completeTheRequiredInvoiceRegistrationFields',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Financial Details:`
  String get financialDetails {
    return Intl.message(
      'Financial Details:',
      name: 'financialDetails',
      desc: '',
      args: [],
    );
  }

  /// `Amount Before Tax`
  String get amountBeforeTax {
    return Intl.message(
      'Amount Before Tax',
      name: 'amountBeforeTax',
      desc: '',
      args: [],
    );
  }

  /// `VAT (15%)`
  String get vat15Percent {
    return Intl.message('VAT (15%)', name: 'vat15Percent', desc: '', args: []);
  }

  /// `Payment Terms`
  String get paymentTerms {
    return Intl.message(
      'Payment Terms',
      name: 'paymentTerms',
      desc: '',
      args: [],
    );
  }

  /// `Due Date`
  String get dueDate {
    return Intl.message('Due Date', name: 'dueDate', desc: '', args: []);
  }

  /// `Upload Invoice:`
  String get uploadInvoice {
    return Intl.message(
      'Upload Invoice:',
      name: 'uploadInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Invoice Registration`
  String get invoiceRegistration {
    return Intl.message(
      'Invoice Registration',
      name: 'invoiceRegistration',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Note Registration`
  String get deliveryNoteRegistration {
    return Intl.message(
      'Delivery Note Registration',
      name: 'deliveryNoteRegistration',
      desc: '',
      args: [],
    );
  }

  /// `Return Registration`
  String get returnRegistration {
    return Intl.message(
      'Return Registration',
      name: 'returnRegistration',
      desc: '',
      args: [],
    );
  }

  /// `Complete the required Delivery Note fields:`
  String get completeTheRequiredDeliveryNoteFields {
    return Intl.message(
      'Complete the required Delivery Note fields:',
      name: 'completeTheRequiredDeliveryNoteFields',
      desc: '',
      args: [],
    );
  }

  /// `Complete the required Return fields:`
  String get completeTheRequiredReturnFields {
    return Intl.message(
      'Complete the required Return fields:',
      name: 'completeTheRequiredReturnFields',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Note Number`
  String get deliveryNoteNumber {
    return Intl.message(
      'Delivery Note Number',
      name: 'deliveryNoteNumber',
      desc: '',
      args: [],
    );
  }

  /// `Return Reason`
  String get returnReason {
    return Intl.message(
      'Return Reason',
      name: 'returnReason',
      desc: '',
      args: [],
    );
  }

  /// `Select Payment Terms`
  String get selectPaymentTerms {
    return Intl.message(
      'Select Payment Terms',
      name: 'selectPaymentTerms',
      desc: '',
      args: [],
    );
  }

  /// `Receive Order Summary`
  String get receiveOrderSummary {
    return Intl.message(
      'Receive Order Summary',
      name: 'receiveOrderSummary',
      desc: '',
      args: [],
    );
  }

  /// `You can confirm now.`
  String get youCanConfirmNow {
    return Intl.message(
      'You can confirm now.',
      name: 'youCanConfirmNow',
      desc: '',
      args: [],
    );
  }

  /// `Inspection Summary`
  String get inspectionSummary {
    return Intl.message(
      'Inspection Summary',
      name: 'inspectionSummary',
      desc: '',
      args: [],
    );
  }

  /// `Receipt Summary`
  String get receiptSummary {
    return Intl.message(
      'Receipt Summary',
      name: 'receiptSummary',
      desc: '',
      args: [],
    );
  }

  /// `{count} Items Received`
  String itemsReceivedCount(int count) {
    return Intl.message(
      '$count Items Received',
      name: 'itemsReceivedCount',
      desc: '',
      args: [count],
    );
  }

  /// `{count} Quantity Variance`
  String quantityVarianceCount(int count) {
    return Intl.message(
      '$count Quantity Variance',
      name: 'quantityVarianceCount',
      desc: '',
      args: [count],
    );
  }

  /// `Total Value`
  String get totalValue {
    return Intl.message('Total Value', name: 'totalValue', desc: '', args: []);
  }

  /// `Goods Inspection ({count}):`
  String goodsInspectionCount(int count) {
    return Intl.message(
      'Goods Inspection ($count):',
      name: 'goodsInspectionCount',
      desc: '',
      args: [count],
    );
  }

  /// `Document:`
  String get document {
    return Intl.message('Document:', name: 'document', desc: '', args: []);
  }

  /// `Financial Summary`
  String get financialSummary {
    return Intl.message(
      'Financial Summary',
      name: 'financialSummary',
      desc: '',
      args: [],
    );
  }

  /// `Mark Order as Received`
  String get markOrderAsReceived {
    return Intl.message(
      'Mark Order as Received',
      name: 'markOrderAsReceived',
      desc: '',
      args: [],
    );
  }

  /// `Invoice Attachment`
  String get invoiceAttachment {
    return Intl.message(
      'Invoice Attachment',
      name: 'invoiceAttachment',
      desc: '',
      args: [],
    );
  }

  /// `Variance Summary:`
  String get varianceSummary {
    return Intl.message(
      'Variance Summary:',
      name: 'varianceSummary',
      desc: '',
      args: [],
    );
  }

  /// `Required Action`
  String get requiredAction {
    return Intl.message(
      'Required Action',
      name: 'requiredAction',
      desc: '',
      args: [],
    );
  }

  /// `Short {quantity} {unit} ({value} SAR value)`
  String shortQuantityValue(String quantity, String unit, String value) {
    return Intl.message(
      'Short $quantity $unit ($value SAR value)',
      name: 'shortQuantityValue',
      desc: '',
      args: [quantity, unit, value],
    );
  }

  /// `{count} Items Received`
  String countItemsReceived(int count) {
    return Intl.message(
      '$count Items Received',
      name: 'countItemsReceived',
      desc: '',
      args: [count],
    );
  }

  /// `{count} Quantity Variance`
  String countQuantityVariance(int count) {
    return Intl.message(
      '$count Quantity Variance',
      name: 'countQuantityVariance',
      desc: '',
      args: [count],
    );
  }

  /// `Goods Inspection ({count}):`
  String goodsInspectionCountTitle(int count) {
    return Intl.message(
      'Goods Inspection ($count):',
      name: 'goodsInspectionCountTitle',
      desc: '',
      args: [count],
    );
  }

  /// `{itemName}:`
  String itemNameVariance(String itemName) {
    return Intl.message(
      '$itemName:',
      name: 'itemNameVariance',
      desc: '',
      args: [itemName],
    );
  }

  /// `Variance`
  String get variance_v {
    return Intl.message('Variance', name: 'variance_v', desc: '', args: []);
  }

  /// `Describe the inspections, including any discoveries or details.`
  String get describeTheInspectionsIncludingAnyDiscoveriesOrDetails {
    return Intl.message(
      'Describe the inspections, including any discoveries or details.',
      name: 'describeTheInspectionsIncludingAnyDiscoveriesOrDetails',
      desc: '',
      args: [],
    );
  }

  /// `Upload Photo`
  String get uploadPhoto {
    return Intl.message(
      'Upload Photo',
      name: 'uploadPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Amount to Deduct`
  String get amountToDeduct {
    return Intl.message(
      'Amount to Deduct',
      name: 'amountToDeduct',
      desc: '',
      args: [],
    );
  }

  /// `Compensatory Order`
  String get compensatoryOrder {
    return Intl.message(
      'Compensatory Order',
      name: 'compensatoryOrder',
      desc: '',
      args: [],
    );
  }

  /// `Need to return an order/item?`
  String get needToReturnAnOrderItem {
    return Intl.message(
      'Need to return an order/item?',
      name: 'needToReturnAnOrderItem',
      desc: '',
      args: [],
    );
  }

  /// `Click the button below to open your Purchase History. Select a completed order, then tap ‘Return Item’ to start the return process.`
  String
  get clickTheButtonBelowToOpenYourPurchaseHistorySelectACompletedOrderThenTapReturnItemToStartTheReturnProcess {
    return Intl.message(
      'Click the button below to open your Purchase History. Select a completed order, then tap ‘Return Item’ to start the return process.',
      name:
          'clickTheButtonBelowToOpenYourPurchaseHistorySelectACompletedOrderThenTapReturnItemToStartTheReturnProcess',
      desc: '',
      args: [],
    );
  }

  /// `Returned Goods`
  String get returnedGoods {
    return Intl.message(
      'Returned Goods',
      name: 'returnedGoods',
      desc: '',
      args: [],
    );
  }

  /// `Manage all your pending & past returns`
  String get manageAllYourPendingAndPastReturns {
    return Intl.message(
      'Manage all your pending & past returns',
      name: 'manageAllYourPendingAndPastReturns',
      desc: '',
      args: [],
    );
  }

  /// `No Aggregators Found`
  String get noAggregatorsFound {
    return Intl.message(
      'No Aggregators Found',
      name: 'noAggregatorsFound',
      desc: '',
      args: [],
    );
  }

  /// `Reject Handover`
  String get rejectHandover {
    return Intl.message(
      'Reject Handover',
      name: 'rejectHandover',
      desc: '',
      args: [],
    );
  }

  /// `You’re rejecting this handover due to issues or inconsistencies.\nThe cashier will be notified to make corrections.`
  String get youAreRejectingThisHandoverDueToIssuesOrInconsistencies {
    return Intl.message(
      'You’re rejecting this handover due to issues or inconsistencies.\nThe cashier will be notified to make corrections.',
      name: 'youAreRejectingThisHandoverDueToIssuesOrInconsistencies',
      desc: '',
      args: [],
    );
  }

  /// `Manager’s Comment`
  String get managerComment {
    return Intl.message(
      'Manager’s Comment',
      name: 'managerComment',
      desc: '',
      args: [],
    );
  }

  /// `Provide any suggestions or notes to guide the employee in correcting the handover.`
  String get provideAnySuggestionsOrNotes {
    return Intl.message(
      'Provide any suggestions or notes to guide the employee in correcting the handover.',
      name: 'provideAnySuggestionsOrNotes',
      desc: '',
      args: [],
    );
  }

  /// `Handover Rejected`
  String get handoverRejected {
    return Intl.message(
      'Handover Rejected',
      name: 'handoverRejected',
      desc: '',
      args: [],
    );
  }

  /// `The handover has been rejected. The cashier has been notified to review and make the necessary corrections.`
  String get theHandoverHasBeenRejected {
    return Intl.message(
      'The handover has been rejected. The cashier has been notified to review and make the necessary corrections.',
      name: 'theHandoverHasBeenRejected',
      desc: '',
      args: [],
    );
  }

  /// `Reject & Ask for correction`
  String get rejectAndAskForCorrection {
    return Intl.message(
      'Reject & Ask for correction',
      name: 'rejectAndAskForCorrection',
      desc: '',
      args: [],
    );
  }

  /// `You’ve requested {cashierName} to make corrections to this handover.`
  String youRequestedCashierToMakeCorrections(String cashierName) {
    return Intl.message(
      'You’ve requested $cashierName to make corrections to this handover.',
      name: 'youRequestedCashierToMakeCorrections',
      desc: 'Desc',
      args: [cashierName],
    );
  }

  /// `You’ll be overriding the rejection from {cashierName}, and this action is final and cannot be undone.`
  String uWillOverrideTheRejectionForm(String cashierName) {
    return Intl.message(
      'You’ll be overriding the rejection from $cashierName, and this action is final and cannot be undone.',
      name: 'uWillOverrideTheRejectionForm',
      desc: 'Desc',
      args: [cashierName],
    );
  }

  /// `Edit Handover`
  String get editHandover {
    return Intl.message(
      'Edit Handover',
      name: 'editHandover',
      desc: '',
      args: [],
    );
  }

  /// `Your Comment`
  String get yourComment {
    return Intl.message(
      'Your Comment',
      name: 'yourComment',
      desc: '',
      args: [],
    );
  }

  /// `Empty Comment`
  String get emptyComment {
    return Intl.message(
      'Empty Comment',
      name: 'emptyComment',
      desc: '',
      args: [],
    );
  }

  /// `You can’t request corrections anymore (2/2)`
  String get cantRequestCorrectionsAnymore {
    return Intl.message(
      'You can’t request corrections anymore (2/2)',
      name: 'cantRequestCorrectionsAnymore',
      desc: '',
      args: [],
    );
  }

  /// `Approve Anyway`
  String get approveAnyWay {
    return Intl.message(
      'Approve Anyway',
      name: 'approveAnyWay',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to approve this handover?`
  String get areUSureUWantToApprove {
    return Intl.message(
      'Are you sure you want to approve this handover?',
      name: 'areUSureUWantToApprove',
      desc: '',
      args: [],
    );
  }

  /// `Why are you approving this request?`
  String get whyAreUApprovingTheRequest {
    return Intl.message(
      'Why are you approving this request?',
      name: 'whyAreUApprovingTheRequest',
      desc: '',
      args: [],
    );
  }

  /// `Approve Handover`
  String get approveHandover {
    return Intl.message(
      'Approve Handover',
      name: 'approveHandover',
      desc: '',
      args: [],
    );
  }

  /// `You’ve approved the handover and overridden the rejection from {cashierName}.`
  String uApprovedTheHandoverFromCashier(String cashierName) {
    return Intl.message(
      'You’ve approved the handover and overridden the rejection from $cashierName.',
      name: 'uApprovedTheHandoverFromCashier',
      desc: 'Desc',
      args: [cashierName],
    );
  }

  /// `The process is now marked as complete.`
  String get theProcessIsNowMarkedAsComplete {
    return Intl.message(
      'The process is now marked as complete.',
      name: 'theProcessIsNowMarkedAsComplete',
      desc: '',
      args: [],
    );
  }

  /// `You’re approving this handover from the cashier. All records will be locked and marked as complete.`
  String get yAreApprovingThisHandoverFromCashier {
    return Intl.message(
      'You’re approving this handover from the cashier. All records will be locked and marked as complete.',
      name: 'yAreApprovingThisHandoverFromCashier',
      desc: '',
      args: [],
    );
  }

  /// `This action is irreversible and will close the employee’s handover record permanently.`
  String get thisActionIsIrreversibleAndWillCloseHandoverPermanently {
    return Intl.message(
      'This action is irreversible and will close the employee’s handover record permanently.',
      name: 'thisActionIsIrreversibleAndWillCloseHandoverPermanently',
      desc: '',
      args: [],
    );
  }

  /// `Request Corrections`
  String get requestCorrections {
    return Intl.message(
      'Request Corrections',
      name: 'requestCorrections',
      desc: '',
      args: [],
    );
  }

  /// `This will send the handover back to {cashierName} for updates based on {managerName}’s feedback.`
  String thisWillSendTheHandoverBackToCashierBasedOnManagerFeedBack(
    String cashierName,
    String managerName,
  ) {
    return Intl.message(
      'This will send the handover back to $cashierName for updates based on $managerName’s feedback.',
      name: 'thisWillSendTheHandoverBackToCashierBasedOnManagerFeedBack',
      desc: 'Desc',
      args: [cashierName, managerName],
    );
  }

  /// `They’ve been notified to review and update the handover.`
  String get theyHaveBeenNotifiedToReviewTheHandover {
    return Intl.message(
      'They’ve been notified to review and update the handover.',
      name: 'theyHaveBeenNotifiedToReviewTheHandover',
      desc: '',
      args: [],
    );
  }

  /// `Your correction request has been sent to {cashierName}.`
  String yourCorrectionRequestHasBeenSentToCashier(String cashierName) {
    return Intl.message(
      'Your correction request has been sent to $cashierName.',
      name: 'yourCorrectionRequestHasBeenSentToCashier',
      desc: 'Desc',
      args: [cashierName],
    );
  }

  /// `Request Sent`
  String get requestSent {
    return Intl.message(
      'Request Sent',
      name: 'requestSent',
      desc: '',
      args: [],
    );
  }

  /// `Review Details`
  String get reviewDetails {
    return Intl.message(
      'Review Details',
      name: 'reviewDetails',
      desc: '',
      args: [],
    );
  }

  /// `Here’s why this handover process was rejected`
  String get hereIsWhyThisHandoverWasRejected {
    return Intl.message(
      'Here’s why this handover process was rejected',
      name: 'hereIsWhyThisHandoverWasRejected',
      desc: '',
      args: [],
    );
  }

  /// `Managers Comment (Correction Request)`
  String get managersCommentCorrectionRequest {
    return Intl.message(
      'Managers Comment (Correction Request)',
      name: 'managersCommentCorrectionRequest',
      desc: '',
      args: [],
    );
  }

  /// `Shift Ended, Pending Cash Handover`
  String get shiftEndedPendingHandover {
    return Intl.message(
      'Shift Ended, Pending Cash Handover',
      name: 'shiftEndedPendingHandover',
      desc: '',
      args: [],
    );
  }

  /// `Your shift has been closed, but the cash handover hasn’t been completed yet.\nPlease complete the handover to finish the process.`
  String get shiftEndedPendingHandoverDesc {
    return Intl.message(
      'Your shift has been closed, but the cash handover hasn’t been completed yet.\nPlease complete the handover to finish the process.',
      name: 'shiftEndedPendingHandoverDesc',
      desc: '',
      args: [],
    );
  }

  /// `Shift Ended`
  String get shiftEnded {
    return Intl.message('Shift Ended', name: 'shiftEnded', desc: '', args: []);
  }

  /// `Your cash handover is now pending approval from {cashierName}. You’ll be notified once they confirm it.`
  String shiftEndedDesc(String cashierName) {
    return Intl.message(
      'Your cash handover is now pending approval from $cashierName. You’ll be notified once they confirm it.',
      name: 'shiftEndedDesc',
      desc: 'Desc',
      args: [cashierName],
    );
  }

  /// `Your shift has been submitted for final review.\nYou’ll be notified once {AccountantName} approves or rejects your handover.\nNo further changes can be made to today’s records.`
  String yourFinalHandoverHasBeenSubmittedForReview(String AccountantName) {
    return Intl.message(
      'Your shift has been submitted for final review.\nYou’ll be notified once $AccountantName approves or rejects your handover.\nNo further changes can be made to today’s records.',
      name: 'yourFinalHandoverHasBeenSubmittedForReview',
      desc: 'Desc',
      args: [AccountantName],
    );
  }

  /// `Business Date closed`
  String get businessDateClosed {
    return Intl.message(
      'Business Date closed',
      name: 'businessDateClosed',
      desc: '',
      args: [],
    );
  }

  /// `Business Date:`
  String get businessDate {
    return Intl.message(
      'Business Date:',
      name: 'businessDate',
      desc: '',
      args: [],
    );
  }

  /// `My Handover Summary`
  String get myHandoverSummary {
    return Intl.message(
      'My Handover Summary',
      name: 'myHandoverSummary',
      desc: '',
      args: [],
    );
  }

  /// `The breakdown below includes sales handed over to me by other cashiers during this workday.`
  String get breakdownBelowIncludesSales {
    return Intl.message(
      'The breakdown below includes sales handed over to me by other cashiers during this workday.',
      name: 'breakdownBelowIncludesSales',
      desc: '',
      args: [],
    );
  }

  /// `All handovers, shifts, and sales will be recorded under yesterday’s workday.`
  String get allHandoverAndShiftsWillBeRecordedUnderYesterdayWorkday {
    return Intl.message(
      'All handovers, shifts, and sales will be recorded under yesterday’s workday.',
      name: 'allHandoverAndShiftsWillBeRecordedUnderYesterdayWorkday',
      desc: '',
      args: [],
    );
  }

  /// `All handovers, shifts, and sales will be recorded under today’s workday.`
  String get allHandoverAndShiftsWillBeRecordedUnderTodayWorkday {
    return Intl.message(
      'All handovers, shifts, and sales will be recorded under today’s workday.',
      name: 'allHandoverAndShiftsWillBeRecordedUnderTodayWorkday',
      desc: '',
      args: [],
    );
  }

  /// `Make Corrections`
  String get makeCorrections {
    return Intl.message(
      'Make Corrections',
      name: 'makeCorrections',
      desc: '',
      args: [],
    );
  }

  /// `Edit Final Submission`
  String get editFinalSubmission {
    return Intl.message(
      'Edit Final Submission',
      name: 'editFinalSubmission',
      desc: '',
      args: [],
    );
  }

  /// `Undo Changes`
  String get undoChanges {
    return Intl.message(
      'Undo Changes',
      name: 'undoChanges',
      desc: '',
      args: [],
    );
  }

  /// `Submit daily Report`
  String get submitDailyReport {
    return Intl.message(
      'Submit daily Report',
      name: 'submitDailyReport',
      desc: '',
      args: [],
    );
  }

  /// `submit Changes`
  String get submitChanges {
    return Intl.message(
      'submit Changes',
      name: 'submitChanges',
      desc: '',
      args: [],
    );
  }

  /// `Review & Correct Final Totals`
  String get reviewAndCorrectFinal {
    return Intl.message(
      'Review & Correct Final Totals',
      name: 'reviewAndCorrectFinal',
      desc: '',
      args: [],
    );
  }

  /// `You’re making corrections to the final shift submission as requested by the accountant.`
  String get uAreMakingCorrectionsToTheFinalShiftSubmission {
    return Intl.message(
      'You’re making corrections to the final shift submission as requested by the accountant.',
      name: 'uAreMakingCorrectionsToTheFinalShiftSubmission',
      desc: '',
      args: [],
    );
  }

  /// `Your final handover has been submitted. You’ll be notified once the accountant reviews it, no further action needed for now.`
  String get yourFinalHandoverHasBeenSubmitted {
    return Intl.message(
      'Your final handover has been submitted. You’ll be notified once the accountant reviews it, no further action needed for now.',
      name: 'yourFinalHandoverHasBeenSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Submission Successful`
  String get submissionSuccessful {
    return Intl.message(
      'Submission Successful',
      name: 'submissionSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Please refine your search filter selections for improved results.`
  String get pleaseRefineYourFilter {
    return Intl.message(
      'Please refine your search filter selections for improved results.',
      name: 'pleaseRefineYourFilter',
      desc: '',
      args: [],
    );
  }

  /// `Filter Shift List By`
  String get filterShiftListBy {
    return Intl.message(
      'Filter Shift List By',
      name: 'filterShiftListBy',
      desc: '',
      args: [],
    );
  }

  /// `Search for managers by name`
  String get searchForManagersByName {
    return Intl.message(
      'Search for managers by name',
      name: 'searchForManagersByName',
      desc: '',
      args: [],
    );
  }

  /// `No Pending Shifts`
  String get noPendingShifts {
    return Intl.message(
      'No Pending Shifts',
      name: 'noPendingShifts',
      desc: '',
      args: [],
    );
  }

  /// `All shifts have been reviewed or reassigned.`
  String get allShiftHaveBeenReviewedOrReassigned {
    return Intl.message(
      'All shifts have been reviewed or reassigned.',
      name: 'allShiftHaveBeenReviewedOrReassigned',
      desc: '',
      args: [],
    );
  }

  /// `No Shifts In Progress`
  String get noShiftsInProgress {
    return Intl.message(
      'No Shifts In Progress',
      name: 'noShiftsInProgress',
      desc: '',
      args: [],
    );
  }

  /// `No shifts are currently in progress.`
  String get noShiftsAreCurrentlyInProgress {
    return Intl.message(
      'No shifts are currently in progress.',
      name: 'noShiftsAreCurrentlyInProgress',
      desc: '',
      args: [],
    );
  }

  /// `No Completed Shifts`
  String get noCompletedShifts {
    return Intl.message(
      'No Completed Shifts',
      name: 'noCompletedShifts',
      desc: '',
      args: [],
    );
  }

  /// `There are no completed shifts yet.`
  String get thereAreNoCompletedShiftsYet {
    return Intl.message(
      'There are no completed shifts yet.',
      name: 'thereAreNoCompletedShiftsYet',
      desc: '',
      args: [],
    );
  }

  /// `All Shifts`
  String get allShifts {
    return Intl.message('All Shifts', name: 'allShifts', desc: '', args: []);
  }

  /// `No Shifts Available`
  String get noShiftsAvailable {
    return Intl.message(
      'No Shifts Available',
      name: 'noShiftsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No shifts are currently recorded.`
  String get noShiftsAreCurrentlyRecorded {
    return Intl.message(
      'No shifts are currently recorded.',
      name: 'noShiftsAreCurrentlyRecorded',
      desc: '',
      args: [],
    );
  }

  /// `Replacement with Good Product`
  String get replacementWithGoodProduct {
    return Intl.message(
      'Replacement with Good Product',
      name: 'replacementWithGoodProduct',
      desc: '',
      args: [],
    );
  }

  /// `Cash Refund`
  String get cashRefund {
    return Intl.message('Cash Refund', name: 'cashRefund', desc: '', args: []);
  }

  /// `Credit for Future Orders`
  String get creditForFutureOrders {
    return Intl.message(
      'Credit for Future Orders',
      name: 'creditForFutureOrders',
      desc: '',
      args: [],
    );
  }

  /// `Rejected by Supplier`
  String get rejectedBySupplier {
    return Intl.message(
      'Rejected by Supplier',
      name: 'rejectedBySupplier',
      desc: '',
      args: [],
    );
  }

  /// `Goods Returns`
  String get goodsReturns {
    return Intl.message(
      'Goods Returns',
      name: 'goodsReturns',
      desc: '',
      args: [],
    );
  }

  /// `Item Return details`
  String get itemReturnDetails {
    return Intl.message(
      'Item Return details',
      name: 'itemReturnDetails',
      desc: '',
      args: [],
    );
  }

  /// `Original order info`
  String get originalOrderInfo {
    return Intl.message(
      'Original order info',
      name: 'originalOrderInfo',
      desc: '',
      args: [],
    );
  }

  /// `This item return request is linked to an original closed order. You can see details or go to orginal order for more details.`
  String get thisItemReturnRequestIsLinkedToAnOriginalClosed {
    return Intl.message(
      'This item return request is linked to an original closed order. You can see details or go to orginal order for more details.',
      name: 'thisItemReturnRequestIsLinkedToAnOriginalClosed',
      desc: '',
      args: [],
    );
  }

  /// `Return Request`
  String get returnRequest {
    return Intl.message(
      'Return Request',
      name: 'returnRequest',
      desc: '',
      args: [],
    );
  }

  /// `Go to original pruchase order details`
  String get goToOriginalPruchaseOrderDetails {
    return Intl.message(
      'Go to original pruchase order details',
      name: 'goToOriginalPruchaseOrderDetails',
      desc: '',
      args: [],
    );
  }

  /// `Return Request Summary`
  String get returnRequestSummary {
    return Intl.message(
      'Return Request Summary',
      name: 'returnRequestSummary',
      desc: '',
      args: [],
    );
  }

  /// `Related Order`
  String get relatedOrder {
    return Intl.message(
      'Related Order',
      name: 'relatedOrder',
      desc: '',
      args: [],
    );
  }

  /// `Total Return Value`
  String get totalReturnValue {
    return Intl.message(
      'Total Return Value',
      name: 'totalReturnValue',
      desc: '',
      args: [],
    );
  }

  /// `Return Date`
  String get returnDate {
    return Intl.message('Return Date', name: 'returnDate', desc: '', args: []);
  }

  /// `Return Number`
  String get returnNumber {
    return Intl.message(
      'Return Number',
      name: 'returnNumber',
      desc: '',
      args: [],
    );
  }

  /// `Items ({count}):`
  String itemsCount(Object count) {
    return Intl.message(
      'Items ($count):',
      name: 'itemsCount',
      desc: '',
      args: [count],
    );
  }

  /// `Return Quantity`
  String get returnQuantity {
    return Intl.message(
      'Return Quantity',
      name: 'returnQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Reason (Quality)`
  String get reasonQuality {
    return Intl.message(
      'Reason (Quality)',
      name: 'reasonQuality',
      desc: '',
      args: [],
    );
  }

  /// `Attached Evidence(s)`
  String get attachedEvidences {
    return Intl.message(
      'Attached Evidence(s)',
      name: 'attachedEvidences',
      desc: '',
      args: [],
    );
  }

  /// `Supplier Avg Response:`
  String get supplierAvgResponse {
    return Intl.message(
      'Supplier Avg Response:',
      name: 'supplierAvgResponse',
      desc: '',
      args: [],
    );
  }

  /// `Create Supplier Return`
  String get createSupplierReturn {
    return Intl.message(
      'Create Supplier Return',
      name: 'createSupplierReturn',
      desc: '',
      args: [],
    );
  }

  /// `Choose items from this order details to return`
  String get chooseItemsFromThisOrderDetailsToReturn {
    return Intl.message(
      'Choose items from this order details to return',
      name: 'chooseItemsFromThisOrderDetailsToReturn',
      desc: '',
      args: [],
    );
  }

  /// `Return Details`
  String get returnDetails {
    return Intl.message(
      'Return Details',
      name: 'returnDetails',
      desc: '',
      args: [],
    );
  }

  /// `Attach Evidence(s)`
  String get attachEvidences {
    return Intl.message(
      'Attach Evidence(s)',
      name: 'attachEvidences',
      desc: '',
      args: [],
    );
  }

  /// `e.g Damaged discovered during detailed inspection. Products do not meet required quality standards and cannot be sold to customers.`
  String get egDamagedDiscoveredDuringDetailedInspectionProductsDoNotMeet {
    return Intl.message(
      'e.g Damaged discovered during detailed inspection. Products do not meet required quality standards and cannot be sold to customers.',
      name: 'egDamagedDiscoveredDuringDetailedInspectionProductsDoNotMeet',
      desc: '',
      args: [],
    );
  }

  /// `Send Return Request`
  String get sendReturnRequest {
    return Intl.message(
      'Send Return Request',
      name: 'sendReturnRequest',
      desc: '',
      args: [],
    );
  }

  /// `Accept Rejection Without Escalation?`
  String get acceptRejectionWithoutEscalation {
    return Intl.message(
      'Accept Rejection Without Escalation?',
      name: 'acceptRejectionWithoutEscalation',
      desc: '',
      args: [],
    );
  }

  /// `You’re confirming that this return does not require further action.`
  String get youreConfirmingThatThisReturnDoesNotRequireFurtherAction {
    return Intl.message(
      'You’re confirming that this return does not require further action.',
      name: 'youreConfirmingThatThisReturnDoesNotRequireFurtherAction',
      desc: '',
      args: [],
    );
  }

  /// `The rejection will stand as-is, and no escalation will be triggered.`
  String get theRejectionWillStandAsisAndNoEscalationWillBe {
    return Intl.message(
      'The rejection will stand as-is, and no escalation will be triggered.',
      name: 'theRejectionWillStandAsisAndNoEscalationWillBe',
      desc: '',
      args: [],
    );
  }

  /// `This decision is final and cannot be undone.`
  String get thisDecisionIsFinalAndCannotBeUndone {
    return Intl.message(
      'This decision is final and cannot be undone.',
      name: 'thisDecisionIsFinalAndCannotBeUndone',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message('Accept', name: 'accept', desc: '', args: []);
  }

  /// `Cancel Escalation`
  String get cancelEscalation {
    return Intl.message(
      'Cancel Escalation',
      name: 'cancelEscalation',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Escalation`
  String get confirmEscalation {
    return Intl.message(
      'Confirm Escalation',
      name: 'confirmEscalation',
      desc: '',
      args: [],
    );
  }

  /// `Supplier’s Rejection Reason`
  String get suppliersRejectionReason {
    return Intl.message(
      'Supplier’s Rejection Reason',
      name: 'suppliersRejectionReason',
      desc: '',
      args: [],
    );
  }

  /// `The supplier has declined this return request. You can follow up or escalate if needed.`
  String get theSupplierHasDeclinedThisReturnRequestYouCanFollow {
    return Intl.message(
      'The supplier has declined this return request. You can follow up or escalate if needed.',
      name: 'theSupplierHasDeclinedThisReturnRequestYouCanFollow',
      desc: '',
      args: [],
    );
  }

  /// `Return Rejected`
  String get returnRejected {
    return Intl.message(
      'Return Rejected',
      name: 'returnRejected',
      desc: '',
      args: [],
    );
  }

  /// `Awaiting Supplier Review`
  String get awaitingSupplierReview {
    return Intl.message(
      'Awaiting Supplier Review',
      name: 'awaitingSupplierReview',
      desc: '',
      args: [],
    );
  }

  /// `The return has been submitted. Waiting for the supplier to review and respond.`
  String get theReturnHasBeenSubmittedWaitingForTheSupplierTo {
    return Intl.message(
      'The return has been submitted. Waiting for the supplier to review and respond.',
      name: 'theReturnHasBeenSubmittedWaitingForTheSupplierTo',
      desc: '',
      args: [],
    );
  }

  /// `Resolved – Refund Received`
  String get resolvedRefundReceived {
    return Intl.message(
      'Resolved – Refund Received',
      name: 'resolvedRefundReceived',
      desc: '',
      args: [],
    );
  }

  /// `You’ve been refunded for this return.`
  String get youveBeenRefundedForThisReturn {
    return Intl.message(
      'You’ve been refunded for this return.',
      name: 'youveBeenRefundedForThisReturn',
      desc: '',
      args: [],
    );
  }

  /// `Escalate Rejection`
  String get escalateRejection {
    return Intl.message(
      'Escalate Rejection',
      name: 'escalateRejection',
      desc: '',
      args: [],
    );
  }

  /// `Accept Rejection`
  String get acceptRejection {
    return Intl.message(
      'Accept Rejection',
      name: 'acceptRejection',
      desc: '',
      args: [],
    );
  }

  /// `Pending Resolution`
  String get pendingResolution {
    return Intl.message(
      'Pending Resolution',
      name: 'pendingResolution',
      desc: '',
      args: [],
    );
  }

  /// `Rejection escalated`
  String get rejectionEscalated {
    return Intl.message(
      'Rejection escalated',
      name: 'rejectionEscalated',
      desc: '',
      args: [],
    );
  }

  /// `Awaiting final decision from brand manager or Finance team.`
  String get awaitingFinalDecisionFromBrandManagerOrFinanceTeam {
    return Intl.message(
      'Awaiting final decision from brand manager or Finance team.',
      name: 'awaitingFinalDecisionFromBrandManagerOrFinanceTeam',
      desc: '',
      args: [],
    );
  }

  /// `Escalated on: {date}`
  String escalatedOnDate(Object date) {
    return Intl.message(
      'Escalated on: $date',
      name: 'escalatedOnDate',
      desc: '',
      args: [date],
    );
  }

  /// `Accepted on: {date}`
  String acceptedOnDate(Object date) {
    return Intl.message(
      'Accepted on: $date',
      name: 'acceptedOnDate',
      desc: '',
      args: [date],
    );
  }

  /// `View supplier’s rejection details`
  String get viewSuppliersRejectionDetails {
    return Intl.message(
      'View supplier’s rejection details',
      name: 'viewSuppliersRejectionDetails',
      desc: '',
      args: [],
    );
  }

  /// `Resolved by Brand Manager`
  String get resolvedByBrandManager {
    return Intl.message(
      'Resolved by Brand Manager',
      name: 'resolvedByBrandManager',
      desc: '',
      args: [],
    );
  }

  /// `Order Variance Resolved`
  String get orderVarianceResolved {
    return Intl.message(
      'Order Variance Resolved',
      name: 'orderVarianceResolved',
      desc: '',
      args: [],
    );
  }

  /// `Brand manager has marked this escalation as resolved.`
  String get brandManagerHasMarkedThisEscalationAsResolved {
    return Intl.message(
      'Brand manager has marked this escalation as resolved.',
      name: 'brandManagerHasMarkedThisEscalationAsResolved',
      desc: '',
      args: [],
    );
  }

  /// `Resolved on: {date}`
  String resolvedOnDate(Object date) {
    return Intl.message(
      'Resolved on: $date',
      name: 'resolvedOnDate',
      desc: '',
      args: [date],
    );
  }

  /// `shift:`
  String get shift {
    return Intl.message('shift:', name: 'shift', desc: '', args: []);
  }

  /// `Status:`
  String get status_column {
    return Intl.message('Status:', name: 'status_column', desc: '', args: []);
  }

  /// `Created By:`
  String get createdBy {
    return Intl.message('Created By:', name: 'createdBy', desc: '', args: []);
  }

  /// `Profile Settings`
  String get profileSettings {
    return Intl.message(
      'Profile Settings',
      name: 'profileSettings',
      desc: '',
      args: [],
    );
  }

  /// `Change Shift`
  String get changeShift {
    return Intl.message(
      'Change Shift',
      name: 'changeShift',
      desc: '',
      args: [],
    );
  }

  /// `Date:`
  String get date_columns {
    return Intl.message('Date:', name: 'date_columns', desc: '', args: []);
  }

  /// `Creation Details`
  String get creationDetails {
    return Intl.message(
      'Creation Details',
      name: 'creationDetails',
      desc: '',
      args: [],
    );
  }

  /// `Reason for Reassignment: (optional)`
  String get reasonForReassign {
    return Intl.message(
      'Reason for Reassignment: (optional)',
      name: 'reasonForReassign',
      desc: '',
      args: [],
    );
  }

  /// `Employee’s Profile has been created, pending activation by employee.`
  String get employeeProfileCreatedPendingActivation {
    return Intl.message(
      'Employee’s Profile has been created, pending activation by employee.',
      name: 'employeeProfileCreatedPendingActivation',
      desc: '',
      args: [],
    );
  }

  /// `This account has not been activated, so you cannot view their work shift history.`
  String get thisAccountHasNotBeenActivatedUCannotViewWorkHistory {
    return Intl.message(
      'This account has not been activated, so you cannot view their work shift history.',
      name: 'thisAccountHasNotBeenActivatedUCannotViewWorkHistory',
      desc: '',
      args: [],
    );
  }

  /// `Excellent`
  String get excellent {
    return Intl.message('Excellent', name: 'excellent', desc: '', args: []);
  }

  /// `Poor`
  String get poor {
    return Intl.message('Poor', name: 'poor', desc: '', args: []);
  }

  /// `Order Confirmed`
  String get orderConfirmated {
    return Intl.message(
      'Order Confirmed',
      name: 'orderConfirmated',
      desc: '',
      args: [],
    );
  }

  /// `You can track completed orders in the “Orders & Purchases” tool page.`
  String get youCanTrackCompletedOrdersInTheOrdersAndPurchasesToolPage {
    return Intl.message(
      'You can track completed orders in the “Orders & Purchases” tool page.',
      name: 'youCanTrackCompletedOrdersInTheOrdersAndPurchasesToolPage',
      desc: '',
      args: [],
    );
  }

  /// `Reject Items`
  String get rejectItems {
    return Intl.message(
      'Reject Items',
      name: 'rejectItems',
      desc: '',
      args: [],
    );
  }

  /// `Return Items`
  String get returnItems {
    return Intl.message(
      'Return Items',
      name: 'returnItems',
      desc: '',
      args: [],
    );
  }

  /// `Return Request Submitted`
  String get returnRequestSubmitted {
    return Intl.message(
      'Return Request Submitted',
      name: 'returnRequestSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Pending approval from {supplierName}, you will be notified when they respond.`
  String pendingApprovalFromSupplierYouWillBeNotifiedWhenTheyRespond(
    Object supplierName,
  ) {
    return Intl.message(
      'Pending approval from $supplierName, you will be notified when they respond.',
      name: 'pendingApprovalFromSupplierYouWillBeNotifiedWhenTheyRespond',
      desc: '',
      args: [supplierName],
    );
  }

  /// `Missing Documents (Drafts missing info)`
  String get missingDocuments {
    return Intl.message(
      'Missing Documents (Drafts missing info)',
      name: 'missingDocuments',
      desc: '',
      args: [],
    );
  }

  /// `You have draft entries with incomplete details.\n\nUpload required documents or complete missing fields to continue receiving the order.`
  String get missingDocumentsDesc {
    return Intl.message(
      'You have draft entries with incomplete details.\n\nUpload required documents or complete missing fields to continue receiving the order.',
      name: 'missingDocumentsDesc',
      desc: '',
      args: [],
    );
  }

  /// `No fully received orders yet.`
  String get noFullyReceivedOrdersYet {
    return Intl.message(
      'No fully received orders yet.',
      name: 'noFullyReceivedOrdersYet',
      desc: '',
      args: [],
    );
  }

  /// `Once you finish reviewing and confirming an order, it’ll appear here for reference.`
  String
  get onceYouFinishReviewingAndConfirmingAnOrderItllAppearHereForReference {
    return Intl.message(
      'Once you finish reviewing and confirming an order, it’ll appear here for reference.',
      name:
          'onceYouFinishReviewingAndConfirmingAnOrderItllAppearHereForReference',
      desc: '',
      args: [],
    );
  }

  /// `Pending Supplier Review`
  String get pendingSupplierReview {
    return Intl.message(
      'Pending Supplier Review',
      name: 'pendingSupplierReview',
      desc: '',
      args: [],
    );
  }

  /// `Pending Returns`
  String get noPendingReturns {
    return Intl.message(
      'Pending Returns',
      name: 'noPendingReturns',
      desc: '',
      args: [],
    );
  }

  /// `Resolved`
  String get resolved {
    return Intl.message('Resolved', name: 'resolved', desc: '', args: []);
  }

  /// `No returns in progress yet.`
  String get noReturnsInProgressYet {
    return Intl.message(
      'No returns in progress yet.',
      name: 'noReturnsInProgressYet',
      desc: '',
      args: [],
    );
  }

  /// `Once you start returning an item, it’ll appear here for tracking and follow-up.`
  String get onceYouStartReturningAnItemItllAppearHereForTrackingAndFollowUp {
    return Intl.message(
      'Once you start returning an item, it’ll appear here for tracking and follow-up.',
      name: 'onceYouStartReturningAnItemItllAppearHereForTrackingAndFollowUp',
      desc: '',
      args: [],
    );
  }

  /// `No completed returns yet.`
  String get noCompletedReturnsYet {
    return Intl.message(
      'No completed returns yet.',
      name: 'noCompletedReturnsYet',
      desc: '',
      args: [],
    );
  }

  /// `Returned items that are fully processed and closed will be listed here.`
  String get returnedItemsThatAreFullyProcessedAndClosedWillBeListedHere {
    return Intl.message(
      'Returned items that are fully processed and closed will be listed here.',
      name: 'returnedItemsThatAreFullyProcessedAndClosedWillBeListedHere',
      desc: '',
      args: [],
    );
  }

  /// `No Returns Available`
  String get noReturnsAvailable {
    return Intl.message(
      'No Returns Available',
      name: 'noReturnsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `All Returns ({count})`
  String allReturnsCount(Object count) {
    return Intl.message(
      'All Returns ($count)',
      name: 'allReturnsCount',
      desc: '',
      args: [count],
    );
  }

  /// `All Returns from All Store Branches`
  String get allReturnsFromAllStoreBranches {
    return Intl.message(
      'All Returns from All Store Branches',
      name: 'allReturnsFromAllStoreBranches',
      desc: '',
      args: [],
    );
  }

  /// `Reject Return`
  String get rejectReturn {
    return Intl.message(
      'Reject Return',
      name: 'rejectReturn',
      desc: '',
      args: [],
    );
  }

  /// `Approve Return`
  String get approveReturn {
    return Intl.message(
      'Approve Return',
      name: 'approveReturn',
      desc: '',
      args: [],
    );
  }

  /// `Reject Return Request`
  String get rejectReturnRequest {
    return Intl.message(
      'Reject Return Request',
      name: 'rejectReturnRequest',
      desc: '',
      args: [],
    );
  }

  /// `You’re about to reject this return request.`
  String get youAreAboutToRejectThisReturnRequest {
    return Intl.message(
      'You’re about to reject this return request.',
      name: 'youAreAboutToRejectThisReturnRequest',
      desc: '',
      args: [],
    );
  }

  /// `Please include a reason so they understand your position.`
  String get pleaseIncludeAReasonSoTheyUnderstandYourPosition {
    return Intl.message(
      'Please include a reason so they understand your position.',
      name: 'pleaseIncludeAReasonSoTheyUnderstandYourPosition',
      desc: '',
      args: [],
    );
  }

  /// `Once submitted, the buyer will be notified and can either accept your decision or escalate it to management for review.`
  String
  get onceSubmittedTheBuyerWillBeNotifiedAndCanEitherAcceptYourDecisionOrEscalateItToManagementForReview {
    return Intl.message(
      'Once submitted, the buyer will be notified and can either accept your decision or escalate it to management for review.',
      name:
          'onceSubmittedTheBuyerWillBeNotifiedAndCanEitherAcceptYourDecisionOrEscalateItToManagementForReview',
      desc: '',
      args: [],
    );
  }

  /// `Reject & Send Feedback`
  String get rejectAndSendFeedback {
    return Intl.message(
      'Reject & Send Feedback',
      name: 'rejectAndSendFeedback',
      desc: '',
      args: [],
    );
  }

  /// `No Orders Available`
  String get noOrdersAvailable {
    return Intl.message(
      'No Orders Available',
      name: 'noOrdersAvailable',
      desc: '',
      args: [],
    );
  }

  /// `You’ve confirmed that no further action is needed.`
  String get youveConfirmedThatNoFurtherActionIsNeeded {
    return Intl.message(
      'You’ve confirmed that no further action is needed.',
      name: 'youveConfirmedThatNoFurtherActionIsNeeded',
      desc: '',
      args: [],
    );
  }

  /// `Rejection Accepted`
  String get rejectionAccepted {
    return Intl.message(
      'Rejection Accepted',
      name: 'rejectionAccepted',
      desc: '',
      args: [],
    );
  }

  /// `You’ve successfully escalated the return rejection. The brand manager or finance team will review and get back to you.`
  String get youveSuccessfullyEscalatedTheReturnRejection {
    return Intl.message(
      'You’ve successfully escalated the return rejection. The brand manager or finance team will review and get back to you.',
      name: 'youveSuccessfullyEscalatedTheReturnRejection',
      desc: '',
      args: [],
    );
  }

  /// `They can now either accept your decision or escalate it for management-level resolution.`
  String
  get theyCanNowEitherAcceptYourDecisionOrEscalateItForManagementLevelResolution {
    return Intl.message(
      'They can now either accept your decision or escalate it for management-level resolution.',
      name:
          'theyCanNowEitherAcceptYourDecisionOrEscalateItForManagementLevelResolution',
      desc: '',
      args: [],
    );
  }

  /// `Rejection and marked this request as closed.`
  String get rejectionAndMarkedThisRequestAsClosed {
    return Intl.message(
      'Rejection and marked this request as closed.',
      name: 'rejectionAndMarkedThisRequestAsClosed',
      desc: '',
      args: [],
    );
  }

  /// `Rejected by You`
  String get rejectedByYou {
    return Intl.message(
      'Rejected by You',
      name: 'rejectedByYou',
      desc: '',
      args: [],
    );
  }

  /// `You’ve rejected this return request. The buyer has been notified.`
  String get youveRejectedThisReturnRequestTheBuyerHasBeenNotified {
    return Intl.message(
      'You’ve rejected this return request. The buyer has been notified.',
      name: 'youveRejectedThisReturnRequestTheBuyerHasBeenNotified',
      desc: '',
      args: [],
    );
  }

  /// `Opens`
  String get opens {
    return Intl.message('Opens', name: 'opens', desc: '', args: []);
  }

  /// `You submitted a delivery {date} extension. Pending approval from {branchName}`
  String youSubmittedADeliveryDateTimeExtensionPendingApprovalFromBranchName(
    Object date,
    Object branchName,
  ) {
    return Intl.message(
      'You submitted a delivery $date extension. Pending approval from $branchName',
      name:
          'youSubmittedADeliveryDateTimeExtensionPendingApprovalFromBranchName',
      desc: '',
      args: [date, branchName],
    );
  }

  /// `New {date} extension has been approved by {branchName}. Order delivery date has been updated`
  String newDateTimeExtensionApprovedByBranchName(
    Object date,
    Object branchName,
  ) {
    return Intl.message(
      'New $date extension has been approved by $branchName. Order delivery date has been updated',
      name: 'newDateTimeExtensionApprovedByBranchName',
      desc: '',
      args: [date, branchName],
    );
  }

  /// `Supplier has requested a delivery {date} extension. Pending your approval`
  String supplierHasRequestedADeliveryDateTimeExtensionPendingYourApproval(
    Object date,
  ) {
    return Intl.message(
      'Supplier has requested a delivery $date extension. Pending your approval',
      name: 'supplierHasRequestedADeliveryDateTimeExtensionPendingYourApproval',
      desc: '',
      args: [date],
    );
  }

  /// `New {date} extension has been approved by you. Order delivery date has been updated`
  String newDateTimeExtensionApproved(Object date) {
    return Intl.message(
      'New $date extension has been approved by you. Order delivery date has been updated',
      name: 'newDateTimeExtensionApproved',
      desc: '',
      args: [date],
    );
  }

  /// `You have rejected New {date} extension and Order has been canceled.`
  String newDateTimeExtensionRejected(Object date) {
    return Intl.message(
      'You have rejected New $date extension and Order has been canceled.',
      name: 'newDateTimeExtensionRejected',
      desc: '',
      args: [date],
    );
  }

  /// `Upon delivery, supplier will upload:`
  String get uponDeliverySupplierWillUpload {
    return Intl.message(
      'Upon delivery, supplier will upload:',
      name: 'uponDeliverySupplierWillUpload',
      desc: '',
      args: [],
    );
  }

  /// `You will upload required documents after order arrives to mark purchase as completed:`
  String
  get youWillUploadRequiredDocumentsAfterOrderArrivesToMarkPurchaseAsCompleted {
    return Intl.message(
      'You will upload required documents after order arrives to mark purchase as completed:',
      name:
          'youWillUploadRequiredDocumentsAfterOrderArrivesToMarkPurchaseAsCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Variance (Order, If Any)`
  String get varianceOrderIfAny {
    return Intl.message(
      'Variance (Order, If Any)',
      name: 'varianceOrderIfAny',
      desc: '',
      args: [],
    );
  }

  /// `Or receipt without docs (if still pending)`
  String get receiptWithoutDocs {
    return Intl.message(
      'Or receipt without docs (if still pending)',
      name: 'receiptWithoutDocs',
      desc: '',
      args: [],
    );
  }

  /// `See receipt details`
  String get seeReceiptDetails {
    return Intl.message(
      'See receipt details',
      name: 'seeReceiptDetails',
      desc: '',
      args: [],
    );
  }

  /// `Supplier must review and respond`
  String get supplierMustReviewAndRespond {
    return Intl.message(
      'Supplier must review and respond',
      name: 'supplierMustReviewAndRespond',
      desc: '',
      args: [],
    );
  }

  /// `Variance Logged`
  String get varianceLogged {
    return Intl.message(
      'Variance Logged',
      name: 'varianceLogged',
      desc: '',
      args: [],
    );
  }

  /// `View Variance Details & Verdict`
  String get viewVarianceDetailsAndVerdict {
    return Intl.message(
      'View Variance Details & Verdict',
      name: 'viewVarianceDetailsAndVerdict',
      desc: '',
      args: [],
    );
  }

  /// `Review details about this order’s completion & Confirmation:`
  String get reviewDetailsAboutThisOrdersCompletionConfirmation {
    return Intl.message(
      'Review details about this order’s completion & Confirmation:',
      name: 'reviewDetailsAboutThisOrdersCompletionConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Completed on: {date} - {time}`
  String completedOnDateTime(Object date, Object time) {
    return Intl.message(
      'Completed on: $date - $time',
      name: 'completedOnDateTime',
      desc: '',
      args: [date, time],
    );
  }

  /// `Variance Details`
  String get varianceDetails {
    return Intl.message(
      'Variance Details',
      name: 'varianceDetails',
      desc: '',
      args: [],
    );
  }

  /// `Item delivered is {quantity} {unit} lower than requested & Confirmed Qty.`
  String itemDeliveredIsQuantityUnitLowerThanRequestedAndConfirmedQty(
    String quantity,
    String unit,
  ) {
    return Intl.message(
      'Item delivered is $quantity $unit lower than requested & Confirmed Qty.',
      name: 'itemDeliveredIsQuantityUnitLowerThanRequestedAndConfirmedQty',
      desc: '',
      args: [quantity, unit],
    );
  }

  /// `Variance Detected`
  String get varianceDetected_v {
    return Intl.message(
      'Variance Detected',
      name: 'varianceDetected_v',
      desc: '',
      args: [],
    );
  }

  /// `Delay Request Approved`
  String get delayRequestApproved {
    return Intl.message(
      'Delay Request Approved',
      name: 'delayRequestApproved',
      desc: '',
      args: [],
    );
  }

  /// `The supplier has been notified.\nAll items will now follow the updated delivery schedule as proposed.`
  String
  get theSupplierHasBeenNotifiedAllItemsWillNowFollowTheUpdatedDeliveryScheduleAsProposed {
    return Intl.message(
      'The supplier has been notified.\nAll items will now follow the updated delivery schedule as proposed.',
      name:
          'theSupplierHasBeenNotifiedAllItemsWillNowFollowTheUpdatedDeliveryScheduleAsProposed',
      desc: '',
      args: [],
    );
  }

  /// `Delay Request Rejected`
  String get delayRequestRejected {
    return Intl.message(
      'Delay Request Rejected',
      name: 'delayRequestRejected',
      desc: '',
      args: [],
    );
  }

  /// `The supplier has been notified.\nThis order has been cancelled due to the missed delivery timeline.`
  String
  get theSupplierHasBeenNotifiedThisOrderHasBeenCancelledDueToTheMissedDeliveryTimeline {
    return Intl.message(
      'The supplier has been notified.\nThis order has been cancelled due to the missed delivery timeline.',
      name:
          'theSupplierHasBeenNotifiedThisOrderHasBeenCancelledDueToTheMissedDeliveryTimeline',
      desc: '',
      args: [],
    );
  }

  /// ` Reject Delay Request for All Items`
  String get rejectDelayRequestForAllItems {
    return Intl.message(
      ' Reject Delay Request for All Items',
      name: 'rejectDelayRequestForAllItems',
      desc: '',
      args: [],
    );
  }

  /// `You’re about to reject the supplier’s delay request.`
  String get youAreAboutToRejectTheSuppliersDelayRequest {
    return Intl.message(
      'You’re about to reject the supplier’s delay request.',
      name: 'youAreAboutToRejectTheSuppliersDelayRequest',
      desc: '',
      args: [],
    );
  }

  /// `Since the supplier cannot deliver by the original date, this order will be cancelled and removed from active processing.`
  String
  get sinceTheSupplierCannotDeliverByTheOriginalDateThisOrderWillBeCancelledAndRemovedFromActiveProcessing {
    return Intl.message(
      'Since the supplier cannot deliver by the original date, this order will be cancelled and removed from active processing.',
      name:
          'sinceTheSupplierCannotDeliverByTheOriginalDateThisOrderWillBeCancelledAndRemovedFromActiveProcessing',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Rejection`
  String get confirmRejection {
    return Intl.message(
      'Confirm Rejection',
      name: 'confirmRejection',
      desc: '',
      args: [],
    );
  }

  /// `Delay Approved`
  String get delayApproved {
    return Intl.message(
      'Delay Approved',
      name: 'delayApproved',
      desc: '',
      args: [],
    );
  }

  /// `Delay Rejected`
  String get delayRejected {
    return Intl.message(
      'Delay Rejected',
      name: 'delayRejected',
      desc: '',
      args: [],
    );
  }

  /// `Cashier Full Name`
  String get cashierFullName {
    return Intl.message(
      'Cashier Full Name',
      name: 'cashierFullName',
      desc: '',
      args: [],
    );
  }

  /// `Employee Role`
  String get employeeRole {
    return Intl.message(
      'Employee Role',
      name: 'employeeRole',
      desc: '',
      args: [],
    );
  }

  /// `Cashier E-mail`
  String get cashierEmail {
    return Intl.message(
      'Cashier E-mail',
      name: 'cashierEmail',
      desc: '',
      args: [],
    );
  }

  /// `Search branch...`
  String get searchBranch {
    return Intl.message(
      'Search branch...',
      name: 'searchBranch',
      desc: '',
      args: [],
    );
  }

  /// `Field cannot be empty`
  String get fieldCannotBeEmpty {
    return Intl.message(
      'Field cannot be empty',
      name: 'fieldCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Email is already registered`
  String get emailIsAlreadyRegistered {
    return Intl.message(
      'Email is already registered',
      name: 'emailIsAlreadyRegistered',
      desc: '',
      args: [],
    );
  }

  /// `Submitted From {branchName}`
  String submittedFromBranchName(Object branchName) {
    return Intl.message(
      'Submitted From $branchName',
      name: 'submittedFromBranchName',
      desc: '',
      args: [branchName],
    );
  }

  /// `{managerName} submitted this order Request for review and approval.`
  String managerNameSubmittedThisOrderRequestForReviewAndApproval(
    Object managerName,
  ) {
    return Intl.message(
      '$managerName submitted this order Request for review and approval.',
      name: 'managerNameSubmittedThisOrderRequestForReviewAndApproval',
      desc: '',
      args: [managerName],
    );
  }

  /// `Viewed By Supplier`
  String get viewedBySupplier {
    return Intl.message(
      'Viewed By Supplier',
      name: 'viewedBySupplier',
      desc: '',
      args: [],
    );
  }

  /// `Request was opened and reviewed, but no action has been taken yet.`
  String get requestWasOpenedAndReviewedButNoActionHasBeenTakenYet {
    return Intl.message(
      'Request was opened and reviewed, but no action has been taken yet.',
      name: 'requestWasOpenedAndReviewedButNoActionHasBeenTakenYet',
      desc: '',
      args: [],
    );
  }

  /// `Request was reviewed and approved.`
  String get requestWasReviewedAndApproved {
    return Intl.message(
      'Request was reviewed and approved.',
      name: 'requestWasReviewedAndApproved',
      desc: '',
      args: [],
    );
  }

  /// `Marked as Received`
  String get markedAsReceived {
    return Intl.message(
      'Marked as Received',
      name: 'markedAsReceived',
      desc: '',
      args: [],
    );
  }

  /// `You marked this order as Delivery. now confirmed as received.`
  String get youMarkedThisOrderAsDeliveryNowConfirmedAsReceived {
    return Intl.message(
      'You marked this order as Delivery. now confirmed as received.',
      name: 'youMarkedThisOrderAsDeliveryNowConfirmedAsReceived',
      desc: '',
      args: [],
    );
  }

  /// `Request was rejected. You’ll find the reason attached in “Details”.`
  String get requestWasRejectedYoullFindTheReasonAttachedInDetails {
    return Intl.message(
      'Request was rejected. You’ll find the reason attached in “Details”.',
      name: 'requestWasRejectedYoullFindTheReasonAttachedInDetails',
      desc: '',
      args: [],
    );
  }

  /// `Modified`
  String get modified {
    return Intl.message('Modified', name: 'modified', desc: '', args: []);
  }

  /// `Order modified. Review the changes in “Details”`
  String get orderModifiedDesc {
    return Intl.message(
      'Order modified. Review the changes in “Details”',
      name: 'orderModifiedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Request was canceled. You’ll find the reason attached in “Details”.`
  String get requestWasCanceledYoullFindTheReasonAttachedInDetails {
    return Intl.message(
      'Request was canceled. You’ll find the reason attached in “Details”.',
      name: 'requestWasCanceledYoullFindTheReasonAttachedInDetails',
      desc: '',
      args: [],
    );
  }

  /// `Submitted`
  String get submitted {
    return Intl.message('Submitted', name: 'submitted', desc: '', args: []);
  }

  /// `{managerName} submitted this item return request for review and approval.`
  String managerNameSubmittedThisItemReturnRequestForReviewAndApproval(
    Object managerName,
  ) {
    return Intl.message(
      '$managerName submitted this item return request for review and approval.',
      name: 'managerNameSubmittedThisItemReturnRequestForReviewAndApproval',
      desc: '',
      args: [managerName],
    );
  }

  /// `Return approved. The supplier has been notified to process the return.`
  String get returnApprovedDesc {
    return Intl.message(
      'Return approved. The supplier has been notified to process the return.',
      name: 'returnApprovedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Return rejected. Review the reason in “Details”.`
  String get returnRejectedDesc {
    return Intl.message(
      'Return rejected. Review the reason in “Details”.',
      name: 'returnRejectedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Escalated`
  String get escalated {
    return Intl.message('Escalated', name: 'escalated', desc: '', args: []);
  }

  /// `Return escalation submitted. Awaiting management review and final decision.`
  String get returnEscalatedDesc {
    return Intl.message(
      'Return escalation submitted. Awaiting management review and final decision.',
      name: 'returnEscalatedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Return resolved by brand manager. Review details in “Details”.`
  String get returnResolvedDesc {
    return Intl.message(
      'Return resolved by brand manager. Review details in “Details”.',
      name: 'returnResolvedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Urgent Notifications:`
  String get urgentNotifications {
    return Intl.message(
      'Urgent Notifications:',
      name: 'urgentNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Today's inventory not completed yet`
  String get todaysInventoryNotCompletedYet {
    return Intl.message(
      'Today\'s inventory not completed yet',
      name: 'todaysInventoryNotCompletedYet',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday's report`
  String get yesterdaysReport {
    return Intl.message(
      'Yesterday\'s report',
      name: 'yesterdaysReport',
      desc: '',
      args: [],
    );
  }

  /// `discrepancies need clarification`
  String get discrepanciesNeedClarification {
    return Intl.message(
      'discrepancies need clarification',
      name: 'discrepanciesNeedClarification',
      desc: '',
      args: [],
    );
  }

  /// `waste & damage drafts saved`
  String get wasteAndDamageDraftsSaved {
    return Intl.message(
      'waste & damage drafts saved',
      name: 'wasteAndDamageDraftsSaved',
      desc: '',
      args: [],
    );
  }

  /// `Core Tasks (5):`
  String get coreTasks {
    return Intl.message(
      'Core Tasks (5):',
      name: 'coreTasks',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Inventory`
  String get monthlyInventory {
    return Intl.message(
      'Monthly Inventory',
      name: 'monthlyInventory',
      desc: '',
      args: [],
    );
  }

  /// `Smart Monthly Inventory`
  String get smartMonthlyInventory {
    return Intl.message(
      'Smart Monthly Inventory',
      name: 'smartMonthlyInventory',
      desc: '',
      args: [],
    );
  }

  /// `Waste & Damage Mgmt.`
  String get wasteAndDamageMgmt {
    return Intl.message(
      'Waste & Damage Mgmt.',
      name: 'wasteAndDamageMgmt',
      desc: '',
      args: [],
    );
  }

  /// `Reports & Review`
  String get reportsAndReview {
    return Intl.message(
      'Reports & Review',
      name: 'reportsAndReview',
      desc: '',
      args: [],
    );
  }

  /// `Quick Overview:`
  String get quickOverview {
    return Intl.message(
      'Quick Overview:',
      name: 'quickOverview',
      desc: '',
      args: [],
    );
  }

  /// `Inventory Status`
  String get inventoryStatus {
    return Intl.message(
      'Inventory Status',
      name: 'inventoryStatus',
      desc: '',
      args: [],
    );
  }

  /// `Daily inventory`
  String get dailyInventoryValue {
    return Intl.message(
      'Daily inventory',
      name: 'dailyInventoryValue',
      desc: '',
      args: [],
    );
  }

  /// `{count} Products`
  String productsCount(int count) {
    return Intl.message(
      '$count Products',
      name: 'productsCount',
      desc: 'Displays products count',
      args: [count],
    );
  }

  /// `1,247 products`
  String get productsCountValue {
    return Intl.message(
      '1,247 products',
      name: 'productsCountValue',
      desc: '',
      args: [],
    );
  }

  /// `Inventory State`
  String get inventoryState {
    return Intl.message(
      'Inventory State',
      name: 'inventoryState',
      desc: '',
      args: [],
    );
  }

  /// `Pending (not started)`
  String get pendingNotStarted {
    return Intl.message(
      'Pending (not started)',
      name: 'pendingNotStarted',
      desc: '',
      args: [],
    );
  }

  /// `Schedule`
  String get schedule {
    return Intl.message('Schedule', name: 'schedule', desc: '', args: []);
  }

  /// `9:00 AM daily`
  String get scheduleValue {
    return Intl.message(
      '9:00 AM daily',
      name: 'scheduleValue',
      desc: '',
      args: [],
    );
  }

  /// `Personal & Waste Overview:`
  String get personalAndWasteOverview {
    return Intl.message(
      'Personal & Waste Overview:',
      name: 'personalAndWasteOverview',
      desc: '',
      args: [],
    );
  }

  /// `Your Personal Balance`
  String get yourPersonalBalance {
    return Intl.message(
      'Your Personal Balance',
      name: 'yourPersonalBalance',
      desc: '',
      args: [],
    );
  }

  /// `-125 SAR shortage`
  String get personalBalanceValue {
    return Intl.message(
      '-125 SAR shortage',
      name: 'personalBalanceValue',
      desc: '',
      args: [],
    );
  }

  /// `Daily Waste review status`
  String get dailyWasteReviewStatus {
    return Intl.message(
      'Daily Waste review status',
      name: 'dailyWasteReviewStatus',
      desc: '',
      args: [],
    );
  }

  /// `Needs review`
  String get needsReview {
    return Intl.message(
      'Needs review',
      name: 'needsReview',
      desc: '',
      args: [],
    );
  }

  /// `Increase from yesterday 💰 Value`
  String get increaseFromYesterdayValue {
    return Intl.message(
      'Increase from yesterday 💰 Value',
      name: 'increaseFromYesterdayValue',
      desc: '',
      args: [],
    );
  }

  /// `Your Personal Account`
  String get yourPersonalAccount {
    return Intl.message(
      'Your Personal Account',
      name: 'yourPersonalAccount',
      desc: '',
      args: [],
    );
  }

  /// `Choose from  the buttons below to resolve this shortage`
  String get chooseFromButtonsToResolveShortage {
    return Intl.message(
      'Choose from  the buttons below to resolve this shortage',
      name: 'chooseFromButtonsToResolveShortage',
      desc: '',
      args: [],
    );
  }

  /// `Request Review`
  String get requestReview {
    return Intl.message(
      'Request Review',
      name: 'requestReview',
      desc: '',
      args: [],
    );
  }

  /// `No Requests Yet`
  String get noRequestsYet {
    return Intl.message(
      'No Requests Yet',
      name: 'noRequestsYet',
      desc: '',
      args: [],
    );
  }

  /// `You have not sent any custody requests to Store Owner for approvals.`
  String get youHaveNotSentAnyCustodyRequestsToStoreOwnerForApprovals {
    return Intl.message(
      'You have not sent any custody requests to Store Owner for approvals.',
      name: 'youHaveNotSentAnyCustodyRequestsToStoreOwnerForApprovals',
      desc: '',
      args: [],
    );
  }

  /// `No Transactions Yet`
  String get noTransactionsYet {
    return Intl.message(
      'No Transactions Yet',
      name: 'noTransactionsYet',
      desc: '',
      args: [],
    );
  }

  /// `This branch hasn’t received any payments or recorded any expenses yet.`
  String get thisBranchHasntReceivedAnyPaymentsOrRecordedAnyExpensesYet {
    return Intl.message(
      'This branch hasn’t received any payments or recorded any expenses yet.',
      name: 'thisBranchHasntReceivedAnyPaymentsOrRecordedAnyExpensesYet',
      desc: '',
      args: [],
    );
  }

  /// `Your account activity will appear here once transactions are recorded.`
  String get yourAccountActivityWillAppearHereOnceTransactionsAreRecorded {
    return Intl.message(
      'Your account activity will appear here once transactions are recorded.',
      name: 'yourAccountActivityWillAppearHereOnceTransactionsAreRecorded',
      desc: '',
      args: [],
    );
  }

  /// `Voice`
  String get voice {
    return Intl.message('Voice', name: 'voice', desc: '', args: []);
  }

  /// `Camera`
  String get camera {
    return Intl.message('Camera', name: 'camera', desc: '', args: []);
  }

  /// `Slider`
  String get slider {
    return Intl.message('Slider', name: 'slider', desc: '', args: []);
  }

  /// `💡 Quick Suggestions`
  String get quickSuggestions {
    return Intl.message(
      '💡 Quick Suggestions',
      name: 'quickSuggestions',
      desc: '',
      args: [],
    );
  }

  /// `Input Methods:`
  String get inputMethods {
    return Intl.message(
      'Input Methods:',
      name: 'inputMethods',
      desc: '',
      args: [],
    );
  }

  /// `Daily Quick Inventory`
  String get dailyQuickInventory {
    return Intl.message(
      'Daily Quick Inventory',
      name: 'dailyQuickInventory',
      desc: '',
      args: [],
    );
  }

  /// `Enter {itemName} Actual Quantity`
  String enterItemActualQuantity(Object itemName) {
    return Intl.message(
      'Enter $itemName Actual Quantity',
      name: 'enterItemActualQuantity',
      desc: '',
      args: [itemName],
    );
  }

  /// `Selected Products for Today's Inventory ({count} products): `
  String selectedProductsForTodaysInventory(Object count) {
    return Intl.message(
      'Selected Products for Today\'s Inventory ($count products): ',
      name: 'selectedProductsForTodaysInventory',
      desc: '',
      args: [count],
    );
  }

  /// `Products pre-selected by management`
  String get productsPreSelectedByManagement {
    return Intl.message(
      'Products pre-selected by management',
      name: 'productsPreSelectedByManagement',
      desc: '',
      args: [],
    );
  }

  /// `Start Daily Quick Inventory`
  String get startDailyQuickInventory {
    return Intl.message(
      'Start Daily Quick Inventory',
      name: 'startDailyQuickInventory',
      desc: '',
      args: [],
    );
  }

  /// `Choose Inventory Method for Today's Inventory ({count} selected products):`
  String chooseInventoryMethodForTodaysInventory(Object count) {
    return Intl.message(
      'Choose Inventory Method for Today\'s Inventory ($count selected products):',
      name: 'chooseInventoryMethodForTodaysInventory',
      desc: '',
      args: [count],
    );
  }

  /// `Personal Inventory`
  String get personalInventory {
    return Intl.message(
      'Personal Inventory',
      name: 'personalInventory',
      desc: '',
      args: [],
    );
  }

  /// `Perform inventory yourself as branch manager`
  String get performInventoryYourselfAsBranchManager {
    return Intl.message(
      'Perform inventory yourself as branch manager',
      name: 'performInventoryYourselfAsBranchManager',
      desc: '',
      args: [],
    );
  }

  /// `Advantages:`
  String get advantages {
    return Intl.message('Advantages:', name: 'advantages', desc: '', args: []);
  }

  /// `Speed and efficiency`
  String get speedAndEfficiency {
    return Intl.message(
      'Speed and efficiency',
      name: 'speedAndEfficiency',
      desc: '',
      args: [],
    );
  }

  /// `Direct control`
  String get directControl {
    return Intl.message(
      'Direct control',
      name: 'directControl',
      desc: '',
      args: [],
    );
  }

  /// `Complete responsibility`
  String get completeResponsibility {
    return Intl.message(
      'Complete responsibility',
      name: 'completeResponsibility',
      desc: '',
      args: [],
    );
  }

  /// `Start Myself`
  String get startMyself {
    return Intl.message(
      'Start Myself',
      name: 'startMyself',
      desc: '',
      args: [],
    );
  }

  /// `Assign Staff`
  String get assignStaff {
    return Intl.message(
      'Assign Staff',
      name: 'assignStaff',
      desc: '',
      args: [],
    );
  }

  /// `Choose a staff to perform inventory`
  String get chooseAStaffToPerformInventory {
    return Intl.message(
      'Choose a staff to perform inventory',
      name: 'chooseAStaffToPerformInventory',
      desc: '',
      args: [],
    );
  }

  /// `Assignment Details:`
  String get assignmentDetails {
    return Intl.message(
      'Assignment Details:',
      name: 'assignmentDetails',
      desc: '',
      args: [],
    );
  }

  /// `Assigned staff: -`
  String get assignedStaff {
    return Intl.message(
      'Assigned staff: -',
      name: 'assignedStaff',
      desc: '',
      args: [],
    );
  }

  /// `Responsibility: Remains with you as manager`
  String get responsibilityRemainsWithYouAsManager {
    return Intl.message(
      'Responsibility: Remains with you as manager',
      name: 'responsibilityRemainsWithYouAsManager',
      desc: '',
      args: [],
    );
  }

  /// `Review: Optional before sending`
  String get reviewOptionalBeforeSending {
    return Intl.message(
      'Review: Optional before sending',
      name: 'reviewOptionalBeforeSending',
      desc: '',
      args: [],
    );
  }

  /// `Employee/Staff`
  String get employeeStaff {
    return Intl.message(
      'Employee/Staff',
      name: 'employeeStaff',
      desc: '',
      args: [],
    );
  }

  /// `Choose Staff First`
  String get chooseStaffFirst {
    return Intl.message(
      'Choose Staff First',
      name: 'chooseStaffFirst',
      desc: '',
      args: [],
    );
  }

  /// `Bottles`
  String get bottles {
    return Intl.message('Bottles', name: 'bottles', desc: '', args: []);
  }

  /// `Gallons`
  String get gallons {
    return Intl.message('Gallons', name: 'gallons', desc: '', args: []);
  }

  /// `Barrels`
  String get barrels {
    return Intl.message('Barrels', name: 'barrels', desc: '', args: []);
  }

  /// `Packs`
  String get packs {
    return Intl.message('Packs', name: 'packs', desc: '', args: []);
  }

  /// `Back to Inventory`
  String get backToInventory {
    return Intl.message(
      'Back to Inventory',
      name: 'backToInventory',
      desc: '',
      args: [],
    );
  }

  /// `Team Member Assigned`
  String get teamMemberAssigned {
    return Intl.message(
      'Team Member Assigned',
      name: 'teamMemberAssigned',
      desc: '',
      args: [],
    );
  }

  /// `They'll receive a task and submit the recorded quantity.`
  String get theyWillReceiveTaskAndSubmitQuantity {
    return Intl.message(
      'They\'ll receive a task and submit the recorded quantity.',
      name: 'theyWillReceiveTaskAndSubmitQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Employee's Full Name`
  String get employeesFullName {
    return Intl.message(
      'Employee\'s Full Name',
      name: 'employeesFullName',
      desc: '',
      args: [],
    );
  }

  /// `Next Steps:`
  String get nextSteps {
    return Intl.message('Next Steps:', name: 'nextSteps', desc: '', args: []);
  }

  /// `1. Staff completes the count`
  String get staffCompletesTheCount {
    return Intl.message(
      '1. Staff completes the count',
      name: 'staffCompletesTheCount',
      desc: '',
      args: [],
    );
  }

  /// `2. You review and confirm`
  String get youReviewAndConfirm {
    return Intl.message(
      '2. You review and confirm',
      name: 'youReviewAndConfirm',
      desc: '',
      args: [],
    );
  }

  /// `3. Data is sent to the accountant`
  String get dataIsSentToTheAccountant {
    return Intl.message(
      '3. Data is sent to the accountant',
      name: 'dataIsSentToTheAccountant',
      desc: '',
      args: [],
    );
  }

  /// `4. Sales input is synced from external system`
  String get salesInputIsSyncedFromExternalSystem {
    return Intl.message(
      '4. Sales input is synced from external system',
      name: 'salesInputIsSyncedFromExternalSystem',
      desc: '',
      args: [],
    );
  }

  /// `5. Discrepancy report will follow within hours`
  String get discrepancyReportWillFollowWithinHours {
    return Intl.message(
      '5. Discrepancy report will follow within hours',
      name: 'discrepancyReportWillFollowWithinHours',
      desc: '',
      args: [],
    );
  }

  /// `Change Method`
  String get changeMethod {
    return Intl.message(
      'Change Method',
      name: 'changeMethod',
      desc: '',
      args: [],
    );
  }

  /// `Daily Inventory Summary`
  String get dailyInventorySummary {
    return Intl.message(
      'Daily Inventory Summary',
      name: 'dailyInventorySummary',
      desc: '',
      args: [],
    );
  }

  /// `Review the inventory count details before submitting. You can save to draft or submit now.`
  String get reviewInventoryCountDetails {
    return Intl.message(
      'Review the inventory count details before submitting. You can save to draft or submit now.',
      name: 'reviewInventoryCountDetails',
      desc: '',
      args: [],
    );
  }

  /// `Session Summary`
  String get sessionSummary {
    return Intl.message(
      'Session Summary',
      name: 'sessionSummary',
      desc: '',
      args: [],
    );
  }

  /// `Inventory date`
  String get inventoryDate {
    return Intl.message(
      'Inventory date',
      name: 'inventoryDate',
      desc: '',
      args: [],
    );
  }

  /// `Start time`
  String get startTime {
    return Intl.message('Start time', name: 'startTime', desc: '', args: []);
  }

  /// `Time taken`
  String get timeTaken {
    return Intl.message('Time taken', name: 'timeTaken', desc: '', args: []);
  }

  /// `Performed by`
  String get performedBy {
    return Intl.message(
      'Performed by',
      name: 'performedBy',
      desc: '',
      args: [],
    );
  }

  /// `Completed products`
  String get completedProducts {
    return Intl.message(
      'Completed products',
      name: 'completedProducts',
      desc: '',
      args: [],
    );
  }

  /// `All Inventoried Products`
  String get allInventoriedProducts {
    return Intl.message(
      'All Inventoried Products',
      name: 'allInventoriedProducts',
      desc: '',
      args: [],
    );
  }

  /// `Final Checkpoints:`
  String get finalCheckpoints {
    return Intl.message(
      'Final Checkpoints:',
      name: 'finalCheckpoints',
      desc: '',
      args: [],
    );
  }

  /// `All products inventoried`
  String get allProductsInventoried {
    return Intl.message(
      'All products inventoried',
      name: 'allProductsInventoried',
      desc: '',
      args: [],
    );
  }

  /// `Quantities accurate and reviewed`
  String get quantitiesAccurateAndReviewed {
    return Intl.message(
      'Quantities accurate and reviewed',
      name: 'quantitiesAccurateAndReviewed',
      desc: '',
      args: [],
    );
  }

  /// `No input errors`
  String get noInputErrors {
    return Intl.message(
      'No input errors',
      name: 'noInputErrors',
      desc: '',
      args: [],
    );
  }

  /// `Special notes recorded`
  String get specialNotesRecorded {
    return Intl.message(
      'Special notes recorded',
      name: 'specialNotesRecorded',
      desc: '',
      args: [],
    );
  }

  /// `1. Send data to accountant`
  String get sendDataToAccountant {
    return Intl.message(
      '1. Send data to accountant',
      name: 'sendDataToAccountant',
      desc: '',
      args: [],
    );
  }

  /// `2. Sales input from external system`
  String get salesInputFromExternalSystem {
    return Intl.message(
      '2. Sales input from external system',
      name: 'salesInputFromExternalSystem',
      desc: '',
      args: [],
    );
  }

  /// `3. Discrepancy report will arrive within hours`
  String get discrepancyReportWithinHours {
    return Intl.message(
      '3. Discrepancy report will arrive within hours',
      name: 'discrepancyReportWithinHours',
      desc: '',
      args: [],
    );
  }

  /// `Send Data`
  String get sendData {
    return Intl.message('Send Data', name: 'sendData', desc: '', args: []);
  }

  /// `All Inventoried Products ({count}):`
  String allInventoriedProductsCount(Object count) {
    return Intl.message(
      'All Inventoried Products ($count):',
      name: 'allInventoriedProductsCount',
      desc: '',
      args: [count],
    );
  }

  /// `Count Completed!`
  String get countCompleted {
    return Intl.message(
      'Count Completed!',
      name: 'countCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Your daily inventory count has been successfully submitted.`
  String get yourDailyInventoryCountHasBeenSuccessfullySubmitted {
    return Intl.message(
      'Your daily inventory count has been successfully submitted.',
      name: 'yourDailyInventoryCountHasBeenSuccessfullySubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Daily Inventory Reassigned`
  String get dailyInventoryReassigned {
    return Intl.message(
      'Daily Inventory Reassigned',
      name: 'dailyInventoryReassigned',
      desc: '',
      args: [],
    );
  }

  /// `Employee's list`
  String get employeesList {
    return Intl.message(
      'Employee\'s list',
      name: 'employeesList',
      desc: '',
      args: [],
    );
  }

  /// `Assign an employee to complete this daily Inventory count:`
  String get assignEmployeeToInventory {
    return Intl.message(
      'Assign an employee to complete this daily Inventory count:',
      name: 'assignEmployeeToInventory',
      desc: '',
      args: [],
    );
  }

  /// `Search for employee's by first or last name`
  String get searchEmployeesByName {
    return Intl.message(
      'Search for employee\'s by first or last name',
      name: 'searchEmployeesByName',
      desc: '',
      args: [],
    );
  }

  /// `No employees found`
  String get noEmployeesFound {
    return Intl.message(
      'No employees found',
      name: 'noEmployeesFound',
      desc: '',
      args: [],
    );
  }

  /// `Assign Now`
  String get assignNow {
    return Intl.message('Assign Now', name: 'assignNow', desc: '', args: []);
  }

  /// `Varianced`
  String get varianced {
    return Intl.message('Varianced', name: 'varianced', desc: '', args: []);
  }

  /// `Monthly Regular Inventory Setup`
  String get monthlyRegularInventorySetup {
    return Intl.message(
      'Monthly Regular Inventory Setup',
      name: 'monthlyRegularInventorySetup',
      desc: '',
      args: [],
    );
  }

  /// `Simplified Monthly Inventory Setup (Brnch. Mgr.)`
  String get simplifiedMonthlyInventorySetup {
    return Intl.message(
      'Simplified Monthly Inventory Setup (Brnch. Mgr.)',
      name: 'simplifiedMonthlyInventorySetup',
      desc: '',
      args: [],
    );
  }

  /// `Inventory Team:`
  String get inventoryTeam {
    return Intl.message(
      'Inventory Team:',
      name: 'inventoryTeam',
      desc: '',
      args: [],
    );
  }

  /// `Add staff's for this month's inventory count.`
  String get addStaffForThisMonthsInventoryCount {
    return Intl.message(
      'Add staff\'s for this month\'s inventory count.',
      name: 'addStaffForThisMonthsInventoryCount',
      desc: '',
      args: [],
    );
  }

  /// `Team Leader`
  String get teamLeader {
    return Intl.message('Team Leader', name: 'teamLeader', desc: '', args: []);
  }

  /// `First Staff`
  String get firstStaff {
    return Intl.message('First Staff', name: 'firstStaff', desc: '', args: []);
  }

  /// `Smart suggestion - Last inventory team:`
  String get smartSuggestionLastInventoryTeam {
    return Intl.message(
      'Smart suggestion - Last inventory team:',
      name: 'smartSuggestionLastInventoryTeam',
      desc: '',
      args: [],
    );
  }

  /// `Staff Name`
  String get staffName {
    return Intl.message('Staff Name', name: 'staffName', desc: '', args: []);
  }

  /// `Use same team`
  String get useSameTeam {
    return Intl.message(
      'Use same team',
      name: 'useSameTeam',
      desc: '',
      args: [],
    );
  }

  /// `Start Inventory`
  String get startInventory {
    return Intl.message(
      'Start Inventory',
      name: 'startInventory',
      desc: '',
      args: [],
    );
  }

  /// `(You)`
  String get you {
    return Intl.message('(You)', name: 'you', desc: '', args: []);
  }

  /// `Completed Products ({count})`
  String completedProductsCount(int count) {
    return Intl.message(
      'Completed Products ($count)',
      name: 'completedProductsCount',
      desc: 'Displays completed products count',
      args: [count],
    );
  }

  /// `Start Counting`
  String get startCounting {
    return Intl.message(
      'Start Counting',
      name: 'startCounting',
      desc: '',
      args: [],
    );
  }

  /// `No Inventories`
  String get noInventories {
    return Intl.message(
      'No Inventories',
      name: 'noInventories',
      desc: '',
      args: [],
    );
  }

  /// `You and your team have not counted any products yet. Click on "New Inventory" to get started`
  String get noInventoriesDesc {
    return Intl.message(
      'You and your team have not counted any products yet. Click on "New Inventory" to get started',
      name: 'noInventoriesDesc',
      desc: '',
      args: [],
    );
  }

  /// `Review Inventory`
  String get reviewInventory {
    return Intl.message(
      'Review Inventory',
      name: 'reviewInventory',
      desc: '',
      args: [],
    );
  }

  /// `Pending Products ({count})`
  String pendingProducts(int count) {
    return Intl.message(
      'Pending Products ($count)',
      name: 'pendingProducts',
      desc: 'Displays pending products count',
      args: [count],
    );
  }

  /// `Choose a product to start the inventory count`
  String get chooseAProductToStartTheInventoryCount {
    return Intl.message(
      'Choose a product to start the inventory count',
      name: 'chooseAProductToStartTheInventoryCount',
      desc: '',
      args: [],
    );
  }

  /// `Item Name`
  String get itemName {
    return Intl.message('Item Name', name: 'itemName', desc: '', args: []);
  }

  /// `Sara`
  String get sara {
    return Intl.message('Sara', name: 'sara', desc: '', args: []);
  }

  /// ` is handling it...`
  String get isHandlingIt {
    return Intl.message(
      ' is handling it...',
      name: 'isHandlingIt',
      desc: '',
      args: [],
    );
  }

  /// `({mins} Mins ago)`
  String minsAgo(int mins) {
    return Intl.message(
      '($mins Mins ago)',
      name: 'minsAgo',
      desc: 'Displays time ago in minutes',
      args: [mins],
    );
  }

  /// `Discrepancy`
  String get discrepancy {
    return Intl.message('Discrepancy', name: 'discrepancy', desc: '', args: []);
  }

  /// `Monthly Regular Inventory`
  String get monthlyRegularInventory {
    return Intl.message(
      'Monthly Regular Inventory',
      name: 'monthlyRegularInventory',
      desc: '',
      args: [],
    );
  }

  /// `Simplified Monthly Inventory count`
  String get simplifiedMonthlyInventoryCount {
    return Intl.message(
      'Simplified Monthly Inventory count',
      name: 'simplifiedMonthlyInventoryCount',
      desc: '',
      args: [],
    );
  }

  /// `Inventory Complete`
  String get inventoryComplete {
    return Intl.message(
      'Inventory Complete',
      name: 'inventoryComplete',
      desc: '',
      args: [],
    );
  }

  /// `You can save as a draft or submit now for review.`
  String get youCanSaveAsADraftOrSubmitNowForReview {
    return Intl.message(
      'You can save as a draft or submit now for review.',
      name: 'youCanSaveAsADraftOrSubmitNowForReview',
      desc: '',
      args: [],
    );
  }

  /// `If the indicator appears significantly off-center, it may signal incorrect quantity input.`
  String
  get ifTheIndicatorAppearsSignificantlyOffCenterItMaySignalIncorrectQuantityInput {
    return Intl.message(
      'If the indicator appears significantly off-center, it may signal incorrect quantity input.',
      name:
          'ifTheIndicatorAppearsSignificantlyOffCenterItMaySignalIncorrectQuantityInput',
      desc: '',
      args: [],
    );
  }

  /// `Smart Monthly Inventory Comparison`
  String get smartMonthlyInventoryComparison {
    return Intl.message(
      'Smart Monthly Inventory Comparison',
      name: 'smartMonthlyInventoryComparison',
      desc: '',
      args: [],
    );
  }

  /// `See the difference between this month’s inventory against last month’s inventory:`
  String
  get seeTheDifferenceBetweenThisMonthsInventoryAgainstLastMonthsInventory {
    return Intl.message(
      'See the difference between this month’s inventory against last month’s inventory:',
      name:
          'seeTheDifferenceBetweenThisMonthsInventoryAgainstLastMonthsInventory',
      desc: '',
      args: [],
    );
  }

  /// `This Month`
  String get thisMonth {
    return Intl.message('This Month', name: 'thisMonth', desc: '', args: []);
  }

  /// `Previous Month`
  String get previousMonth {
    return Intl.message(
      'Previous Month',
      name: 'previousMonth',
      desc: '',
      args: [],
    );
  }

  /// `Increase`
  String get increase {
    return Intl.message('Increase', name: 'increase', desc: '', args: []);
  }

  /// `Team Contribution:`
  String get teamContribution {
    return Intl.message(
      'Team Contribution:',
      name: 'teamContribution',
      desc: '',
      args: [],
    );
  }

  /// `Excellent Performance`
  String get excellentPerformance {
    return Intl.message(
      'Excellent Performance',
      name: 'excellentPerformance',
      desc: '',
      args: [],
    );
  }

  /// `Export Report`
  String get exportReport {
    return Intl.message(
      'Export Report',
      name: 'exportReport',
      desc: '',
      args: [],
    );
  }

  /// `e.g Taxi fare for supply run`
  String get egTaxiFareForSupplyRun {
    return Intl.message(
      'e.g Taxi fare for supply run',
      name: 'egTaxiFareForSupplyRun',
      desc: '',
      args: [],
    );
  }

  /// `July 6, daily Inventory details`
  String get july6DailyInventoryDetails {
    return Intl.message(
      'July 6, daily Inventory details',
      name: 'july6DailyInventoryDetails',
      desc: '',
      args: [],
    );
  }

  /// `Pending Final Review`
  String get pendingFinalReview {
    return Intl.message(
      'Pending Final Review',
      name: 'pendingFinalReview',
      desc: '',
      args: [],
    );
  }

  /// `Send data to accountant\nSales input from external system\nDiscrepancy report will arrive within hours`
  String
  get sendDataToAccountantSalesInputFromExternalSystemDiscrepancyReportWillArriveWithinHours {
    return Intl.message(
      'Send data to accountant\nSales input from external system\nDiscrepancy report will arrive within hours',
      name:
          'sendDataToAccountantSalesInputFromExternalSystemDiscrepancyReportWillArriveWithinHours',
      desc: '',
      args: [],
    );
  }

  /// `Overall/Comprehensive Actions`
  String get overallComprehensiveActions {
    return Intl.message(
      'Overall/Comprehensive Actions',
      name: 'overallComprehensiveActions',
      desc: '',
      args: [],
    );
  }

  /// `How would you like to respond to the discrepancy for the following items at once:`
  String
  get howWouldYouLikeToRespondToTheDiscrepancyForTheFollowingItemsAtOnce {
    return Intl.message(
      'How would you like to respond to the discrepancy for the following items at once:',
      name:
          'howWouldYouLikeToRespondToTheDiscrepancyForTheFollowingItemsAtOnce',
      desc: '',
      args: [],
    );
  }

  /// `Review All Purchases`
  String get reviewAllPurchases {
    return Intl.message(
      'Review All Purchases',
      name: 'reviewAllPurchases',
      desc: '',
      args: [],
    );
  }

  /// `Consult Management`
  String get consultManagement {
    return Intl.message(
      'Consult Management',
      name: 'consultManagement',
      desc: '',
      args: [],
    );
  }

  /// `Explain why there is a shortage in this item's record:`
  String get explainWhyThereIsAShortageInThisItemsRecord {
    return Intl.message(
      'Explain why there is a shortage in this item\'s record:',
      name: 'explainWhyThereIsAShortageInThisItemsRecord',
      desc: '',
      args: [],
    );
  }

  /// `Once submitted:`
  String get onceSubmitted {
    return Intl.message(
      'Once submitted:',
      name: 'onceSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `It will be sent for approval by the Brand Manager or Store Owner`
  String get itWillBeSentForApprovalByTheBrandManagerOrStoreOwner {
    return Intl.message(
      'It will be sent for approval by the Brand Manager or Store Owner',
      name: 'itWillBeSentForApprovalByTheBrandManagerOrStoreOwner',
      desc: '',
      args: [],
    );
  }

  /// `If approved, the item will be logged as waste`
  String get ifApprovedTheItemWillBeLoggedAsWaste {
    return Intl.message(
      'If approved, the item will be logged as waste',
      name: 'ifApprovedTheItemWillBeLoggedAsWaste',
      desc: '',
      args: [],
    );
  }

  /// `If rejected, the value will be added to your account statement as a liability`
  String get ifRejectedTheValueWillBeAddedToYourAccountStatementAsALiability {
    return Intl.message(
      'If rejected, the value will be added to your account statement as a liability',
      name: 'ifRejectedTheValueWillBeAddedToYourAccountStatementAsALiability',
      desc: '',
      args: [],
    );
  }

  /// `Quick Actions`
  String get quickActions {
    return Intl.message(
      'Quick Actions',
      name: 'quickActions',
      desc: '',
      args: [],
    );
  }

  /// `How would you like to respond to the discrepancy of Fresh Milk - Nadec:`
  String get howWouldYouLikeToRespondToTheDiscrepancyOfFreshMilkNadec {
    return Intl.message(
      'How would you like to respond to the discrepancy of Fresh Milk - Nadec:',
      name: 'howWouldYouLikeToRespondToTheDiscrepancyOfFreshMilkNadec',
      desc: '',
      args: [],
    );
  }

  /// `Edit Purchases`
  String get editPurchases {
    return Intl.message(
      'Edit Purchases',
      name: 'editPurchases',
      desc: '',
      args: [],
    );
  }

  /// `Approve Without Change`
  String get approveWithoutChange {
    return Intl.message(
      'Approve Without Change',
      name: 'approveWithoutChange',
      desc: '',
      args: [],
    );
  }

  /// `Inventory Actions`
  String get inventoryActions {
    return Intl.message(
      'Inventory Actions',
      name: 'inventoryActions',
      desc: '',
      args: [],
    );
  }

  /// `Inventory Information:`
  String get inventoryInformation {
    return Intl.message(
      'Inventory Information:',
      name: 'inventoryInformation',
      desc: '',
      args: [],
    );
  }

  /// `Reason for shortage`
  String get reasonForShortage {
    return Intl.message(
      'Reason for shortage',
      name: 'reasonForShortage',
      desc: '',
      args: [],
    );
  }

  /// `Inventory Summary:`
  String get inventorySummary {
    return Intl.message(
      'Inventory Summary:',
      name: 'inventorySummary',
      desc: '',
      args: [],
    );
  }

  /// `All products complete`
  String get allProductsComplete {
    return Intl.message(
      'All products complete',
      name: 'allProductsComplete',
      desc: '',
      args: [],
    );
  }

  /// `Inventoried Products ({count}):`
  String inventoriedProducts(Object count) {
    return Intl.message(
      'Inventoried Products ($count):',
      name: 'inventoriedProducts',
      desc: '',
      args: [count],
    );
  }

  /// `Total inventory value`
  String get totalInventoryValue {
    return Intl.message(
      'Total inventory value',
      name: 'totalInventoryValue',
      desc: '',
      args: [],
    );
  }

  /// `Discrepancy Summary`
  String get discrepancySummary {
    return Intl.message(
      'Discrepancy Summary',
      name: 'discrepancySummary',
      desc: '',
      args: [],
    );
  }

  /// `Products with discrepancies`
  String get productsWithDiscrepancies {
    return Intl.message(
      'Products with discrepancies',
      name: 'productsWithDiscrepancies',
      desc: '',
      args: [],
    );
  }

  /// `Matching products`
  String get matchingProducts {
    return Intl.message(
      'Matching products',
      name: 'matchingProducts',
      desc: '',
      args: [],
    );
  }

  /// `Total discrepancy value`
  String get totalDiscrepancyValue {
    return Intl.message(
      'Total discrepancy value',
      name: 'totalDiscrepancyValue',
      desc: '',
      args: [],
    );
  }

  /// `Discrepancy type`
  String get discrepancyType {
    return Intl.message(
      'Discrepancy type',
      name: 'discrepancyType',
      desc: '',
      args: [],
    );
  }

  /// `Shortage (stock deficit)`
  String get shortageStockDeficit {
    return Intl.message(
      'Shortage (stock deficit)',
      name: 'shortageStockDeficit',
      desc: '',
      args: [],
    );
  }

  /// `Products requiring clarification`
  String get productsRequiringClarification {
    return Intl.message(
      'Products requiring clarification',
      name: 'productsRequiringClarification',
      desc: '',
      args: [],
    );
  }

  /// `Fresh Milk - Nadec`
  String get freshMilkNadec {
    return Intl.message(
      'Fresh Milk - Nadec',
      name: 'freshMilkNadec',
      desc: '',
      args: [],
    );
  }

  /// `Mozzarella Cheese - Almarai`
  String get mozzarellaCheeseAlmarai {
    return Intl.message(
      'Mozzarella Cheese - Almarai',
      name: 'mozzarellaCheeseAlmarai',
      desc: '',
      args: [],
    );
  }

  /// `Daily Inventory ({count})`
  String dailyInventory(int count) {
    return Intl.message(
      'Daily Inventory ($count)',
      name: 'dailyInventory',
      desc: 'Displays daily inventory count',
      args: [count],
    );
  }

  /// `Manage all your pending & draft records`
  String get manageAllYourPendingDraftRecords {
    return Intl.message(
      'Manage all your pending & draft records',
      name: 'manageAllYourPendingDraftRecords',
      desc: '',
      args: [],
    );
  }

  /// `Products Pre-selected`
  String get productsPreSelected {
    return Intl.message(
      'Products Pre-selected',
      name: 'productsPreSelected',
      desc: '',
      args: [],
    );
  }

  /// `How would you like to record this inventory suggestions?`
  String get howWouldYouLikeToRecordThisInventorySuggestions {
    return Intl.message(
      'How would you like to record this inventory suggestions?',
      name: 'howWouldYouLikeToRecordThisInventorySuggestions',
      desc: '',
      args: [],
    );
  }

  /// `Assign to Staff`
  String get assignToStaff {
    return Intl.message(
      'Assign to Staff',
      name: 'assignToStaff',
      desc: '',
      args: [],
    );
  }

  /// `Ahmed Mohammed (Branch Manager)`
  String get ahmedMohammedBranchManager {
    return Intl.message(
      'Ahmed Mohammed (Branch Manager)',
      name: 'ahmedMohammedBranchManager',
      desc: '',
      args: [],
    );
  }

  /// `{name} is handling it...`
  String saraIsHandlingIt(String name) {
    return Intl.message(
      '$name is handling it...',
      name: 'saraIsHandlingIt',
      desc: 'Displays who is handling the product',
      args: [name],
    );
  }

  /// `How Slider Works`
  String get howSliderWorks {
    return Intl.message(
      'How Slider Works',
      name: 'howSliderWorks',
      desc: '',
      args: [],
    );
  }

  /// `Use the slider to estimate how full a single container is, like a bottle, gallon, or barrel.`
  String get useSliderToEstimateHowFull {
    return Intl.message(
      'Use the slider to estimate how full a single container is, like a bottle, gallon, or barrel.',
      name: 'useSliderToEstimateHowFull',
      desc: '',
      args: [],
    );
  }

  /// `First, enter the full volume of one item (e.g. 100 liters).`
  String get firstEnterFullVolumeOfOneItem {
    return Intl.message(
      'First, enter the full volume of one item (e.g. 100 liters).',
      name: 'firstEnterFullVolumeOfOneItem',
      desc: '',
      args: [],
    );
  }

  /// `Then, use the slider to show how much is left in one partially filled item (e.g. 30% full = 30L).`
  String get thenUseSliderToShowHowMuchLeft {
    return Intl.message(
      'Then, use the slider to show how much is left in one partially filled item (e.g. 30% full = 30L).',
      name: 'thenUseSliderToShowHowMuchLeft',
      desc: '',
      args: [],
    );
  }

  /// `This helps when not all containers are full. We'll auto-calculate the total for you — even if it's a mix of full + partial units.`
  String get sliderHelpsWhenNotAllContainersFull {
    return Intl.message(
      'This helps when not all containers are full. We\'ll auto-calculate the total for you — even if it\'s a mix of full + partial units.',
      name: 'sliderHelpsWhenNotAllContainersFull',
      desc: '',
      args: [],
    );
  }

  /// `Example 💡`
  String get exampleLightBulb {
    return Intl.message(
      'Example 💡',
      name: 'exampleLightBulb',
      desc: '',
      args: [],
    );
  }

  /// `You have 10 full gallons (100L each) and 1 that's half full → total = 105 liters.`
  String get tenFullGallons100LEachOneHalfFullTotalLiters {
    return Intl.message(
      'You have 10 full gallons (100L each) and 1 that\'s half full → total = 105 liters.',
      name: 'tenFullGallons100LEachOneHalfFullTotalLiters',
      desc: '',
      args: [],
    );
  }

  /// `Slide to set count`
  String get slideToSetCount {
    return Intl.message(
      'Slide to set count',
      name: 'slideToSetCount',
      desc: '',
      args: [],
    );
  }

  /// `Enter full volume, then drag to estimate what's left. We'll auto-calculate the rest.`
  String get enterFullVolumeThenDragToEstimateLeft {
    return Intl.message(
      'Enter full volume, then drag to estimate what\'s left. We\'ll auto-calculate the rest.',
      name: 'enterFullVolumeThenDragToEstimateLeft',
      desc: '',
      args: [],
    );
  }

  /// `Total Number of containers`
  String get totalNumberOfContainers {
    return Intl.message(
      'Total Number of containers',
      name: 'totalNumberOfContainers',
      desc: '',
      args: [],
    );
  }

  /// `Volume Per Container`
  String get volumePerContainer {
    return Intl.message(
      'Volume Per Container',
      name: 'volumePerContainer',
      desc: '',
      args: [],
    );
  }

  /// `Total Liters`
  String get totalLiters {
    return Intl.message(
      'Total Liters',
      name: 'totalLiters',
      desc: '',
      args: [],
    );
  }

  /// `Slide to the percentage of the partial container`
  String get slideToPercentageOfPartialContainer {
    return Intl.message(
      'Slide to the percentage of the partial container',
      name: 'slideToPercentageOfPartialContainer',
      desc: '',
      args: [],
    );
  }

  /// `Reset All`
  String get resetAll {
    return Intl.message('Reset All', name: 'resetAll', desc: '', args: []);
  }

  /// `Confirm Count`
  String get confirmCount {
    return Intl.message(
      'Confirm Count',
      name: 'confirmCount',
      desc: '',
      args: [],
    );
  }

  /// `Learn More`
  String get learnMore {
    return Intl.message('Learn More', name: 'learnMore', desc: '', args: []);
  }

  /// `Go to slider`
  String get goToSlider {
    return Intl.message('Go to slider', name: 'goToSlider', desc: '', args: []);
  }

  /// `If the indicator appears significantly off-center, it may signal incorrect quantity input.`
  String get indicatorSignalsIncorrectQuantityInput {
    return Intl.message(
      'If the indicator appears significantly off-center, it may signal incorrect quantity input.',
      name: 'indicatorSignalsIncorrectQuantityInput',
      desc: '',
      args: [],
    );
  }

  /// `See the difference between this month's inventory against last month's inventory:`
  String get seeDifferenceThisMonthVsLastMonthInventory {
    return Intl.message(
      'See the difference between this month\'s inventory against last month\'s inventory:',
      name: 'seeDifferenceThisMonthVsLastMonthInventory',
      desc: '',
      args: [],
    );
  }

  /// `Number of participants`
  String get numberOfParticipants {
    return Intl.message(
      'Number of participants',
      name: 'numberOfParticipants',
      desc: '',
      args: [],
    );
  }

  /// `Successfully completed`
  String get successfullyCompleted {
    return Intl.message(
      'Successfully completed',
      name: 'successfullyCompleted',
      desc: '',
      args: [],
    );
  }

  /// `John Doe`
  String get johnDoe {
    return Intl.message('John Doe', name: 'johnDoe', desc: '', args: []);
  }

  /// `Complete core tasks or assign new task to others`
  String get completeCoreTasksOrAssignNewTaskToOthers {
    return Intl.message(
      'Complete core tasks or assign new task to others',
      name: 'completeCoreTasksOrAssignNewTaskToOthers',
      desc: '',
      args: [],
    );
  }

  /// `Waste & Damage Management`
  String get wasteDamageManagement {
    return Intl.message(
      'Waste & Damage Management',
      name: 'wasteDamageManagement',
      desc: '',
      args: [],
    );
  }

  /// `Reports & Review`
  String get reportsReview {
    return Intl.message(
      'Reports & Review',
      name: 'reportsReview',
      desc: '',
      args: [],
    );
  }

  /// `How would you like to respond to the discrepancy for the following items at once:`
  String get howWouldYouLikeToRespondToDiscrepancyAtOnce {
    return Intl.message(
      'How would you like to respond to the discrepancy for the following items at once:',
      name: 'howWouldYouLikeToRespondToDiscrepancyAtOnce',
      desc: '',
      args: [],
    );
  }

  /// `Review Complete Waste`
  String get reviewCompleteWaste {
    return Intl.message(
      'Review Complete Waste',
      name: 'reviewCompleteWaste',
      desc: '',
      args: [],
    );
  }

  /// `Comprehensive Approval with Justification`
  String get comprehensiveApprovalWithJustification {
    return Intl.message(
      'Comprehensive Approval with Justification',
      name: 'comprehensiveApprovalWithJustification',
      desc: '',
      args: [],
    );
  }

  /// `It will be sent for approval by the Brand Manager or Store Owner`
  String get sentForApprovalByBrandManagerOrStoreOwner {
    return Intl.message(
      'It will be sent for approval by the Brand Manager or Store Owner',
      name: 'sentForApprovalByBrandManagerOrStoreOwner',
      desc: '',
      args: [],
    );
  }

  /// `If approved, the item will be logged as waste`
  String get ifApprovedLoggedAsWaste {
    return Intl.message(
      'If approved, the item will be logged as waste',
      name: 'ifApprovedLoggedAsWaste',
      desc: '',
      args: [],
    );
  }

  /// `If rejected, the value will be added to your account statement as a liability`
  String get ifRejectedAddedAsLiability {
    return Intl.message(
      'If rejected, the value will be added to your account statement as a liability',
      name: 'ifRejectedAddedAsLiability',
      desc: '',
      args: [],
    );
  }

  /// `Shortage Amount:`
  String get shortageAmount {
    return Intl.message(
      'Shortage Amount:',
      name: 'shortageAmount',
      desc: '',
      args: [],
    );
  }

  /// `How would you like to respond to the discrepancy of {productName}:`
  String howWouldYouLikeToRespondToDiscrepancy(String productName) {
    return Intl.message(
      'How would you like to respond to the discrepancy of $productName:',
      name: 'howWouldYouLikeToRespondToDiscrepancy',
      desc: 'Displays the product name in discrepancy question',
      args: [productName],
    );
  }

  /// `Record Waste/Damage`
  String get recordWasteDamage {
    return Intl.message(
      'Record Waste/Damage',
      name: 'recordWasteDamage',
      desc: '',
      args: [],
    );
  }

  /// `Number of products`
  String get numberOfProducts {
    return Intl.message(
      'Number of products',
      name: 'numberOfProducts',
      desc: '',
      args: [],
    );
  }

  /// `Expected time:`
  String get expectedTime {
    return Intl.message(
      'Expected time:',
      name: 'expectedTime',
      desc: '',
      args: [],
    );
  }

  /// `products`
  String get products {
    return Intl.message('products', name: 'products', desc: '', args: []);
  }

  /// `minutes`
  String get minutes {
    return Intl.message('minutes', name: 'minutes', desc: '', args: []);
  }

  /// `{date}, Discrepancy Report`
  String timeDiscrepancyReport(Object date) {
    return Intl.message(
      '$date, Discrepancy Report',
      name: 'timeDiscrepancyReport',
      desc: '',
      args: [date],
    );
  }

  /// `Review discrepancies and take actions.`
  String get reviewDiscrepanciesAndTakeActions {
    return Intl.message(
      'Review discrepancies and take actions.',
      name: 'reviewDiscrepanciesAndTakeActions',
      desc: '',
      args: [],
    );
  }

  /// `Timelines content here`
  String get timelinesContentHere {
    return Intl.message(
      'Timelines content here',
      name: 'timelinesContentHere',
      desc: '',
      args: [],
    );
  }

  /// `Products requiring clarification ({count}):`
  String productsRequiringClarificationCount(Object count) {
    return Intl.message(
      'Products requiring clarification ($count):',
      name: 'productsRequiringClarificationCount',
      desc: '',
      args: [count],
    );
  }

  /// `Sales:`
  String get sales {
    return Intl.message('Sales:', name: 'sales', desc: '', args: []);
  }

  /// `Recorded waste`
  String get recordedWaste {
    return Intl.message(
      'Recorded waste',
      name: 'recordedWaste',
      desc: '',
      args: [],
    );
  }

  /// `Net Transfer In`
  String get netTransferIn {
    return Intl.message(
      'Net Transfer In',
      name: 'netTransferIn',
      desc: '',
      args: [],
    );
  }

  /// `Net Transfer Out`
  String get netTransferOut {
    return Intl.message(
      'Net Transfer Out',
      name: 'netTransferOut',
      desc: '',
      args: [],
    );
  }

  /// `Theoretically expected:`
  String get theoreticallyExpected {
    return Intl.message(
      'Theoretically expected:',
      name: 'theoreticallyExpected',
      desc: '',
      args: [],
    );
  }

  /// `Actual from inventory:`
  String get actualFromInventory {
    return Intl.message(
      'Actual from inventory:',
      name: 'actualFromInventory',
      desc: '',
      args: [],
    );
  }

  /// `Time Limit: 24 hours`
  String get timeLimit24Hours {
    return Intl.message(
      'Time Limit: 24 hours',
      name: 'timeLimit24Hours',
      desc: '',
      args: [],
    );
  }

  /// `Discrepancy Found`
  String get discrepancyFound {
    return Intl.message(
      'Discrepancy Found',
      name: 'discrepancyFound',
      desc: '',
      args: [],
    );
  }

  /// `Total Number of Milk containers`
  String get totalNumberOfMilkContainers {
    return Intl.message(
      'Total Number of Milk containers',
      name: 'totalNumberOfMilkContainers',
      desc: '',
      args: [],
    );
  }

  /// `Daily Inventory`
  String get dailyInventoryAction {
    return Intl.message(
      'Daily Inventory',
      name: 'dailyInventoryAction',
      desc: '',
      args: [],
    );
  }

  /// `Main Action`
  String get mainAction {
    return Intl.message('Main Action', name: 'mainAction', desc: '', args: []);
  }

  /// `Add Justification`
  String get addJustification {
    return Intl.message(
      'Add Justification',
      name: 'addJustification',
      desc: '',
      args: [],
    );
  }

  /// `Confirm & Submit`
  String get confirmAndSubmit {
    return Intl.message(
      'Confirm & Submit',
      name: 'confirmAndSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Export as Excel`
  String get exportAsExcel {
    return Intl.message(
      'Export as Excel',
      name: 'exportAsExcel',
      desc: '',
      args: [],
    );
  }

  /// `Export Now`
  String get exportNow {
    return Intl.message('Export Now', name: 'exportNow', desc: '', args: []);
  }

  /// `How would you like to export {date} Monthly Regular Inventory:`
  String howWouldYouLikeToExportDateMonthlyRegularInventory(Object date) {
    return Intl.message(
      'How would you like to export $date Monthly Regular Inventory:',
      name: 'howWouldYouLikeToExportDateMonthlyRegularInventory',
      desc: '',
      args: [date],
    );
  }

  /// `Review the details below before starting the process:`
  String get reviewTheDetailsBelowBeforeStartingTheProcess {
    return Intl.message(
      'Review the details below before starting the process:',
      name: 'reviewTheDetailsBelowBeforeStartingTheProcess',
      desc: '',
      args: [],
    );
  }

  /// `Mandatory awareness screen will appear after selection`
  String get mandatoryAwarenessScreenWillAppearAfterSelection {
    return Intl.message(
      'Mandatory awareness screen will appear after selection',
      name: 'mandatoryAwarenessScreenWillAppearAfterSelection',
      desc: '',
      args: [],
    );
  }

  /// `This month so far ({month}):`
  String thisMonthSoFarMonth(Object month) {
    return Intl.message(
      'This month so far ($month):',
      name: 'thisMonthSoFarMonth',
      desc: '',
      args: [month],
    );
  }

  /// `Total waste:`
  String get totalWaste {
    return Intl.message('Total waste:', name: 'totalWaste', desc: '', args: []);
  }

  /// `Total damage:`
  String get totalDamage {
    return Intl.message(
      'Total damage:',
      name: 'totalDamage',
      desc: '',
      args: [],
    );
  }

  /// `Number of incidents:`
  String get numberOfIncidents {
    return Intl.message(
      'Number of incidents:',
      name: 'numberOfIncidents',
      desc: '',
      args: [],
    );
  }

  /// `Saved drafts:`
  String get savedDrafts {
    return Intl.message(
      'Saved drafts:',
      name: 'savedDrafts',
      desc: '',
      args: [],
    );
  }

  /// `Comparison with previous month:`
  String get comparisonWithPreviousMonth {
    return Intl.message(
      'Comparison with previous month:',
      name: 'comparisonWithPreviousMonth',
      desc: '',
      args: [],
    );
  }

  /// `Wastes:`
  String get wastes {
    return Intl.message('Wastes:', name: 'wastes', desc: '', args: []);
  }

  /// `decrease from last hour.`
  String get decreaseFromLastHour {
    return Intl.message(
      'decrease from last hour.',
      name: 'decreaseFromLastHour',
      desc: '',
      args: [],
    );
  }

  /// `Damages:`
  String get damages {
    return Intl.message('Damages:', name: 'damages', desc: '', args: []);
  }

  /// `Increase from last hour.`
  String get increaseFromLastHour {
    return Intl.message(
      'Increase from last hour.',
      name: 'increaseFromLastHour',
      desc: '',
      args: [],
    );
  }

  /// `Waste & Damage Registration`
  String get wasteAndDamageRegistration {
    return Intl.message(
      'Waste & Damage Registration',
      name: 'wasteAndDamageRegistration',
      desc: '',
      args: [],
    );
  }

  /// `{count} Incidents`
  String countOfIncidents(Object count) {
    return Intl.message(
      '$count Incidents',
      name: 'countOfIncidents',
      desc: '',
      args: [count],
    );
  }

  /// `{count} Draft`
  String countOfDraft(Object count) {
    return Intl.message(
      '$count Draft',
      name: 'countOfDraft',
      desc: '',
      args: [count],
    );
  }

  /// `Choose Registration Method:`
  String get chooseRegistrationMethod {
    return Intl.message(
      'Choose Registration Method:',
      name: 'chooseRegistrationMethod',
      desc: '',
      args: [],
    );
  }

  /// `Quick Statistics:`
  String get quickStatistics {
    return Intl.message(
      'Quick Statistics:',
      name: 'quickStatistics',
      desc: '',
      args: [],
    );
  }

  /// `Register waste & damage yourself as branch manager`
  String get registerWasteDamageYourselfAsBranchManager {
    return Intl.message(
      'Register waste & damage yourself as branch manager',
      name: 'registerWasteDamageYourselfAsBranchManager',
      desc: '',
      args: [],
    );
  }

  /// `Direct responsibility`
  String get directResponsibility {
    return Intl.message(
      'Direct responsibility',
      name: 'directResponsibility',
      desc: '',
      args: [],
    );
  }

  /// `Accuracy in classification`
  String get accuracyInClassification {
    return Intl.message(
      'Accuracy in classification',
      name: 'accuracyInClassification',
      desc: '',
      args: [],
    );
  }

  /// `Speed in decision making`
  String get speedInDecisionMaking {
    return Intl.message(
      'Speed in decision making',
      name: 'speedInDecisionMaking',
      desc: '',
      args: [],
    );
  }

  /// `No additional approval needed`
  String get noAdditionalApprovalNeeded {
    return Intl.message(
      'No additional approval needed',
      name: 'noAdditionalApprovalNeeded',
      desc: '',
      args: [],
    );
  }

  /// `Choose a staff to register waste & damage`
  String get chooseAStaffToRegisterWasteDamage {
    return Intl.message(
      'Choose a staff to register waste & damage',
      name: 'chooseAStaffToRegisterWasteDamage',
      desc: '',
      args: [],
    );
  }

  /// `Review: Mandatory before sending`
  String get reviewMandatoryBeforeSending {
    return Intl.message(
      'Review: Mandatory before sending',
      name: 'reviewMandatoryBeforeSending',
      desc: '',
      args: [],
    );
  }

  /// `Signature: In your name as manager`
  String get signatureInYourNameAsManager {
    return Intl.message(
      'Signature: In your name as manager',
      name: 'signatureInYourNameAsManager',
      desc: '',
      args: [],
    );
  }

  /// `I confirm I understand the difference and can distinguish`
  String get iConfirmIUnderstandTheDifferenceAndCanDistinguish {
    return Intl.message(
      'I confirm I understand the difference and can distinguish',
      name: 'iConfirmIUnderstandTheDifferenceAndCanDistinguish',
      desc: '',
      args: [],
    );
  }

  /// `Start Registration`
  String get startRegistration {
    return Intl.message(
      'Start Registration',
      name: 'startRegistration',
      desc: '',
      args: [],
    );
  }

  /// `Mandatory Awareness`
  String get mandatoryAwareness {
    return Intl.message(
      'Mandatory Awareness',
      name: 'mandatoryAwareness',
      desc: '',
      args: [],
    );
  }

  /// `Difference Between Waste and Damage`
  String get differenceBetweenWasteAndDamage {
    return Intl.message(
      'Difference Between Waste and Damage',
      name: 'differenceBetweenWasteAndDamage',
      desc: '',
      args: [],
    );
  }

  /// `Must pass this screen before registering any item`
  String get mustPassThisScreenBeforeRegisteringAnyItem {
    return Intl.message(
      'Must pass this screen before registering any item',
      name: 'mustPassThisScreenBeforeRegisteringAnyItem',
      desc: '',
      args: [],
    );
  }

  /// `Why distinguish between waste and damage?`
  String get whyDistinguishBetweenWasteAndDamage {
    return Intl.message(
      'Why distinguish between waste and damage?',
      name: 'whyDistinguishBetweenWasteAndDamage',
      desc: '',
      args: [],
    );
  }

  /// `To ensure accuracy of financial and operational reports`
  String get toEnsureAccuracyOfFinancialAndOperationalReports {
    return Intl.message(
      'To ensure accuracy of financial and operational reports',
      name: 'toEnsureAccuracyOfFinancialAndOperationalReports',
      desc: '',
      args: [],
    );
  }

  /// `Waste:`
  String get wasteColon {
    return Intl.message('Waste:', name: 'wasteColon', desc: '', args: []);
  }

  /// `Damage:`
  String get damageColon {
    return Intl.message('Damage:', name: 'damageColon', desc: '', args: []);
  }

  /// `Products that cannot be used due to:`
  String get productsThatCannotBeUsedDueTo {
    return Intl.message(
      'Products that cannot be used due to:',
      name: 'productsThatCannotBeUsedDueTo',
      desc: '',
      args: [],
    );
  }

  /// `Correct examples of waste:`
  String get correctExamplesOfWaste {
    return Intl.message(
      'Correct examples of waste:',
      name: 'correctExamplesOfWaste',
      desc: '',
      args: [],
    );
  }

  /// `Expiration date passed`
  String get expirationDatePassed {
    return Intl.message(
      'Expiration date passed',
      name: 'expirationDatePassed',
      desc: '',
      args: [],
    );
  }

  /// `Natural spoilage (mold, odor change)`
  String get naturalSpoilageMoldOdorChange {
    return Intl.message(
      'Natural spoilage (mold, odor change)',
      name: 'naturalSpoilageMoldOdorChange',
      desc: '',
      args: [],
    );
  }

  /// `Excess cooking beyond need`
  String get excessCookingBeyondNeed {
    return Intl.message(
      'Excess cooking beyond need',
      name: 'excessCookingBeyondNeed',
      desc: '',
      args: [],
    );
  }

  /// `Food preparation leftovers`
  String get foodPreparationLeftovers {
    return Intl.message(
      'Food preparation leftovers',
      name: 'foodPreparationLeftovers',
      desc: '',
      args: [],
    );
  }

  /// `Products nearing expiration`
  String get productsNearingExpiration {
    return Intl.message(
      'Products nearing expiration',
      name: 'productsNearingExpiration',
      desc: '',
      args: [],
    );
  }

  /// `Accounting Impact`
  String get accountingImpact {
    return Intl.message(
      'Accounting Impact',
      name: 'accountingImpact',
      desc: '',
      args: [],
    );
  }

  /// `Accounting Impact`
  String get accountingImpactWaste {
    return Intl.message(
      'Accounting Impact',
      name: 'accountingImpactWaste',
      desc: '',
      args: [],
    );
  }

  /// `Accounting Impact`
  String get accountingImpactDamage {
    return Intl.message(
      'Accounting Impact',
      name: 'accountingImpactDamage',
      desc: '',
      args: [],
    );
  }

  /// `Employee must be selected. Cost may be deducted if management rejects the justification.`
  String
  get employeeMustBeSelectedCostMayBeDeductedIfManagementRejectsTheJustification {
    return Intl.message(
      'Employee must be selected. Cost may be deducted if management rejects the justification.',
      name:
          'employeeMustBeSelectedCostMayBeDeductedIfManagementRejectsTheJustification',
      desc: '',
      args: [],
    );
  }

  /// `Products damaged due to external factors:`
  String get productsDamagedDueToExternalFactors {
    return Intl.message(
      'Products damaged due to external factors:',
      name: 'productsDamagedDueToExternalFactors',
      desc: '',
      args: [],
    );
  }

  /// `Correct examples of damage:`
  String get correctExamplesOfDamage {
    return Intl.message(
      'Correct examples of damage:',
      name: 'correctExamplesOfDamage',
      desc: '',
      args: [],
    );
  }

  /// `Breaking or falling`
  String get breakingOrFalling {
    return Intl.message(
      'Breaking or falling',
      name: 'breakingOrFalling',
      desc: '',
      args: [],
    );
  }

  /// `Refrigeration failure`
  String get refrigerationFailure {
    return Intl.message(
      'Refrigeration failure',
      name: 'refrigerationFailure',
      desc: '',
      args: [],
    );
  }

  /// `Container leakage`
  String get containerLeakage {
    return Intl.message(
      'Container leakage',
      name: 'containerLeakage',
      desc: '',
      args: [],
    );
  }

  /// `Damage during transport`
  String get damageDuringTransport {
    return Intl.message(
      'Damage during transport',
      name: 'damageDuringTransport',
      desc: '',
      args: [],
    );
  }

  /// `Manufacturing defects from supplier`
  String get manufacturingDefectsFromSupplier {
    return Intl.message(
      'Manufacturing defects from supplier',
      name: 'manufacturingDefectsFromSupplier',
      desc: '',
      args: [],
    );
  }

  /// `Common incorrect examples:`
  String get commonIncorrectExamples {
    return Intl.message(
      'Common incorrect examples:',
      name: 'commonIncorrectExamples',
      desc: '',
      args: [],
    );
  }

  /// `❌ Recording "staff consumption" as waste or damage`
  String get recordingStaffConsumptionAsWasteOrDamage {
    return Intl.message(
      '❌ Recording "staff consumption" as waste or damage',
      name: 'recordingStaffConsumptionAsWasteOrDamage',
      desc: '',
      args: [],
    );
  }

  /// `❌ Hiding counting shortage as damage`
  String get hidingCountingShortageAsDamage {
    return Intl.message(
      '❌ Hiding counting shortage as damage',
      name: 'hidingCountingShortageAsDamage',
      desc: '',
      args: [],
    );
  }

  /// `❌ Confusing between the two terms`
  String get confusingBetweenTheTwoTerms {
    return Intl.message(
      '❌ Confusing between the two terms',
      name: 'confusingBetweenTheTwoTerms',
      desc: '',
      args: [],
    );
  }

  /// `Documentation Requirements:`
  String get documentationRequirements {
    return Intl.message(
      'Documentation Requirements:',
      name: 'documentationRequirements',
      desc: '',
      args: [],
    );
  }

  /// `Photo optional`
  String get photoOptional {
    return Intl.message(
      'Photo optional',
      name: 'photoOptional',
      desc: '',
      args: [],
    );
  }

  /// `Photo required (if value >20 SAR)`
  String get photoRequiredIfValueGreaterThan20Sar {
    return Intl.message(
      'Photo required (if value >20 SAR)',
      name: 'photoRequiredIfValueGreaterThan20Sar',
      desc: '',
      args: [],
    );
  }

  /// `Save Draft`
  String get saveDraft {
    return Intl.message('Save Draft', name: 'saveDraft', desc: '', args: []);
  }

  /// `Add to List`
  String get addToList {
    return Intl.message('Add to List', name: 'addToList', desc: '', args: []);
  }

  /// `Waste`
  String get waste {
    return Intl.message('Waste', name: 'waste', desc: '', args: []);
  }

  /// `Damage`
  String get damage {
    return Intl.message('Damage', name: 'damage', desc: '', args: []);
  }

  /// `Add Items/Products Manually`
  String get addItemsProductsManually {
    return Intl.message(
      'Add Items/Products Manually',
      name: 'addItemsProductsManually',
      desc: '',
      args: [],
    );
  }

  /// `Search for products and add`
  String get searchForProductsAndAdd {
    return Intl.message(
      'Search for products and add',
      name: 'searchForProductsAndAdd',
      desc: '',
      args: [],
    );
  }

  /// `Waste/Damage Details:`
  String get wasteDamageDetailsColon {
    return Intl.message(
      'Waste/Damage Details:',
      name: 'wasteDamageDetailsColon',
      desc: '',
      args: [],
    );
  }

  /// `Complete the required fields below:`
  String get completeTheRequiredFieldsBelow {
    return Intl.message(
      'Complete the required fields below:',
      name: 'completeTheRequiredFieldsBelow',
      desc: '',
      args: [],
    );
  }

  /// `Product Information:`
  String get productInformation {
    return Intl.message(
      'Product Information:',
      name: 'productInformation',
      desc: '',
      args: [],
    );
  }

  /// `Available in stock:`
  String get availableInStock {
    return Intl.message(
      'Available in stock:',
      name: 'availableInStock',
      desc: '',
      args: [],
    );
  }

  /// `Price per unit:`
  String get pricePerUnit {
    return Intl.message(
      'Price per unit:',
      name: 'pricePerUnit',
      desc: '',
      args: [],
    );
  }

  /// `Problem Type:`
  String get problemType {
    return Intl.message(
      'Problem Type:',
      name: 'problemType',
      desc: '',
      args: [],
    );
  }

  /// `Assign Responsibility`
  String get assignResponsibility {
    return Intl.message(
      'Assign Responsibility',
      name: 'assignResponsibility',
      desc: '',
      args: [],
    );
  }

  /// `Cause of damage`
  String get causeOfDamage {
    return Intl.message(
      'Cause of damage',
      name: 'causeOfDamage',
      desc: '',
      args: [],
    );
  }

  /// `Affected product`
  String get affectedProduct {
    return Intl.message(
      'Affected product',
      name: 'affectedProduct',
      desc: '',
      args: [],
    );
  }

  /// `Reason for waste/damage:`
  String get reasonForWasteDamage {
    return Intl.message(
      'Reason for waste/damage:',
      name: 'reasonForWasteDamage',
      desc: '',
      args: [],
    );
  }

  /// `Expired`
  String get expired {
    return Intl.message('Expired', name: 'expired', desc: '', args: []);
  }

  /// `Damaged`
  String get damaged {
    return Intl.message('Damaged', name: 'damaged', desc: '', args: []);
  }

  /// `Detailed justification for manager`
  String get detailedJustificationForManager {
    return Intl.message(
      'Detailed justification for manager',
      name: 'detailedJustificationForManager',
      desc: '',
      args: [],
    );
  }

  /// `Accurate description of situation...`
  String get accurateDescriptionOfSituation {
    return Intl.message(
      'Accurate description of situation...',
      name: 'accurateDescriptionOfSituation',
      desc: '',
      args: [],
    );
  }

  /// `Explanatory photo:`
  String get explanatoryPhoto {
    return Intl.message(
      'Explanatory photo:',
      name: 'explanatoryPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Required for damage >20 SAR`
  String get requiredForDamageGreaterThan20Sar {
    return Intl.message(
      'Required for damage >20 SAR',
      name: 'requiredForDamageGreaterThan20Sar',
      desc: '',
      args: [],
    );
  }

  /// `Remove Item from list`
  String get removeItemFromList {
    return Intl.message(
      'Remove Item from list',
      name: 'removeItemFromList',
      desc: '',
      args: [],
    );
  }

  /// `The damage was due to my own actions, mistakes, or mishandling.`
  String get theDamageWasDueToMyOwnActionsMistakesOrMishandling {
    return Intl.message(
      'The damage was due to my own actions, mistakes, or mishandling.',
      name: 'theDamageWasDueToMyOwnActionsMistakesOrMishandling',
      desc: '',
      args: [],
    );
  }

  /// `The damage was caused by something beyond employee control — such as equipment failure, a system glitch, or external incidents (e.g. customer behavior, delivery issue, etc.).`
  String get theDamageWasCausedBySomethingBeyondEmployeeControl {
    return Intl.message(
      'The damage was caused by something beyond employee control — such as equipment failure, a system glitch, or external incidents (e.g. customer behavior, delivery issue, etc.).',
      name: 'theDamageWasCausedBySomethingBeyondEmployeeControl',
      desc: '',
      args: [],
    );
  }

  /// `The damage resulted from a combination of employee actions (including mine) and external factors like hardware, systems, or customer-related issues.`
  String get theDamageResultedFromACombinationOfEmployeeActions {
    return Intl.message(
      'The damage resulted from a combination of employee actions (including mine) and external factors like hardware, systems, or customer-related issues.',
      name: 'theDamageResultedFromACombinationOfEmployeeActions',
      desc: '',
      args: [],
    );
  }

  /// `Choose the employee(s) responsible and specify the portion each person is accountable for.`
  String
  get chooseTheEmployeeSResponsibleAndSpecifyThePortionEachPersonIsAccountableFor {
    return Intl.message(
      'Choose the employee(s) responsible and specify the portion each person is accountable for.',
      name:
          'chooseTheEmployeeSResponsibleAndSpecifyThePortionEachPersonIsAccountableFor',
      desc: '',
      args: [],
    );
  }

  /// `No other employees found.`
  String get noOtherEmployeesFound {
    return Intl.message(
      'No other employees found.',
      name: 'noOtherEmployeesFound',
      desc: '',
      args: [],
    );
  }

  /// `Store Branch Name`
  String get storeBranchName {
    return Intl.message(
      'Store Branch Name',
      name: 'storeBranchName',
      desc: '',
      args: [],
    );
  }

  /// `Responsible Employees’s`
  String get responsibleEmployeess {
    return Intl.message(
      'Responsible Employees’s',
      name: 'responsibleEmployeess',
      desc: '',
      args: [],
    );
  }

  /// `You need to select at least 1 people`
  String get youNeedToSelectAtLeastOnePeople {
    return Intl.message(
      'You need to select at least 1 people',
      name: 'youNeedToSelectAtLeastOnePeople',
      desc: '',
      args: [],
    );
  }

  /// `Surplus`
  String get surplus {
    return Intl.message('Surplus', name: 'surplus', desc: '', args: []);
  }

  /// `Preparation error`
  String get preparationError {
    return Intl.message(
      'Preparation error',
      name: 'preparationError',
      desc: '',
      args: [],
    );
  }

  /// `One`
  String get one {
    return Intl.message('One', name: 'one', desc: '', args: []);
  }

  /// `Portion & Handling Issue`
  String get portionHandlingIssue {
    return Intl.message(
      'Portion & Handling Issue',
      name: 'portionHandlingIssue',
      desc: '',
      args: [],
    );
  }

  /// `Production/Preparation Error`
  String get productionPreparationError {
    return Intl.message(
      'Production/Preparation Error',
      name: 'productionPreparationError',
      desc: '',
      args: [],
    );
  }

  /// `Order Cancellation / Return`
  String get orderCancellationReturn {
    return Intl.message(
      'Order Cancellation / Return',
      name: 'orderCancellationReturn',
      desc: '',
      args: [],
    );
  }

  /// `Operational Mismanagement`
  String get operationalMismanagement {
    return Intl.message(
      'Operational Mismanagement',
      name: 'operationalMismanagement',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message('Other', name: 'other', desc: '', args: []);
  }

  /// `Storage/Temperature Damage`
  String get storageTemperatureDamage {
    return Intl.message(
      'Storage/Temperature Damage',
      name: 'storageTemperatureDamage',
      desc: '',
      args: [],
    );
  }

  /// `Supplier/Delivery Issue`
  String get supplierDeliveryIssue {
    return Intl.message(
      'Supplier/Delivery Issue',
      name: 'supplierDeliveryIssue',
      desc: '',
      args: [],
    );
  }

  /// `Equipment Failure`
  String get equipmentFailure {
    return Intl.message(
      'Equipment Failure',
      name: 'equipmentFailure',
      desc: '',
      args: [],
    );
  }

  /// `Save Report to draft`
  String get saveReportToDraft {
    return Intl.message(
      'Save Report to draft',
      name: 'saveReportToDraft',
      desc: '',
      args: [],
    );
  }

  /// `Selected Product ({count}):`
  String selectedProductCount(Object count) {
    return Intl.message(
      'Selected Product ($count):',
      name: 'selectedProductCount',
      desc: '',
      args: [count],
    );
  }

  /// `Add Another Product`
  String get addAnotherProduct {
    return Intl.message(
      'Add Another Product',
      name: 'addAnotherProduct',
      desc: '',
      args: [],
    );
  }

  /// `View, edit, pause, or delete schedules`
  String get recurringOrdersSubtitle {
    return Intl.message(
      'View, edit, pause, or delete schedules',
      name: 'recurringOrdersSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Next scheduled run ({count})`
  String nextScheduledRun(Object count) {
    return Intl.message(
      'Next scheduled run ($count)',
      name: 'nextScheduledRun',
      desc: '',
      args: [count],
    );
  }

  /// `No active recurring orders. Start one to streamline repeat purchases.`
  String get noActiveRecurringOrders {
    return Intl.message(
      'No active recurring orders. Start one to streamline repeat purchases.',
      name: 'noActiveRecurringOrders',
      desc: '',
      args: [],
    );
  }

  /// `Create New Schedule`
  String get createNewSchedule {
    return Intl.message(
      'Create New Schedule',
      name: 'createNewSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Paused Schedules ({count})`
  String pausedSchedules(Object count) {
    return Intl.message(
      'Paused Schedules ($count)',
      name: 'pausedSchedules',
      desc: '',
      args: [count],
    );
  }

  /// `No paused or deactivated schedules. Paused orders will appear here.`
  String get noPausedSchedules {
    return Intl.message(
      'No paused or deactivated schedules. Paused orders will appear here.',
      name: 'noPausedSchedules',
      desc: '',
      args: [],
    );
  }

  /// `Next Schedule: {when}`
  String nextSchedule(Object when) {
    return Intl.message(
      'Next Schedule: $when',
      name: 'nextSchedule',
      desc: '',
      args: [when],
    );
  }

  /// `In Progress ({count})`
  String inProgressCount(Object count) {
    return Intl.message(
      'In Progress ($count)',
      name: 'inProgressCount',
      desc: '',
      args: [count],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message('Remove', name: 'remove', desc: '', args: []);
  }

  /// `History`
  String get history {
    return Intl.message('History', name: 'history', desc: '', args: []);
  }

  /// `Generated`
  String get generated {
    return Intl.message('Generated', name: 'generated', desc: '', args: []);
  }

  /// `Order Name`
  String get orderName {
    return Intl.message('Order Name', name: 'orderName', desc: '', args: []);
  }

  /// `Weekly Dairy Order`
  String get weeklyDairyOrder {
    return Intl.message(
      'Weekly Dairy Order',
      name: 'weeklyDairyOrder',
      desc: '',
      args: [],
    );
  }

  /// `Repeat Frequency`
  String get repeatFrequency {
    return Intl.message(
      'Repeat Frequency',
      name: 'repeatFrequency',
      desc: '',
      args: [],
    );
  }

  /// `Weekly`
  String get weekly {
    return Intl.message('Weekly', name: 'weekly', desc: '', args: []);
  }

  /// `Next Order Schedule`
  String get nextOrderSchedule {
    return Intl.message(
      'Next Order Schedule',
      name: 'nextOrderSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Schedule time`
  String get scheduleTime {
    return Intl.message(
      'Schedule time',
      name: 'scheduleTime',
      desc: '',
      args: [],
    );
  }

  /// `Item Count & Availability ({count})`
  String itemCountAndAvailability(Object count) {
    return Intl.message(
      'Item Count & Availability ($count)',
      name: 'itemCountAndAvailability',
      desc: '',
      args: [count],
    );
  }

  /// `Fresh Beef`
  String get freshBeef {
    return Intl.message('Fresh Beef', name: 'freshBeef', desc: '', args: []);
  }

  /// `Activation Period`
  String get activationPeriod {
    return Intl.message(
      'Activation Period',
      name: 'activationPeriod',
      desc: '',
      args: [],
    );
  }

  /// `End Date`
  String get endDate {
    return Intl.message('End Date', name: 'endDate', desc: '', args: []);
  }

  /// `Items & Quantities ({count}):`
  String itemsAndQuantities(Object count) {
    return Intl.message(
      'Items & Quantities ($count):',
      name: 'itemsAndQuantities',
      desc: '',
      args: [count],
    );
  }

  /// `Schedule Settings`
  String get scheduleSettings {
    return Intl.message(
      'Schedule Settings',
      name: 'scheduleSettings',
      desc: '',
      args: [],
    );
  }

  /// `Request Days`
  String get requestDays {
    return Intl.message(
      'Request Days',
      name: 'requestDays',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Smart Settings`
  String get smartSettings {
    return Intl.message(
      'Smart Settings',
      name: 'smartSettings',
      desc: '',
      args: [],
    );
  }

  /// `Completed Orders ({count})`
  String completedOrdersCount(Object count) {
    return Intl.message(
      'Completed Orders ($count)',
      name: 'completedOrdersCount',
      desc: '',
      args: [count],
    );
  }

  /// `Order cycle is complete, and records are archived. Tap to see delivery details.`
  String get orderCycleComplete {
    return Intl.message(
      'Order cycle is complete, and records are archived. Tap to see delivery details.',
      name: 'orderCycleComplete',
      desc: '',
      args: [],
    );
  }

  /// `This cycle’s order was manually canceled. The recurring schedule remains active — next order will generate on {date}.`
  String thisCycleOrderCanceled(Object date) {
    return Intl.message(
      'This cycle’s order was manually canceled. The recurring schedule remains active — next order will generate on $date.',
      name: 'thisCycleOrderCanceled',
      desc: '',
      args: [date],
    );
  }

  /// `Temporarily on hold`
  String get temporarilyOnHold {
    return Intl.message(
      'Temporarily on hold',
      name: 'temporarilyOnHold',
      desc: '',
      args: [],
    );
  }

  /// `No orders will be triggered until the schedule is resumed.`
  String get noOrdersWillBeTriggeredUntilTheScheduleIsResumed {
    return Intl.message(
      'No orders will be triggered until the schedule is resumed.',
      name: 'noOrdersWillBeTriggeredUntilTheScheduleIsResumed',
      desc: '',
      args: [],
    );
  }

  /// `Paused`
  String get paused {
    return Intl.message('Paused', name: 'paused', desc: '', args: []);
  }

  /// `Create as schedule`
  String get createAsShcedule {
    return Intl.message(
      'Create as schedule',
      name: 'createAsShcedule',
      desc: '',
      args: [],
    );
  }

  /// `Monthly`
  String get monthly {
    return Intl.message('Monthly', name: 'monthly', desc: '', args: []);
  }

  /// `Based on inventory level`
  String get basedOnInventoryLevel {
    return Intl.message(
      'Based on inventory level',
      name: 'basedOnInventoryLevel',
      desc: '',
      args: [],
    );
  }

  /// `Set schedule, cycle, and notifications for this:`
  String get setScheduleCycleAndNotificationsForThis {
    return Intl.message(
      'Set schedule, cycle, and notifications for this:',
      name: 'setScheduleCycleAndNotificationsForThis',
      desc: '',
      args: [],
    );
  }

  /// `Set how often this order should repeat:`
  String get setHowOftenThisOrderShouldRepeat {
    return Intl.message(
      'Set how often this order should repeat:',
      name: 'setHowOftenThisOrderShouldRepeat',
      desc: '',
      args: [],
    );
  }

  /// `Alert 24 hours before`
  String get alert24HoursBefore {
    return Intl.message(
      'Alert 24 hours before',
      name: 'alert24HoursBefore',
      desc: '',
      args: [],
    );
  }

  /// `Review before sending`
  String get reviewBeforeSending {
    return Intl.message(
      'Review before sending',
      name: 'reviewBeforeSending',
      desc: '',
      args: [],
    );
  }

  /// `Send automatically without review`
  String get sendAutomaticallyWithoutReview {
    return Intl.message(
      'Send automatically without review',
      name: 'sendAutomaticallyWithoutReview',
      desc: '',
      args: [],
    );
  }

  /// `Auto-adjust quantities based on consumption`
  String get autoAdjustQuantitiesBasedOnConsumption {
    return Intl.message(
      'Auto-adjust quantities based on consumption',
      name: 'autoAdjustQuantitiesBasedOnConsumption',
      desc: '',
      args: [],
    );
  }

  /// `Freeze during holidays and events`
  String get freezeDuringHolidaysAndEvents {
    return Intl.message(
      'Freeze during holidays and events',
      name: 'freezeDuringHolidaysAndEvents',
      desc: '',
      args: [],
    );
  }

  /// `Notify when prices change`
  String get notifyWhenPricesChange {
    return Intl.message(
      'Notify when prices change',
      name: 'notifyWhenPricesChange',
      desc: '',
      args: [],
    );
  }

  /// `Start Date`
  String get startDate {
    return Intl.message('Start Date', name: 'startDate', desc: '', args: []);
  }

  /// `Open (Repeats Until You end it)`
  String get openRepeatsUntilYouEndIt {
    return Intl.message(
      'Open (Repeats Until You end it)',
      name: 'openRepeatsUntilYouEndIt',
      desc: '',
      args: [],
    );
  }

  /// `What time should the orders be automatically sent?`
  String get whatTimeShouldTheOrdersBeAutomaticallySent {
    return Intl.message(
      'What time should the orders be automatically sent?',
      name: 'whatTimeShouldTheOrdersBeAutomaticallySent',
      desc: '',
      args: [],
    );
  }

  /// `Time picker`
  String get timePicker {
    return Intl.message('Time picker', name: 'timePicker', desc: '', args: []);
  }

  /// `Time of day`
  String get timeOfDay {
    return Intl.message('Time of day', name: 'timeOfDay', desc: '', args: []);
  }

  /// `Morning (between 12:00 AM – 11:59 AM)`
  String get morningBetween1200AM1159AM {
    return Intl.message(
      'Morning (between 12:00 AM – 11:59 AM)',
      name: 'morningBetween1200AM1159AM',
      desc: '',
      args: [],
    );
  }

  /// `Afternoon (between 12:00 PM – 11:59 PM)`
  String get afternoonBetween1200PM1159PM {
    return Intl.message(
      'Afternoon (between 12:00 PM – 11:59 PM)',
      name: 'afternoonBetween1200PM1159PM',
      desc: '',
      args: [],
    );
  }

  /// `Hour`
  String get hour {
    return Intl.message('Hour', name: 'hour', desc: '', args: []);
  }

  /// `Minute`
  String get minute {
    return Intl.message('Minute', name: 'minute', desc: '', args: []);
  }

  /// `Confirm Time`
  String get confirmTime {
    return Intl.message(
      'Confirm Time',
      name: 'confirmTime',
      desc: '',
      args: [],
    );
  }

  /// `Repeat Days`
  String get repeatDays {
    return Intl.message('Repeat Days', name: 'repeatDays', desc: '', args: []);
  }

  /// `Pick the days to auto-send this order every week.`
  String get pickTheDaysToAutoSendThisOrderEveryWeek {
    return Intl.message(
      'Pick the days to auto-send this order every week.',
      name: 'pickTheDaysToAutoSendThisOrderEveryWeek',
      desc: '',
      args: [],
    );
  }

  /// `Sun`
  String get sun {
    return Intl.message('Sun', name: 'sun', desc: '', args: []);
  }

  /// `Mon`
  String get mon {
    return Intl.message('Mon', name: 'mon', desc: '', args: []);
  }

  /// `Tue`
  String get tue {
    return Intl.message('Tue', name: 'tue', desc: '', args: []);
  }

  /// `Wed`
  String get wed {
    return Intl.message('Wed', name: 'wed', desc: '', args: []);
  }

  /// `Thu`
  String get thu {
    return Intl.message('Thu', name: 'thu', desc: '', args: []);
  }

  /// `Fri`
  String get fri {
    return Intl.message('Fri', name: 'fri', desc: '', args: []);
  }

  /// `Sat`
  String get sat {
    return Intl.message('Sat', name: 'sat', desc: '', args: []);
  }

  /// `AM`
  String get am {
    return Intl.message('AM', name: 'am', desc: '', args: []);
  }

  /// `PM`
  String get pm {
    return Intl.message('PM', name: 'pm', desc: '', args: []);
  }

  /// `Repeat Type`
  String get repeatType {
    return Intl.message('Repeat Type', name: 'repeatType', desc: '', args: []);
  }

  /// `Pick the date to auto-send this order every month.`
  String get pickTheDateToAutoSendThisOrderEveryMonth {
    return Intl.message(
      'Pick the date to auto-send this order every month.',
      name: 'pickTheDateToAutoSendThisOrderEveryMonth',
      desc: '',
      args: [],
    );
  }

  /// `By Date`
  String get byDate {
    return Intl.message('By Date', name: 'byDate', desc: '', args: []);
  }

  /// `By Pattern`
  String get byPattern {
    return Intl.message('By Pattern', name: 'byPattern', desc: '', args: []);
  }

  /// `Repeat monthly on every:`
  String get repeatMonthlyOnEvery {
    return Intl.message(
      'Repeat monthly on every:',
      name: 'repeatMonthlyOnEvery',
      desc: '',
      args: [],
    );
  }

  /// `Date picker`
  String get datePicker {
    return Intl.message('Date picker', name: 'datePicker', desc: '', args: []);
  }

  /// `Every`
  String get every {
    return Intl.message('Every', name: 'every', desc: '', args: []);
  }

  /// `Day of the week`
  String get dayOfTheWeek {
    return Intl.message(
      'Day of the week',
      name: 'dayOfTheWeek',
      desc: '',
      args: [],
    );
  }

  /// `Level Ratio`
  String get levelRatio {
    return Intl.message('Level Ratio', name: 'levelRatio', desc: '', args: []);
  }

  /// `Trigger order when selected item’s available quantity drops to:`
  String get triggerOrderWhenSelectedItemAvailableQuantityDropsTo {
    return Intl.message(
      'Trigger order when selected item’s available quantity drops to:',
      name: 'triggerOrderWhenSelectedItemAvailableQuantityDropsTo',
      desc: '',
      args: [],
    );
  }

  /// `Emergency`
  String get emergency {
    return Intl.message('Emergency', name: 'emergency', desc: '', args: []);
  }

  /// `Moderate`
  String get moderate {
    return Intl.message('Moderate', name: 'moderate', desc: '', args: []);
  }

  /// `Set Value`
  String get setValue {
    return Intl.message('Set Value', name: 'setValue', desc: '', args: []);
  }

  /// `Trigger Condition`
  String get triggerCondition {
    return Intl.message(
      'Trigger Condition',
      name: 'triggerCondition',
      desc: '',
      args: [],
    );
  }

  /// `A new order will be auto-created, but no further orders will be triggered until restock is confirmed.`
  String
  get aNewOrderWillBeAutoCreatedButNoFurtherOrdersWillBeTriggeredUntilRestockIsConfirmed {
    return Intl.message(
      'A new order will be auto-created, but no further orders will be triggered until restock is confirmed.',
      name:
          'aNewOrderWillBeAutoCreatedButNoFurtherOrdersWillBeTriggeredUntilRestockIsConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Ratio Level (%)`
  String get ratioLevel {
    return Intl.message(
      'Ratio Level (%)',
      name: 'ratioLevel',
      desc: '',
      args: [],
    );
  }

  /// `Review Schedule Summary`
  String get reviewScheduleSummary {
    return Intl.message(
      'Review Schedule Summary',
      name: 'reviewScheduleSummary',
      desc: '',
      args: [],
    );
  }

  /// `Review the order schedule details before activating. You can edit, pause, or delete it later.`
  String
  get reviewTheOrderScheduleDetailsBeforeActivatingYouCanEditPauseOrDeleteItLater {
    return Intl.message(
      'Review the order schedule details before activating. You can edit, pause, or delete it later.',
      name:
          'reviewTheOrderScheduleDetailsBeforeActivatingYouCanEditPauseOrDeleteItLater',
      desc: '',
      args: [],
    );
  }

  /// `Repeat Mode`
  String get repeatMode {
    return Intl.message('Repeat Mode', name: 'repeatMode', desc: '', args: []);
  }

  /// `This order will repeat on every: {dates} of every week.`
  String thisOrderWillRepeatOnEvery(Object dates) {
    return Intl.message(
      'This order will repeat on every: $dates of every week.',
      name: 'thisOrderWillRepeatOnEvery',
      desc: '',
      args: [dates],
    );
  }

  /// `Repeat Days Of every month`
  String get repeatDayOfEveryMonth {
    return Intl.message(
      'Repeat Days Of every month',
      name: 'repeatDayOfEveryMonth',
      desc: '',
      args: [],
    );
  }

  /// `Of Every Month`
  String get ofEveryMonth {
    return Intl.message(
      'Of Every Month',
      name: 'ofEveryMonth',
      desc: '',
      args: [],
    );
  }

  /// `This order will repeat on every: {dates} of every month.`
  String thisOrderWillRepeatOnEveryOfEveryMonth(Object dates) {
    return Intl.message(
      'This order will repeat on every: $dates of every month.',
      name: 'thisOrderWillRepeatOnEveryOfEveryMonth',
      desc: '',
      args: [dates],
    );
  }

  /// `When selected item’s available quantity drops to {pers}% of usual levels, a new order will be created automatically.`
  String
  whenSelectedItemAvailableQuantityDropsToPersOfUsualLevelsNewOrderCreatedAutomatically(
    Object pers,
  ) {
    return Intl.message(
      'When selected item’s available quantity drops to $pers% of usual levels, a new order will be created automatically.',
      name:
          'whenSelectedItemAvailableQuantityDropsToPersOfUsualLevelsNewOrderCreatedAutomatically',
      desc: '',
      args: [pers],
    );
  }

  /// `Save and Activate`
  String get saveAndActivate {
    return Intl.message(
      'Save and Activate',
      name: 'saveAndActivate',
      desc: '',
      args: [],
    );
  }

  /// `Recurring Order Scheduled`
  String get recurringOrderScheduled {
    return Intl.message(
      'Recurring Order Scheduled',
      name: 'recurringOrderScheduled',
      desc: '',
      args: [],
    );
  }

  /// `Your recurring order has been successfully created.`
  String get yourRecurringOrderHasBeenSuccessfullyCreated {
    return Intl.message(
      'Your recurring order has been successfully created.',
      name: 'yourRecurringOrderHasBeenSuccessfullyCreated',
      desc: '',
      args: [],
    );
  }

  /// `Go To Recurring Orders`
  String get goToRecurringOrders {
    return Intl.message(
      'Go To Recurring Orders',
      name: 'goToRecurringOrders',
      desc: '',
      args: [],
    );
  }

  /// `Go To Submit Order`
  String get goToSubmitOrder {
    return Intl.message(
      'Go To Submit Order',
      name: 'goToSubmitOrder',
      desc: '',
      args: [],
    );
  }

  /// `Emergency Order`
  String get emergencyOrder {
    return Intl.message(
      'Emergency Order',
      name: 'emergencyOrder',
      desc: '',
      args: [],
    );
  }

  /// `Cashier Dashboard for Store Branch`
  String get cashierDashboardForStoreBranch {
    return Intl.message(
      'Cashier Dashboard for Store Branch',
      name: 'cashierDashboardForStoreBranch',
      desc: '',
      args: [],
    );
  }

  /// `Store branch Info`
  String get storeBranchInfo {
    return Intl.message(
      'Store branch Info',
      name: 'storeBranchInfo',
      desc: '',
      args: [],
    );
  }

  /// `Learn more about your store branch and your daily work assignments.`
  String get learnMoreAboutYourStoreBranchAndYourDailyWorkAssignments {
    return Intl.message(
      'Learn more about your store branch and your daily work assignments.',
      name: 'learnMoreAboutYourStoreBranchAndYourDailyWorkAssignments',
      desc: '',
      args: [],
    );
  }

  /// `No Active Shift`
  String get noActiveShift {
    return Intl.message(
      'No Active Shift',
      name: 'noActiveShift',
      desc: '',
      args: [],
    );
  }

  /// `Your branch supervisor hasn't set up any shifts for you yet. You'll receive a notification once it's ready!`
  String get noActiveShiftDesc {
    return Intl.message(
      'Your branch supervisor hasn\'t set up any shifts for you yet. You\'ll receive a notification once it\'s ready!',
      name: 'noActiveShiftDesc',
      desc: '',
      args: [],
    );
  }

  /// `Role: Senior Cashier`
  String get roleSeniorCashier {
    return Intl.message(
      'Role: Senior Cashier',
      name: 'roleSeniorCashier',
      desc: '',
      args: [],
    );
  }

  /// `Shifts`
  String get shifts {
    return Intl.message('Shifts', name: 'shifts', desc: '', args: []);
  }

  /// `Ledger`
  String get ledger {
    return Intl.message('Ledger', name: 'ledger', desc: '', args: []);
  }

  /// `Your Branch Manager hasn’t assigned a shift to you yet.\n\nYou’ll receive a notification as soon as one is added.`
  String get noAssignedShiftsDesc {
    return Intl.message(
      'Your Branch Manager hasn’t assigned a shift to you yet.\n\nYou’ll receive a notification as soon as one is added.',
      name: 'noAssignedShiftsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Reassigned`
  String get reassigned {
    return Intl.message('Reassigned', name: 'reassigned', desc: '', args: []);
  }

  /// `No assigned shifts`
  String get noAssignedShifts {
    return Intl.message(
      'No assigned shifts',
      name: 'noAssignedShifts',
      desc: '',
      args: [],
    );
  }

  /// `You have not started any shift yet. Check “Pending” to see a list of upcoming shifts.`
  String get noStartedShiftsDesc {
    return Intl.message(
      'You have not started any shift yet. Check “Pending” to see a list of upcoming shifts.',
      name: 'noStartedShiftsDesc',
      desc: '',
      args: [],
    );
  }

  /// `No Closed shifts`
  String get noClosedShifts {
    return Intl.message(
      'No Closed shifts',
      name: 'noClosedShifts',
      desc: '',
      args: [],
    );
  }

  /// `You have not completed any shift yet. Check “Pending” to see a list of upcoming shifts.`
  String get noClosedShiftsDesc {
    return Intl.message(
      'You have not completed any shift yet. Check “Pending” to see a list of upcoming shifts.',
      name: 'noClosedShiftsDesc',
      desc: '',
      args: [],
    );
  }

  /// `No Reassigned Shifts`
  String get noReassignedShifts {
    return Intl.message(
      'No Reassigned Shifts',
      name: 'noReassignedShifts',
      desc: '',
      args: [],
    );
  }

  /// `Your Branch Manager has not reassigned your shift to someone else yet.\n\nIf they do, the update will appear here.`
  String get noReassignedShiftsDesc {
    return Intl.message(
      'Your Branch Manager has not reassigned your shift to someone else yet.\n\nIf they do, the update will appear here.',
      name: 'noReassignedShiftsDesc',
      desc: '',
      args: [],
    );
  }

  /// `My Work Lists ({count})`
  String myWorkLists(Object count) {
    return Intl.message(
      'My Work Lists ($count)',
      name: 'myWorkLists',
      desc: '',
      args: [count],
    );
  }

  /// `No Activity Yet`
  String get noActivityYet {
    return Intl.message(
      'No Activity Yet',
      name: 'noActivityYet',
      desc: '',
      args: [],
    );
  }

  /// `You haven’t completed any shifts, received handovers, or submitted any handover records yet.\n\nOnce you begin working shifts, your full activity history will appear here.`
  String get noActivityYetDesc {
    return Intl.message(
      'You haven’t completed any shifts, received handovers, or submitted any handover records yet.\n\nOnce you begin working shifts, your full activity history will appear here.',
      name: 'noActivityYetDesc',
      desc: '',
      args: [],
    );
  }

  /// `(To Start)`
  String get toStart {
    return Intl.message('(To Start)', name: 'toStart', desc: '', args: []);
  }

  /// `Reassigned Mid-Shift`
  String get reassignedMidShift {
    return Intl.message(
      'Reassigned Mid-Shift',
      name: 'reassignedMidShift',
      desc: '',
      args: [],
    );
  }

  /// `You have approved this Handover`
  String get youHaveApprovedThisHandover {
    return Intl.message(
      'You have approved this Handover',
      name: 'youHaveApprovedThisHandover',
      desc: '',
      args: [],
    );
  }

  /// `Accept Shift`
  String get acceptShift {
    return Intl.message(
      'Accept Shift',
      name: 'acceptShift',
      desc: '',
      args: [],
    );
  }

  /// `Opening Balance`
  String get openingBalance_o {
    return Intl.message(
      'Opening Balance',
      name: 'openingBalance_o',
      desc: '',
      args: [],
    );
  }

  /// `Cash Given`
  String get cashGiven {
    return Intl.message('Cash Given', name: 'cashGiven', desc: '', args: []);
  }

  /// `Accept Handover`
  String get acceptHandover {
    return Intl.message(
      'Accept Handover',
      name: 'acceptHandover',
      desc: '',
      args: [],
    );
  }

  /// `{name} listed you as one of the reasons for the variance in their shift’s closing balance.\n\nPlease review the details and choose to approve or reject your part in it.`
  String variancePendingApprovalDesc(Object name) {
    return Intl.message(
      '$name listed you as one of the reasons for the variance in their shift’s closing balance.\n\nPlease review the details and choose to approve or reject your part in it.',
      name: 'variancePendingApprovalDesc',
      desc: '',
      args: [name],
    );
  }

  /// `No Products Selected For Today`
  String get noProductsSelectedForToday {
    return Intl.message(
      'No Products Selected For Today',
      name: 'noProductsSelectedForToday',
      desc: '',
      args: [],
    );
  }

  /// `Hand Over From`
  String get handOverFrom {
    return Intl.message(
      'Hand Over From',
      name: 'handOverFrom',
      desc: '',
      args: [],
    );
  }

  /// `Hand Over To`
  String get handOverTo {
    return Intl.message('Hand Over To', name: 'handOverTo', desc: '', args: []);
  }

  /// `New Assignments`
  String get newAssignments {
    return Intl.message(
      'New Assignments',
      name: 'newAssignments',
      desc: '',
      args: [],
    );
  }

  /// `Click to see details`
  String get clickToSeeDetails {
    return Intl.message(
      'Click to see details',
      name: 'clickToSeeDetails',
      desc: '',
      args: [],
    );
  }

  /// `Pending Tasks`
  String get pendingTasks {
    return Intl.message(
      'Pending Tasks',
      name: 'pendingTasks',
      desc: '',
      args: [],
    );
  }

  /// `Assigned Tasks`
  String get assignedTasks {
    return Intl.message(
      'Assigned Tasks',
      name: 'assignedTasks',
      desc: '',
      args: [],
    );
  }

  /// `Your Personal Statistics`
  String get yourPersonalStatistics {
    return Intl.message(
      'Your Personal Statistics',
      name: 'yourPersonalStatistics',
      desc: '',
      args: [],
    );
  }

  /// `This Month's ({month}) Achievements`
  String thisMonthsAchievements(Object month) {
    return Intl.message(
      'This Month\'s ($month) Achievements',
      name: 'thisMonthsAchievements',
      desc: '',
      args: [month],
    );
  }

  /// `Daily Inventory completed`
  String get dailyInventoryCompleted {
    return Intl.message(
      'Daily Inventory completed',
      name: 'dailyInventoryCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Average inventory time`
  String get averageInventoryTime {
    return Intl.message(
      'Average inventory time',
      name: 'averageInventoryTime',
      desc: '',
      args: [],
    );
  }

  /// `Accuracy rate`
  String get accuracyRate {
    return Intl.message(
      'Accuracy rate',
      name: 'accuracyRate',
      desc: '',
      args: [],
    );
  }

  /// `Waste recorded`
  String get wasteRecorded {
    return Intl.message(
      'Waste recorded',
      name: 'wasteRecorded',
      desc: '',
      args: [],
    );
  }

  /// `Performance rating`
  String get performanceRating {
    return Intl.message(
      'Performance rating',
      name: 'performanceRating',
      desc: '',
      args: [],
    );
  }

  /// `Contact Manager`
  String get contactManager {
    return Intl.message(
      'Contact Manager',
      name: 'contactManager',
      desc: '',
      args: [],
    );
  }

  /// `Daily Inventory`
  String get dailyInventory_d {
    return Intl.message(
      'Daily Inventory',
      name: 'dailyInventory_d',
      desc: '',
      args: [],
    );
  }

  /// `{count} Specified Products`
  String countSpecifiedProducts(Object count) {
    return Intl.message(
      '$count Specified Products',
      name: 'countSpecifiedProducts',
      desc: '',
      args: [count],
    );
  }

  /// `Start Inventory Now`
  String get startInventoryNow {
    return Intl.message(
      'Start Inventory Now',
      name: 'startInventoryNow',
      desc: '',
      args: [],
    );
  }

  /// `Waste & Damage Registration`
  String get wasteDamageRegistration {
    return Intl.message(
      'Waste & Damage Registration',
      name: 'wasteDamageRegistration',
      desc: '',
      args: [],
    );
  }

  /// `Record Waste/Damage Now`
  String get recordWasteDamageNow {
    return Intl.message(
      'Record Waste/Damage Now',
      name: 'recordWasteDamageNow',
      desc: '',
      args: [],
    );
  }

  /// `Timing`
  String get timing {
    return Intl.message('Timing', name: 'timing', desc: '', args: []);
  }

  /// `As needed`
  String get asNeeded {
    return Intl.message('As needed', name: 'asNeeded', desc: '', args: []);
  }

  /// `Start Now`
  String get startNow {
    return Intl.message('Start Now', name: 'startNow', desc: '', args: []);
  }

  /// `Reassignments`
  String get reassignments {
    return Intl.message(
      'Reassignments',
      name: 'reassignments',
      desc: '',
      args: [],
    );
  }

  /// `Schedule Details`
  String get scheduleDetails {
    return Intl.message(
      'Schedule Details',
      name: 'scheduleDetails',
      desc: '',
      args: [],
    );
  }

  /// `View activity log and manage recurring schedule.`
  String get viewActivityAndManageSchedule {
    return Intl.message(
      'View activity log and manage recurring schedule.',
      name: 'viewActivityAndManageSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Next Order – Weekly Repeat`
  String get nextOrderWeeklyRepeat {
    return Intl.message(
      'Next Order – Weekly Repeat',
      name: 'nextOrderWeeklyRepeat',
      desc: '',
      args: [],
    );
  }

  /// `Your next order will be automatically generated on {date} at {time}.`
  String nextOrderWillBeGeneratedOn(Object date, Object time) {
    return Intl.message(
      'Your next order will be automatically generated on $date at $time.',
      name: 'nextOrderWillBeGeneratedOn',
      desc: '',
      args: [date, time],
    );
  }

  /// `Generated order has been confirmed and is currently being processed.`
  String get generatedOrderConfirmed {
    return Intl.message(
      'Generated order has been confirmed and is currently being processed.',
      name: 'generatedOrderConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Procurement steps (confirmation, Progressing, delivery) are underway.`
  String get procurementStepsUnderway {
    return Intl.message(
      'Procurement steps (confirmation, Progressing, delivery) are underway.',
      name: 'procurementStepsUnderway',
      desc: '',
      args: [],
    );
  }

  /// `Generated order is currently being Confirmation from {name}.`
  String generatedOrderConfirmation(Object name) {
    return Intl.message(
      'Generated order is currently being Confirmation from $name.',
      name: 'generatedOrderConfirmation',
      desc: '',
      args: [name],
    );
  }

  /// `Pause`
  String get pause {
    return Intl.message('Pause', name: 'pause', desc: '', args: []);
  }

  /// `Resume`
  String get resume {
    return Intl.message('Resume', name: 'resume', desc: '', args: []);
  }

  /// `Pause Schedule`
  String get pauseSchedule {
    return Intl.message(
      'Pause Schedule',
      name: 'pauseSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Edit Schedule`
  String get editSchedule {
    return Intl.message(
      'Edit Schedule',
      name: 'editSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Delete Schedule`
  String get deleteSchedule {
    return Intl.message(
      'Delete Schedule',
      name: 'deleteSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Resume Schedule`
  String get resumeSchedule {
    return Intl.message(
      'Resume Schedule',
      name: 'resumeSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Pending your confirmation`
  String get pendingYourConfirmation {
    return Intl.message(
      'Pending your confirmation',
      name: 'pendingYourConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `{date} Daily Inventory Details`
  String dateDailyInventoryDetails(Object date) {
    return Intl.message(
      '$date Daily Inventory Details',
      name: 'dateDailyInventoryDetails',
      desc: '',
      args: [date],
    );
  }

  /// `Waste & Damages ({count})`
  String wasteAndDamages(Object count) {
    return Intl.message(
      'Waste & Damages ($count)',
      name: 'wasteAndDamages',
      desc: '',
      args: [count],
    );
  }

  /// `Monthly Inventory ({count})`
  String monthlyInventoryCount(Object count) {
    return Intl.message(
      'Monthly Inventory ($count)',
      name: 'monthlyInventoryCount',
      desc: '',
      args: [count],
    );
  }

  /// `Pending your action`
  String get pendingYourAction {
    return Intl.message(
      'Pending your action',
      name: 'pendingYourAction',
      desc: '',
      args: [],
    );
  }

  /// `You have not sent any requests`
  String get noRequestsYetDesc {
    return Intl.message(
      'You have not sent any requests',
      name: 'noRequestsYetDesc',
      desc: '',
      args: [],
    );
  }

  /// `Balance Trend Stats`
  String get balanceTrendStatsTitle {
    return Intl.message(
      'Balance Trend Stats',
      name: 'balanceTrendStatsTitle',
      desc: '',
      args: [],
    );
  }

  /// `The trend chart compares money in vs. money out`
  String get balanceTrendStatsSubtitle {
    return Intl.message(
      'The trend chart compares money in vs. money out',
      name: 'balanceTrendStatsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Branch Balance trends`
  String get branchBalanceTrends {
    return Intl.message(
      'Branch Balance trends',
      name: 'branchBalanceTrends',
      desc: '',
      args: [],
    );
  }

  /// `Personal Balance trends`
  String get personalBalanceTrends {
    return Intl.message(
      'Personal Balance trends',
      name: 'personalBalanceTrends',
      desc: '',
      args: [],
    );
  }

  /// `Daily`
  String get trendStatsDaily {
    return Intl.message('Daily', name: 'trendStatsDaily', desc: '', args: []);
  }

  /// `Weekly`
  String get trendStatsWeekly {
    return Intl.message('Weekly', name: 'trendStatsWeekly', desc: '', args: []);
  }

  /// `Monthly`
  String get trendStatsMonthly {
    return Intl.message(
      'Monthly',
      name: 'trendStatsMonthly',
      desc: '',
      args: [],
    );
  }

  /// `Timeline`
  String get trendStatsTimeline {
    return Intl.message(
      'Timeline',
      name: 'trendStatsTimeline',
      desc: '',
      args: [],
    );
  }

  /// `Showing data from:`
  String get trendStatsShowingDataFrom {
    return Intl.message(
      'Showing data from:',
      name: 'trendStatsShowingDataFrom',
      desc: '',
      args: [],
    );
  }

  /// `Total Custody Requests`
  String get trendStatsTotalCustodyRequests {
    return Intl.message(
      'Total Custody Requests',
      name: 'trendStatsTotalCustodyRequests',
      desc: '',
      args: [],
    );
  }

  /// `No Increase from last hour`
  String get trendStatsNoIncrease {
    return Intl.message(
      'No Increase from last hour',
      name: 'trendStatsNoIncrease',
      desc: '',
      args: [],
    );
  }

  /// `Total Expense`
  String get trendStatsTotalExpense {
    return Intl.message(
      'Total Expense',
      name: 'trendStatsTotalExpense',
      desc: '',
      args: [],
    );
  }

  /// `higher than last last hour.`
  String get trendStatsHigherThanLastHour {
    return Intl.message(
      'higher than last last hour.',
      name: 'trendStatsHigherThanLastHour',
      desc: '',
      args: [],
    );
  }

  /// `Report Saved`
  String get reportSaved {
    return Intl.message(
      'Report Saved',
      name: 'reportSaved',
      desc: '',
      args: [],
    );
  }

  /// `Your report has been saved and shared with your manager’s drafts. You can access it there to review, edit, or submit it for approval when you're ready.`
  String get reportSavedDesc {
    return Intl.message(
      'Your report has been saved and shared with your manager’s drafts. You can access it there to review, edit, or submit it for approval when you\'re ready.',
      name: 'reportSavedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Submission Date`
  String get submissionDate {
    return Intl.message(
      'Submission Date',
      name: 'submissionDate',
      desc: '',
      args: [],
    );
  }

  /// `Affected Products`
  String get affectedProducts {
    return Intl.message(
      'Affected Products',
      name: 'affectedProducts',
      desc: '',
      args: [],
    );
  }

  /// `Report Details`
  String get reportDetails {
    return Intl.message(
      'Report Details',
      name: 'reportDetails',
      desc: '',
      args: [],
    );
  }

  /// `Report Submitted`
  String get reportSubmitted {
    return Intl.message(
      'Report Submitted',
      name: 'reportSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Your report has been successfully submitted by {name} to management for review.`
  String reportSubmittedDesc(Object name) {
    return Intl.message(
      'Your report has been successfully submitted by $name to management for review.',
      name: 'reportSubmittedDesc',
      desc: '',
      args: [name],
    );
  }

  /// `Assignment Information:`
  String get assignmentInformation {
    return Intl.message(
      'Assignment Information:',
      name: 'assignmentInformation',
      desc: '',
      args: [],
    );
  }

  /// `Responsibility`
  String get responsibility {
    return Intl.message(
      'Responsibility',
      name: 'responsibility',
      desc: '',
      args: [],
    );
  }

  /// `Accurate waste & damage registration`
  String get accurateWasteDamageRegistration {
    return Intl.message(
      'Accurate waste & damage registration',
      name: 'accurateWasteDamageRegistration',
      desc: '',
      args: [],
    );
  }

  /// `Immediate upon discovery`
  String get immediateUponDiscovery {
    return Intl.message(
      'Immediate upon discovery',
      name: 'immediateUponDiscovery',
      desc: '',
      args: [],
    );
  }

  /// `Will be sent to manager for approval`
  String get reviewWillBeSentToManager {
    return Intl.message(
      'Will be sent to manager for approval',
      name: 'reviewWillBeSentToManager',
      desc: '',
      args: [],
    );
  }

  /// `Reminder`
  String get reminder {
    return Intl.message('Reminder', name: 'reminder', desc: '', args: []);
  }

  /// `You are registering in the manager's name`
  String get registeringInManagersName {
    return Intl.message(
      'You are registering in the manager\'s name',
      name: 'registeringInManagersName',
      desc: '',
      args: [],
    );
  }

  /// `Quantity wasted:`
  String get quantityWasted {
    return Intl.message(
      'Quantity wasted:',
      name: 'quantityWasted',
      desc: '',
      args: [],
    );
  }

  /// `Pending Review`
  String get pendingReview {
    return Intl.message(
      'Pending Review',
      name: 'pendingReview',
      desc: '',
      args: [],
    );
  }

  /// `{name} has completed the assigned task of registering waste and Damages. You can review it, edit or contact {name} for adjustments.`
  String completedTaskReview(Object name) {
    return Intl.message(
      '$name has completed the assigned task of registering waste and Damages. You can review it, edit or contact $name for adjustments.',
      name: 'completedTaskReview',
      desc: '',
      args: [name],
    );
  }

  /// `Report in Draft`
  String get reportInDraft {
    return Intl.message(
      'Report in Draft',
      name: 'reportInDraft',
      desc: '',
      args: [],
    );
  }

  /// `Report Approved`
  String get reportApproved {
    return Intl.message(
      'Report Approved',
      name: 'reportApproved',
      desc: '',
      args: [],
    );
  }

  /// `Brand Owner has approved this report. Report has been added to your “Completed” section.`
  String get reportApprovedDesc {
    return Intl.message(
      'Brand Owner has approved this report. Report has been added to your “Completed” section.',
      name: 'reportApprovedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Registered by`
  String get registeredBy {
    return Intl.message(
      'Registered by',
      name: 'registeredBy',
      desc: '',
      args: [],
    );
  }

  /// `Registration time`
  String get registrationTime {
    return Intl.message(
      'Registration time',
      name: 'registrationTime',
      desc: '',
      args: [],
    );
  }

  /// `Number of items`
  String get numberOfItems {
    return Intl.message(
      'Number of items',
      name: 'numberOfItems',
      desc: '',
      args: [],
    );
  }

  /// `Signature`
  String get signature {
    return Intl.message('Signature', name: 'signature', desc: '', args: []);
  }

  /// `Assigned`
  String get assigned {
    return Intl.message('Assigned', name: 'assigned', desc: '', args: []);
  }

  /// `In {branchName} as branch manager`
  String inBranchAsBranchManager(Object branchName) {
    return Intl.message(
      'In $branchName as branch manager',
      name: 'inBranchAsBranchManager',
      desc: '',
      args: [branchName],
    );
  }

  /// `Pending staff assignment`
  String get pendingStaffAssignment {
    return Intl.message(
      'Pending staff assignment',
      name: 'pendingStaffAssignment',
      desc: '',
      args: [],
    );
  }

  /// `You have chosen to assign this inventory count to a staff member. Once you select the staff, they will receive a notification to complete the inventory count.`
  String get pendingStaffAssignmentDesc {
    return Intl.message(
      'You have chosen to assign this inventory count to a staff member. Once you select the staff, they will receive a notification to complete the inventory count.',
      name: 'pendingStaffAssignmentDesc',
      desc: '',
      args: [],
    );
  }

  /// `Available Staff List`
  String get availableStaffList {
    return Intl.message(
      'Available Staff List',
      name: 'availableStaffList',
      desc: '',
      args: [],
    );
  }

  /// `Add staff’s to this month’s inventory team.`
  String get addStaffToThisMonthsTeam {
    return Intl.message(
      'Add staff’s to this month’s inventory team.',
      name: 'addStaffToThisMonthsTeam',
      desc: '',
      args: [],
    );
  }

  /// `Download Statement`
  String get downloadStatement {
    return Intl.message(
      'Download Statement',
      name: 'downloadStatement',
      desc: '',
      args: [],
    );
  }

  /// `Export your account statement in your preferred file format & Timeframe.`
  String get exportYourAccountStatementInYourPreferredFileFormatAndTimeframe {
    return Intl.message(
      'Export your account statement in your preferred file format & Timeframe.',
      name: 'exportYourAccountStatementInYourPreferredFileFormatAndTimeframe',
      desc: '',
      args: [],
    );
  }

  /// `Variance types identify mismatches between total sales and the amount handed over, based on the sales breakdown you provide.`
  String get varianceInfoDesc {
    return Intl.message(
      'Variance types identify mismatches between total sales and the amount handed over, based on the sales breakdown you provide.',
      name: 'varianceInfoDesc',
      desc: '',
      args: [],
    );
  }

  /// `This means the `
  String get thisMeansThe {
    return Intl.message(
      'This means the ',
      name: 'thisMeansThe',
      desc: '',
      args: [],
    );
  }

  /// `cash or payments handed over `
  String get cashOrPaymentHandedOver {
    return Intl.message(
      'cash or payments handed over ',
      name: 'cashOrPaymentHandedOver',
      desc: '',
      args: [],
    );
  }

  /// `are more than the recorded sales.`
  String get areMoreThanTheRecordedSales {
    return Intl.message(
      'are more than the recorded sales.',
      name: 'areMoreThanTheRecordedSales',
      desc: '',
      args: [],
    );
  }

  /// `are less than the recorded sales.`
  String get areLessThanTheRecordedSales {
    return Intl.message(
      'are less than the recorded sales.',
      name: 'areLessThanTheRecordedSales',
      desc: '',
      args: [],
    );
  }

  /// `It could be due to manual entry errors, forgotten sales, or unrecorded transactions.`
  String get itCouldBeDueToManualEntryErrors {
    return Intl.message(
      'It could be due to manual entry errors, forgotten sales, or unrecorded transactions.',
      name: 'itCouldBeDueToManualEntryErrors',
      desc: '',
      args: [],
    );
  }

  /// `Possible causes include missing cash, incorrect entries, or unprocessed refunds.`
  String
  get possibleCausesIncludeMissingCashIncorrectEntriesUnprocessedRefunds {
    return Intl.message(
      'Possible causes include missing cash, incorrect entries, or unprocessed refunds.',
      name:
          'possibleCausesIncludeMissingCashIncorrectEntriesUnprocessedRefunds',
      desc: '',
      args: [],
    );
  }

  /// `You’re confirming receipt of this handover.The amount will automatically become your `
  String get youAreConfirmingReceiptOfThisHandover {
    return Intl.message(
      'You’re confirming receipt of this handover.The amount will automatically become your ',
      name: 'youAreConfirmingReceiptOfThisHandover',
      desc: '',
      args: [],
    );
  }

  /// ` for the shift you’re about to start.`
  String get forTheShiftYouAreAboutToStart {
    return Intl.message(
      ' for the shift you’re about to start.',
      name: 'forTheShiftYouAreAboutToStart',
      desc: '',
      args: [],
    );
  }

  /// `Shift Accepted`
  String get shiftAccepted {
    return Intl.message(
      'Shift Accepted',
      name: 'shiftAccepted',
      desc: '',
      args: [],
    );
  }

  /// `You’ve successfully accepted the handover.The handed-over amount has been set as your opening balance, and your shift is now officially active and being tracked.`
  String get yourSuccessfullyAcceptedTheHandover {
    return Intl.message(
      'You’ve successfully accepted the handover.The handed-over amount has been set as your opening balance, and your shift is now officially active and being tracked.',
      name: 'yourSuccessfullyAcceptedTheHandover',
      desc: '',
      args: [],
    );
  }

  /// `All sales, expenses, and handover actions from this point forward will be recorded under your name.`
  String
  get allSalesExpensesAndHandoverActionsFromThisPointForwardWillBeRecordedUnderYourName {
    return Intl.message(
      'All sales, expenses, and handover actions from this point forward will be recorded under your name.',
      name:
          'allSalesExpensesAndHandoverActionsFromThisPointForwardWillBeRecordedUnderYourName',
      desc: '',
      args: [],
    );
  }

  /// `An explanation and/or document has been provided for this shift’s variance.`
  String get anExplanationForVariance {
    return Intl.message(
      'An explanation and/or document has been provided for this shift’s variance.',
      name: 'anExplanationForVariance',
      desc: '',
      args: [],
    );
  }

  /// `Approve Responsibility`
  String get approveResponsibility {
    return Intl.message(
      'Approve Responsibility',
      name: 'approveResponsibility',
      desc: '',
      args: [],
    );
  }

  /// `You’re confirming your involvement in the variance reported for this shift.Your response will be recorded and included in the final handover review.`
  String get youAreConfirmingYourInvolvementInTheVariance {
    return Intl.message(
      'You’re confirming your involvement in the variance reported for this shift.Your response will be recorded and included in the final handover review.',
      name: 'youAreConfirmingYourInvolvementInTheVariance',
      desc: '',
      args: [],
    );
  }

  /// `You Accepted Responsibility`
  String get youAcceptedYourResponsibility {
    return Intl.message(
      'You Accepted Responsibility',
      name: 'youAcceptedYourResponsibility',
      desc: '',
      args: [],
    );
  }

  /// `You’ve accepted your part in the cause of this variance. Your response has been recorded and submitted.`
  String get YouAcceptedYourPart {
    return Intl.message(
      'You’ve accepted your part in the cause of this variance. Your response has been recorded and submitted.',
      name: 'YouAcceptedYourPart',
      desc: '',
      args: [],
    );
  }

  /// `Reject Responsibility`
  String get rejectResponsibility {
    return Intl.message(
      'Reject Responsibility',
      name: 'rejectResponsibility',
      desc: '',
      args: [],
    );
  }

  /// `You’re about to reject responsibility for the variance in this shift. To proceed, please explain why you believe you’re not accountable.`
  String get youAreAboutToRejectResponsibilityForVariance {
    return Intl.message(
      'You’re about to reject responsibility for the variance in this shift. To proceed, please explain why you believe you’re not accountable.',
      name: 'youAreAboutToRejectResponsibilityForVariance',
      desc: '',
      args: [],
    );
  }

  /// `Briefly explain why you’re not responsible for this variance (e.g. you weren’t on duty, incorrect figures, etc.).`
  String get brieflyExplainWhyYouAreNotResponsible {
    return Intl.message(
      'Briefly explain why you’re not responsible for this variance (e.g. you weren’t on duty, incorrect figures, etc.).',
      name: 'brieflyExplainWhyYouAreNotResponsible',
      desc: '',
      args: [],
    );
  }

  /// `You Rejected Responsibility`
  String get youRejectedResponsibility {
    return Intl.message(
      'You Rejected Responsibility',
      name: 'youRejectedResponsibility',
      desc: '',
      args: [],
    );
  }

  /// `You’ve rejected your involvement in the cause of this variance. The shift will now be escalated for further review.`
  String get YouRejectedYourInvolvementInTheVariance {
    return Intl.message(
      'You’ve rejected your involvement in the cause of this variance. The shift will now be escalated for further review.',
      name: 'YouRejectedYourInvolvementInTheVariance',
      desc: '',
      args: [],
    );
  }

  /// `You accepted your part in the variance on: {dateAndTime}`
  String youAcceptedYourPartAt(String dateAndTime) {
    return Intl.message(
      'You accepted your part in the variance on: $dateAndTime',
      name: 'youAcceptedYourPartAt',
      desc: 'Displays who is handling the product',
      args: [dateAndTime],
    );
  }

  /// `You rejected your part in the variance on: {dateAndTime}`
  String youRejectedYourPartAt(String dateAndTime) {
    return Intl.message(
      'You rejected your part in the variance on: $dateAndTime',
      name: 'youRejectedYourPartAt',
      desc: 'Displays who is handling the product',
      args: [dateAndTime],
    );
  }

  /// `You rejected this handover on: {dateAndTime}`
  String youRejectedThisHandover(String dateAndTime) {
    return Intl.message(
      'You rejected this handover on: $dateAndTime',
      name: 'youRejectedThisHandover',
      desc: 'Displays who is handling the product',
      args: [dateAndTime],
    );
  }

  /// `You Accepted this handover on: {dateAndTime}`
  String youAcceptedThisHandover(String dateAndTime) {
    return Intl.message(
      'You Accepted this handover on: $dateAndTime',
      name: 'youAcceptedThisHandover',
      desc: 'Displays who is handling the product',
      args: [dateAndTime],
    );
  }

  /// `Changed your mind?`
  String get changeYourMind {
    return Intl.message(
      'Changed your mind?',
      name: 'changeYourMind',
      desc: '',
      args: [],
    );
  }

  /// `You previously rejected this variance. If you now accept responsibility, you can still approve your part below.`
  String get youPreviouslyRejectedThisVariance {
    return Intl.message(
      'You previously rejected this variance. If you now accept responsibility, you can still approve your part below.',
      name: 'youPreviouslyRejectedThisVariance',
      desc: '',
      args: [],
    );
  }

  /// `Reassigned to you while the shift was active.`
  String get reassignedToYouWhileShiftIsActive {
    return Intl.message(
      'Reassigned to you while the shift was active.',
      name: 'reassignedToYouWhileShiftIsActive',
      desc: '',
      args: [],
    );
  }

  /// `Review Shift Reassignment`
  String get reviewShitReassignment {
    return Intl.message(
      'Review Shift Reassignment',
      name: 'reviewShitReassignment',
      desc: '',
      args: [],
    );
  }

  /// `You’ve been reassigned to this shift.Review the details, including any handover (opening balance, notes, sales).`
  String get youReassignedToThisShift {
    return Intl.message(
      'You’ve been reassigned to this shift.Review the details, including any handover (opening balance, notes, sales).',
      name: 'youReassignedToThisShift',
      desc: '',
      args: [],
    );
  }

  /// `The shift is scheduled for today and may already be active.`
  String get theShiftIsScheduledForTodayAndMayAlreadyBeActive {
    return Intl.message(
      'The shift is scheduled for today and may already be active.',
      name: 'theShiftIsScheduledForTodayAndMayAlreadyBeActive',
      desc: '',
      args: [],
    );
  }

  /// `You’ve accepted the reassigned shift.All records and responsibilities have now been transferred to you, your activity will be tracked from this point forward.`
  String get youAcceptedTheReassignedShift {
    return Intl.message(
      'You’ve accepted the reassigned shift.All records and responsibilities have now been transferred to you, your activity will be tracked from this point forward.',
      name: 'youAcceptedTheReassignedShift',
      desc: '',
      args: [],
    );
  }

  /// `Reassignment Reason`
  String get reassignmentReason {
    return Intl.message(
      'Reassignment Reason',
      name: 'reassignmentReason',
      desc: '',
      args: [],
    );
  }

  /// `You Can't Take This Shift`
  String get uCantTakeThisShift {
    return Intl.message(
      'You Can\'t Take This Shift',
      name: 'uCantTakeThisShift',
      desc: '',
      args: [],
    );
  }

  /// `It's been reassigned by {name}`
  String itIsBeenReassignedByTheBranchManager(String name) {
    return Intl.message(
      'It\'s been reassigned by $name',
      name: 'itIsBeenReassignedByTheBranchManager',
      desc: 'Displays who is handling the product',
      args: [name],
    );
  }

  /// `You can’t continue this shift because it’s been reassigned to another by {name}`
  String uCantContinueThisShiftBecauseItHasBeenReassignedToAnother(
    String name,
  ) {
    return Intl.message(
      'You can’t continue this shift because it’s been reassigned to another by $name',
      name: 'uCantContinueThisShiftBecauseItHasBeenReassignedToAnother',
      desc: 'Displays who is handling the product',
      args: [name],
    );
  }

  /// `No variances`
  String get noVariances {
    return Intl.message(
      'No variances',
      name: 'noVariances',
      desc: '',
      args: [],
    );
  }

  /// `No handovers`
  String get noHandovers {
    return Intl.message(
      'No handovers',
      name: 'noHandovers',
      desc: '',
      args: [],
    );
  }

  /// `You submitted this expense for review and approval.`
  String get expenseSubmittedForApproval {
    return Intl.message(
      'You submitted this expense for review and approval.',
      name: 'expenseSubmittedForApproval',
      desc: '',
      args: [],
    );
  }

  /// `You modified this expense after submitting it for approval. The updated version has been re-submitted to your manager for review.`
  String get expenseModifiedDesc {
    return Intl.message(
      'You modified this expense after submitting it for approval. The updated version has been re-submitted to your manager for review.',
      name: 'expenseModifiedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Resubmitted`
  String get resubmitted {
    return Intl.message('Resubmitted', name: 'resubmitted', desc: '', args: []);
  }

  /// `You resubmitted this expense after it was rejected. The updated version has been re-submitted to your manager for review.`
  String get expenseResubmittedDesc {
    return Intl.message(
      'You resubmitted this expense after it was rejected. The updated version has been re-submitted to your manager for review.',
      name: 'expenseResubmittedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Viewed by Brand Manager`
  String get viewedByBrandManager {
    return Intl.message(
      'Viewed by Brand Manager',
      name: 'viewedByBrandManager',
      desc: '',
      args: [],
    );
  }

  /// `Your manager has viewed this expense and is currently reviewing it. You will receive a notification once they take action on it.`
  String get expenseViewedByManager {
    return Intl.message(
      'Your manager has viewed this expense and is currently reviewing it. You will receive a notification once they take action on it.',
      name: 'expenseViewedByManager',
      desc: '',
      args: [],
    );
  }

  /// `Expense was reviewed and officially approved.`
  String get expenseApprovedDesc {
    return Intl.message(
      'Expense was reviewed and officially approved.',
      name: 'expenseApprovedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Expense was rejected. You’ll find the reason attached in “Details”.`
  String get expenseRejectedDesc {
    return Intl.message(
      'Expense was rejected. You’ll find the reason attached in “Details”.',
      name: 'expenseRejectedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Manager's {name} (you) submitted this daily inventory for review and approval.`
  String managerSubmittedDailyInventory(Object name) {
    return Intl.message(
      'Manager\'s $name (you) submitted this daily inventory for review and approval.',
      name: 'managerSubmittedDailyInventory',
      desc: '',
      args: [name],
    );
  }

  /// `You’ve assigned {name} to handle this daily count. They’ll receive the task and log the quantity.`
  String assignedToHandleDailyCount(Object name) {
    return Intl.message(
      'You’ve assigned $name to handle this daily count. They’ll receive the task and log the quantity.',
      name: 'assignedToHandleDailyCount',
      desc: '',
      args: [name],
    );
  }

  /// `Restock`
  String get restock {
    return Intl.message('Restock', name: 'restock', desc: '', args: []);
  }

  /// `Replacement`
  String get replacement {
    return Intl.message('Replacement', name: 'replacement', desc: '', args: []);
  }

  /// `Item replaced`
  String get itemReplaced {
    return Intl.message(
      'Item replaced',
      name: 'itemReplaced',
      desc: '',
      args: [],
    );
  }

  /// `Asset Management`
  String get assetManagement {
    return Intl.message(
      'Asset Management',
      name: 'assetManagement',
      desc: '',
      args: [],
    );
  }

  /// `Nakheel Main Branch North`
  String get nakheelMainBranchNorth {
    return Intl.message(
      'Nakheel Main Branch North',
      name: 'nakheelMainBranchNorth',
      desc: '',
      args: [],
    );
  }

  /// `Ongoing Operations`
  String get ongoingOperations {
    return Intl.message(
      'Ongoing Operations',
      name: 'ongoingOperations',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Count`
  String get monthlyCount {
    return Intl.message(
      'Monthly Count',
      name: 'monthlyCount',
      desc: '',
      args: [],
    );
  }

  /// `Handover Session`
  String get handoverSession {
    return Intl.message(
      'Handover Session',
      name: 'handoverSession',
      desc: '',
      args: [],
    );
  }

  /// `Join Handover Session`
  String get joinHandoverSession {
    return Intl.message(
      'Join Handover Session',
      name: 'joinHandoverSession',
      desc: '',
      args: [],
    );
  }

  /// `Just a few actions needed to complete the handover.`
  String get joinHandoverSessionDesc {
    return Intl.message(
      'Just a few actions needed to complete the handover.',
      name: 'joinHandoverSessionDesc',
      desc: '',
      args: [],
    );
  }

  /// `Session Code`
  String get sessionCode {
    return Intl.message(
      'Session Code',
      name: 'sessionCode',
      desc: '',
      args: [],
    );
  }

  /// `Session Info`
  String get sessionInfo {
    return Intl.message(
      'Session Info',
      name: 'sessionInfo',
      desc: '',
      args: [],
    );
  }

  /// `Handover By`
  String get handoverBy {
    return Intl.message('Handover By', name: 'handoverBy', desc: '', args: []);
  }

  /// `Zones`
  String get zones {
    return Intl.message('Zones', name: 'zones', desc: '', args: []);
  }

  /// `Zones & Assets`
  String get zonesAndAssets {
    return Intl.message(
      'Zones & Assets',
      name: 'zonesAndAssets',
      desc: '',
      args: [],
    );
  }

  /// `Asset List for Review`
  String get assetListForReview {
    return Intl.message(
      'Asset List for Review',
      name: 'assetListForReview',
      desc: '',
      args: [],
    );
  }

  /// `Recipient Confirmations`
  String get recipientConfirmations {
    return Intl.message(
      'Recipient Confirmations',
      name: 'recipientConfirmations',
      desc: '',
      args: [],
    );
  }

  /// `I Reviewed the Asset List`
  String get iReviewedAssetList {
    return Intl.message(
      'I Reviewed the Asset List',
      name: 'iReviewedAssetList',
      desc: '',
      args: [],
    );
  }

  /// `Join Session`
  String get joinSession {
    return Intl.message(
      'Join Session',
      name: 'joinSession',
      desc: '',
      args: [],
    );
  }

  /// `Handover Joined`
  String get handoverJoined {
    return Intl.message(
      'Handover Joined',
      name: 'handoverJoined',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully joined the handover session.`
  String get handoverJoinedDesc {
    return Intl.message(
      'You have successfully joined the handover session.',
      name: 'handoverJoinedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Active Handover Session`
  String get activeHandoverSession {
    return Intl.message(
      'Active Handover Session',
      name: 'activeHandoverSession',
      desc: '',
      args: [],
    );
  }

  /// `From {from} → To {to}`
  String activeHandoverFromTo(String from, String to) {
    return Intl.message(
      'From $from → To $to',
      name: 'activeHandoverFromTo',
      desc: '',
      args: [from, to],
    );
  }

  /// `Zone Details`
  String get zoneDetails {
    return Intl.message(
      'Zone Details',
      name: 'zoneDetails',
      desc: '',
      args: [],
    );
  }

  /// `Review all {count} zones and complete any required actions before continuing.`
  String reviewZonesDesc(int count) {
    return Intl.message(
      'Review all $count zones and complete any required actions before continuing.',
      name: 'reviewZonesDesc',
      desc: '',
      args: [count],
    );
  }

  /// `Approve Zone`
  String get approveZone {
    return Intl.message(
      'Approve Zone',
      name: 'approveZone',
      desc: '',
      args: [],
    );
  }

  /// `Edit Linked Assets`
  String get editLinkedAssets {
    return Intl.message(
      'Edit Linked Assets',
      name: 'editLinkedAssets',
      desc: '',
      args: [],
    );
  }

  /// `Next: Review Assets`
  String get nextReviewAssets {
    return Intl.message(
      'Next: Review Assets',
      name: 'nextReviewAssets',
      desc: '',
      args: [],
    );
  }

  /// `This zone is approved`
  String get zoneIsApproved {
    return Intl.message(
      'This zone is approved',
      name: 'zoneIsApproved',
      desc: '',
      args: [],
    );
  }

  /// `Progress`
  String get progress {
    return Intl.message('Progress', name: 'progress', desc: '', args: []);
  }

  /// `Assets Overview`
  String get assetsOverview {
    return Intl.message(
      'Assets Overview',
      name: 'assetsOverview',
      desc: '',
      args: [],
    );
  }

  /// `Maintenance`
  String get maintenance {
    return Intl.message('Maintenance', name: 'maintenance', desc: '', args: []);
  }

  /// `Problem`
  String get problem {
    return Intl.message('Problem', name: 'problem', desc: '', args: []);
  }

  /// `Search Results`
  String get searchResults {
    return Intl.message(
      'Search Results',
      name: 'searchResults',
      desc: '',
      args: [],
    );
  }

  /// `Result Summary`
  String get resultSummary {
    return Intl.message(
      'Result Summary',
      name: 'resultSummary',
      desc: '',
      args: [],
    );
  }

  /// `Match`
  String get match {
    return Intl.message('Match', name: 'match', desc: '', args: []);
  }

  /// `of {total}`
  String ofTotal(int total) {
    return Intl.message('of $total', name: 'ofTotal', desc: '', args: [total]);
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `New Asset`
  String get newAsset {
    return Intl.message('New Asset', name: 'newAsset', desc: '', args: []);
  }

  /// `Transfers`
  String get transfers {
    return Intl.message('Transfers', name: 'transfers', desc: '', args: []);
  }

  /// `Count`
  String get count {
    return Intl.message('Count', name: 'count', desc: '', args: []);
  }

  /// `Modify`
  String get modify {
    return Intl.message('Modify', name: 'modify', desc: '', args: []);
  }

  /// `Quick Action`
  String get quickAction {
    return Intl.message(
      'Quick Action',
      name: 'quickAction',
      desc: '',
      args: [],
    );
  }

  /// `Receive Assets from Finance`
  String get receiveAssetsFromFinance {
    return Intl.message(
      'Receive Assets from Finance',
      name: 'receiveAssetsFromFinance',
      desc: '',
      args: [],
    );
  }

  /// `Receive Conveyor from Central`
  String get receiveConveyorFromCentral {
    return Intl.message(
      'Receive Conveyor from Central',
      name: 'receiveConveyorFromCentral',
      desc: '',
      args: [],
    );
  }

  /// `Approved Transfer to East`
  String get approvedTransferToEast {
    return Intl.message(
      'Approved Transfer to East',
      name: 'approvedTransferToEast',
      desc: '',
      args: [],
    );
  }

  /// `Approved Disposal`
  String get approvedDisposal {
    return Intl.message(
      'Approved Disposal',
      name: 'approvedDisposal',
      desc: '',
      args: [],
    );
  }

  /// `Urgent Actions`
  String get urgentActions {
    return Intl.message(
      'Urgent Actions',
      name: 'urgentActions',
      desc: '',
      args: [],
    );
  }

  /// `Smart Asset Search`
  String get smartAssetSearch {
    return Intl.message(
      'Smart Asset Search',
      name: 'smartAssetSearch',
      desc: '',
      args: [],
    );
  }

  /// `Assets in Your Branch`
  String get assetsInYourBranch {
    return Intl.message(
      'Assets in Your Branch',
      name: 'assetsInYourBranch',
      desc: '',
      args: [],
    );
  }

  /// `Filter Search Result By:`
  String get filterSearchResultBy {
    return Intl.message(
      'Filter Search Result By:',
      name: 'filterSearchResultBy',
      desc: '',
      args: [],
    );
  }

  /// `Zone`
  String get zone {
    return Intl.message('Zone', name: 'zone', desc: '', args: []);
  }

  /// `Responsible`
  String get responsible {
    return Intl.message('Responsible', name: 'responsible', desc: '', args: []);
  }

  /// `Search by Name, ID, or Description...`
  String get searchByNameIdOrDescription {
    return Intl.message(
      'Search by Name, ID, or Description...',
      name: 'searchByNameIdOrDescription',
      desc: '',
      args: [],
    );
  }

  /// `Quick Search by Update`
  String get quickSearchByUpdate {
    return Intl.message(
      'Quick Search by Update',
      name: 'quickSearchByUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Updated Today`
  String get updatedToday {
    return Intl.message(
      'Updated Today',
      name: 'updatedToday',
      desc: '',
      args: [],
    );
  }

  /// `Updated Yesterday`
  String get updatedYesterday {
    return Intl.message(
      'Updated Yesterday',
      name: 'updatedYesterday',
      desc: '',
      args: [],
    );
  }

  /// `Not Updated 1 Month`
  String get notUpdated1Month {
    return Intl.message(
      'Not Updated 1 Month',
      name: 'notUpdated1Month',
      desc: '',
      args: [],
    );
  }

  /// `Not Updated 2 Months`
  String get notUpdated2Months {
    return Intl.message(
      'Not Updated 2 Months',
      name: 'notUpdated2Months',
      desc: '',
      args: [],
    );
  }

  /// `In My Custody`
  String get inMyCustody {
    return Intl.message(
      'In My Custody',
      name: 'inMyCustody',
      desc: '',
      args: [],
    );
  }

  /// `Under Maintenance`
  String get underMaintenance {
    return Intl.message(
      'Under Maintenance',
      name: 'underMaintenance',
      desc: '',
      args: [],
    );
  }

  /// `Last 3 Searches`
  String get last3Searches {
    return Intl.message(
      'Last 3 Searches',
      name: 'last3Searches',
      desc: '',
      args: [],
    );
  }

  /// `Upload Image`
  String get uploadImage {
    return Intl.message(
      'Upload Image',
      name: 'uploadImage',
      desc: '',
      args: [],
    );
  }

  /// `Start Search`
  String get startSearch {
    return Intl.message(
      'Start Search',
      name: 'startSearch',
      desc: '',
      args: [],
    );
  }

  /// `Search by Name`
  String get searchByName {
    return Intl.message(
      'Search by Name',
      name: 'searchByName',
      desc: '',
      args: [],
    );
  }

  /// `Search for employees who are responsible for the Asset you are looking for`
  String get searchForEmployeesDesc {
    return Intl.message(
      'Search for employees who are responsible for the Asset you are looking for',
      name: 'searchForEmployeesDesc',
      desc: '',
      args: [],
    );
  }

  /// `Employee’s Full Name`
  String get employeeFullName {
    return Intl.message(
      'Employee’s Full Name',
      name: 'employeeFullName',
      desc: '',
      args: [],
    );
  }

  /// `Asset Type`
  String get assetTypeTitle {
    return Intl.message(
      'Asset Type',
      name: 'assetTypeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Search for asset based on categories`
  String get searchForAssetCategoriesDesc {
    return Intl.message(
      'Search for asset based on categories',
      name: 'searchForAssetCategoriesDesc',
      desc: '',
      args: [],
    );
  }

  /// `Search for categories by name`
  String get searchCategoriesByName {
    return Intl.message(
      'Search for categories by name',
      name: 'searchCategoriesByName',
      desc: '',
      args: [],
    );
  }

  /// `Office Equipments`
  String get officeEquipments {
    return Intl.message(
      'Office Equipments',
      name: 'officeEquipments',
      desc: '',
      args: [],
    );
  }

  /// `Kitchen Equipments`
  String get kitchenEquipments {
    return Intl.message(
      'Kitchen Equipments',
      name: 'kitchenEquipments',
      desc: '',
      args: [],
    );
  }

  /// `Zone list`
  String get zoneListTitle {
    return Intl.message('Zone list', name: 'zoneListTitle', desc: '', args: []);
  }

  /// `Search for asset in the following zone:`
  String get searchForAssetZoneDesc {
    return Intl.message(
      'Search for asset in the following zone:',
      name: 'searchForAssetZoneDesc',
      desc: '',
      args: [],
    );
  }

  /// `Search for zone by name`
  String get searchZoneByName {
    return Intl.message(
      'Search for zone by name',
      name: 'searchZoneByName',
      desc: '',
      args: [],
    );
  }

  /// `Zone Name`
  String get zoneName {
    return Intl.message('Zone Name', name: 'zoneName', desc: '', args: []);
  }

  /// `Type of Asset`
  String get typeOfAsset {
    return Intl.message(
      'Type of Asset',
      name: 'typeOfAsset',
      desc: '',
      args: [],
    );
  }

  /// `Preview`
  String get preview {
    return Intl.message('Preview', name: 'preview', desc: '', args: []);
  }

  /// `Action`
  String get actionBtn {
    return Intl.message('Action', name: 'actionBtn', desc: '', args: []);
  }

  /// `Select All`
  String get selectAll {
    return Intl.message('Select All', name: 'selectAll', desc: '', args: []);
  }

  /// `Age`
  String get age {
    return Intl.message('Age', name: 'age', desc: '', args: []);
  }

  /// `Assigned To`
  String get assignedTo {
    return Intl.message('Assigned To', name: 'assignedTo', desc: '', args: []);
  }

  /// `Assets`
  String get assets {
    return Intl.message('Assets', name: 'assets', desc: '', args: []);
  }

  /// `Bulk Actions`
  String get bulkActions {
    return Intl.message(
      'Bulk Actions',
      name: 'bulkActions',
      desc: '',
      args: [],
    );
  }

  /// `All {count} Asset’s have been selected, how would you like to proceed?`
  String allAssetsSelectedProceed(String count) {
    return Intl.message(
      'All $count Asset’s have been selected, how would you like to proceed?',
      name: 'allAssetsSelectedProceed',
      desc: '',
      args: [count],
    );
  }

  /// `Transfer All {count} Assets`
  String transferAllAssets(String count) {
    return Intl.message(
      'Transfer All $count Assets',
      name: 'transferAllAssets',
      desc: '',
      args: [count],
    );
  }

  /// `Modify asset status`
  String get modifyAssetStatus {
    return Intl.message(
      'Modify asset status',
      name: 'modifyAssetStatus',
      desc: '',
      args: [],
    );
  }

  /// `Assets Disposal request`
  String get assetsDisposalRequest {
    return Intl.message(
      'Assets Disposal request',
      name: 'assetsDisposalRequest',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `Needs Attention`
  String get needsAttention {
    return Intl.message(
      'Needs Attention',
      name: 'needsAttention',
      desc: '',
      args: [],
    );
  }

  /// `Custody`
  String get custody {
    return Intl.message('Custody', name: 'custody', desc: '', args: []);
  }

  /// `Value`
  String get valueText {
    return Intl.message('Value', name: 'valueText', desc: '', args: []);
  }

  /// `e.g. Minor issues, requires inspection.`
  String get exampleNoteApprovalRequestOwner {
    return Intl.message(
      'e.g. Minor issues, requires inspection.',
      name: 'exampleNoteApprovalRequestOwner',
      desc: '',
      args: [],
    );
  }

  /// `Your asset status update has been sent to the responsible party for review and action. You will receive a notification once they respond.`
  String get yourAssetStatusUpdateHasBeenSent {
    return Intl.message(
      'Your asset status update has been sent to the responsible party for review and action. You will receive a notification once they respond.',
      name: 'yourAssetStatusUpdateHasBeenSent',
      desc: '',
      args: [],
    );
  }

  /// `Initial Audit`
  String get initialAudit {
    return Intl.message(
      'Initial Audit',
      name: 'initialAudit',
      desc: '',
      args: [],
    );
  }

  /// `Add Zones and count assets as a New Branch`
  String get addZonesAndCountAssetsAsNewBranch {
    return Intl.message(
      'Add Zones and count assets as a New Branch',
      name: 'addZonesAndCountAssetsAsNewBranch',
      desc: '',
      args: [],
    );
  }

  /// `Zone Setup`
  String get zoneSetup {
    return Intl.message('Zone Setup', name: 'zoneSetup', desc: '', args: []);
  }

  /// `You currently have {count} zones added`
  String youCurrentlyHaveNZonesAdded(Object count) {
    return Intl.message(
      'You currently have $count zones added',
      name: 'youCurrentlyHaveNZonesAdded',
      desc: '',
      args: [count],
    );
  }

  /// `Kitchen`
  String get kitchen {
    return Intl.message('Kitchen', name: 'kitchen', desc: '', args: []);
  }

  /// `Dining`
  String get dining {
    return Intl.message('Dining', name: 'dining', desc: '', args: []);
  }

  /// `Store`
  String get store {
    return Intl.message('Store', name: 'store', desc: '', args: []);
  }

  /// `{count} Assets`
  String assetsCount(Object count) {
    return Intl.message(
      '$count Assets',
      name: 'assetsCount',
      desc: '',
      args: [count],
    );
  }

  /// `Add New Zone`
  String get addNewZone {
    return Intl.message('Add New Zone', name: 'addNewZone', desc: '', args: []);
  }

  /// `Count Assets`
  String get countAssets {
    return Intl.message(
      'Count Assets',
      name: 'countAssets',
      desc: '',
      args: [],
    );
  }

  /// `Click on "Add" button to get started`
  String get clickOnAddButtonToGetStarted {
    return Intl.message(
      'Click on "Add" button to get started',
      name: 'clickOnAddButtonToGetStarted',
      desc: '',
      args: [],
    );
  }

  /// `Total Number of Asset`
  String get totalNumberOfAsset {
    return Intl.message(
      'Total Number of Asset',
      name: 'totalNumberOfAsset',
      desc: '',
      args: [],
    );
  }

  /// `New Photo`
  String get newPhoto {
    return Intl.message('New Photo', name: 'newPhoto', desc: '', args: []);
  }

  /// `Add Asset #{number}`
  String addAssetNumber(Object number) {
    return Intl.message(
      'Add Asset #$number',
      name: 'addAssetNumber',
      desc: '',
      args: [number],
    );
  }

  /// `Count Progress:`
  String get countProgress {
    return Intl.message(
      'Count Progress:',
      name: 'countProgress',
      desc: '',
      args: [],
    );
  }

  /// `Recorded`
  String get recorded {
    return Intl.message('Recorded', name: 'recorded', desc: '', args: []);
  }

  /// `Save & Add`
  String get saveAndAdd {
    return Intl.message('Save & Add', name: 'saveAndAdd', desc: '', args: []);
  }

  /// `Complete & Send`
  String get completeAndSend {
    return Intl.message(
      'Complete & Send',
      name: 'completeAndSend',
      desc: '',
      args: [],
    );
  }

  /// `Receive Assets`
  String get fixedAssetsReceiveAssetsTitle {
    return Intl.message(
      'Receive Assets',
      name: 'fixedAssetsReceiveAssetsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Review received fixed assets and their status details.`
  String get fixedAssetsReceiveAssetsSubtitle {
    return Intl.message(
      'Review received fixed assets and their status details.',
      name: 'fixedAssetsReceiveAssetsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Assigned Zone`
  String get fixedAssetsReceiveAssetsAssignedZone {
    return Intl.message(
      'Assigned Zone',
      name: 'fixedAssetsReceiveAssetsAssignedZone',
      desc: '',
      args: [],
    );
  }

  /// `Asset Type`
  String get fixedAssetsReceiveAssetsAssetType {
    return Intl.message(
      'Asset Type',
      name: 'fixedAssetsReceiveAssetsAssetType',
      desc: '',
      args: [],
    );
  }

  /// `New ID`
  String get fixedAssetsReceiveAssetsNewId {
    return Intl.message(
      'New ID',
      name: 'fixedAssetsReceiveAssetsNewId',
      desc: '',
      args: [],
    );
  }

  /// `No Received Assets`
  String get fixedAssetsReceiveAssetsEmptyTitle {
    return Intl.message(
      'No Received Assets',
      name: 'fixedAssetsReceiveAssetsEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `No received assets were found. Try updating filters or check again later.`
  String get fixedAssetsReceiveAssetsEmptyDesc {
    return Intl.message(
      'No received assets were found. Try updating filters or check again later.',
      name: 'fixedAssetsReceiveAssetsEmptyDesc',
      desc: '',
      args: [],
    );
  }

  /// `Inventory Number`
  String get inventoryNumber {
    return Intl.message(
      'Inventory Number',
      name: 'inventoryNumber',
      desc: '',
      args: [],
    );
  }

  /// `Staff`
  String get staff {
    return Intl.message('Staff', name: 'staff', desc: '', args: []);
  }

  /// `No Tasks Found`
  String get noTasksFound {
    return Intl.message(
      'No Tasks Found',
      name: 'noTasksFound',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Receive Assets`
  String get receiveAssets {
    return Intl.message(
      'Receive Assets',
      name: 'receiveAssets',
      desc: '',
      args: [],
    );
  }

  /// `Assigned Zone`
  String get assignedZone {
    return Intl.message(
      'Assigned Zone',
      name: 'assignedZone',
      desc: '',
      args: [],
    );
  }

  /// `Asset Type`
  String get assetType {
    return Intl.message('Asset Type', name: 'assetType', desc: '', args: []);
  }

  /// `Receipt Status`
  String get receiptStatus {
    return Intl.message(
      'Receipt Status',
      name: 'receiptStatus',
      desc: '',
      args: [],
    );
  }

  /// `Receipt Photo`
  String get receiptPhoto {
    return Intl.message(
      'Receipt Photo',
      name: 'receiptPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Assets Count`
  String get assetsCount_a {
    return Intl.message(
      'Assets Count',
      name: 'assetsCount_a',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Receipt`
  String get confirmReceipt {
    return Intl.message(
      'Confirm Receipt',
      name: 'confirmReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Transfers & Disposal`
  String get transfersAndDisposal {
    return Intl.message(
      'Transfers & Disposal',
      name: 'transfersAndDisposal',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Asset`
  String get transferAsset {
    return Intl.message(
      'Transfer Asset',
      name: 'transferAsset',
      desc: '',
      args: [],
    );
  }

  /// `Asset Confirmed`
  String get assetConfirmed {
    return Intl.message(
      'Asset Confirmed',
      name: 'assetConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `The asset has been accepted and added to your branch’s records. You can now view its details, including assigned zone and asset type, in the Assets Overview.`
  String get assetConfirmedDesc {
    return Intl.message(
      'The asset has been accepted and added to your branch’s records. You can now view its details, including assigned zone and asset type, in the Assets Overview.',
      name: 'assetConfirmedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Modification`
  String get modification {
    return Intl.message(
      'Modification',
      name: 'modification',
      desc: '',
      args: [],
    );
  }

  /// `Disposals`
  String get disposals {
    return Intl.message('Disposals', name: 'disposals', desc: '', args: []);
  }

  /// `View Details`
  String get viewDetails {
    return Intl.message(
      'View Details',
      name: 'viewDetails',
      desc: '',
      args: [],
    );
  }

  /// `Outgoing Transfer`
  String get outgoingTransfer {
    return Intl.message(
      'Outgoing Transfer',
      name: 'outgoingTransfer',
      desc: '',
      args: [],
    );
  }

  /// `From Central:`
  String get fromCentral {
    return Intl.message(
      'From Central:',
      name: 'fromCentral',
      desc: '',
      args: [],
    );
  }

  /// `From Finance:`
  String get fromFinance {
    return Intl.message(
      'From Finance:',
      name: 'fromFinance',
      desc: '',
      args: [],
    );
  }

  /// `Disposal`
  String get disposal {
    return Intl.message('Disposal', name: 'disposal', desc: '', args: []);
  }

  /// `Excellent Condition`
  String get excellentCondition {
    return Intl.message(
      'Excellent Condition',
      name: 'excellentCondition',
      desc: '',
      args: [],
    );
  }

  /// `In Maintenance`
  String get inMaintenance {
    return Intl.message(
      'In Maintenance',
      name: 'inMaintenance',
      desc: '',
      args: [],
    );
  }

  /// `You submitted this request`
  String get youSubmittedThisRequest {
    return Intl.message(
      'You submitted this request',
      name: 'youSubmittedThisRequest',
      desc: '',
      args: [],
    );
  }

  /// `You received this request`
  String get youReceivedThisRequest {
    return Intl.message(
      'You received this request',
      name: 'youReceivedThisRequest',
      desc: '',
      args: [],
    );
  }

  /// `From Branch`
  String get fromBranch {
    return Intl.message('From Branch', name: 'fromBranch', desc: '', args: []);
  }

  /// `Initial Check`
  String get initialCheck {
    return Intl.message(
      'Initial Check',
      name: 'initialCheck',
      desc: '',
      args: [],
    );
  }

  /// `Cleaning`
  String get cleaning {
    return Intl.message('Cleaning', name: 'cleaning', desc: '', args: []);
  }

  /// `Your asset status update has been sent for approval.`
  String get modificationSubmittedDesc {
    return Intl.message(
      'Your asset status update has been sent for approval.',
      name: 'modificationSubmittedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Your asset status update has been approved.`
  String get modificationApprovedDesc {
    return Intl.message(
      'Your asset status update has been approved.',
      name: 'modificationApprovedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Update image and location of selected asset:`
  String get updateImageAndLocation {
    return Intl.message(
      'Update image and location of selected asset:',
      name: 'updateImageAndLocation',
      desc: '',
      args: [],
    );
  }

  /// `New Location`
  String get newLocation {
    return Intl.message(
      'New Location',
      name: 'newLocation',
      desc: '',
      args: [],
    );
  }

  /// `Update Image`
  String get updateImage {
    return Intl.message(
      'Update Image',
      name: 'updateImage',
      desc: '',
      args: [],
    );
  }

  /// `Current Location`
  String get currentLocation {
    return Intl.message(
      'Current Location',
      name: 'currentLocation',
      desc: '',
      args: [],
    );
  }

  /// `Active Locations`
  String get activeLocations {
    return Intl.message(
      'Active Locations',
      name: 'activeLocations',
      desc: '',
      args: [],
    );
  }

  /// `Transfer/Dispose Asset`
  String get transferDisposeAsset {
    return Intl.message(
      'Transfer/Dispose Asset',
      name: 'transferDisposeAsset',
      desc: '',
      args: [],
    );
  }

  /// `Will be sent to management for approval`
  String get transferAssetDesc {
    return Intl.message(
      'Will be sent to management for approval',
      name: 'transferAssetDesc',
      desc: '',
      args: [],
    );
  }

  /// `Request Type`
  String get requestType {
    return Intl.message(
      'Request Type',
      name: 'requestType',
      desc: '',
      args: [],
    );
  }

  /// `Transfer to Branch`
  String get transferToBranch {
    return Intl.message(
      'Transfer to Branch',
      name: 'transferToBranch',
      desc: '',
      args: [],
    );
  }

  /// `Transfer To Branch Request Details`
  String get transferToBranchRequestDetails {
    return Intl.message(
      'Transfer To Branch Request Details',
      name: 'transferToBranchRequestDetails',
      desc: '',
      args: [],
    );
  }

  /// `Request Details:`
  String get requestDetailsTitle {
    return Intl.message(
      'Request Details:',
      name: 'requestDetailsTitle',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get to {
    return Intl.message('To', name: 'to', desc: '', args: []);
  }

  /// `Transfer ID`
  String get transferId {
    return Intl.message('Transfer ID', name: 'transferId', desc: '', args: []);
  }

  /// `Asset List ({count}):`
  String assetListCount(int count) {
    return Intl.message(
      'Asset List ($count):',
      name: 'assetListCount',
      desc: 'Asset list count',
      args: [count],
    );
  }

  /// `Record`
  String get record {
    return Intl.message('Record', name: 'record', desc: '', args: []);
  }

  /// `Attachment ({count})`
  String attachmentCount(int count) {
    return Intl.message(
      'Attachment ($count)',
      name: 'attachmentCount',
      desc: 'Attachment count',
      args: [count],
    );
  }

  /// `Recipient Branch`
  String get recipientBranch {
    return Intl.message(
      'Recipient Branch',
      name: 'recipientBranch',
      desc: '',
      args: [],
    );
  }

  /// `Final Disposal`
  String get finalDisposal {
    return Intl.message(
      'Final Disposal',
      name: 'finalDisposal',
      desc: '',
      args: [],
    );
  }

  /// `External Transfer`
  String get externalTransfer {
    return Intl.message(
      'External Transfer',
      name: 'externalTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Choose Assets`
  String get chooseAssets {
    return Intl.message(
      'Choose Assets',
      name: 'chooseAssets',
      desc: '',
      args: [],
    );
  }

  /// `Click button below to search for assets for this request`
  String get clickButtonBelowToSearchForAssetsForThisRequest {
    return Intl.message(
      'Click button below to search for assets for this request',
      name: 'clickButtonBelowToSearchForAssetsForThisRequest',
      desc: '',
      args: [],
    );
  }

  /// `Acknowledgments`
  String get acknowledgments {
    return Intl.message(
      'Acknowledgments',
      name: 'acknowledgments',
      desc: '',
      args: [],
    );
  }

  /// `I Acknowledge Transfer Policy`
  String get iAcknowledgeTransferPolicy {
    return Intl.message(
      'I Acknowledge Transfer Policy',
      name: 'iAcknowledgeTransferPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Coordinated with Receiving Branch`
  String get coordinatedWithReceivingBranch {
    return Intl.message(
      'Coordinated with Receiving Branch',
      name: 'coordinatedWithReceivingBranch',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Details`
  String get transferDetails {
    return Intl.message(
      'Transfer Details',
      name: 'transferDetails',
      desc: '',
      args: [],
    );
  }

  /// `Skip confirmation, already agreed with receiver`
  String get skipConfirmationAlreadyAgreedWithReceiver {
    return Intl.message(
      'Skip confirmation, already agreed with receiver',
      name: 'skipConfirmationAlreadyAgreedWithReceiver',
      desc: '',
      args: [],
    );
  }

  /// `Submit Now`
  String get submitNow {
    return Intl.message('Submit Now', name: 'submitNow', desc: '', args: []);
  }

  /// `Choose Store Branch`
  String get chooseStoreBranch {
    return Intl.message(
      'Choose Store Branch',
      name: 'chooseStoreBranch',
      desc: '',
      args: [],
    );
  }

  /// `Proposed disposal date`
  String get proposedDisposalDate {
    return Intl.message(
      'Proposed disposal date',
      name: 'proposedDisposalDate',
      desc: '',
      args: [],
    );
  }

  /// `Proposed disposal time`
  String get proposedDisposalTime {
    return Intl.message(
      'Proposed disposal time',
      name: 'proposedDisposalTime',
      desc: '',
      args: [],
    );
  }

  /// `Disposal method`
  String get disposalMethod {
    return Intl.message(
      'Disposal method',
      name: 'disposalMethod',
      desc: '',
      args: [],
    );
  }

  /// `Approval from store owner/brand manager is required`
  String get approvalFromManagerRequired {
    return Intl.message(
      'Approval from store owner/brand manager is required',
      name: 'approvalFromManagerRequired',
      desc: '',
      args: [],
    );
  }

  /// `Branch List`
  String get branchList {
    return Intl.message('Branch List', name: 'branchList', desc: '', args: []);
  }

  /// `Who is the recipient branch for this transfer request?`
  String get whoIsTheRecipientBranchForThisTransferRequest {
    return Intl.message(
      'Who is the recipient branch for this transfer request?',
      name: 'whoIsTheRecipientBranchForThisTransferRequest',
      desc: '',
      args: [],
    );
  }

  /// `Search for branch by first or last name`
  String get searchForBranchByFirstOrLastName {
    return Intl.message(
      'Search for branch by first or last name',
      name: 'searchForBranchByFirstOrLastName',
      desc: '',
      args: [],
    );
  }

  /// `Choose Asset`
  String get chooseAsset {
    return Intl.message(
      'Choose Asset',
      name: 'chooseAsset',
      desc: '',
      args: [],
    );
  }

  /// `All Assets`
  String get allAssets {
    return Intl.message('All Assets', name: 'allAssets', desc: '', args: []);
  }

  /// `Choose an asset for this Transfer/Dispose request`
  String get chooseAnAssetForThisTransferDisposeRequest {
    return Intl.message(
      'Choose an asset for this Transfer/Dispose request',
      name: 'chooseAnAssetForThisTransferDisposeRequest',
      desc: '',
      args: [],
    );
  }

  /// `Scrap`
  String get scrap {
    return Intl.message('Scrap', name: 'scrap', desc: '', args: []);
  }

  /// `Sell`
  String get sell {
    return Intl.message('Sell', name: 'sell', desc: '', args: []);
  }

  /// `Return to supplier`
  String get returnToSupplier {
    return Intl.message(
      'Return to supplier',
      name: 'returnToSupplier',
      desc: '',
      args: [],
    );
  }

  /// `This asset is already chosen. Please select another one.`
  String get assetIsAlreadyChosen {
    return Intl.message(
      'This asset is already chosen. Please select another one.',
      name: 'assetIsAlreadyChosen',
      desc: '',
      args: [],
    );
  }

  /// `Transfer reason`
  String get transferReason {
    return Intl.message(
      'Transfer reason',
      name: 'transferReason',
      desc: '',
      args: [],
    );
  }

  /// `e.g East Branch Expansion, Excess Here`
  String get transferReasonHint {
    return Intl.message(
      'e.g East Branch Expansion, Excess Here',
      name: 'transferReasonHint',
      desc: '',
      args: [],
    );
  }

  /// `Disposal reason`
  String get disposalReason {
    return Intl.message(
      'Disposal reason',
      name: 'disposalReason',
      desc: '',
      args: [],
    );
  }

  /// `e.g. Broken, Outdated`
  String get disposalReasonHint {
    return Intl.message(
      'e.g. Broken, Outdated',
      name: 'disposalReasonHint',
      desc: '',
      args: [],
    );
  }

  /// `Condition description`
  String get conditionDescription {
    return Intl.message(
      'Condition description',
      name: 'conditionDescription',
      desc: '',
      args: [],
    );
  }

  /// `Describe asset state before disposal`
  String get conditionDescriptionHint {
    return Intl.message(
      'Describe asset state before disposal',
      name: 'conditionDescriptionHint',
      desc: '',
      args: [],
    );
  }

  /// `Visual evidence`
  String get visualEvidence {
    return Intl.message(
      'Visual evidence',
      name: 'visualEvidence',
      desc: '',
      args: [],
    );
  }

  /// `Selected Assets`
  String get selectedAssets {
    return Intl.message(
      'Selected Assets',
      name: 'selectedAssets',
      desc: '',
      args: [],
    );
  }

  /// `Final Disposal request details`
  String get finalDisposalDetails {
    return Intl.message(
      'Final Disposal request details',
      name: 'finalDisposalDetails',
      desc: '',
      args: [],
    );
  }

  /// `Approved by Owner`
  String get approvedByOwner {
    return Intl.message(
      'Approved by Owner',
      name: 'approvedByOwner',
      desc: '',
      args: [],
    );
  }

  /// `Pending Confirmation`
  String get pendingConfirmation {
    return Intl.message(
      'Pending Confirmation',
      name: 'pendingConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Pending confirmation from Owner`
  String get pendingOwnerApproval {
    return Intl.message(
      'Pending confirmation from Owner',
      name: 'pendingOwnerApproval',
      desc: '',
      args: [],
    );
  }

  /// `Final disposal request confirmed for proposed {date} & {time}`
  String finalDisposalConfirmed(Object date, Object time) {
    return Intl.message(
      'Final disposal request confirmed for proposed $date & $time',
      name: 'finalDisposalConfirmed',
      desc: '',
      args: [date, time],
    );
  }

  /// `Approved on: {date}`
  String approvedOn(Object date) {
    return Intl.message(
      'Approved on: $date',
      name: 'approvedOn',
      desc: '',
      args: [date],
    );
  }

  /// `Tools`
  String get tools {
    return Intl.message('Tools', name: 'tools', desc: '', args: []);
  }

  /// `Analytics`
  String get analytics {
    return Intl.message('Analytics', name: 'analytics', desc: '', args: []);
  }

  /// `Reject Expense Request`
  String get rejectExpenseRequest {
    return Intl.message(
      'Reject Expense Request',
      name: 'rejectExpenseRequest',
      desc: '',
      args: [],
    );
  }

  /// `You’re rejecting this single invoice request.\nPlease give a reason — this will help the requester adjust or resubmit if necessary.`
  String get rejectExpenseRequestDesc {
    return Intl.message(
      'You’re rejecting this single invoice request.\nPlease give a reason — this will help the requester adjust or resubmit if necessary.',
      name: 'rejectExpenseRequestDesc',
      desc: '',
      args: [],
    );
  }

  /// `E.g. invoice mismatch, vendor issue, missing attachments.`
  String get rejectExpenseReasonHint {
    return Intl.message(
      'E.g. invoice mismatch, vendor issue, missing attachments.',
      name: 'rejectExpenseReasonHint',
      desc: '',
      args: [],
    );
  }

  /// `Reject Custody Request`
  String get rejectCustodyRequest {
    return Intl.message(
      'Reject Custody Request',
      name: 'rejectCustodyRequest',
      desc: '',
      args: [],
    );
  }

  /// `You’re about to reject this Branch Custody request.\nAdd a reason so the requester can make corrections if needed.`
  String get rejectCustodyRequestDesc {
    return Intl.message(
      'You’re about to reject this Branch Custody request.\nAdd a reason so the requester can make corrections if needed.',
      name: 'rejectCustodyRequestDesc',
      desc: '',
      args: [],
    );
  }

  /// `E.g. exceeds cash limit, missing justification, request not in scope.`
  String get rejectCustodyReasonHint {
    return Intl.message(
      'E.g. exceeds cash limit, missing justification, request not in scope.',
      name: 'rejectCustodyReasonHint',
      desc: '',
      args: [],
    );
  }

  /// `Operations Panel`
  String get operationsPanel {
    return Intl.message(
      'Operations Panel',
      name: 'operationsPanel',
      desc: '',
      args: [],
    );
  }

  /// `Your hub for actions, records, and store oversight.`
  String get operationsPanelDesc {
    return Intl.message(
      'Your hub for actions, records, and store oversight.',
      name: 'operationsPanelDesc',
      desc: '',
      args: [],
    );
  }

  /// `Add Store Branch`
  String get addStoreBranch {
    return Intl.message(
      'Add Store Branch',
      name: 'addStoreBranch',
      desc: '',
      args: [],
    );
  }

  /// `Add Employee`
  String get addEmployee {
    return Intl.message(
      'Add Employee',
      name: 'addEmployee',
      desc: '',
      args: [],
    );
  }

  /// `Make Payment to Supplier`
  String get makePaymentToSupplier {
    return Intl.message(
      'Make Payment to Supplier',
      name: 'makePaymentToSupplier',
      desc: '',
      args: [],
    );
  }

  /// `Top-up Custody from Sales`
  String get topUpCustodyFromSales {
    return Intl.message(
      'Top-up Custody from Sales',
      name: 'topUpCustodyFromSales',
      desc: '',
      args: [],
    );
  }

  /// `HR Tools`
  String get hrTools {
    return Intl.message('HR Tools', name: 'hrTools', desc: '', args: []);
  }

  /// `Store Branches`
  String get storeBranches {
    return Intl.message(
      'Store Branches',
      name: 'storeBranches',
      desc: '',
      args: [],
    );
  }

  /// `Employee & Staff`
  String get employeeAndStaff {
    return Intl.message(
      'Employee & Staff',
      name: 'employeeAndStaff',
      desc: '',
      args: [],
    );
  }

  /// `Store Owner Dashboard`
  String get storeOwnerDashboard {
    return Intl.message(
      'Store Owner Dashboard',
      name: 'storeOwnerDashboard',
      desc: '',
      args: [],
    );
  }

  /// `Invoices Summary`
  String get invoicesSummary {
    return Intl.message(
      'Invoices Summary',
      name: 'invoicesSummary',
      desc: '',
      args: [],
    );
  }

  /// `Expenses Summary`
  String get expensesSummary {
    return Intl.message(
      'Expenses Summary',
      name: 'expensesSummary',
      desc: '',
      args: [],
    );
  }

  /// `Custody Summary`
  String get custodySummary {
    return Intl.message(
      'Custody Summary',
      name: 'custodySummary',
      desc: '',
      args: [],
    );
  }

  /// `Approved Invoices`
  String get approvedInvoices {
    return Intl.message(
      'Approved Invoices',
      name: 'approvedInvoices',
      desc: '',
      args: [],
    );
  }

  /// `higher than last month.`
  String get higherThanLastMonth {
    return Intl.message(
      'higher than last month.',
      name: 'higherThanLastMonth',
      desc: '',
      args: [],
    );
  }

  /// `Pending Invoice`
  String get pendingInvoice {
    return Intl.message(
      'Pending Invoice',
      name: 'pendingInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Go To Requests`
  String get goToRequests {
    return Intl.message(
      'Go To Requests',
      name: 'goToRequests',
      desc: '',
      args: [],
    );
  }

  /// `Handover Session Preparation`
  String get handoverSessionPreparation {
    return Intl.message(
      'Handover Session Preparation',
      name: 'handoverSessionPreparation',
      desc: '',
      args: [],
    );
  }

  /// `Just a few details needed to complete the handover.`
  String get handoverSessionPreparationDesc {
    return Intl.message(
      'Just a few details needed to complete the handover.',
      name: 'handoverSessionPreparationDesc',
      desc: '',
      args: [],
    );
  }

  /// `Recipient Info`
  String get recipientInfo {
    return Intl.message(
      'Recipient Info',
      name: 'recipientInfo',
      desc: '',
      args: [],
    );
  }

  /// `Choose recipient employee to get started`
  String get chooseRecipientEmployeeToGetStarted {
    return Intl.message(
      'Choose recipient employee to get started',
      name: 'chooseRecipientEmployeeToGetStarted',
      desc: '',
      args: [],
    );
  }

  /// `Choose Employee`
  String get chooseEmployee {
    return Intl.message(
      'Choose Employee',
      name: 'chooseEmployee',
      desc: '',
      args: [],
    );
  }

  /// `Session Details`
  String get sessionDetails {
    return Intl.message(
      'Session Details',
      name: 'sessionDetails',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message('Time', name: 'time', desc: '', args: []);
  }

  /// `Included Zones`
  String get includedZones {
    return Intl.message(
      'Included Zones',
      name: 'includedZones',
      desc: '',
      args: [],
    );
  }

  /// `Choose what zones to handover`
  String get chooseWhatZonesToHandover {
    return Intl.message(
      'Choose what zones to handover',
      name: 'chooseWhatZonesToHandover',
      desc: '',
      args: [],
    );
  }

  /// `Select all zones`
  String get selectAllZones {
    return Intl.message(
      'Select all zones',
      name: 'selectAllZones',
      desc: '',
      args: [],
    );
  }

  /// `Detailed List`
  String get detailedList {
    return Intl.message(
      'Detailed List',
      name: 'detailedList',
      desc: '',
      args: [],
    );
  }

  /// `Send Invitation`
  String get sendInvitation {
    return Intl.message(
      'Send Invitation',
      name: 'sendInvitation',
      desc: '',
      args: [],
    );
  }

  /// `Notify recipient via`
  String get notifyRecipientVia {
    return Intl.message(
      'Notify recipient via',
      name: 'notifyRecipientVia',
      desc: '',
      args: [],
    );
  }

  /// `Confirmations`
  String get confirmations {
    return Intl.message(
      'Confirmations',
      name: 'confirmations',
      desc: '',
      args: [],
    );
  }

  /// `Recipient is here in person`
  String get recipientIsHereInPerson {
    return Intl.message(
      'Recipient is here in person',
      name: 'recipientIsHereInPerson',
      desc: '',
      args: [],
    );
  }

  /// `Selected assets are all ready for handover`
  String get selectedAssetsAreAllReady {
    return Intl.message(
      'Selected assets are all ready for handover',
      name: 'selectedAssetsAreAllReady',
      desc: '',
      args: [],
    );
  }

  /// `Start Session & Notify`
  String get startSessionAndNotify {
    return Intl.message(
      'Start Session & Notify',
      name: 'startSessionAndNotify',
      desc: '',
      args: [],
    );
  }

  /// `Zones Detailed View`
  String get zonesDetailedView {
    return Intl.message(
      'Zones Detailed View',
      name: 'zonesDetailedView',
      desc: '',
      args: [],
    );
  }

  /// `See all zones, locations, and linked assets`
  String get seeAllZonesLocationsAndLinkedAssets {
    return Intl.message(
      'See all zones, locations, and linked assets',
      name: 'seeAllZonesLocationsAndLinkedAssets',
      desc: '',
      args: [],
    );
  }

  /// `Handover Initiated`
  String get handoverInitiated {
    return Intl.message(
      'Handover Initiated',
      name: 'handoverInitiated',
      desc: '',
      args: [],
    );
  }

  /// `Your handover request has been sent. You will be notified when they accept it.`
  String get yourHandoverRequestHasBeenSent {
    return Intl.message(
      'Your handover request has been sent. You will be notified when they accept it.',
      name: 'yourHandoverRequestHasBeenSent',
      desc: '',
      args: [],
    );
  }

  /// `See handover details and QR code`
  String get seeHandoverDetailsAndQrCode {
    return Intl.message(
      'See handover details and QR code',
      name: 'seeHandoverDetailsAndQrCode',
      desc: '',
      args: [],
    );
  }

  /// `Assets Handover details`
  String get assetsHandoverDetails {
    return Intl.message(
      'Assets Handover details',
      name: 'assetsHandoverDetails',
      desc: '',
      args: [],
    );
  }

  /// `Initiated`
  String get initiated {
    return Intl.message('Initiated', name: 'initiated', desc: '', args: []);
  }

  /// `Starting a Handover?`
  String get startingAHandover {
    return Intl.message(
      'Starting a Handover?',
      name: 'startingAHandover',
      desc: '',
      args: [],
    );
  }

  /// `You’re about to initiate a formal asset handover, typically used when a Branch Manager or Custodian is being replaced due to shift changes, resignation, or transfer. This process ensures a smooth transition of responsibilities and accountability for the branch’s assets.`
  String get youreAboutToInitiateAFormalAssetHandover {
    return Intl.message(
      'You’re about to initiate a formal asset handover, typically used when a Branch Manager or Custodian is being replaced due to shift changes, resignation, or transfer. This process ensures a smooth transition of responsibilities and accountability for the branch’s assets.',
      name: 'youreAboutToInitiateAFormalAssetHandover',
      desc: '',
      args: [],
    );
  }

  /// `Please ensure:`
  String get pleaseEnsure {
    return Intl.message(
      'Please ensure:',
      name: 'pleaseEnsure',
      desc: '',
      args: [],
    );
  }

  /// `All items have been counted`
  String get allItemsCounted {
    return Intl.message(
      'All items have been counted',
      name: 'allItemsCounted',
      desc: '',
      args: [],
    );
  }

  /// `Photos or notes are added where needed`
  String get photosOrNotesAdded {
    return Intl.message(
      'Photos or notes are added where needed',
      name: 'photosOrNotesAdded',
      desc: '',
      args: [],
    );
  }

  /// `Everything in your custody is accounted for`
  String get everythingInYourCustodyAccountedFor {
    return Intl.message(
      'Everything in your custody is accounted for',
      name: 'everythingInYourCustodyAccountedFor',
      desc: '',
      args: [],
    );
  }

  /// `Once completed, you’ll lose edit access to all asset-related actions. Read-only access will remain (if granted).`
  String get onceCompletedYouLoseEditAccess {
    return Intl.message(
      'Once completed, you’ll lose edit access to all asset-related actions. Read-only access will remain (if granted).',
      name: 'onceCompletedYouLoseEditAccess',
      desc: '',
      args: [],
    );
  }

  /// `Proceed with Handover?`
  String get proceedWithHandover {
    return Intl.message(
      'Proceed with Handover?',
      name: 'proceedWithHandover',
      desc: '',
      args: [],
    );
  }

  /// `Change Recipient`
  String get changeRecipient {
    return Intl.message(
      'Change Recipient',
      name: 'changeRecipient',
      desc: '',
      args: [],
    );
  }

  /// `Zone approved`
  String get zoneApproved {
    return Intl.message(
      'Zone approved',
      name: 'zoneApproved',
      desc: '',
      args: [],
    );
  }

  /// `Review Assets`
  String get reviewAssets {
    return Intl.message(
      'Review Assets',
      name: 'reviewAssets',
      desc: '',
      args: [],
    );
  }

  /// `Progress Map`
  String get progressMap {
    return Intl.message(
      'Progress Map',
      name: 'progressMap',
      desc: '',
      args: [],
    );
  }

  /// `Remaining`
  String get remaining {
    return Intl.message('Remaining', name: 'remaining', desc: '', args: []);
  }

  /// `Handover Summary`
  String get handoverSummary {
    return Intl.message(
      'Handover Summary',
      name: 'handoverSummary',
      desc: '',
      args: [],
    );
  }

  /// `Number of accepted assets`
  String get numberAcceptedAssets {
    return Intl.message(
      'Number of accepted assets',
      name: 'numberAcceptedAssets',
      desc: '',
      args: [],
    );
  }

  /// `Number of rejected assets`
  String get numberRejectedAssets {
    return Intl.message(
      'Number of rejected assets',
      name: 'numberRejectedAssets',
      desc: '',
      args: [],
    );
  }

  /// `Number of note assets`
  String get numberNoteAssets {
    return Intl.message(
      'Number of note assets',
      name: 'numberNoteAssets',
      desc: '',
      args: [],
    );
  }

  /// `Signature & Confirmation`
  String get signatureAndConfirmation {
    return Intl.message(
      'Signature & Confirmation',
      name: 'signatureAndConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Total Assets`
  String get totalAssets {
    return Intl.message(
      'Total Assets',
      name: 'totalAssets',
      desc: '',
      args: [],
    );
  }

  /// `Handover description`
  String get handoverDescription {
    return Intl.message(
      'Handover description',
      name: 'handoverDescription',
      desc: '',
      args: [],
    );
  }

  /// `Weekly Cleaning`
  String get weeklyCleaning {
    return Intl.message(
      'Weekly Cleaning',
      name: 'weeklyCleaning',
      desc: '',
      args: [],
    );
  }

  /// `Party Confirmations`
  String get partyConfirmations {
    return Intl.message(
      'Party Confirmations',
      name: 'partyConfirmations',
      desc: '',
      args: [],
    );
  }

  /// `Both the sender and recipient must review and sign to officially complete this handover.\n\nThis confirms that all listed assets have been inspected, agreed upon, and transferred.`
  String get handoverConfirmationDesc {
    return Intl.message(
      'Both the sender and recipient must review and sign to officially complete this handover.\n\nThis confirms that all listed assets have been inspected, agreed upon, and transferred.',
      name: 'handoverConfirmationDesc',
      desc: '',
      args: [],
    );
  }

  /// `Complete Handover`
  String get completeHandover {
    return Intl.message(
      'Complete Handover',
      name: 'completeHandover',
      desc: '',
      args: [],
    );
  }

  /// `Session Results:`
  String get sessionResults {
    return Intl.message(
      'Session Results:',
      name: 'sessionResults',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get duration {
    return Intl.message('Duration', name: 'duration', desc: '', args: []);
  }

  /// `Accepted`
  String get accepted {
    return Intl.message('Accepted', name: 'accepted', desc: '', args: []);
  }

  /// `Notes`
  String get notes {
    return Intl.message('Notes', name: 'notes', desc: '', args: []);
  }

  /// `Photos taken`
  String get photosTaken {
    return Intl.message(
      'Photos taken',
      name: 'photosTaken',
      desc: '',
      args: [],
    );
  }

  /// `Recorded discrepancies:`
  String get recordedDiscrepancies {
    return Intl.message(
      'Recorded discrepancies:',
      name: 'recordedDiscrepancies',
      desc: '',
      args: [],
    );
  }

  /// `View attached discrepancy`
  String get viewAttachedDiscrepancy {
    return Intl.message(
      'View attached discrepancy',
      name: 'viewAttachedDiscrepancy',
      desc: '',
      args: [],
    );
  }

  /// `Digital Signatures:`
  String get digitalSignatures {
    return Intl.message(
      'Digital Signatures:',
      name: 'digitalSignatures',
      desc: '',
      args: [],
    );
  }

  /// `"I Confirm Handover with Noted Discrepancies"`
  String get iConfirmHandoverWithNotedDiscrepancies {
    return Intl.message(
      '"I Confirm Handover with Noted Discrepancies"',
      name: 'iConfirmHandoverWithNotedDiscrepancies',
      desc: '',
      args: [],
    );
  }

  /// `"Received Assets with Required Documentation"`
  String get receivedAssetsWithRequiredDocumentation {
    return Intl.message(
      '"Received Assets with Required Documentation"',
      name: 'receivedAssetsWithRequiredDocumentation',
      desc: '',
      args: [],
    );
  }

  /// `Your handover Request to {name}, has been sent. You will be notified when they accept it.`
  String handoverRequestSent(String name) {
    return Intl.message(
      'Your handover Request to $name, has been sent. You will be notified when they accept it.',
      name: 'handoverRequestSent',
      desc: 'Displays who is handling the product',
      args: [name],
    );
  }

  /// `Handover Details & QR Code`
  String get handoverDetailsAndQrCode {
    return Intl.message(
      'Handover Details & QR Code',
      name: 'handoverDetailsAndQrCode',
      desc: '',
      args: [],
    );
  }

  /// `Signature Pending`
  String get signaturePending {
    return Intl.message(
      'Signature Pending',
      name: 'signaturePending',
      desc: '',
      args: [],
    );
  }

  /// `{name} (Recipient) has reviewed and signed the handover.\nYour confirmation is now required to complete the process.`
  String recipientSignedHandover(Object name) {
    return Intl.message(
      '$name (Recipient) has reviewed and signed the handover.\nYour confirmation is now required to complete the process.',
      name: 'recipientSignedHandover',
      desc: '',
      args: [name],
    );
  }

  /// `Sign Now`
  String get signNow {
    return Intl.message('Sign Now', name: 'signNow', desc: '', args: []);
  }

  /// `Handover Details`
  String get handoveDetails {
    return Intl.message(
      'Handover Details',
      name: 'handoveDetails',
      desc: '',
      args: [],
    );
  }

  /// `Handover Completed`
  String get handoverCompleted {
    return Intl.message(
      'Handover Completed',
      name: 'handoverCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Both parties have confirmed the asset transfer.\nAll assigned items are now officially handed over and recorded.`
  String get handoverCompletedDesc {
    return Intl.message(
      'Both parties have confirmed the asset transfer.\nAll assigned items are now officially handed over and recorded.',
      name: 'handoverCompletedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Track Handover details`
  String get trackHandoverDetails {
    return Intl.message(
      'Track Handover details',
      name: 'trackHandoverDetails',
      desc: '',
      args: [],
    );
  }

  /// `Signed`
  String get signed {
    return Intl.message('Signed', name: 'signed', desc: '', args: []);
  }

  /// `Handover Complete with {count} Recorded Discrepancies`
  String handoverCompleteWithRecordedDiscrepancies(Object count) {
    return Intl.message(
      'Handover Complete with $count Recorded Discrepancies',
      name: 'handoverCompleteWithRecordedDiscrepancies',
      desc: '',
      args: [count],
    );
  }

  /// `Automatic Dispatch:`
  String get automaticDispatch {
    return Intl.message(
      'Automatic Dispatch:',
      name: 'automaticDispatch',
      desc: '',
      args: [],
    );
  }

  /// `Owner`
  String get owner {
    return Intl.message('Owner', name: 'owner', desc: '', args: []);
  }

  /// `Full Report`
  String get fullReport {
    return Intl.message('Full Report', name: 'fullReport', desc: '', args: []);
  }

  /// `Brand Manager`
  String get brandManager {
    return Intl.message(
      'Brand Manager',
      name: 'brandManager',
      desc: '',
      args: [],
    );
  }

  /// `Executive Summary`
  String get executiveSummary {
    return Intl.message(
      'Executive Summary',
      name: 'executiveSummary',
      desc: '',
      args: [],
    );
  }

  /// `Finance`
  String get finance {
    return Intl.message('Finance', name: 'finance', desc: '', args: []);
  }

  /// `Asset Value Update`
  String get assetValueUpdate {
    return Intl.message(
      'Asset Value Update',
      name: 'assetValueUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Back to Asset Dashboard`
  String get backToAssetDashboard {
    return Intl.message(
      'Back to Asset Dashboard',
      name: 'backToAssetDashboard',
      desc: '',
      args: [],
    );
  }

  /// `WhatsApp`
  String get whatsApp {
    return Intl.message('WhatsApp', name: 'whatsApp', desc: '', args: []);
  }

  /// `Push Notification`
  String get pushNotification {
    return Intl.message(
      'Push Notification',
      name: 'pushNotification',
      desc: '',
      args: [],
    );
  }

  /// `Notes & Summary`
  String get notesAndSummary {
    return Intl.message(
      'Notes & Summary',
      name: 'notesAndSummary',
      desc: '',
      args: [],
    );
  }

  /// `Zones Handed Over`
  String get zonesHandedOver {
    return Intl.message(
      'Zones Handed Over',
      name: 'zonesHandedOver',
      desc: '',
      args: [],
    );
  }

  /// `Full Asset History View`
  String get fullAssetHistoryView {
    return Intl.message(
      'Full Asset History View',
      name: 'fullAssetHistoryView',
      desc: '',
      args: [],
    );
  }

  /// `Review details, timeline and changes below`
  String get reviewDetailsTimelineAndChangesBelow {
    return Intl.message(
      'Review details, timeline and changes below',
      name: 'reviewDetailsTimelineAndChangesBelow',
      desc: '',
      args: [],
    );
  }

  /// `Historical Photos`
  String get historicalPhotos {
    return Intl.message(
      'Historical Photos',
      name: 'historicalPhotos',
      desc: '',
      args: [],
    );
  }

  /// `Tap arrow to close timelines and changes`
  String get tapArrowToCloseTimelinesAndChanges {
    return Intl.message(
      'Tap arrow to close timelines and changes',
      name: 'tapArrowToCloseTimelinesAndChanges',
      desc: '',
      args: [],
    );
  }

  /// `CURRENT IMAGE`
  String get currentImage {
    return Intl.message(
      'CURRENT IMAGE',
      name: 'currentImage',
      desc: '',
      args: [],
    );
  }

  /// `Status History`
  String get statusHistory {
    return Intl.message(
      'Status History',
      name: 'statusHistory',
      desc: '',
      args: [],
    );
  }

  /// `Transfer/Movement History`
  String get transferMovementHistory {
    return Intl.message(
      'Transfer/Movement History',
      name: 'transferMovementHistory',
      desc: '',
      args: [],
    );
  }

  /// `Custody History`
  String get custodyHistory {
    return Intl.message(
      'Custody History',
      name: 'custodyHistory',
      desc: '',
      args: [],
    );
  }

  /// `Financial Information`
  String get financialInformation {
    return Intl.message(
      'Financial Information',
      name: 'financialInformation',
      desc: '',
      args: [],
    );
  }

  /// `Total Movements`
  String get totalMovements {
    return Intl.message(
      'Total Movements',
      name: 'totalMovements',
      desc: '',
      args: [],
    );
  }

  /// `Show All {count} Photos`
  String showAllPhotos(int count) {
    return Intl.message(
      'Show All $count Photos',
      name: 'showAllPhotos',
      desc: 'Show all photos count',
      args: [count],
    );
  }

  /// `Show More Detailed Timeline`
  String get showMoreDetailedTimeline {
    return Intl.message(
      'Show More Detailed Timeline',
      name: 'showMoreDetailedTimeline',
      desc: '',
      args: [],
    );
  }

  /// `Added to {zone}`
  String addedToZone(String zone) {
    return Intl.message(
      'Added to $zone',
      name: 'addedToZone',
      desc: 'Added to zone',
      args: [zone],
    );
  }

  /// `Moved to {location}`
  String movedTo(String location) {
    return Intl.message(
      'Moved to $location',
      name: 'movedTo',
      desc: 'Moved to location',
      args: [location],
    );
  }

  /// `Relocate Within {area}`
  String relocateWithin(String area) {
    return Intl.message(
      'Relocate Within $area',
      name: 'relocateWithin',
      desc: 'Relocate within area',
      args: [area],
    );
  }

  /// `Location History Map`
  String get locationHistoryMap {
    return Intl.message(
      'Location History Map',
      name: 'locationHistoryMap',
      desc: '',
      args: [],
    );
  }

  /// `Current`
  String get currentCustody {
    return Intl.message('Current', name: 'currentCustody', desc: '', args: []);
  }

  /// `Previous`
  String get previousCustody {
    return Intl.message(
      'Previous',
      name: 'previousCustody',
      desc: '',
      args: [],
    );
  }

  /// `Performance Score`
  String get performanceScore {
    return Intl.message(
      'Performance Score',
      name: 'performanceScore',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Value`
  String get purchaseValue {
    return Intl.message(
      'Purchase Value',
      name: 'purchaseValue',
      desc: '',
      args: [],
    );
  }

  /// `Current Value`
  String get currentValue {
    return Intl.message(
      'Current Value',
      name: 'currentValue',
      desc: '',
      args: [],
    );
  }

  /// `Estimated`
  String get estimated {
    return Intl.message('Estimated', name: 'estimated', desc: '', args: []);
  }

  /// `Maintenance Cost`
  String get maintenanceCost {
    return Intl.message(
      'Maintenance Cost',
      name: 'maintenanceCost',
      desc: '',
      args: [],
    );
  }

  /// `View Purchase Invoice`
  String get viewPurchaseInvoice {
    return Intl.message(
      'View Purchase Invoice',
      name: 'viewPurchaseInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Generate Report`
  String get generateReport {
    return Intl.message(
      'Generate Report',
      name: 'generateReport',
      desc: '',
      args: [],
    );
  }

  /// `Updated By`
  String get updatedBy {
    return Intl.message('Updated By', name: 'updatedBy', desc: '', args: []);
  }

  /// `Date & Time`
  String get dateAndTime {
    return Intl.message('Date & Time', name: 'dateAndTime', desc: '', args: []);
  }

  /// `Initial Recording`
  String get initialRecording {
    return Intl.message(
      'Initial Recording',
      name: 'initialRecording',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Audit`
  String get monthlyAudit {
    return Intl.message(
      'Monthly Audit',
      name: 'monthlyAudit',
      desc: '',
      args: [],
    );
  }

  /// `Quarterly Review`
  String get quarterlyReview {
    return Intl.message(
      'Quarterly Review',
      name: 'quarterlyReview',
      desc: '',
      args: [],
    );
  }

  /// `Performance Issues`
  String get performanceIssues {
    return Intl.message(
      'Performance Issues',
      name: 'performanceIssues',
      desc: '',
      args: [],
    );
  }

  /// `Equipment`
  String get equipment {
    return Intl.message('Equipment', name: 'equipment', desc: '', args: []);
  }

  /// `Coffee Station`
  String get coffeeStation {
    return Intl.message(
      'Coffee Station',
      name: 'coffeeStation',
      desc: '',
      args: [],
    );
  }

  /// `Handover Request`
  String get handoverRequest {
    return Intl.message(
      'Handover Request',
      name: 'handoverRequest',
      desc: '',
      args: [],
    );
  }

  /// `Rejected Assets Pending Your Review`
  String get rejectedAssetsPendingYourReview {
    return Intl.message(
      'Rejected Assets Pending Your Review',
      name: 'rejectedAssetsPendingYourReview',
      desc: '',
      args: [],
    );
  }

  /// `Start New Handover for All`
  String get startNewHandoverForAll {
    return Intl.message(
      'Start New Handover for All',
      name: 'startNewHandoverForAll',
      desc: '',
      args: [],
    );
  }

  /// `No Increase from last month.`
  String get noIncreaseFromLastMonth {
    return Intl.message(
      'No Increase from last month.',
      name: 'noIncreaseFromLastMonth',
      desc: '',
      args: [],
    );
  }

  /// `Reports & Analytics`
  String get reportsAndAnalytics {
    return Intl.message(
      'Reports & Analytics',
      name: 'reportsAndAnalytics',
      desc: '',
      args: [],
    );
  }

  /// `Expense Trends`
  String get expenseTrends {
    return Intl.message(
      'Expense Trends',
      name: 'expenseTrends',
      desc: '',
      args: [],
    );
  }

  /// `Owner Payment Form`
  String get ownerPaymentForm {
    return Intl.message(
      'Owner Payment Form',
      name: 'ownerPaymentForm',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Date`
  String get transferDate {
    return Intl.message(
      'Transfer Date',
      name: 'transferDate',
      desc: '',
      args: [],
    );
  }

  /// `Purpose of Transfer`
  String get purposeOfTransfer {
    return Intl.message(
      'Purpose of Transfer',
      name: 'purposeOfTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Bank Transfer Recorded`
  String get bankTransferRecorded {
    return Intl.message(
      'Bank Transfer Recorded',
      name: 'bankTransferRecorded',
      desc: '',
      args: [],
    );
  }

  /// `The payment details have been added to your payment log and the branch manager’s custody balance updated.`
  String get bankTransferRecordedDesc {
    return Intl.message(
      'The payment details have been added to your payment log and the branch manager’s custody balance updated.',
      name: 'bankTransferRecordedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Cash Handover Recorded`
  String get cashHandoverRecorded {
    return Intl.message(
      'Cash Handover Recorded',
      name: 'cashHandoverRecorded',
      desc: '',
      args: [],
    );
  }

  /// `Amount SAR has been added to the branch manager’s custody balance and logged in your payment history.`
  String get cashHandoverRecordedDesc {
    return Intl.message(
      'Amount SAR has been added to the branch manager’s custody balance and logged in your payment history.',
      name: 'cashHandoverRecordedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Send funds via bank transfer or cash handover. Successful Payments can’t be edited.`
  String get sendFundsToBranchManager {
    return Intl.message(
      'Send funds via bank transfer or cash handover. Successful Payments can’t be edited.',
      name: 'sendFundsToBranchManager',
      desc: '',
      args: [],
    );
  }

  /// `Cash Sales Transfers`
  String get cashSalesTransfers {
    return Intl.message(
      'Cash Sales Transfers',
      name: 'cashSalesTransfers',
      desc: '',
      args: [],
    );
  }

  /// `Reject Cash Handover Request`
  String get rejectCashHandoverRequest {
    return Intl.message(
      'Reject Cash Handover Request',
      name: 'rejectCashHandoverRequest',
      desc: '',
      args: [],
    );
  }

  /// `You’re rejecting this handover. Please provide a reason so the sender can understand what went wrong and take the necessary steps to correct it.`
  String get rejectCashHandoverRequestDesc {
    return Intl.message(
      'You’re rejecting this handover. Please provide a reason so the sender can understand what went wrong and take the necessary steps to correct it.',
      name: 'rejectCashHandoverRequestDesc',
      desc: '',
      args: [],
    );
  }

  /// `Cash Sales Transfer`
  String get cashSalesTransfer {
    return Intl.message(
      'Cash Sales Transfer',
      name: 'cashSalesTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Payment Log`
  String get paymentLog {
    return Intl.message('Payment Log', name: 'paymentLog', desc: '', args: []);
  }

  /// `Financial Reporting`
  String get financialReporting {
    return Intl.message(
      'Financial Reporting',
      name: 'financialReporting',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Time`
  String get transferTime {
    return Intl.message(
      'Transfer Time',
      name: 'transferTime',
      desc: '',
      args: [],
    );
  }

  /// `Waste & Damage`
  String get wasteAndDamage {
    return Intl.message(
      'Waste & Damage',
      name: 'wasteAndDamage',
      desc: '',
      args: [],
    );
  }

  /// `Report Summary`
  String get reportSummary {
    return Intl.message(
      'Report Summary',
      name: 'reportSummary',
      desc: '',
      args: [],
    );
  }

  /// `{branchName} has submitted a Waste & Damage Report for review.`
  String reportSubmittedForReview(Object branchName) {
    return Intl.message(
      '$branchName has submitted a Waste & Damage Report for review.',
      name: 'reportSubmittedForReview',
      desc: '',
      args: [branchName],
    );
  }

  /// `Recording Time`
  String get recordingTime {
    return Intl.message(
      'Recording Time',
      name: 'recordingTime',
      desc: '',
      args: [],
    );
  }

  /// `Status Type`
  String get statusType {
    return Intl.message('Status Type', name: 'statusType', desc: '', args: []);
  }

  /// `Recorded Item Details`
  String get recordedItemDetails {
    return Intl.message(
      'Recorded Item Details',
      name: 'recordedItemDetails',
      desc: '',
      args: [],
    );
  }

  /// `Recording by`
  String get recordingBy {
    return Intl.message(
      'Recording by',
      name: 'recordingBy',
      desc: '',
      args: [],
    );
  }

  /// `Justification Note`
  String get justificationNote {
    return Intl.message(
      'Justification Note',
      name: 'justificationNote',
      desc: '',
      args: [],
    );
  }

  /// `General Actions & Links`
  String get generalActionsAndLinks {
    return Intl.message(
      'General Actions & Links',
      name: 'generalActionsAndLinks',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Products Inventoried`
  String get productsInventoried {
    return Intl.message(
      'Products Inventoried',
      name: 'productsInventoried',
      desc: '',
      args: [],
    );
  }

  /// `Expected Balance`
  String get expectedBalance {
    return Intl.message(
      'Expected Balance',
      name: 'expectedBalance',
      desc: '',
      args: [],
    );
  }

  /// `Actual Balance`
  String get actualBalance {
    return Intl.message(
      'Actual Balance',
      name: 'actualBalance',
      desc: '',
      args: [],
    );
  }

  /// `You have not sent any daily inventory requests to store owner for approvals.`
  String get youHaveNotSentAnyDailyInventoryRequestsToStoreOwnerForApprovals {
    return Intl.message(
      'You have not sent any daily inventory requests to store owner for approvals.',
      name: 'youHaveNotSentAnyDailyInventoryRequestsToStoreOwnerForApprovals',
      desc: '',
      args: [],
    );
  }

  /// `You have not sent any wast and damage requests to store owner for approvals.`
  String get youHaveNotSentAnyWastAndDamageRequestsToStoreOwnerForApprovals {
    return Intl.message(
      'You have not sent any wast and damage requests to store owner for approvals.',
      name: 'youHaveNotSentAnyWastAndDamageRequestsToStoreOwnerForApprovals',
      desc: '',
      args: [],
    );
  }

  /// `Escalation Requests`
  String get escalationRequests {
    return Intl.message(
      'Escalation Requests',
      name: 'escalationRequests',
      desc: '',
      args: [],
    );
  }

  /// `Rejected by Brand Manager`
  String get rejectedByBrandManager {
    return Intl.message(
      'Rejected by Brand Manager',
      name: 'rejectedByBrandManager',
      desc: '',
      args: [],
    );
  }

  /// `Order Variance Rejected`
  String get orderVarianceRejected {
    return Intl.message(
      'Order Variance Rejected',
      name: 'orderVarianceRejected',
      desc: '',
      args: [],
    );
  }

  /// `Brand Manager has marked this escalation as rejected. Please review the details and make necessary adjustments before resubmitting.`
  String get brandManagerHasMarkedThisEscalationAsRejected {
    return Intl.message(
      'Brand Manager has marked this escalation as rejected. Please review the details and make necessary adjustments before resubmitting.',
      name: 'brandManagerHasMarkedThisEscalationAsRejected',
      desc: '',
      args: [],
    );
  }

  /// `Escalation`
  String get escalation {
    return Intl.message('Escalation', name: 'escalation', desc: '', args: []);
  }

  /// `Reports`
  String get reports {
    return Intl.message('Reports', name: 'reports', desc: '', args: []);
  }

  /// `Export History`
  String get exportHistory {
    return Intl.message(
      'Export History',
      name: 'exportHistory',
      desc: '',
      args: [],
    );
  }

  /// `Expense Report`
  String get expenseReport {
    return Intl.message(
      'Expense Report',
      name: 'expenseReport',
      desc: '',
      args: [],
    );
  }

  /// `Custody Report`
  String get custodyReport {
    return Intl.message(
      'Custody Report',
      name: 'custodyReport',
      desc: '',
      args: [],
    );
  }

  /// `Report is Ready`
  String get reportIsReady {
    return Intl.message(
      'Report is Ready',
      name: 'reportIsReady',
      desc: '',
      args: [],
    );
  }

  /// `No reports available`
  String get noReportsAvailable {
    return Intl.message(
      'No reports available',
      name: 'noReportsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Reports haven’t been generated yet. You’ll be notified once they’re available.`
  String get reportsHaventBeenGeneratedYet {
    return Intl.message(
      'Reports haven’t been generated yet. You’ll be notified once they’re available.',
      name: 'reportsHaventBeenGeneratedYet',
      desc: '',
      args: [],
    );
  }

  /// `No Reports Exported Yet`
  String get noReportsExportedYet {
    return Intl.message(
      'No Reports Exported Yet',
      name: 'noReportsExportedYet',
      desc: '',
      args: [],
    );
  }

  /// `You haven’t exported any reports yet. Use the Export button in the “See Report Details” page to generate and download your first report.`
  String get noReportsExportedYetDesc {
    return Intl.message(
      'You haven’t exported any reports yet. Use the Export button in the “See Report Details” page to generate and download your first report.',
      name: 'noReportsExportedYetDesc',
      desc: '',
      args: [],
    );
  }

  /// `June Expense Report`
  String get juneExpenseReportTitle {
    return Intl.message(
      'June Expense Report',
      name: 'juneExpenseReportTitle',
      desc: '',
      args: [],
    );
  }

  /// `Track every spend in one place`
  String get trackEverySpendInOnePlace {
    return Intl.message(
      'Track every spend in one place',
      name: 'trackEverySpendInOnePlace',
      desc: '',
      args: [],
    );
  }

  /// `Export`
  String get exportLabel {
    return Intl.message('Export', name: 'exportLabel', desc: '', args: []);
  }

  /// `Quick`
  String get quickFilter {
    return Intl.message('Quick', name: 'quickFilter', desc: '', args: []);
  }

  /// `Standard`
  String get standardFilter {
    return Intl.message('Standard', name: 'standardFilter', desc: '', args: []);
  }

  /// `Custom`
  String get customFilter {
    return Intl.message('Custom', name: 'customFilter', desc: '', args: []);
  }

  /// `Monthly`
  String get monthlyFilter {
    return Intl.message('Monthly', name: 'monthlyFilter', desc: '', args: []);
  }

  /// `Weekly`
  String get weeklyFilter {
    return Intl.message('Weekly', name: 'weeklyFilter', desc: '', args: []);
  }

  /// `Daily`
  String get dailyFilter {
    return Intl.message('Daily', name: 'dailyFilter', desc: '', args: []);
  }

  /// `Yearly`
  String get yearlyFilter {
    return Intl.message('Yearly', name: 'yearlyFilter', desc: '', args: []);
  }

  /// `Branch Name`
  String get branchName {
    return Intl.message('Branch Name', name: 'branchName', desc: '', args: []);
  }

  /// `Branch A`
  String get branchA {
    return Intl.message('Branch A', name: 'branchA', desc: '', args: []);
  }

  /// `Branch B`
  String get branchB {
    return Intl.message('Branch B', name: 'branchB', desc: '', args: []);
  }

  /// `Quick Expense For {branchName}`
  String quickExpenseForBranch(String branchName) {
    return Intl.message(
      'Quick Expense For $branchName',
      name: 'quickExpenseForBranch',
      desc: 'Quick expense title with branch name',
      args: [branchName],
    );
  }

  /// `June 1 - 30, 2025`
  String get juneRangeLabel {
    return Intl.message(
      'June 1 - 30, 2025',
      name: 'juneRangeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Total Quick Expense Requests`
  String get totalQuickExpenseRequests {
    return Intl.message(
      'Total Quick Expense Requests',
      name: 'totalQuickExpenseRequests',
      desc: '',
      args: [],
    );
  }

  /// `{count} =`
  String totalQuickExpenseCount(int count) {
    return Intl.message(
      '$count =',
      name: 'totalQuickExpenseCount',
      desc: 'Total quick expense count with suffix',
      args: [count],
    );
  }

  /// `-8%`
  String get lowerThanLastMonthPercent {
    return Intl.message(
      '-8%',
      name: 'lowerThanLastMonthPercent',
      desc: '',
      args: [],
    );
  }

  /// `LOWER THAN LAST MONTH.`
  String get lowerThanLastMonthLabel {
    return Intl.message(
      'LOWER THAN LAST MONTH.',
      name: 'lowerThanLastMonthLabel',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethodTitle {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethodTitle',
      desc: '',
      args: [],
    );
  }

  /// `Cash vs Bank Transfers`
  String get cashVsBankTransfers {
    return Intl.message(
      'Cash vs Bank Transfers',
      name: 'cashVsBankTransfers',
      desc: '',
      args: [],
    );
  }

  /// `{count} Records`
  String recordsCount(int count) {
    return Intl.message(
      '$count Records',
      name: 'recordsCount',
      desc: 'Records count',
      args: [count],
    );
  }

  /// `Top 5 Suppliers`
  String get topSuppliersTitle {
    return Intl.message(
      'Top 5 Suppliers',
      name: 'topSuppliersTitle',
      desc: '',
      args: [],
    );
  }

  /// `Supplier Name (1)`
  String get supplierName1 {
    return Intl.message(
      'Supplier Name (1)',
      name: 'supplierName1',
      desc: '',
      args: [],
    );
  }

  /// `Supplier Name (2)`
  String get supplierName2 {
    return Intl.message(
      'Supplier Name (2)',
      name: 'supplierName2',
      desc: '',
      args: [],
    );
  }

  /// `Supplier Name (3)`
  String get supplierName3 {
    return Intl.message(
      'Supplier Name (3)',
      name: 'supplierName3',
      desc: '',
      args: [],
    );
  }

  /// `Supplier Name (4)`
  String get supplierName4 {
    return Intl.message(
      'Supplier Name (4)',
      name: 'supplierName4',
      desc: '',
      args: [],
    );
  }

  /// `Supplier Name (5)`
  String get supplierName5 {
    return Intl.message(
      'Supplier Name (5)',
      name: 'supplierName5',
      desc: '',
      args: [],
    );
  }

  /// `Expense Request Ratio`
  String get expenseRequestRatioTitle {
    return Intl.message(
      'Expense Request Ratio',
      name: 'expenseRequestRatioTitle',
      desc: '',
      args: [],
    );
  }

  /// `Tax vs Non-Tax Invoice Ratio`
  String get taxVsNonTaxInvoiceRatio {
    return Intl.message(
      'Tax vs Non-Tax Invoice Ratio',
      name: 'taxVsNonTaxInvoiceRatio',
      desc: '',
      args: [],
    );
  }

  /// `{count} Requests`
  String requestsCount(int count) {
    return Intl.message(
      '$count Requests',
      name: 'requestsCount',
      desc: 'Requests count',
      args: [count],
    );
  }

  /// `Tax Requests`
  String get taxRequests {
    return Intl.message(
      'Tax Requests',
      name: 'taxRequests',
      desc: '',
      args: [],
    );
  }

  /// `Non Tax Requests`
  String get nonTaxRequests {
    return Intl.message(
      'Non Tax Requests',
      name: 'nonTaxRequests',
      desc: '',
      args: [],
    );
  }

  /// `Branch Comparison Reports.`
  String get branchComparisonReportsTitle {
    return Intl.message(
      'Branch Comparison Reports.',
      name: 'branchComparisonReportsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Branch Full Name`
  String get branchFullName {
    return Intl.message(
      'Branch Full Name',
      name: 'branchFullName',
      desc: '',
      args: [],
    );
  }

  /// `Cash Transfer And Owner Payment Log.`
  String get cashTransferAndOwnerPaymentLog {
    return Intl.message(
      'Cash Transfer And Owner Payment Log.',
      name: 'cashTransferAndOwnerPaymentLog',
      desc: '',
      args: [],
    );
  }

  /// `{count}`
  String cashTransferCount(int count) {
    return Intl.message(
      '$count',
      name: 'cashTransferCount',
      desc: 'Cash transfer count',
      args: [count],
    );
  }

  /// `Bank Transfer`
  String get bankTransferLabel {
    return Intl.message(
      'Bank Transfer',
      name: 'bankTransferLabel',
      desc: '',
      args: [],
    );
  }

  /// `Cash Handover`
  String get cashHandoverLabel {
    return Intl.message(
      'Cash Handover',
      name: 'cashHandoverLabel',
      desc: '',
      args: [],
    );
  }

  /// `Bank Transfers`
  String get bankTransfers {
    return Intl.message(
      'Bank Transfers',
      name: 'bankTransfers',
      desc: '',
      args: [],
    );
  }

  /// `Cash Handovers`
  String get cashHandovers {
    return Intl.message(
      'Cash Handovers',
      name: 'cashHandovers',
      desc: '',
      args: [],
    );
  }

  /// `June 11 - 1:24 AM`
  String get expenseLogDateTime {
    return Intl.message(
      'June 11 - 1:24 AM',
      name: 'expenseLogDateTime',
      desc: '',
      args: [],
    );
  }

  /// `From Branch Name`
  String get fromBranchName {
    return Intl.message(
      'From Branch Name',
      name: 'fromBranchName',
      desc: '',
      args: [],
    );
  }

  /// `Quick Expenses Report`
  String get quickExpensesReportTitle {
    return Intl.message(
      'Quick Expenses Report',
      name: 'quickExpensesReportTitle',
      desc: '',
      args: [],
    );
  }

  /// `Current Balance`
  String get currentBalance {
    return Intl.message(
      'Current Balance',
      name: 'currentBalance',
      desc: '',
      args: [],
    );
  }

  /// `Suppliers`
  String get suppliers {
    return Intl.message('Suppliers', name: 'suppliers', desc: '', args: []);
  }

  /// `Aggregators`
  String get aggregators {
    return Intl.message('Aggregators', name: 'aggregators', desc: '', args: []);
  }

  /// `Old Password`
  String get oldPassword {
    return Intl.message(
      'Old Password',
      name: 'oldPassword',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `Old password matches new password`
  String get oldPasswordMatchesNew {
    return Intl.message(
      'Old password matches new password',
      name: 'oldPasswordMatchesNew',
      desc: '',
      args: [],
    );
  }

  /// `Financial Reports`
  String get financialReports {
    return Intl.message(
      'Financial Reports',
      name: 'financialReports',
      desc: '',
      args: [],
    );
  }

  /// `Nakheel Restaurant Chain`
  String get nakheelRestaurantChain {
    return Intl.message(
      'Nakheel Restaurant Chain',
      name: 'nakheelRestaurantChain',
      desc: '',
      args: [],
    );
  }

  /// `Report Type`
  String get reportType {
    return Intl.message('Report Type', name: 'reportType', desc: '', args: []);
  }

  /// `Core Reports`
  String get coreReports {
    return Intl.message(
      'Core Reports',
      name: 'coreReports',
      desc: '',
      args: [],
    );
  }

  /// `Show Sub-Details`
  String get showSubDetails {
    return Intl.message(
      'Show Sub-Details',
      name: 'showSubDetails',
      desc: '',
      args: [],
    );
  }

  /// `Profit & Loss Statement`
  String get profitAndLossStatement {
    return Intl.message(
      'Profit & Loss Statement',
      name: 'profitAndLossStatement',
      desc: '',
      args: [],
    );
  }

  /// `Sales Channel Analysis`
  String get salesChannelAnalysis {
    return Intl.message(
      'Sales Channel Analysis',
      name: 'salesChannelAnalysis',
      desc: '',
      args: [],
    );
  }

  /// `Smart Comparisons`
  String get smartComparisons {
    return Intl.message(
      'Smart Comparisons',
      name: 'smartComparisons',
      desc: '',
      args: [],
    );
  }

  /// `Specialized Reports`
  String get specializedReports {
    return Intl.message(
      'Specialized Reports',
      name: 'specializedReports',
      desc: '',
      args: [],
    );
  }

  /// `Profit vs Cash Reconciliation`
  String get profitVsCashReconciliation {
    return Intl.message(
      'Profit vs Cash Reconciliation',
      name: 'profitVsCashReconciliation',
      desc: '',
      args: [],
    );
  }

  /// `Break-Even Analysis`
  String get breakEvenAnalysis {
    return Intl.message(
      'Break-Even Analysis',
      name: 'breakEvenAnalysis',
      desc: '',
      args: [],
    );
  }

  /// `Operational Profitability`
  String get operationalProfitability {
    return Intl.message(
      'Operational Profitability',
      name: 'operationalProfitability',
      desc: '',
      args: [],
    );
  }

  /// `Menu Engineering`
  String get menuEngineering {
    return Intl.message(
      'Menu Engineering',
      name: 'menuEngineering',
      desc: '',
      args: [],
    );
  }

  /// `Menu Engineering Actions`
  String get menuEngineeringActions {
    return Intl.message(
      'Menu Engineering Actions',
      name: 'menuEngineeringActions',
      desc: '',
      args: [],
    );
  }

  /// `Item Test`
  String get itemTest {
    return Intl.message('Item Test', name: 'itemTest', desc: '', args: []);
  }

  /// `Pricing Simulator`
  String get pricingSimulator {
    return Intl.message(
      'Pricing Simulator',
      name: 'pricingSimulator',
      desc: '',
      args: [],
    );
  }

  /// `Detailed Financial Analysis`
  String get detailedFinancialAnalysis {
    return Intl.message(
      'Detailed Financial Analysis',
      name: 'detailedFinancialAnalysis',
      desc: '',
      args: [],
    );
  }

  /// `Comprehensive Channel Analysis`
  String get comprehensiveChannelAnalysis {
    return Intl.message(
      'Comprehensive Channel Analysis',
      name: 'comprehensiveChannelAnalysis',
      desc: '',
      args: [],
    );
  }

  /// `Monthly and Branch Comparisons`
  String get monthlyAndBranchComparisons {
    return Intl.message(
      'Monthly and Branch Comparisons',
      name: 'monthlyAndBranchComparisons',
      desc: '',
      args: [],
    );
  }

  /// `Understand the difference between your money and profits`
  String get understandTheDifferenceBetweenYourMoneyAndProfits {
    return Intl.message(
      'Understand the difference between your money and profits',
      name: 'understandTheDifferenceBetweenYourMoneyAndProfits',
      desc: '',
      args: [],
    );
  }

  /// `Risk Analysis and Financial Safety`
  String get riskAnalysisAndFinancialSafety {
    return Intl.message(
      'Risk Analysis and Financial Safety',
      name: 'riskAnalysisAndFinancialSafety',
      desc: '',
      args: [],
    );
  }

  /// `Performance Indicators and Industry Comparisons`
  String get performanceIndicatorsAndIndustryComparisons {
    return Intl.message(
      'Performance Indicators and Industry Comparisons',
      name: 'performanceIndicatorsAndIndustryComparisons',
      desc: '',
      args: [],
    );
  }

  /// `Test profitability of new items before adding them.`
  String get testProfitabilityOfNewItemsBeforeAddingThem {
    return Intl.message(
      'Test profitability of new items before adding them.',
      name: 'testProfitabilityOfNewItemsBeforeAddingThem',
      desc: '',
      args: [],
    );
  }

  /// `Simulate the impact of price changes on profits.`
  String get simulateTheImpactOfPriceChangesOnProfits {
    return Intl.message(
      'Simulate the impact of price changes on profits.',
      name: 'simulateTheImpactOfPriceChangesOnProfits',
      desc: '',
      args: [],
    );
  }

  /// `Profit & Loss Statement`
  String get profitLossStatement {
    return Intl.message(
      'Profit & Loss Statement',
      name: 'profitLossStatement',
      desc: '',
      args: [],
    );
  }

  /// `Display Settings:`
  String get displaySettings {
    return Intl.message(
      'Display Settings:',
      name: 'displaySettings',
      desc: '',
      args: [],
    );
  }

  /// `Apply your preferred filters to show better results:`
  String get applyYourPreferredFiltersToShowBetterResults {
    return Intl.message(
      'Apply your preferred filters to show better results:',
      name: 'applyYourPreferredFiltersToShowBetterResults',
      desc: '',
      args: [],
    );
  }

  /// `profitability  Summary:`
  String get profitabilitySummary {
    return Intl.message(
      'profitability  Summary:',
      name: 'profitabilitySummary',
      desc: '',
      args: [],
    );
  }

  /// `Total Revenue`
  String get totalRevenue {
    return Intl.message(
      'Total Revenue',
      name: 'totalRevenue',
      desc: '',
      args: [],
    );
  }

  /// `Net Profit`
  String get netProfit {
    return Intl.message('Net Profit', name: 'netProfit', desc: '', args: []);
  }

  /// `Profit Margin`
  String get profitMargin {
    return Intl.message(
      'Profit Margin',
      name: 'profitMargin',
      desc: '',
      args: [],
    );
  }

  /// `For more details, view level 2 report`
  String get forMoreDetailsViewLevel2Report {
    return Intl.message(
      'For more details, view level 2 report',
      name: 'forMoreDetailsViewLevel2Report',
      desc: '',
      args: [],
    );
  }

  /// `Export Level 2 Report As:`
  String get exportLevel2ReportAs {
    return Intl.message(
      'Export Level 2 Report As:',
      name: 'exportLevel2ReportAs',
      desc: '',
      args: [],
    );
  }

  /// `Via Email`
  String get viaEmail {
    return Intl.message('Via Email', name: 'viaEmail', desc: '', args: []);
  }

  /// `Direct Cost Total`
  String get directCostTotal {
    return Intl.message(
      'Direct Cost Total',
      name: 'directCostTotal',
      desc: '',
      args: [],
    );
  }

  /// `Profit & Loss`
  String get profitLoss {
    return Intl.message(
      'Profit & Loss',
      name: 'profitLoss',
      desc: '',
      args: [],
    );
  }

  /// `Visualize revenue, expenses, and net profit trends.`
  String get visualizeRevenueExpensesAndNetProfitTrends {
    return Intl.message(
      'Visualize revenue, expenses, and net profit trends.',
      name: 'visualizeRevenueExpensesAndNetProfitTrends',
      desc: '',
      args: [],
    );
  }

  /// `Turnover Total`
  String get turnoverTotal {
    return Intl.message(
      'Turnover Total',
      name: 'turnoverTotal',
      desc: '',
      args: [],
    );
  }

  /// `Gross Profit`
  String get grossProfit {
    return Intl.message(
      'Gross Profit',
      name: 'grossProfit',
      desc: '',
      args: [],
    );
  }

  /// `Grand Total Cost`
  String get grandTotalCost {
    return Intl.message(
      'Grand Total Cost',
      name: 'grandTotalCost',
      desc: '',
      args: [],
    );
  }

  /// `Profitability Amount`
  String get profitabilityAmount {
    return Intl.message(
      'Profitability Amount',
      name: 'profitabilityAmount',
      desc: '',
      args: [],
    );
  }

  /// `G&A Expenses`
  String get gaExpenses {
    return Intl.message('G&A Expenses', name: 'gaExpenses', desc: '', args: []);
  }

  /// `Other Income/expenses`
  String get otherIncomeexpenses {
    return Intl.message(
      'Other Income/expenses',
      name: 'otherIncomeexpenses',
      desc: '',
      args: [],
    );
  }

  /// `Net Profit & Loss`
  String get netProfitLoss {
    return Intl.message(
      'Net Profit & Loss',
      name: 'netProfitLoss',
      desc: '',
      args: [],
    );
  }

  /// `Filter Data`
  String get filterData {
    return Intl.message('Filter Data', name: 'filterData', desc: '', args: []);
  }

  /// `Report Month:`
  String get reportMonth {
    return Intl.message(
      'Report Month:',
      name: 'reportMonth',
      desc: '',
      args: [],
    );
  }

  /// `Reset Filter`
  String get resetFilter {
    return Intl.message(
      'Reset Filter',
      name: 'resetFilter',
      desc: '',
      args: [],
    );
  }

  /// `Apply Filter`
  String get applyFilter {
    return Intl.message(
      'Apply Filter',
      name: 'applyFilter',
      desc: '',
      args: [],
    );
  }

  /// `Choose Report date:`
  String get chooseReportDate {
    return Intl.message(
      'Choose Report date:',
      name: 'chooseReportDate',
      desc: '',
      args: [],
    );
  }

  /// `Active Branches`
  String get activeBranches {
    return Intl.message(
      'Active Branches',
      name: 'activeBranches',
      desc: '',
      args: [],
    );
  }

  /// `Comparison Settings`
  String get comparisonSettings {
    return Intl.message(
      'Comparison Settings',
      name: 'comparisonSettings',
      desc: '',
      args: [],
    );
  }

  /// `Compared with:`
  String get comparedWith {
    return Intl.message(
      'Compared with:',
      name: 'comparedWith',
      desc: '',
      args: [],
    );
  }

  /// `Overall Performance:`
  String get overallPerformance {
    return Intl.message(
      'Overall Performance:',
      name: 'overallPerformance',
      desc: '',
      args: [],
    );
  }

  /// `Total Profitability`
  String get totalProfitability {
    return Intl.message(
      'Total Profitability',
      name: 'totalProfitability',
      desc: '',
      args: [],
    );
  }

  /// `Direct Sales`
  String get directSales {
    return Intl.message(
      'Direct Sales',
      name: 'directSales',
      desc: '',
      args: [],
    );
  }

  /// `Other Apps`
  String get otherApps {
    return Intl.message('Other Apps', name: 'otherApps', desc: '', args: []);
  }

  /// `Compare With:`
  String get compareWith {
    return Intl.message(
      'Compare With:',
      name: 'compareWith',
      desc: '',
      args: [],
    );
  }

  /// `{count} Sales Chanels Recorded:`
  String countSalesChanelsRecorded(Object count) {
    return Intl.message(
      '$count Sales Chanels Recorded:',
      name: 'countSalesChanelsRecorded',
      desc: '',
      args: [count],
    );
  }

  /// `Sales Channels - Level 2`
  String get salesChannelsLevel2 {
    return Intl.message(
      'Sales Channels - Level 2',
      name: 'salesChannelsLevel2',
      desc: '',
      args: [],
    );
  }

  /// `{July} Overall Performance breakdown`
  String overallPerformanceBreakdown(Object July) {
    return Intl.message(
      '$July Overall Performance breakdown',
      name: 'overallPerformanceBreakdown',
      desc: '',
      args: [July],
    );
  }

  /// `Profitability`
  String get profitability {
    return Intl.message(
      'Profitability',
      name: 'profitability',
      desc: '',
      args: [],
    );
  }

  /// `App-Commissions`
  String get appcommissions {
    return Intl.message(
      'App-Commissions',
      name: 'appcommissions',
      desc: '',
      args: [],
    );
  }

  /// `Order count`
  String get orderCount {
    return Intl.message('Order count', name: 'orderCount', desc: '', args: []);
  }

  /// `Average order value`
  String get averageOrderValue {
    return Intl.message(
      'Average order value',
      name: 'averageOrderValue',
      desc: '',
      args: [],
    );
  }

  /// `Smart Monthly Comparisons`
  String get smartMonthlyComparisons {
    return Intl.message(
      'Smart Monthly Comparisons',
      name: 'smartMonthlyComparisons',
      desc: '',
      args: [],
    );
  }

  /// `Branch Ranking:`
  String get branchRanking {
    return Intl.message(
      'Branch Ranking:',
      name: 'branchRanking',
      desc: '',
      args: [],
    );
  }

  /// `Sales Comparison`
  String get salesComparison {
    return Intl.message(
      'Sales Comparison',
      name: 'salesComparison',
      desc: '',
      args: [],
    );
  }

  /// `Smart Filter Data`
  String get smartFilterData {
    return Intl.message(
      'Smart Filter Data',
      name: 'smartFilterData',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Comparison`
  String get monthlyComparison {
    return Intl.message(
      'Monthly Comparison',
      name: 'monthlyComparison',
      desc: '',
      args: [],
    );
  }

  /// `Branch Comparison`
  String get branchComparison {
    return Intl.message(
      'Branch Comparison',
      name: 'branchComparison',
      desc: '',
      args: [],
    );
  }

  /// `Smart Branch Comparisons`
  String get smartBranchComparisons {
    return Intl.message(
      'Smart Branch Comparisons',
      name: 'smartBranchComparisons',
      desc: '',
      args: [],
    );
  }

  /// `Primary Branch:`
  String get primaryBranch {
    return Intl.message(
      'Primary Branch:',
      name: 'primaryBranch',
      desc: '',
      args: [],
    );
  }

  /// `Amounts Calculated But Not Received:`
  String get amountsCalculatedButNotReceived {
    return Intl.message(
      'Amounts Calculated But Not Received:',
      name: 'amountsCalculatedButNotReceived',
      desc: '',
      args: [],
    );
  }

  /// `Pending sales (Apps)`
  String get pendingSalesApps {
    return Intl.message(
      'Pending sales (Apps)',
      name: 'pendingSalesApps',
      desc: '',
      args: [],
    );
  }

  /// `Paid Cash But Not Fully Shown in Profits:`
  String get paidCashButNotFullyShownInProfits {
    return Intl.message(
      'Paid Cash But Not Fully Shown in Profits:',
      name: 'paidCashButNotFullyShownInProfits',
      desc: '',
      args: [],
    );
  }

  /// `Rent paid:`
  String get rentPaid {
    return Intl.message('Rent paid:', name: 'rentPaid', desc: '', args: []);
  }

  /// `Previous expense reconciliation:`
  String get previousExpenseReconciliation {
    return Intl.message(
      'Previous expense reconciliation:',
      name: 'previousExpenseReconciliation',
      desc: '',
      args: [],
    );
  }

  /// `Advances/Fixed assets:`
  String get advancesfixedAssets {
    return Intl.message(
      'Advances/Fixed assets:',
      name: 'advancesfixedAssets',
      desc: '',
      args: [],
    );
  }

  /// `Zakat/Taxes:`
  String get zakattaxes {
    return Intl.message('Zakat/Taxes:', name: 'zakattaxes', desc: '', args: []);
  }

  /// `Unused inventory:`
  String get unusedInventory {
    return Intl.message(
      'Unused inventory:',
      name: 'unusedInventory',
      desc: '',
      args: [],
    );
  }

  /// `Depreciation, etc`
  String get depreciationEtc {
    return Intl.message(
      'Depreciation, etc',
      name: 'depreciationEtc',
      desc: '',
      args: [],
    );
  }

  /// `Non-Cash Expenses`
  String get noncashExpenses {
    return Intl.message(
      'Non-Cash Expenses',
      name: 'noncashExpenses',
      desc: '',
      args: [],
    );
  }

  /// `Supplier invoices:`
  String get supplierInvoices {
    return Intl.message(
      'Supplier invoices:',
      name: 'supplierInvoices',
      desc: '',
      args: [],
    );
  }

  /// `Accrued salaries:`
  String get accruedSalaries {
    return Intl.message(
      'Accrued salaries:',
      name: 'accruedSalaries',
      desc: '',
      args: [],
    );
  }

  /// `Obligations Not Yet Paid`
  String get obligationsNotYetPaid {
    return Intl.message(
      'Obligations Not Yet Paid',
      name: 'obligationsNotYetPaid',
      desc: '',
      args: [],
    );
  }

  /// `Final Result`
  String get finalResult {
    return Intl.message(
      'Final Result',
      name: 'finalResult',
      desc: '',
      args: [],
    );
  }

  /// `Your Expected Cash`
  String get yourExpectedCash {
    return Intl.message(
      'Your Expected Cash',
      name: 'yourExpectedCash',
      desc: '',
      args: [],
    );
  }

  /// `You have unpaid invoices and salaries`
  String get youHaveUnpaidInvoicesAndSalaries {
    return Intl.message(
      'You have unpaid invoices and salaries',
      name: 'youHaveUnpaidInvoicesAndSalaries',
      desc: '',
      args: [],
    );
  }

  /// `Bought goods still in inventory`
  String get boughtGoodsStillInInventory {
    return Intl.message(
      'Bought goods still in inventory',
      name: 'boughtGoodsStillInInventory',
      desc: '',
      args: [],
    );
  }

  /// `Paid advances and expenses not fully counted`
  String get paidAdvancesAndExpensesNotFullyCounted {
    return Intl.message(
      'Paid advances and expenses not fully counted',
      name: 'paidAdvancesAndExpensesNotFullyCounted',
      desc: '',
      args: [],
    );
  }

  /// `Part of your profits stuck in apps`
  String get partOfYourProfitsStuckInApps {
    return Intl.message(
      'Part of your profits stuck in apps',
      name: 'partOfYourProfitsStuckInApps',
      desc: '',
      args: [],
    );
  }

  /// `Pending Sales Overview`
  String get pendingSalesOverview {
    return Intl.message(
      'Pending Sales Overview',
      name: 'pendingSalesOverview',
      desc: '',
      args: [],
    );
  }

  /// `Track and manage outstanding sales for your Store.`
  String get trackAndManageOutstandingSalesForYourStore {
    return Intl.message(
      'Track and manage outstanding sales for your Store.',
      name: 'trackAndManageOutstandingSalesForYourStore',
      desc: '',
      args: [],
    );
  }

  /// `Reason for pending sales`
  String get reasonForPendingSales {
    return Intl.message(
      'Reason for pending sales',
      name: 'reasonForPendingSales',
      desc: '',
      args: [],
    );
  }

  /// `Total Pending Amounts`
  String get totalPendingAmounts {
    return Intl.message(
      'Total Pending Amounts',
      name: 'totalPendingAmounts',
      desc: '',
      args: [],
    );
  }

  /// `Total Pending`
  String get totalPending {
    return Intl.message(
      'Total Pending',
      name: 'totalPending',
      desc: '',
      args: [],
    );
  }

  /// `Inventory Details`
  String get inventoryDetails {
    return Intl.message(
      'Inventory Details',
      name: 'inventoryDetails',
      desc: '',
      args: [],
    );
  }

  /// `Total Unused Inventory`
  String get totalUnusedInventory {
    return Intl.message(
      'Total Unused Inventory',
      name: 'totalUnusedInventory',
      desc: '',
      args: [],
    );
  }

  /// `Total Inventory`
  String get totalInventory {
    return Intl.message(
      'Total Inventory',
      name: 'totalInventory',
      desc: '',
      args: [],
    );
  }

  /// `Supplier Obligations Details`
  String get supplierObligationsDetails {
    return Intl.message(
      'Supplier Obligations Details',
      name: 'supplierObligationsDetails',
      desc: '',
      args: [],
    );
  }

  /// `Total Obligations`
  String get totalObligations {
    return Intl.message(
      'Total Obligations',
      name: 'totalObligations',
      desc: '',
      args: [],
    );
  }

  /// `Reason for obligations`
  String get reasonForObligations {
    return Intl.message(
      'Reason for obligations',
      name: 'reasonForObligations',
      desc: '',
      args: [],
    );
  }

  /// `Reason for pending Amounts`
  String get reasonForPendingAmounts {
    return Intl.message(
      'Reason for pending Amounts',
      name: 'reasonForPendingAmounts',
      desc: '',
      args: [],
    );
  }

  /// `Accrued Salaries Details`
  String get accruedSalariesDetails {
    return Intl.message(
      'Accrued Salaries Details',
      name: 'accruedSalariesDetails',
      desc: '',
      args: [],
    );
  }

  /// `Reason for Accruals`
  String get reasonForAccruals {
    return Intl.message(
      'Reason for Accruals',
      name: 'reasonForAccruals',
      desc: '',
      args: [],
    );
  }

  /// `Total Accrued Salaries`
  String get totalAccruedSalaries {
    return Intl.message(
      'Total Accrued Salaries',
      name: 'totalAccruedSalaries',
      desc: '',
      args: [],
    );
  }

  /// `Total Due`
  String get totalDue {
    return Intl.message('Total Due', name: 'totalDue', desc: '', args: []);
  }

  /// `Depreciation`
  String get depreciation {
    return Intl.message(
      'Depreciation',
      name: 'depreciation',
      desc: '',
      args: [],
    );
  }

  /// `Others`
  String get others {
    return Intl.message('Others', name: 'others', desc: '', args: []);
  }

  /// `Total Non-Cash Expenses`
  String get totalNoncashExpenses {
    return Intl.message(
      'Total Non-Cash Expenses',
      name: 'totalNoncashExpenses',
      desc: '',
      args: [],
    );
  }

  /// `Your Monthly Profits`
  String get yourMonthlyProfits {
    return Intl.message(
      'Your Monthly Profits',
      name: 'yourMonthlyProfits',
      desc: '',
      args: [],
    );
  }

  /// `Your Current Cash`
  String get yourCurrentCash {
    return Intl.message(
      'Your Current Cash',
      name: 'yourCurrentCash',
      desc: '',
      args: [],
    );
  }

  /// `Analysis Settings:`
  String get analysisSettings {
    return Intl.message(
      'Analysis Settings:',
      name: 'analysisSettings',
      desc: '',
      args: [],
    );
  }

  /// `Financial Safety Status:`
  String get financialSafetyStatus {
    return Intl.message(
      'Financial Safety Status:',
      name: 'financialSafetyStatus',
      desc: '',
      args: [],
    );
  }

  /// `Very safe`
  String get verySafe {
    return Intl.message('Very safe', name: 'verySafe', desc: '', args: []);
  }

  /// `Safe`
  String get safe {
    return Intl.message('Safe', name: 'safe', desc: '', args: []);
  }

  /// `At Break even`
  String get atBreakEven {
    return Intl.message(
      'At Break even',
      name: 'atBreakEven',
      desc: '',
      args: [],
    );
  }

  /// `Risk`
  String get risk {
    return Intl.message('Risk', name: 'risk', desc: '', args: []);
  }

  /// `High Risk`
  String get highRisk {
    return Intl.message('High Risk', name: 'highRisk', desc: '', args: []);
  }

  /// `Vs June:`
  String get vsJune {
    return Intl.message('Vs June:', name: 'vsJune', desc: '', args: []);
  }

  /// `Above break-even by`
  String get aboveBreakevenBy {
    return Intl.message(
      'Above break-even by',
      name: 'aboveBreakevenBy',
      desc: '',
      args: [],
    );
  }

  /// `Your current sales`
  String get yourCurrentSales {
    return Intl.message(
      'Your current sales',
      name: 'yourCurrentSales',
      desc: '',
      args: [],
    );
  }

  /// `Break-even point`
  String get breakevenPoint {
    return Intl.message(
      'Break-even point',
      name: 'breakevenPoint',
      desc: '',
      args: [],
    );
  }

  /// `Automatic Calculation Details`
  String get automaticCalculationDetails {
    return Intl.message(
      'Automatic Calculation Details',
      name: 'automaticCalculationDetails',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Fixed Costs`
  String get monthlyFixedCosts {
    return Intl.message(
      'Monthly Fixed Costs',
      name: 'monthlyFixedCosts',
      desc: '',
      args: [],
    );
  }

  /// `Rent and utilities:`
  String get rentAndUtilities {
    return Intl.message(
      'Rent and utilities:',
      name: 'rentAndUtilities',
      desc: '',
      args: [],
    );
  }

  /// `salaries:`
  String get salaries {
    return Intl.message('salaries:', name: 'salaries', desc: '', args: []);
  }

  /// `Insurance and licenses:`
  String get insuranceAndLicenses {
    return Intl.message(
      'Insurance and licenses:',
      name: 'insuranceAndLicenses',
      desc: '',
      args: [],
    );
  }

  /// `Total Fixed`
  String get totalFixed {
    return Intl.message('Total Fixed', name: 'totalFixed', desc: '', args: []);
  }

  /// `Gross profit margin:`
  String get grossProfitMargin {
    return Intl.message(
      'Gross profit margin:',
      name: 'grossProfitMargin',
      desc: '',
      args: [],
    );
  }

  /// `Variable costs:`
  String get variableCosts {
    return Intl.message(
      'Variable costs:',
      name: 'variableCosts',
      desc: '',
      args: [],
    );
  }

  /// `Contribution Margin`
  String get contributionMargin {
    return Intl.message(
      'Contribution Margin',
      name: 'contributionMargin',
      desc: '',
      args: [],
    );
  }

  /// `Formula:`
  String get formula {
    return Intl.message('Formula:', name: 'formula', desc: '', args: []);
  }

  /// `What if conditions change?`
  String get whatIfConditionsChange {
    return Intl.message(
      'What if conditions change?',
      name: 'whatIfConditionsChange',
      desc: '',
      args: [],
    );
  }

  /// `Scenario Analysis - Interactive Chart`
  String get scenarioAnalysisInteractiveChart {
    return Intl.message(
      'Scenario Analysis - Interactive Chart',
      name: 'scenarioAnalysisInteractiveChart',
      desc: '',
      args: [],
    );
  }

  /// `Interactive chart for risk assessment:`
  String get interactiveChartForRiskAssessment {
    return Intl.message(
      'Interactive chart for risk assessment:',
      name: 'interactiveChartForRiskAssessment',
      desc: '',
      args: [],
    );
  }

  /// `Key Performance Indicators`
  String get keyPerformanceIndicators {
    return Intl.message(
      'Key Performance Indicators',
      name: 'keyPerformanceIndicators',
      desc: '',
      args: [],
    );
  }

  /// `Core Profitability Indicators`
  String get coreProfitabilityIndicators {
    return Intl.message(
      'Core Profitability Indicators',
      name: 'coreProfitabilityIndicators',
      desc: '',
      args: [],
    );
  }

  /// `Operational Efficiency Indicators`
  String get operationalEfficiencyIndicators {
    return Intl.message(
      'Operational Efficiency Indicators',
      name: 'operationalEfficiencyIndicators',
      desc: '',
      args: [],
    );
  }

  /// `Employee`
  String get employee {
    return Intl.message('Employee', name: 'employee', desc: '', args: []);
  }

  /// `Labor cost`
  String get laborCost {
    return Intl.message('Labor cost', name: 'laborCost', desc: '', args: []);
  }

  /// `Inventory Turnover`
  String get inventoryTurnover {
    return Intl.message(
      'Inventory Turnover',
      name: 'inventoryTurnover',
      desc: '',
      args: [],
    );
  }

  /// `Average Transaction Value`
  String get averageTransactionValue {
    return Intl.message(
      'Average Transaction Value',
      name: 'averageTransactionValue',
      desc: '',
      args: [],
    );
  }

  /// `Industry Benchmark Comparison`
  String get industryBenchmarkComparison {
    return Intl.message(
      'Industry Benchmark Comparison',
      name: 'industryBenchmarkComparison',
      desc: '',
      args: [],
    );
  }

  /// `Productivity Per Employee`
  String get productivityPerEmployee {
    return Intl.message(
      'Productivity Per Employee',
      name: 'productivityPerEmployee',
      desc: '',
      args: [],
    );
  }

  /// `EBITDA`
  String get ebitda {
    return Intl.message('EBITDA', name: 'ebitda', desc: '', args: []);
  }

  /// `Operating Profit`
  String get operatingProfit {
    return Intl.message(
      'Operating Profit',
      name: 'operatingProfit',
      desc: '',
      args: [],
    );
  }

  /// `Return On Sales`
  String get returnOnSales {
    return Intl.message(
      'Return On Sales',
      name: 'returnOnSales',
      desc: '',
      args: [],
    );
  }

  /// `Your Restaurant`
  String get yourRestaurant {
    return Intl.message(
      'Your Restaurant',
      name: 'yourRestaurant',
      desc: '',
      args: [],
    );
  }

  /// `Industry`
  String get industry {
    return Intl.message('Industry', name: 'industry', desc: '', args: []);
  }

  /// `Overview - Matrix`
  String get overviewMatrix {
    return Intl.message(
      'Overview - Matrix',
      name: 'overviewMatrix',
      desc: '',
      args: [],
    );
  }

  /// `Item distribution by performance`
  String get itemDistributionByPerformance {
    return Intl.message(
      'Item distribution by performance',
      name: 'itemDistributionByPerformance',
      desc: '',
      args: [],
    );
  }

  /// `High Profitability`
  String get highProfitability {
    return Intl.message(
      'High Profitability',
      name: 'highProfitability',
      desc: '',
      args: [],
    );
  }

  /// `🧩 Puzzles`
  String get puzzles {
    return Intl.message('🧩 Puzzles', name: 'puzzles', desc: '', args: []);
  }

  /// `⭐ Stars`
  String get stars {
    return Intl.message('⭐ Stars', name: 'stars', desc: '', args: []);
  }

  /// `Low Profitability`
  String get lowProfitability {
    return Intl.message(
      'Low Profitability',
      name: 'lowProfitability',
      desc: '',
      args: [],
    );
  }

  /// `🐕 Dogs`
  String get dogs {
    return Intl.message('🐕 Dogs', name: 'dogs', desc: '', args: []);
  }

  /// `🐎 Workhorses`
  String get workhorses {
    return Intl.message(
      '🐎 Workhorses',
      name: 'workhorses',
      desc: '',
      args: [],
    );
  }

  /// `Category Analysis`
  String get categoryAnalysis {
    return Intl.message(
      'Category Analysis',
      name: 'categoryAnalysis',
      desc: '',
      args: [],
    );
  }

  /// `Average profitability:`
  String get averageProfitability {
    return Intl.message(
      'Average profitability:',
      name: 'averageProfitability',
      desc: '',
      args: [],
    );
  }

  /// `Review breakdown of the selected category lists:`
  String get reviewBreakdownOfTheSelectedCategoryLists {
    return Intl.message(
      'Review breakdown of the selected category lists:',
      name: 'reviewBreakdownOfTheSelectedCategoryLists',
      desc: '',
      args: [],
    );
  }

  /// `List Breakdown`
  String get listBreakdown {
    return Intl.message(
      'List Breakdown',
      name: 'listBreakdown',
      desc: '',
      args: [],
    );
  }

  /// `Profit %`
  String get profit {
    return Intl.message('Profit %', name: 'profit', desc: '', args: []);
  }

  /// `Sales%`
  String get salesPersintage {
    return Intl.message('Sales%', name: 'salesPersintage', desc: '', args: []);
  }

  /// `Share Report`
  String get shareReport {
    return Intl.message(
      'Share Report',
      name: 'shareReport',
      desc: '',
      args: [],
    );
  }

  /// `Enter an email address, and we’ll send this Smart Branch Level 2 to it.`
  String get enterAnEmailAddressAndWellSendThisSmartBranch {
    return Intl.message(
      'Enter an email address, and we’ll send this Smart Branch Level 2 to it.',
      name: 'enterAnEmailAddressAndWellSendThisSmartBranch',
      desc: '',
      args: [],
    );
  }

  /// `Send Report to email`
  String get sendReportToEmail {
    return Intl.message(
      'Send Report to email',
      name: 'sendReportToEmail',
      desc: '',
      args: [],
    );
  }

  /// `Report sent to email successfully`
  String get reportSentToEmailSuccessfully {
    return Intl.message(
      'Report sent to email successfully',
      name: 'reportSentToEmailSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Forecast Revenue & Profit Margins`
  String get forecastRevenueProfitMargins {
    return Intl.message(
      'Forecast Revenue & Profit Margins',
      name: 'forecastRevenueProfitMargins',
      desc: '',
      args: [],
    );
  }

  /// `Price Simulator`
  String get priceSimulator {
    return Intl.message(
      'Price Simulator',
      name: 'priceSimulator',
      desc: '',
      args: [],
    );
  }

  /// `Simulation Settings`
  String get simulationSettings {
    return Intl.message(
      'Simulation Settings',
      name: 'simulationSettings',
      desc: '',
      args: [],
    );
  }

  /// `Select Item:`
  String get selectItem {
    return Intl.message('Select Item:', name: 'selectItem', desc: '', args: []);
  }

  /// `Search for and choose sales items for this test`
  String get searchForAndChooseSalesItemsForThisTest {
    return Intl.message(
      'Search for and choose sales items for this test',
      name: 'searchForAndChooseSalesItemsForThisTest',
      desc: '',
      args: [],
    );
  }

  /// `Item Data`
  String get itemData {
    return Intl.message('Item Data', name: 'itemData', desc: '', args: []);
  }

  /// `Expected growth`
  String get expectedGrowth {
    return Intl.message(
      'Expected growth',
      name: 'expectedGrowth',
      desc: '',
      args: [],
    );
  }

  /// `Change Price:`
  String get changePrice {
    return Intl.message(
      'Change Price:',
      name: 'changePrice',
      desc: '',
      args: [],
    );
  }

  /// `Expected Growth/Decline`
  String get expectedGrowthdecline {
    return Intl.message(
      'Expected Growth/Decline',
      name: 'expectedGrowthdecline',
      desc: '',
      args: [],
    );
  }

  /// `Current monthly sales`
  String get currentMonthlySales {
    return Intl.message(
      'Current monthly sales',
      name: 'currentMonthlySales',
      desc: '',
      args: [],
    );
  }

  /// `Production cost`
  String get productionCost {
    return Intl.message(
      'Production cost',
      name: 'productionCost',
      desc: '',
      args: [],
    );
  }

  /// `Current selling price`
  String get currentSellingPrice {
    return Intl.message(
      'Current selling price',
      name: 'currentSellingPrice',
      desc: '',
      args: [],
    );
  }

  /// `What is `
  String get whatIs {
    return Intl.message('What is ', name: 'whatIs', desc: '', args: []);
  }

  /// `“Change Price”?`
  String get changePrice_c {
    return Intl.message(
      '“Change Price”?',
      name: 'changePrice_c',
      desc: '',
      args: [],
    );
  }

  /// `Increase the current price of a selected item by a set amount to see how it could affect your future revenue and profit margins.`
  String get increaseTheCurrentPriceOfASelectedItemByA {
    return Intl.message(
      'Increase the current price of a selected item by a set amount to see how it could affect your future revenue and profit margins.',
      name: 'increaseTheCurrentPriceOfASelectedItemByA',
      desc: '',
      args: [],
    );
  }

  /// `What Is Change Price?`
  String get whatIsChangePrice {
    return Intl.message(
      'What Is Change Price?',
      name: 'whatIsChangePrice',
      desc: '',
      args: [],
    );
  }

  /// `New Simulation`
  String get newSimulation {
    return Intl.message(
      'New Simulation',
      name: 'newSimulation',
      desc: '',
      args: [],
    );
  }

  /// `Simulate Change`
  String get simulateChange {
    return Intl.message(
      'Simulate Change',
      name: 'simulateChange',
      desc: '',
      args: [],
    );
  }

  /// `Simulation Complete`
  String get simulationComplete {
    return Intl.message(
      'Simulation Complete',
      name: 'simulationComplete',
      desc: '',
      args: [],
    );
  }

  /// `Simulation Results`
  String get simulationResults {
    return Intl.message(
      'Simulation Results',
      name: 'simulationResults',
      desc: '',
      args: [],
    );
  }

  /// `Save Scenario`
  String get saveScenario {
    return Intl.message(
      'Save Scenario',
      name: 'saveScenario',
      desc: '',
      args: [],
    );
  }

  /// `New price`
  String get newPrice {
    return Intl.message('New price', name: 'newPrice', desc: '', args: []);
  }

  /// `Expected sales`
  String get expectedSales {
    return Intl.message(
      'Expected sales',
      name: 'expectedSales',
      desc: '',
      args: [],
    );
  }

  /// `New unit profit`
  String get newUnitProfit {
    return Intl.message(
      'New unit profit',
      name: 'newUnitProfit',
      desc: '',
      args: [],
    );
  }

  /// `New monthly profit`
  String get newMonthlyProfit {
    return Intl.message(
      'New monthly profit',
      name: 'newMonthlyProfit',
      desc: '',
      args: [],
    );
  }

  /// `Profit change`
  String get profitChange {
    return Intl.message(
      'Profit change',
      name: 'profitChange',
      desc: '',
      args: [],
    );
  }

  /// `Simulation Data`
  String get simulationData {
    return Intl.message(
      'Simulation Data',
      name: 'simulationData',
      desc: '',
      args: [],
    );
  }

  /// `Simulation Item Data`
  String get simulationItemData {
    return Intl.message(
      'Simulation Item Data',
      name: 'simulationItemData',
      desc: '',
      args: [],
    );
  }

  /// `Saved scenarios ({count})`
  String savedScenariosCount(Object count) {
    return Intl.message(
      'Saved scenarios ($count)',
      name: 'savedScenariosCount',
      desc: '',
      args: [count],
    );
  }

  /// `Review and export previously saved scenarios.`
  String get reviewAndExportPreviouslySavedScenarios {
    return Intl.message(
      'Review and export previously saved scenarios.',
      name: 'reviewAndExportPreviouslySavedScenarios',
      desc: '',
      args: [],
    );
  }

  /// `Saved Scenario Result`
  String get savedScenarioResult {
    return Intl.message(
      'Saved Scenario Result',
      name: 'savedScenarioResult',
      desc: '',
      args: [],
    );
  }

  /// `Item Testing`
  String get itemTesting {
    return Intl.message(
      'Item Testing',
      name: 'itemTesting',
      desc: '',
      args: [],
    );
  }

  /// `Start Test`
  String get startTest {
    return Intl.message('Start Test', name: 'startTest', desc: '', args: []);
  }

  /// `New Test`
  String get newTest {
    return Intl.message('New Test', name: 'newTest', desc: '', args: []);
  }

  /// `Item type:`
  String get itemType {
    return Intl.message('Item type:', name: 'itemType', desc: '', args: []);
  }

  /// `Expected Selling Price`
  String get expectedSellingPrice {
    return Intl.message(
      'Expected Selling Price',
      name: 'expectedSellingPrice',
      desc: '',
      args: [],
    );
  }

  /// `Enter Name`
  String get enterName {
    return Intl.message('Enter Name', name: 'enterName', desc: '', args: []);
  }

  /// `Test Results`
  String get testResults {
    return Intl.message(
      'Test Results',
      name: 'testResults',
      desc: '',
      args: [],
    );
  }

  /// `Expected monthly profit`
  String get expectedMonthlyProfit {
    return Intl.message(
      'Expected monthly profit',
      name: 'expectedMonthlyProfit',
      desc: '',
      args: [],
    );
  }

  /// `Expected Classification`
  String get expectedClassification {
    return Intl.message(
      'Expected Classification',
      name: 'expectedClassification',
      desc: '',
      args: [],
    );
  }

  /// `Menu impact`
  String get menuImpact {
    return Intl.message('Menu impact', name: 'menuImpact', desc: '', args: []);
  }

  /// `Test Data`
  String get testData {
    return Intl.message('Test Data', name: 'testData', desc: '', args: []);
  }

  /// `Test Item Data`
  String get testItemData {
    return Intl.message(
      'Test Item Data',
      name: 'testItemData',
      desc: '',
      args: [],
    );
  }

  /// `Test Completed.`
  String get testCompleted {
    return Intl.message(
      'Test Completed.',
      name: 'testCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Saved Tests ({count})`
  String savedTestsCount(Object count) {
    return Intl.message(
      'Saved Tests ($count)',
      name: 'savedTestsCount',
      desc: '',
      args: [count],
    );
  }

  /// `Saved Test Result`
  String get savedTestResult {
    return Intl.message(
      'Saved Test Result',
      name: 'savedTestResult',
      desc: '',
      args: [],
    );
  }

  /// `Physical Counted Cash`
  String get physicalCountedCash {
    return Intl.message(
      'Physical Counted Cash',
      name: 'physicalCountedCash',
      desc: '',
      args: [],
    );
  }

  /// `Enter actual cash in drawer`
  String get physicalCountedCashHint {
    return Intl.message(
      'Enter actual cash in drawer',
      name: 'physicalCountedCashHint',
      desc: '',
      args: [],
    );
  }

  /// `Physical counted cash is required`
  String get physicalCountedCashRequired {
    return Intl.message(
      'Physical counted cash is required',
      name: 'physicalCountedCashRequired',
      desc: '',
      args: [],
    );
  }

  /// `Shortage Allocation Required`
  String get shortageAllocationTitle {
    return Intl.message(
      'Shortage Allocation Required',
      name: 'shortageAllocationTitle',
      desc: '',
      args: [],
    );
  }

  /// `You must allocate the shortage amount across the responsible parties before closing the shift.`
  String get shortageAllocationDesc {
    return Intl.message(
      'You must allocate the shortage amount across the responsible parties before closing the shift.',
      name: 'shortageAllocationDesc',
      desc: '',
      args: [],
    );
  }

  /// `Shortage to Allocate:`
  String get shortageToAllocate {
    return Intl.message(
      'Shortage to Allocate:',
      name: 'shortageToAllocate',
      desc: '',
      args: [],
    );
  }

  /// `Remaining to Allocate:`
  String get remainingToAllocate {
    return Intl.message(
      'Remaining to Allocate:',
      name: 'remainingToAllocate',
      desc: '',
      args: [],
    );
  }

  /// `Remaining amount must be 0.00 SAR`
  String get allocationIncomplete {
    return Intl.message(
      'Remaining amount must be 0.00 SAR',
      name: 'allocationIncomplete',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
