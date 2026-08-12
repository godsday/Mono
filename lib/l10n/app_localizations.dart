import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_hi.dart';

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
    Locale('en'),
    Locale('es'),
    Locale('hi')
  ];

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Hi, Welcome!'**
  String get welcome;

  /// No description provided for @total_balance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get total_balance;

  /// No description provided for @currency_symbol.
  ///
  /// In en, this message translates to:
  /// **'₹'**
  String get currency_symbol;

  /// No description provided for @onboarding_title.
  ///
  /// In en, this message translates to:
  /// **'Small Steps. Better Habits'**
  String get onboarding_title;

  /// No description provided for @onboarding_subtitle.
  ///
  /// In en, this message translates to:
  /// **'A simple way to stay aware of your daily spending.'**
  String get onboarding_subtitle;

  /// No description provided for @enter_name_hint.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get enter_name_hint;

  /// No description provided for @get_started.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get get_started;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// No description provided for @settings_notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get settings_notification;

  /// No description provided for @settings_dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settings_dark_mode;

  /// No description provided for @settings_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// No description provided for @settings_currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get settings_currency;

  /// No description provided for @settings_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settings_about;

  /// No description provided for @settings_support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get settings_support;

  /// No description provided for @settings_secure_data.
  ///
  /// In en, this message translates to:
  /// **'Secure Data'**
  String get settings_secure_data;

  /// No description provided for @settings_reset_app.
  ///
  /// In en, this message translates to:
  /// **'Reset App'**
  String get settings_reset_app;

  /// No description provided for @settings_reset_alert_title.
  ///
  /// In en, this message translates to:
  /// **'Alert!!!'**
  String get settings_reset_alert_title;

  /// No description provided for @settings_reset_alert_subtitle.
  ///
  /// In en, this message translates to:
  /// **'All transaction details will be deleted.\n\nDo you like to continue ?'**
  String get settings_reset_alert_subtitle;

  /// No description provided for @add_transaction_title.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add_transaction_title;

  /// No description provided for @edit_transaction_title.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit_transaction_title;

  /// No description provided for @transaction_type.
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get transaction_type;

  /// No description provided for @transaction_type_expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get transaction_type_expense;

  /// No description provided for @transaction_type_income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get transaction_type_income;

  /// No description provided for @transaction_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get transaction_amount;

  /// No description provided for @transaction_amount_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter Amount'**
  String get transaction_amount_hint;

  /// No description provided for @transaction_date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get transaction_date;

  /// No description provided for @transaction_categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get transaction_categories;

  /// No description provided for @transaction_category_hint.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get transaction_category_hint;

  /// No description provided for @transaction_no_categories.
  ///
  /// In en, this message translates to:
  /// **'No categories available'**
  String get transaction_no_categories;

  /// No description provided for @transaction_notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get transaction_notes;

  /// No description provided for @transaction_notes_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter Notes'**
  String get transaction_notes_hint;

  /// No description provided for @transaction_record_button.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get transaction_record_button;

  /// No description provided for @transaction_update_button.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get transaction_update_button;

  /// No description provided for @error_enter_amount.
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get error_enter_amount;

  /// No description provided for @error_valid_number.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get error_valid_number;

  /// No description provided for @error_select_category.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get error_select_category;

  /// No description provided for @home_title.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home_title;

  /// No description provided for @transactions_title.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions_title;

  /// No description provided for @budget_title.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget_title;

  /// No description provided for @analytics_title.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics_title;

  /// No description provided for @home_greeting_prefix.
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get home_greeting_prefix;

  /// No description provided for @total_balance_title.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get total_balance_title;

  /// No description provided for @balance_is_zero.
  ///
  /// In en, this message translates to:
  /// **'is Zero'**
  String get balance_is_zero;

  /// No description provided for @balance_overspent.
  ///
  /// In en, this message translates to:
  /// **'Over Spent'**
  String get balance_overspent;

  /// No description provided for @this_month_toggle.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get this_month_toggle;

  /// No description provided for @higher_than_last_month.
  ///
  /// In en, this message translates to:
  /// **'higher compared to last month'**
  String get higher_than_last_month;

  /// No description provided for @compared_to_last_month.
  ///
  /// In en, this message translates to:
  /// **'compared to last month'**
  String get compared_to_last_month;

  /// No description provided for @earnings_label.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings_label;

  /// No description provided for @spendings_label.
  ///
  /// In en, this message translates to:
  /// **'Spendings'**
  String get spendings_label;

  /// No description provided for @you_saved_prefix.
  ///
  /// In en, this message translates to:
  /// **'You saved'**
  String get you_saved_prefix;

  /// No description provided for @extra_saved_suffix.
  ///
  /// In en, this message translates to:
  /// **'extra'**
  String get extra_saved_suffix;

  /// No description provided for @greeting_morning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get greeting_morning;

  /// No description provided for @greeting_afternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get greeting_afternoon;

  /// No description provided for @greeting_evening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get greeting_evening;

  /// No description provided for @spending_cycle_label.
  ///
  /// In en, this message translates to:
  /// **'Spending Cycle'**
  String get spending_cycle_label;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'mono'**
  String get app_name;

  /// No description provided for @edit_budget_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Monthly Budget'**
  String get edit_budget_title;

  /// No description provided for @set_budget_title.
  ///
  /// In en, this message translates to:
  /// **'Set Monthly Budget'**
  String get set_budget_title;

  /// No description provided for @plan_spending_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Plan your spending for this month'**
  String get plan_spending_subtitle;

  /// No description provided for @allocate_by_category.
  ///
  /// In en, this message translates to:
  /// **'Allocate by Category'**
  String get allocate_by_category;

  /// No description provided for @no_expense_categories.
  ///
  /// In en, this message translates to:
  /// **'No expense categories found.'**
  String get no_expense_categories;

  /// No description provided for @total_monthly_budget_label.
  ///
  /// In en, this message translates to:
  /// **'Total Monthly Budget'**
  String get total_monthly_budget_label;

  /// No description provided for @recommended_budget_hint.
  ///
  /// In en, this message translates to:
  /// **'Recommended: 70–80% of income'**
  String get recommended_budget_hint;

  /// No description provided for @over_budget_label.
  ///
  /// In en, this message translates to:
  /// **'Over Budget'**
  String get over_budget_label;

  /// No description provided for @remaining_to_allocate_label.
  ///
  /// In en, this message translates to:
  /// **'Remaining to Allocate'**
  String get remaining_to_allocate_label;

  /// No description provided for @update_budget_button.
  ///
  /// In en, this message translates to:
  /// **'Update Budget'**
  String get update_budget_button;

  /// No description provided for @save_budget_button.
  ///
  /// In en, this message translates to:
  /// **'Save Budget'**
  String get save_budget_button;

  /// No description provided for @budget_category_allocation_title.
  ///
  /// In en, this message translates to:
  /// **'Budget Category Allocation'**
  String get budget_category_allocation_title;

  /// No description provided for @budget_category_allocation_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Allocate your budget across different categories'**
  String get budget_category_allocation_subtitle;

  /// No description provided for @budget_category_allocation_remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get budget_category_allocation_remaining;

  /// No description provided for @budget_category_allocation_spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get budget_category_allocation_spent;

  /// No description provided for @budget_category_allocation_budgeted.
  ///
  /// In en, this message translates to:
  /// **'Budgeted'**
  String get budget_category_allocation_budgeted;

  /// No description provided for @budget_category_allocation_no_categories.
  ///
  /// In en, this message translates to:
  /// **'No categories to allocate budget'**
  String get budget_category_allocation_no_categories;

  /// No description provided for @budget_category_allocation_save_button.
  ///
  /// In en, this message translates to:
  /// **'Save Allocation'**
  String get budget_category_allocation_save_button;

  /// No description provided for @analytics_chart_title_expense_trend.
  ///
  /// In en, this message translates to:
  /// **'Expense Trend'**
  String get analytics_chart_title_expense_trend;

  /// No description provided for @analytics_chart_title_net_worth.
  ///
  /// In en, this message translates to:
  /// **'Net Worth'**
  String get analytics_chart_title_net_worth;

  /// No description provided for @analytics_chart_title_asset_allocation.
  ///
  /// In en, this message translates to:
  /// **'Asset Allocation'**
  String get analytics_chart_title_asset_allocation;

  /// No description provided for @analytics_chart_title_budget_discipline.
  ///
  /// In en, this message translates to:
  /// **'Budget Discipline'**
  String get analytics_chart_title_budget_discipline;

  /// No description provided for @no_expense_data.
  ///
  /// In en, this message translates to:
  /// **'No expense data'**
  String get no_expense_data;

  /// No description provided for @no_data_available.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get no_data_available;

  /// No description provided for @no_asset_data.
  ///
  /// In en, this message translates to:
  /// **'No asset data'**
  String get no_asset_data;

  /// No description provided for @no_budget_data.
  ///
  /// In en, this message translates to:
  /// **'No budget data'**
  String get no_budget_data;

  /// No description provided for @budget_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Budget: '**
  String get budget_tooltip;

  /// No description provided for @spent_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Spent: '**
  String get spent_tooltip;

  /// No description provided for @first_time_budget_title.
  ///
  /// In en, this message translates to:
  /// **'Plan Your Money Smarter'**
  String get first_time_budget_title;

  /// No description provided for @first_time_budget_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first monthly budget to track expenses and stay in control.'**
  String get first_time_budget_subtitle;

  /// No description provided for @first_time_budget_button.
  ///
  /// In en, this message translates to:
  /// **'Set Monthly Budget'**
  String get first_time_budget_button;

  /// No description provided for @first_time_goal_title.
  ///
  /// In en, this message translates to:
  /// **'What You\'re Working For'**
  String get first_time_goal_title;

  /// No description provided for @first_time_goal_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Turn your dreams into achievable goals'**
  String get first_time_goal_subtitle;

  /// No description provided for @first_time_goal_button.
  ///
  /// In en, this message translates to:
  /// **'Start Dreaming'**
  String get first_time_goal_button;

  /// No description provided for @first_time_goal_title_expanded.
  ///
  /// In en, this message translates to:
  /// **'Smart Goal Tracking'**
  String get first_time_goal_title_expanded;

  /// No description provided for @first_time_goal_feature_1.
  ///
  /// In en, this message translates to:
  /// **'Monthly savings recommendations.'**
  String get first_time_goal_feature_1;

  /// No description provided for @first_time_goal_feature_2.
  ///
  /// In en, this message translates to:
  /// **'Projected completion dates.'**
  String get first_time_goal_feature_2;

  /// No description provided for @first_time_goal_feature_3.
  ///
  /// In en, this message translates to:
  /// **'Milestone celebrations.'**
  String get first_time_goal_feature_3;

  /// No description provided for @first_time_goal_feature_4.
  ///
  /// In en, this message translates to:
  /// **'Real-time progress tracking.'**
  String get first_time_goal_feature_4;

  /// No description provided for @first_time_goal_coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Wealth Features Are Coming Soon'**
  String get first_time_goal_coming_soon;

  /// No description provided for @first_time_asset_title.
  ///
  /// In en, this message translates to:
  /// **'Track Your Assets'**
  String get first_time_asset_title;

  /// No description provided for @first_time_asset_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Add what you own to understand your net worth'**
  String get first_time_asset_subtitle;

  /// No description provided for @first_time_asset_button.
  ///
  /// In en, this message translates to:
  /// **'Add Assets'**
  String get first_time_asset_button;

  /// No description provided for @first_time_asset_title_expanded.
  ///
  /// In en, this message translates to:
  /// **'Asset & Net Worth Tracking'**
  String get first_time_asset_title_expanded;

  /// No description provided for @first_time_asset_feature_1.
  ///
  /// In en, this message translates to:
  /// **'Net worth growth chart'**
  String get first_time_asset_feature_1;

  /// No description provided for @first_time_asset_feature_2.
  ///
  /// In en, this message translates to:
  /// **'Asset allocation breakdown'**
  String get first_time_asset_feature_2;

  /// No description provided for @first_time_asset_feature_3.
  ///
  /// In en, this message translates to:
  /// **'Monthly growth insights'**
  String get first_time_asset_feature_3;

  /// No description provided for @first_time_asset_feature_4.
  ///
  /// In en, this message translates to:
  /// **'Long-term wealth tracking'**
  String get first_time_asset_feature_4;

  /// No description provided for @first_time_asset_notification.
  ///
  /// In en, this message translates to:
  /// **'Notify Me When It Launches'**
  String get first_time_asset_notification;

  /// No description provided for @hide_button.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide_button;

  /// No description provided for @show_button.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get show_button;

  /// No description provided for @recent_transactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Records'**
  String get recent_transactions;

  /// No description provided for @filter_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filter_all;

  /// No description provided for @filter_today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get filter_today;

  /// No description provided for @filter_weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get filter_weekly;

  /// No description provided for @filter_monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get filter_monthly;

  /// No description provided for @filter_custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get filter_custom;

  /// No description provided for @action_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get action_edit;

  /// No description provided for @action_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get action_delete;

  /// No description provided for @message_deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get message_deleted;

  /// No description provided for @financial_hub_title.
  ///
  /// In en, this message translates to:
  /// **'Financial Hub'**
  String get financial_hub_title;

  /// No description provided for @financial_hub_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your Budget, Assets & Dreams — all in one place'**
  String get financial_hub_subtitle;

  /// No description provided for @about_title.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about_title;

  /// No description provided for @section_legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get section_legal;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @terms_of_service.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get terms_of_service;

  /// No description provided for @section_community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get section_community;

  /// No description provided for @rate_the_app.
  ///
  /// In en, this message translates to:
  /// **'Rate the App'**
  String get rate_the_app;

  /// No description provided for @share_with_friends.
  ///
  /// In en, this message translates to:
  /// **'Share with Friends'**
  String get share_with_friends;

  /// No description provided for @share_text.
  ///
  /// In en, this message translates to:
  /// **'Check out the Mono App for better money management! https://example.com/monoapp'**
  String get share_text;

  /// No description provided for @app_tagline.
  ///
  /// In en, this message translates to:
  /// **'Know your spending. Grow your savings.'**
  String get app_tagline;

  /// No description provided for @version_loading.
  ///
  /// In en, this message translates to:
  /// **'Version ...'**
  String get version_loading;

  /// No description provided for @version_display.
  ///
  /// In en, this message translates to:
  /// **'Version {version} ({buildNumber})'**
  String version_display(Object buildNumber, Object version);

  /// No description provided for @made_with_love.
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ for better money habits'**
  String get made_with_love;

  /// No description provided for @support_title.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support_title;

  /// No description provided for @need_help_title.
  ///
  /// In en, this message translates to:
  /// **'Need Help?'**
  String get need_help_title;

  /// No description provided for @need_help_subtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'re here to help improve your experience.'**
  String get need_help_subtitle;

  /// No description provided for @contact_support.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contact_support;

  /// No description provided for @support_request_title.
  ///
  /// In en, this message translates to:
  /// **'Mono App Support Request'**
  String get support_request_title;

  /// No description provided for @support_request_body.
  ///
  /// In en, this message translates to:
  /// **'App Version:\nDevice:\nAndroid Version:\n\nDescribe your issue here...'**
  String get support_request_body;

  /// No description provided for @report_bug.
  ///
  /// In en, this message translates to:
  /// **'Report a Bug'**
  String get report_bug;

  /// No description provided for @bug_report_title.
  ///
  /// In en, this message translates to:
  /// **'Mono App Bug Report'**
  String get bug_report_title;

  /// No description provided for @bug_report_body.
  ///
  /// In en, this message translates to:
  /// **'App Version:\nDevice:\nAndroid Version:\n\nSteps to reproduce:\n1.\n2.\n3.\n\nExpected result:\nActual result:'**
  String get bug_report_body;

  /// No description provided for @request_feature.
  ///
  /// In en, this message translates to:
  /// **'Request Feature'**
  String get request_feature;

  /// No description provided for @feature_request_title.
  ///
  /// In en, this message translates to:
  /// **'Mono App Feature Request'**
  String get feature_request_title;

  /// No description provided for @feature_request_body.
  ///
  /// In en, this message translates to:
  /// **'Feature suggestion:\n\nWhy would this help you?'**
  String get feature_request_body;

  /// No description provided for @error_send_message.
  ///
  /// In en, this message translates to:
  /// **'Could not send message'**
  String get error_send_message;

  /// No description provided for @budget_overview_title.
  ///
  /// In en, this message translates to:
  /// **'Monthly Budget'**
  String get budget_overview_title;

  /// No description provided for @budget_set_for.
  ///
  /// In en, this message translates to:
  /// **'Budget set for {month}'**
  String budget_set_for(String month);

  /// No description provided for @budget_limit_exceeded.
  ///
  /// In en, this message translates to:
  /// **'You have exceeded your monthly budget!'**
  String get budget_limit_exceeded;

  /// No description provided for @budget_limit_warning.
  ///
  /// In en, this message translates to:
  /// **'Warning: You are approaching your budget limit.'**
  String get budget_limit_warning;

  /// No description provided for @budget_label_budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget_label_budget;

  /// No description provided for @budget_label_spending.
  ///
  /// In en, this message translates to:
  /// **'Spending'**
  String get budget_label_spending;

  /// No description provided for @budget_label_remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get budget_label_remaining;

  /// No description provided for @categories_title.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories_title;

  /// No description provided for @home_empty_state_title.
  ///
  /// In en, this message translates to:
  /// **'Take control of your spending'**
  String get home_empty_state_title;

  /// No description provided for @home_empty_state_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Understand where your money goes. Budget smarter. Save more.'**
  String get home_empty_state_subtitle;

  /// No description provided for @home_empty_state_footer.
  ///
  /// In en, this message translates to:
  /// **'Your data is safely encrypted.'**
  String get home_empty_state_footer;

  /// No description provided for @insight_budget_warning_title.
  ///
  /// In en, this message translates to:
  /// **'Almost There'**
  String get insight_budget_warning_title;

  /// No description provided for @insight_budget_warning_message.
  ///
  /// In en, this message translates to:
  /// **'You have only {amount} left in your budget.'**
  String insight_budget_warning_message(String amount);

  /// No description provided for @insight_budget_safe_title.
  ///
  /// In en, this message translates to:
  /// **'On Track'**
  String get insight_budget_safe_title;

  /// No description provided for @insight_budget_safe_message.
  ///
  /// In en, this message translates to:
  /// **'You\'re {amount} under budget. Keep it up.'**
  String insight_budget_safe_message(String amount);

  /// No description provided for @insight_budget_exceeded_title.
  ///
  /// In en, this message translates to:
  /// **'Budget Alert'**
  String get insight_budget_exceeded_title;

  /// No description provided for @insight_budget_exceeded_message.
  ///
  /// In en, this message translates to:
  /// **'You\'ve exceeded your budget by {amount}'**
  String insight_budget_exceeded_message(String amount);

  /// No description provided for @insight_no_budget_title.
  ///
  /// In en, this message translates to:
  /// **'Plan Ahead'**
  String get insight_no_budget_title;

  /// No description provided for @insight_no_budget_message.
  ///
  /// In en, this message translates to:
  /// **'Set a monthly budget to help control your spending.'**
  String get insight_no_budget_message;

  /// No description provided for @insight_smart_tip_title.
  ///
  /// In en, this message translates to:
  /// **'Smart Tip'**
  String get insight_smart_tip_title;

  /// No description provided for @insight_smart_tip_message.
  ///
  /// In en, this message translates to:
  /// **'To stay on track, keep today\'s spending under {amount}'**
  String insight_smart_tip_message(String amount);

  /// No description provided for @insight_savings_title.
  ///
  /// In en, this message translates to:
  /// **'Savings Update'**
  String get insight_savings_title;

  /// No description provided for @insight_savings_message.
  ///
  /// In en, this message translates to:
  /// **'You\'ve saved {amount} so far this month.'**
  String insight_savings_message(String amount);

  /// No description provided for @insight_default_title.
  ///
  /// In en, this message translates to:
  /// **'All Good'**
  String get insight_default_title;

  /// No description provided for @insight_default_message.
  ///
  /// In en, this message translates to:
  /// **'Your financial activity looks stable.'**
  String get insight_default_message;

  /// No description provided for @home_empty_info_text.
  ///
  /// In en, this message translates to:
  /// **'How it works: Enter your daily expenses, and we\'ll help you understand your spending habits. No bank connections, no automatic deductions.'**
  String get home_empty_info_text;

  /// No description provided for @home_empty_verified_info.
  ///
  /// In en, this message translates to:
  /// **'Personal budget planner - never syncs to your bank.'**
  String get home_empty_verified_info;

  /// No description provided for @home_empty_privacy_info1.
  ///
  /// In en, this message translates to:
  /// **'You control every entry - nothing is automatic.'**
  String get home_empty_privacy_info1;

  /// No description provided for @home_empty_privacy_info2.
  ///
  /// In en, this message translates to:
  /// **'See spending patterns - make informed decisions.'**
  String get home_empty_privacy_info2;

  /// No description provided for @home_empty_privacy_info3.
  ///
  /// In en, this message translates to:
  /// **'We never sell or share your personal data.'**
  String get home_empty_privacy_info3;

  /// No description provided for @add_first_expense.
  ///
  /// In en, this message translates to:
  /// **'Add Your First Expense'**
  String get add_first_expense;

  /// No description provided for @goal_details_title.
  ///
  /// In en, this message translates to:
  /// **'Goal Details'**
  String get goal_details_title;

  /// No description provided for @edit_goal_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Dream / Goal'**
  String get edit_goal_title;

  /// No description provided for @add_money_title.
  ///
  /// In en, this message translates to:
  /// **'Add Money'**
  String get add_money_title;

  /// No description provided for @add_money_button.
  ///
  /// In en, this message translates to:
  /// **'+ Add Money'**
  String get add_money_button;

  /// No description provided for @saved_label.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved_label;

  /// No description provided for @remaining_label.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining_label;

  /// No description provided for @target_amount_label.
  ///
  /// In en, this message translates to:
  /// **'Target Amount'**
  String get target_amount_label;

  /// No description provided for @target_date_label.
  ///
  /// In en, this message translates to:
  /// **'Target Date'**
  String get target_date_label;

  /// No description provided for @progress_label.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress_label;

  /// No description provided for @contribution_history_title.
  ///
  /// In en, this message translates to:
  /// **'Contribution History'**
  String get contribution_history_title;

  /// No description provided for @no_contributions_yet.
  ///
  /// In en, this message translates to:
  /// **'No contributions saved yet.'**
  String get no_contributions_yet;

  /// No description provided for @delete_goal_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Goal'**
  String get delete_goal_title;

  /// No description provided for @delete_goal_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this goal? This action cannot be undone.'**
  String get delete_goal_confirmation;

  /// No description provided for @amount_required_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get amount_required_error;

  /// No description provided for @amount_greater_than_zero_error.
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than 0'**
  String get amount_greater_than_zero_error;

  /// No description provided for @amount_exceeds_remaining_warning.
  ///
  /// In en, this message translates to:
  /// **'Amount exceeds remaining target amount'**
  String get amount_exceeds_remaining_warning;

  /// No description provided for @update_goal_button.
  ///
  /// In en, this message translates to:
  /// **'Update Goal'**
  String get update_goal_button;
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
      <String>['en', 'es', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
