import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

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
    Locale('ru')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'ArcheoAI'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @clubs.
  ///
  /// In en, this message translates to:
  /// **'Clubs'**
  String get clubs;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get welcome;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search artifacts...'**
  String get searchHint;

  /// No description provided for @featured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featured;

  /// No description provided for @allArtifacts.
  ///
  /// In en, this message translates to:
  /// **'All Artifacts'**
  String get allArtifacts;

  /// No description provided for @noArtifacts.
  ///
  /// In en, this message translates to:
  /// **'No artifacts found'**
  String get noArtifacts;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @artifactsAdded.
  ///
  /// In en, this message translates to:
  /// **'Artifacts added'**
  String get artifactsAdded;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @museumArtifacts.
  ///
  /// In en, this message translates to:
  /// **'Museum Artifacts'**
  String get museumArtifacts;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @addArtifact.
  ///
  /// In en, this message translates to:
  /// **'Add new\nartifact'**
  String get addArtifact;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @material.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get material;

  /// No description provided for @condition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get condition;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @foundBy.
  ///
  /// In en, this message translates to:
  /// **'Found by'**
  String get foundBy;

  /// No description provided for @foundDate.
  ///
  /// In en, this message translates to:
  /// **'Found date'**
  String get foundDate;

  /// No description provided for @dimensions.
  ///
  /// In en, this message translates to:
  /// **'Dimensions'**
  String get dimensions;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @width.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get width;

  /// No description provided for @depth.
  ///
  /// In en, this message translates to:
  /// **'Depth'**
  String get depth;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @pickPhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to pick photo'**
  String get pickPhoto;

  /// No description provided for @museumSection.
  ///
  /// In en, this message translates to:
  /// **'Museum Section'**
  String get museumSection;

  /// No description provided for @restorationStatus.
  ///
  /// In en, this message translates to:
  /// **'Restoration Status'**
  String get restorationStatus;

  /// No description provided for @mainInfo.
  ///
  /// In en, this message translates to:
  /// **'Main Information'**
  String get mainInfo;

  /// No description provided for @discovery.
  ///
  /// In en, this message translates to:
  /// **'Discovery'**
  String get discovery;

  /// No description provided for @eras.
  ///
  /// In en, this message translates to:
  /// **'Eras'**
  String get eras;

  /// No description provided for @threeD.
  ///
  /// In en, this message translates to:
  /// **'3D'**
  String get threeD;

  /// No description provided for @noModel.
  ///
  /// In en, this message translates to:
  /// **'3D model not available'**
  String get noModel;

  /// No description provided for @editArtifact.
  ///
  /// In en, this message translates to:
  /// **'Edit Artifact'**
  String get editArtifact;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @deleteArtifact.
  ///
  /// In en, this message translates to:
  /// **'Delete Artifact?'**
  String get deleteArtifact;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// No description provided for @cannotUndo.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get cannotUndo;

  /// No description provided for @officialExpedition.
  ///
  /// In en, this message translates to:
  /// **'Official Expedition Find'**
  String get officialExpedition;

  /// No description provided for @credit.
  ///
  /// In en, this message translates to:
  /// **'Credit (Expedition)'**
  String get credit;

  /// No description provided for @communityPosts.
  ///
  /// In en, this message translates to:
  /// **'Community Posts'**
  String get communityPosts;

  /// No description provided for @noPosts.
  ///
  /// In en, this message translates to:
  /// **'No posts in this community yet.'**
  String get noPosts;

  /// No description provided for @officialAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'OFFICIAL ANNOUNCEMENT'**
  String get officialAnnouncement;

  /// No description provided for @clubAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'CLUB ANNOUNCEMENT'**
  String get clubAnnouncement;

  /// No description provided for @publishedBy.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get publishedBy;

  /// No description provided for @newPost.
  ///
  /// In en, this message translates to:
  /// **'New Post'**
  String get newPost;

  /// No description provided for @postTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get postTitle;

  /// No description provided for @postContent.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get postContent;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @teamChat.
  ///
  /// In en, this message translates to:
  /// **'Team Chat'**
  String get teamChat;

  /// No description provided for @noMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages yet.\nStart a discussion!'**
  String get noMessages;

  /// No description provided for @writeToTeam.
  ///
  /// In en, this message translates to:
  /// **'Write to team...'**
  String get writeToTeam;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @moderator.
  ///
  /// In en, this message translates to:
  /// **'Moderator'**
  String get moderator;

  /// No description provided for @newExpedition.
  ///
  /// In en, this message translates to:
  /// **'New Expedition'**
  String get newExpedition;

  /// No description provided for @expeditions.
  ///
  /// In en, this message translates to:
  /// **'Expeditions'**
  String get expeditions;

  /// No description provided for @yourProjects.
  ///
  /// In en, this message translates to:
  /// **'Your archaeological projects'**
  String get yourProjects;

  /// No description provided for @noProjects.
  ///
  /// In en, this message translates to:
  /// **'No active projects'**
  String get noProjects;

  /// No description provided for @createProjectMsg.
  ///
  /// In en, this message translates to:
  /// **'Create a new expedition for your team or wait for an invitation from colleagues.'**
  String get createProjectMsg;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @invite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get invite;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description available...'**
  String get noDescription;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// No description provided for @deleteProject.
  ///
  /// In en, this message translates to:
  /// **'Delete project?'**
  String get deleteProject;

  /// No description provided for @deleteProjectConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete expedition?'**
  String get deleteProjectConfirm;

  /// No description provided for @inviteColleague.
  ///
  /// In en, this message translates to:
  /// **'Invite colleague'**
  String get inviteColleague;

  /// No description provided for @inviteEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter archaeologist email to add them to your team.'**
  String get inviteEmailLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Archaeologist Email'**
  String get emailLabel;

  /// No description provided for @inviteSent.
  ///
  /// In en, this message translates to:
  /// **'Invitation sent!'**
  String get inviteSent;

  /// No description provided for @startExpedition.
  ///
  /// In en, this message translates to:
  /// **'Start Expedition'**
  String get startExpedition;

  /// No description provided for @projectName.
  ///
  /// In en, this message translates to:
  /// **'Project Name*'**
  String get projectName;

  /// No description provided for @projectDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get projectDescription;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get enterName;

  /// No description provided for @communityNotFound.
  ///
  /// In en, this message translates to:
  /// **'Community not found'**
  String get communityNotFound;

  /// No description provided for @publications.
  ///
  /// In en, this message translates to:
  /// **'Publications'**
  String get publications;

  /// No description provided for @editing.
  ///
  /// In en, this message translates to:
  /// **'Editing'**
  String get editing;

  /// No description provided for @noPublishRequests.
  ///
  /// In en, this message translates to:
  /// **'No publication requests'**
  String get noPublishRequests;

  /// No description provided for @noEditRequests.
  ///
  /// In en, this message translates to:
  /// **'No editing requests'**
  String get noEditRequests;

  /// No description provided for @artifactPublished.
  ///
  /// In en, this message translates to:
  /// **'Artifact published!'**
  String get artifactPublished;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @editRequest.
  ///
  /// In en, this message translates to:
  /// **'Editing Request'**
  String get editRequest;

  /// No description provided for @editAllowed.
  ///
  /// In en, this message translates to:
  /// **'Editing allowed'**
  String get editAllowed;

  /// No description provided for @parseError.
  ///
  /// In en, this message translates to:
  /// **'Artifact data error'**
  String get parseError;

  /// No description provided for @artifactNotFound.
  ///
  /// In en, this message translates to:
  /// **'Artifact not found'**
  String get artifactNotFound;

  /// No description provided for @noFavorites.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any favorite artifacts yet'**
  String get noFavorites;

  /// No description provided for @communities.
  ///
  /// In en, this message translates to:
  /// **'Communities'**
  String get communities;

  /// No description provided for @searchCommunities.
  ///
  /// In en, this message translates to:
  /// **'Search communities...'**
  String get searchCommunities;

  /// No description provided for @myCommunities.
  ///
  /// In en, this message translates to:
  /// **'My Communities'**
  String get myCommunities;

  /// No description provided for @allCommunities.
  ///
  /// In en, this message translates to:
  /// **'All Communities'**
  String get allCommunities;

  /// No description provided for @participantsCount.
  ///
  /// In en, this message translates to:
  /// **'participants'**
  String get participantsCount;

  /// No description provided for @newCommunity.
  ///
  /// In en, this message translates to:
  /// **'New Community'**
  String get newCommunity;

  /// No description provided for @communityPromo.
  ///
  /// In en, this message translates to:
  /// **'Unite researchers by interest.\nShare finds and discuss theories.'**
  String get communityPromo;

  /// No description provided for @communityName.
  ///
  /// In en, this message translates to:
  /// **'Community Name'**
  String get communityName;

  /// No description provided for @communityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Egyptologists'**
  String get communityHint;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'What is your community about?'**
  String get descriptionHint;

  /// No description provided for @cover.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get cover;

  /// No description provided for @addCover.
  ///
  /// In en, this message translates to:
  /// **'Add cover'**
  String get addCover;

  /// No description provided for @recommendSize.
  ///
  /// In en, this message translates to:
  /// **'Recommended size 800x400 (optional)'**
  String get recommendSize;

  /// No description provided for @createCommunityAction.
  ///
  /// In en, this message translates to:
  /// **'Create Community'**
  String get createCommunityAction;

  /// No description provided for @fillFields.
  ///
  /// In en, this message translates to:
  /// **'Fill in title and description'**
  String get fillFields;

  /// No description provided for @communityCreated.
  ///
  /// In en, this message translates to:
  /// **'Community created successfully!'**
  String get communityCreated;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Archaeologist Login'**
  String get loginTitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterEmailPass.
  ///
  /// In en, this message translates to:
  /// **'Enter email and password'**
  String get enterEmailPass;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format.'**
  String get invalidEmail;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get userNotFound;

  /// No description provided for @userDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled.'**
  String get userDisabled;

  /// No description provided for @tooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many login attempts. Try again later.'**
  String get tooManyRequests;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Try again.'**
  String get errorOccurred;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Login error'**
  String get loginError;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Archaeologist Registration'**
  String get registerTitle;

  /// No description provided for @registerAction.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerAction;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get alreadyHaveAccount;

  /// No description provided for @roleVisitor.
  ///
  /// In en, this message translates to:
  /// **'Visitor'**
  String get roleVisitor;

  /// No description provided for @roleArchaeologist.
  ///
  /// In en, this message translates to:
  /// **'Archaeologist'**
  String get roleArchaeologist;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select your role'**
  String get selectRole;

  /// No description provided for @exploreMuseum.
  ///
  /// In en, this message translates to:
  /// **'Explore the museum and its secrets'**
  String get exploreMuseum;

  /// No description provided for @manageArtifacts.
  ///
  /// In en, this message translates to:
  /// **'Add and manage historical finds'**
  String get manageArtifacts;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Fill in all fields'**
  String get fillAllFields;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful!'**
  String get registrationSuccess;

  /// No description provided for @registrationError.
  ///
  /// In en, this message translates to:
  /// **'Registration error'**
  String get registrationError;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @roleSelectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'So we can provide you with the best experience'**
  String get roleSelectionSubtitle;

  /// No description provided for @iAmVisitor.
  ///
  /// In en, this message translates to:
  /// **'I am a Visitor'**
  String get iAmVisitor;

  /// No description provided for @iAmArchaeologist.
  ///
  /// In en, this message translates to:
  /// **'I am an Archaeologist'**
  String get iAmArchaeologist;

  /// No description provided for @scholarTitle.
  ///
  /// In en, this message translates to:
  /// **'History Scholar'**
  String get scholarTitle;

  /// No description provided for @scholarDesc.
  ///
  /// In en, this message translates to:
  /// **'View 5 different artifacts.'**
  String get scholarDesc;

  /// No description provided for @criticTitle.
  ///
  /// In en, this message translates to:
  /// **'Art Critic'**
  String get criticTitle;

  /// No description provided for @criticDesc.
  ///
  /// In en, this message translates to:
  /// **'Leave 3 comments on artifacts.'**
  String get criticDesc;

  /// No description provided for @masterTitle.
  ///
  /// In en, this message translates to:
  /// **'Technophile'**
  String get masterTitle;

  /// No description provided for @masterDesc.
  ///
  /// In en, this message translates to:
  /// **'Examine a 3D model for the first time.'**
  String get masterDesc;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterSaka.
  ///
  /// In en, this message translates to:
  /// **'Saka Era'**
  String get filterSaka;

  /// No description provided for @filterEgypt.
  ///
  /// In en, this message translates to:
  /// **'Ancient Egypt'**
  String get filterEgypt;

  /// No description provided for @filterAntiquity.
  ///
  /// In en, this message translates to:
  /// **'Antiquity'**
  String get filterAntiquity;

  /// No description provided for @filterMedieval.
  ///
  /// In en, this message translates to:
  /// **'Middle Ages'**
  String get filterMedieval;

  /// No description provided for @filterSteppe.
  ///
  /// In en, this message translates to:
  /// **'Nomads'**
  String get filterSteppe;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @addedBy.
  ///
  /// In en, this message translates to:
  /// **'Added by'**
  String get addedBy;

  /// No description provided for @searchByTitle.
  ///
  /// In en, this message translates to:
  /// **'Search by title...'**
  String get searchByTitle;

  /// No description provided for @loginToComment.
  ///
  /// In en, this message translates to:
  /// **'Please login to leave a comment'**
  String get loginToComment;

  /// No description provided for @artifactDeleted.
  ///
  /// In en, this message translates to:
  /// **'Artifact deleted'**
  String get artifactDeleted;

  /// No description provided for @mapError.
  ///
  /// In en, this message translates to:
  /// **'Could not determine location'**
  String get mapError;

  /// No description provided for @loadingComments.
  ///
  /// In en, this message translates to:
  /// **'Loading comments...'**
  String get loadingComments;

  /// No description provided for @noCommentsYet.
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get noCommentsYet;

  /// No description provided for @writeCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Write a comment...'**
  String get writeCommentHint;

  /// No description provided for @loginToWrite.
  ///
  /// In en, this message translates to:
  /// **'Login to comment'**
  String get loginToWrite;

  /// No description provided for @edited.
  ///
  /// In en, this message translates to:
  /// **'edited'**
  String get edited;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get emailAlreadyInUse;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password too weak. Use at least 6 characters.'**
  String get weakPassword;

  /// No description provided for @scannerFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus on the object'**
  String get scannerFocus;

  /// No description provided for @scannerPoints.
  ///
  /// In en, this message translates to:
  /// **'Points captured'**
  String get scannerPoints;

  /// No description provided for @scannerGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating 3D model...'**
  String get scannerGenerating;

  /// No description provided for @scannerInstruction.
  ///
  /// In en, this message translates to:
  /// **'Walk around the object taking photos'**
  String get scannerInstruction;

  /// No description provided for @scannerPolygon.
  ///
  /// In en, this message translates to:
  /// **'POLYGON GENERATION'**
  String get scannerPolygon;

  /// No description provided for @addName.
  ///
  /// In en, this message translates to:
  /// **'Add name'**
  String get addName;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;
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
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
