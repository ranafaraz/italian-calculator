import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('it')
  ];

  /// No description provided for @appName.
  ///
  /// In it, this message translates to:
  /// **'CalcFlow'**
  String get appName;

  /// No description provided for @navCalculator.
  ///
  /// In it, this message translates to:
  /// **'Calcolatrice'**
  String get navCalculator;

  /// No description provided for @navConverter.
  ///
  /// In it, this message translates to:
  /// **'Convertitore'**
  String get navConverter;

  /// No description provided for @navFinance.
  ///
  /// In it, this message translates to:
  /// **'IVA e Sconti'**
  String get navFinance;

  /// No description provided for @navSettings.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni'**
  String get navSettings;

  /// No description provided for @history.
  ///
  /// In it, this message translates to:
  /// **'Cronologia'**
  String get history;

  /// No description provided for @angleMode.
  ///
  /// In it, this message translates to:
  /// **'Modalità angolo'**
  String get angleMode;

  /// No description provided for @scientificToggle.
  ///
  /// In it, this message translates to:
  /// **'Funzioni scientifiche'**
  String get scientificToggle;

  /// No description provided for @copyResult.
  ///
  /// In it, this message translates to:
  /// **'Copia risultato'**
  String get copyResult;

  /// No description provided for @copied.
  ///
  /// In it, this message translates to:
  /// **'Copiato negli appunti'**
  String get copied;

  /// No description provided for @errorInvalid.
  ///
  /// In it, this message translates to:
  /// **'Espressione non valida'**
  String get errorInvalid;

  /// No description provided for @errorDivideByZero.
  ///
  /// In it, this message translates to:
  /// **'Impossibile dividere per zero'**
  String get errorDivideByZero;

  /// No description provided for @errorDomain.
  ///
  /// In it, this message translates to:
  /// **'Operazione non consentita'**
  String get errorDomain;

  /// No description provided for @errorOverflow.
  ///
  /// In it, this message translates to:
  /// **'Numero troppo grande'**
  String get errorOverflow;

  /// No description provided for @searchHistory.
  ///
  /// In it, this message translates to:
  /// **'Cerca calcoli…'**
  String get searchHistory;

  /// No description provided for @emptyHistoryTitle.
  ///
  /// In it, this message translates to:
  /// **'Nessun calcolo'**
  String get emptyHistoryTitle;

  /// No description provided for @emptyHistorySubtitle.
  ///
  /// In it, this message translates to:
  /// **'I calcoli che esegui appariranno qui.'**
  String get emptyHistorySubtitle;

  /// No description provided for @noSearchResults.
  ///
  /// In it, this message translates to:
  /// **'Nessun risultato trovato'**
  String get noSearchResults;

  /// No description provided for @clearHistory.
  ///
  /// In it, this message translates to:
  /// **'Svuota cronologia'**
  String get clearHistory;

  /// No description provided for @clearHistoryConfirmTitle.
  ///
  /// In it, this message translates to:
  /// **'Svuotare la cronologia?'**
  String get clearHistoryConfirmTitle;

  /// No description provided for @clearHistoryConfirmBody.
  ///
  /// In it, this message translates to:
  /// **'Tutti i calcoli, inclusi quelli fissati, verranno eliminati definitivamente.'**
  String get clearHistoryConfirmBody;

  /// No description provided for @cancel.
  ///
  /// In it, this message translates to:
  /// **'Annulla'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In it, this message translates to:
  /// **'Elimina'**
  String get delete;

  /// No description provided for @entryDeleted.
  ///
  /// In it, this message translates to:
  /// **'Calcolo eliminato'**
  String get entryDeleted;

  /// No description provided for @undo.
  ///
  /// In it, this message translates to:
  /// **'Ripristina'**
  String get undo;

  /// No description provided for @pinned.
  ///
  /// In it, this message translates to:
  /// **'Fissati'**
  String get pinned;

  /// No description provided for @pin.
  ///
  /// In it, this message translates to:
  /// **'Fissa'**
  String get pin;

  /// No description provided for @unpin.
  ///
  /// In it, this message translates to:
  /// **'Sblocca'**
  String get unpin;

  /// No description provided for @copy.
  ///
  /// In it, this message translates to:
  /// **'Copia'**
  String get copy;

  /// No description provided for @reuse.
  ///
  /// In it, this message translates to:
  /// **'Riusa'**
  String get reuse;

  /// No description provided for @today.
  ///
  /// In it, this message translates to:
  /// **'Oggi'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In it, this message translates to:
  /// **'Ieri'**
  String get yesterday;

  /// No description provided for @converterTitle.
  ///
  /// In it, this message translates to:
  /// **'Convertitore'**
  String get converterTitle;

  /// No description provided for @categoryLength.
  ///
  /// In it, this message translates to:
  /// **'Lunghezza'**
  String get categoryLength;

  /// No description provided for @categoryMass.
  ///
  /// In it, this message translates to:
  /// **'Peso'**
  String get categoryMass;

  /// No description provided for @categoryTemperature.
  ///
  /// In it, this message translates to:
  /// **'Temperatura'**
  String get categoryTemperature;

  /// No description provided for @categoryArea.
  ///
  /// In it, this message translates to:
  /// **'Area'**
  String get categoryArea;

  /// No description provided for @categoryVolume.
  ///
  /// In it, this message translates to:
  /// **'Volume'**
  String get categoryVolume;

  /// No description provided for @categoryData.
  ///
  /// In it, this message translates to:
  /// **'Dati'**
  String get categoryData;

  /// No description provided for @categorySpeed.
  ///
  /// In it, this message translates to:
  /// **'Velocità'**
  String get categorySpeed;

  /// No description provided for @categoryTime.
  ///
  /// In it, this message translates to:
  /// **'Tempo'**
  String get categoryTime;

  /// No description provided for @from.
  ///
  /// In it, this message translates to:
  /// **'Da'**
  String get from;

  /// No description provided for @to.
  ///
  /// In it, this message translates to:
  /// **'A'**
  String get to;

  /// No description provided for @swapUnits.
  ///
  /// In it, this message translates to:
  /// **'Inverti unità'**
  String get swapUnits;

  /// No description provided for @unitMeters.
  ///
  /// In it, this message translates to:
  /// **'Metri'**
  String get unitMeters;

  /// No description provided for @unitKilometers.
  ///
  /// In it, this message translates to:
  /// **'Chilometri'**
  String get unitKilometers;

  /// No description provided for @unitCentimeters.
  ///
  /// In it, this message translates to:
  /// **'Centimetri'**
  String get unitCentimeters;

  /// No description provided for @unitMillimeters.
  ///
  /// In it, this message translates to:
  /// **'Millimetri'**
  String get unitMillimeters;

  /// No description provided for @unitMiles.
  ///
  /// In it, this message translates to:
  /// **'Miglia'**
  String get unitMiles;

  /// No description provided for @unitFeet.
  ///
  /// In it, this message translates to:
  /// **'Piedi'**
  String get unitFeet;

  /// No description provided for @unitInches.
  ///
  /// In it, this message translates to:
  /// **'Pollici'**
  String get unitInches;

  /// No description provided for @unitYards.
  ///
  /// In it, this message translates to:
  /// **'Iarde'**
  String get unitYards;

  /// No description provided for @unitKilograms.
  ///
  /// In it, this message translates to:
  /// **'Chilogrammi'**
  String get unitKilograms;

  /// No description provided for @unitGrams.
  ///
  /// In it, this message translates to:
  /// **'Grammi'**
  String get unitGrams;

  /// No description provided for @unitMilligrams.
  ///
  /// In it, this message translates to:
  /// **'Milligrammi'**
  String get unitMilligrams;

  /// No description provided for @unitTonnes.
  ///
  /// In it, this message translates to:
  /// **'Tonnellate'**
  String get unitTonnes;

  /// No description provided for @unitPounds.
  ///
  /// In it, this message translates to:
  /// **'Libbre'**
  String get unitPounds;

  /// No description provided for @unitOunces.
  ///
  /// In it, this message translates to:
  /// **'Once'**
  String get unitOunces;

  /// No description provided for @unitCelsius.
  ///
  /// In it, this message translates to:
  /// **'Celsius'**
  String get unitCelsius;

  /// No description provided for @unitFahrenheit.
  ///
  /// In it, this message translates to:
  /// **'Fahrenheit'**
  String get unitFahrenheit;

  /// No description provided for @unitKelvin.
  ///
  /// In it, this message translates to:
  /// **'Kelvin'**
  String get unitKelvin;

  /// No description provided for @unitSquareMeters.
  ///
  /// In it, this message translates to:
  /// **'Metri quadrati'**
  String get unitSquareMeters;

  /// No description provided for @unitSquareKilometers.
  ///
  /// In it, this message translates to:
  /// **'Chilometri quadrati'**
  String get unitSquareKilometers;

  /// No description provided for @unitHectares.
  ///
  /// In it, this message translates to:
  /// **'Ettari'**
  String get unitHectares;

  /// No description provided for @unitLiters.
  ///
  /// In it, this message translates to:
  /// **'Litri'**
  String get unitLiters;

  /// No description provided for @unitMilliliters.
  ///
  /// In it, this message translates to:
  /// **'Millilitri'**
  String get unitMilliliters;

  /// No description provided for @unitCubicMeters.
  ///
  /// In it, this message translates to:
  /// **'Metri cubi'**
  String get unitCubicMeters;

  /// No description provided for @unitGallons.
  ///
  /// In it, this message translates to:
  /// **'Galloni (USA)'**
  String get unitGallons;

  /// No description provided for @unitBytes.
  ///
  /// In it, this message translates to:
  /// **'Byte'**
  String get unitBytes;

  /// No description provided for @unitKilobytes.
  ///
  /// In it, this message translates to:
  /// **'Kilobyte'**
  String get unitKilobytes;

  /// No description provided for @unitMegabytes.
  ///
  /// In it, this message translates to:
  /// **'Megabyte'**
  String get unitMegabytes;

  /// No description provided for @unitGigabytes.
  ///
  /// In it, this message translates to:
  /// **'Gigabyte'**
  String get unitGigabytes;

  /// No description provided for @unitTerabytes.
  ///
  /// In it, this message translates to:
  /// **'Terabyte'**
  String get unitTerabytes;

  /// No description provided for @unitMetersPerSecond.
  ///
  /// In it, this message translates to:
  /// **'Metri al secondo'**
  String get unitMetersPerSecond;

  /// No description provided for @unitKilometersPerHour.
  ///
  /// In it, this message translates to:
  /// **'Chilometri orari'**
  String get unitKilometersPerHour;

  /// No description provided for @unitMilesPerHour.
  ///
  /// In it, this message translates to:
  /// **'Miglia orarie'**
  String get unitMilesPerHour;

  /// No description provided for @unitKnots.
  ///
  /// In it, this message translates to:
  /// **'Nodi'**
  String get unitKnots;

  /// No description provided for @unitMilliseconds.
  ///
  /// In it, this message translates to:
  /// **'Millisecondi'**
  String get unitMilliseconds;

  /// No description provided for @unitSeconds.
  ///
  /// In it, this message translates to:
  /// **'Secondi'**
  String get unitSeconds;

  /// No description provided for @unitMinutes.
  ///
  /// In it, this message translates to:
  /// **'Minuti'**
  String get unitMinutes;

  /// No description provided for @unitHours.
  ///
  /// In it, this message translates to:
  /// **'Ore'**
  String get unitHours;

  /// No description provided for @unitDays.
  ///
  /// In it, this message translates to:
  /// **'Giorni'**
  String get unitDays;

  /// No description provided for @unitWeeks.
  ///
  /// In it, this message translates to:
  /// **'Settimane'**
  String get unitWeeks;

  /// No description provided for @unitYears.
  ///
  /// In it, this message translates to:
  /// **'Anni'**
  String get unitYears;

  /// No description provided for @financeTitle.
  ///
  /// In it, this message translates to:
  /// **'IVA e Sconti'**
  String get financeTitle;

  /// No description provided for @vatCalculator.
  ///
  /// In it, this message translates to:
  /// **'Calcolo IVA'**
  String get vatCalculator;

  /// No description provided for @addVat.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi IVA'**
  String get addVat;

  /// No description provided for @removeVat.
  ///
  /// In it, this message translates to:
  /// **'Scorporo IVA'**
  String get removeVat;

  /// No description provided for @amount.
  ///
  /// In it, this message translates to:
  /// **'Importo'**
  String get amount;

  /// No description provided for @netAmount.
  ///
  /// In it, this message translates to:
  /// **'Netto'**
  String get netAmount;

  /// No description provided for @grossAmount.
  ///
  /// In it, this message translates to:
  /// **'Lordo'**
  String get grossAmount;

  /// No description provided for @vatAmount.
  ///
  /// In it, this message translates to:
  /// **'IVA'**
  String get vatAmount;

  /// No description provided for @vatRate.
  ///
  /// In it, this message translates to:
  /// **'Aliquota IVA'**
  String get vatRate;

  /// No description provided for @customRate.
  ///
  /// In it, this message translates to:
  /// **'Personalizzata'**
  String get customRate;

  /// No description provided for @customRateLabel.
  ///
  /// In it, this message translates to:
  /// **'Aliquota personalizzata (%)'**
  String get customRateLabel;

  /// No description provided for @discountCalculator.
  ///
  /// In it, this message translates to:
  /// **'Calcolo sconto'**
  String get discountCalculator;

  /// No description provided for @originalPrice.
  ///
  /// In it, this message translates to:
  /// **'Prezzo iniziale'**
  String get originalPrice;

  /// No description provided for @discountPercent.
  ///
  /// In it, this message translates to:
  /// **'Sconto (%)'**
  String get discountPercent;

  /// No description provided for @youSave.
  ///
  /// In it, this message translates to:
  /// **'Risparmi'**
  String get youSave;

  /// No description provided for @finalPrice.
  ///
  /// In it, this message translates to:
  /// **'Prezzo finale'**
  String get finalPrice;

  /// No description provided for @invalidNumber.
  ///
  /// In it, this message translates to:
  /// **'Valore non valido'**
  String get invalidNumber;

  /// No description provided for @settingsTitle.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni'**
  String get settingsTitle;

  /// No description provided for @sectionAppearance.
  ///
  /// In it, this message translates to:
  /// **'Aspetto'**
  String get sectionAppearance;

  /// No description provided for @theme.
  ///
  /// In it, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In it, this message translates to:
  /// **'Sistema'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In it, this message translates to:
  /// **'Chiaro'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In it, this message translates to:
  /// **'Scuro'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In it, this message translates to:
  /// **'Lingua'**
  String get language;

  /// No description provided for @italian.
  ///
  /// In it, this message translates to:
  /// **'Italiano'**
  String get italian;

  /// No description provided for @english.
  ///
  /// In it, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @sectionCalculation.
  ///
  /// In it, this message translates to:
  /// **'Calcolo'**
  String get sectionCalculation;

  /// No description provided for @decimalPrecision.
  ///
  /// In it, this message translates to:
  /// **'Cifre decimali'**
  String get decimalPrecision;

  /// No description provided for @decimalPrecisionHint.
  ///
  /// In it, this message translates to:
  /// **'Numero massimo di cifre decimali nei risultati'**
  String get decimalPrecisionHint;

  /// No description provided for @haptics.
  ///
  /// In it, this message translates to:
  /// **'Feedback aptico'**
  String get haptics;

  /// No description provided for @hapticsHint.
  ///
  /// In it, this message translates to:
  /// **'Vibra alla pressione dei tasti'**
  String get hapticsHint;

  /// No description provided for @sectionData.
  ///
  /// In it, this message translates to:
  /// **'Dati'**
  String get sectionData;

  /// No description provided for @clearLocalData.
  ///
  /// In it, this message translates to:
  /// **'Cancella tutti i dati'**
  String get clearLocalData;

  /// No description provided for @clearDataHint.
  ///
  /// In it, this message translates to:
  /// **'Elimina cronologia e preferenze'**
  String get clearDataHint;

  /// No description provided for @clearDataConfirmTitle.
  ///
  /// In it, this message translates to:
  /// **'Cancellare tutti i dati?'**
  String get clearDataConfirmTitle;

  /// No description provided for @clearDataConfirmBody.
  ///
  /// In it, this message translates to:
  /// **'Cronologia e impostazioni torneranno ai valori iniziali. L\'operazione non può essere annullata.'**
  String get clearDataConfirmBody;

  /// No description provided for @localDataCleared.
  ///
  /// In it, this message translates to:
  /// **'Dati cancellati'**
  String get localDataCleared;

  /// No description provided for @sectionAbout.
  ///
  /// In it, this message translates to:
  /// **'Informazioni'**
  String get sectionAbout;

  /// No description provided for @version.
  ///
  /// In it, this message translates to:
  /// **'Versione'**
  String get version;

  /// No description provided for @privacyNote.
  ///
  /// In it, this message translates to:
  /// **'100% offline. I tuoi dati non lasciano mai questo dispositivo.'**
  String get privacyNote;

  /// No description provided for @aboutTagline.
  ///
  /// In it, this message translates to:
  /// **'La calcolatrice italiana: elegante, completa, privata.'**
  String get aboutTagline;
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
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
