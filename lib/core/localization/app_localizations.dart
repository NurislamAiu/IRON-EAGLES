import 'package:flutter/material.dart';

class S {
  final Locale locale;
  S(this.locale);

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const _localizedValues = {
    'en': {
      'appTitle': 'ArcheoAI',
      'home': 'Home',
      'clubs': 'Clubs',
      'create': 'Create',
      'projects': 'Projects',
      'profile': 'Profile',
      'welcome': 'Welcome to',
      'searchHint': 'Search artifacts...',
      'featured': 'Featured',
      'allArtifacts': 'All Artifacts',
      'noArtifacts': 'No artifacts found',
      'login': 'Login',
      'register': 'Register',
      'logout': 'Logout',
      'editProfile': 'Edit Profile',
      'statistics': 'Statistics',
      'artifactsAdded': 'Artifacts added',
      'favorites': 'Favorites',
      'achievements': 'Achievements',
      'settings': 'Settings',
      'language': 'Language',
      'russian': 'Russian',
      'english': 'English',
      'museumArtifacts': 'Museum Artifacts',
      'history': 'History',
      'details': 'Details',
      'map': 'Map',
      'comments': 'Comments',
      'save': 'Save',
      'cancel': 'Cancel',
      'addArtifact': 'Add new\nartifact',
      'next': 'Next',
      'back': 'Back',
      'title': 'Title',
      'description': 'Description',
      'category': 'Category',
      'period': 'Period',
      'material': 'Material',
      'condition': 'Condition',
      'location': 'Location',
      'foundBy': 'Found by',
      'foundDate': 'Found date',
      'dimensions': 'Dimensions',
      'height': 'Height',
      'width': 'Width',
      'depth': 'Depth',
      'notes': 'Notes',
      'pickPhoto': 'Tap to pick photo',
      'museumSection': 'Museum Section',
      'restorationStatus': 'Restoration Status',
      'mainInfo': 'Main Information',
      'discovery': 'Discovery',
      'eras': 'Eras',
      'threeD': '3D',
      'noModel': '3D model not available',
      'editArtifact': 'Edit Artifact',
      'saveChanges': 'Save Changes',
      'deleteArtifact': 'Delete Artifact?',
      'deleteAction': 'Delete',
      'cannotUndo': 'This action cannot be undone.',
      'officialExpedition': 'Official Expedition Find',
      'credit': 'Credit (Expedition)',
      'communityPosts': 'Community Posts',
      'noPosts': 'No posts in this community yet.',
      'officialAnnouncement': 'OFFICIAL ANNOUNCEMENT',
      'clubAnnouncement': 'CLUB ANNOUNCEMENT',
      'publishedBy': 'From',
      'newPost': 'New Post',
      'postTitle': 'Title',
      'postContent': 'Content',
      'publish': 'Publish',
      'join': 'Join',
      'leave': 'Leave',
      'teamChat': 'Team Chat',
      'noMessages': 'No messages yet.\nStart a discussion!',
      'writeToTeam': 'Write to team...',
      'admin': 'Admin',
      'moderator': 'Moderator',
      'newExpedition': 'New Expedition',
      'expeditions': 'Expeditions',
      'yourProjects': 'Your archaeological projects',
      'noProjects': 'No active projects',
      'createProjectMsg': 'Create a new expedition for your team or wait for an invitation from colleagues.',
      'start': 'Start',
      'invite': 'Invite',
      'delete': 'Delete',
      'noDescription': 'No description available...',
      'chat': 'Chat',
      'participants': 'Participants',
      'deleteProject': 'Delete project?',
      'deleteProjectConfirm': 'Are you sure you want to permanently delete expedition?',
      'inviteColleague': 'Invite colleague',
      'inviteEmailLabel': 'Enter archaeologist email to add them to your team.',
      'emailLabel': 'Archaeologist Email',
      'inviteSent': 'Invitation sent!',
      'startExpedition': 'Start Expedition',
      'projectName': 'Project Name*',
      'projectDescription': 'Description (optional)',
      'enterName': 'Enter name',
      'communityNotFound': 'Community not found',
      'publications': 'Publications',
      'editing': 'Editing',
      'noPublishRequests': 'No publication requests',
      'noEditRequests': 'No editing requests',
      'artifactPublished': 'Artifact published!',
      'rejected': 'Rejected',
      'editRequest': 'Editing Request',
      'editAllowed': 'Editing allowed',
      'parseError': 'Artifact data error',
      'artifactNotFound': 'Artifact not found',
      'noFavorites': 'You don\'t have any favorite artifacts yet',
      'communities': 'Communities',
      'searchCommunities': 'Search communities...',
      'myCommunities': 'My Communities',
      'allCommunities': 'All Communities',
      'participantsCount': 'participants',
      'newCommunity': 'New Community',
      'communityPromo': 'Unite researchers by interest.\nShare finds and discuss theories.',
      'communityName': 'Community Name',
      'communityHint': 'e.g., Egyptologists',
      'descriptionHint': 'What is your community about?',
      'cover': 'Cover',
      'addCover': 'Add cover',
      'recommendSize': 'Recommended size 800x400 (optional)',
      'createCommunityAction': 'Create Community',
      'fillFields': 'Fill in title and description',
      'communityCreated': 'Community created successfully!',
      'loginTitle': 'Archaeologist Login',
      'email': 'Email',
      'password': 'Password',
      'enterEmailPass': 'Enter email and password',
      'welcomeBack': 'Welcome back!',
      'invalidEmail': 'Invalid email format.',
      'userNotFound': 'Invalid email or password.',
      'userDisabled': 'This account has been disabled.',
      'tooManyRequests': 'Too many login attempts. Try again later.',
      'errorOccurred': 'An error occurred. Try again.',
      'loginError': 'Login error',
      'createAccount': 'Create account',
      'registerTitle': 'Archaeologist Registration',
      'registerAction': 'Register',
      'userAgreement': 'User Agreement',
      'privacyPolicy': 'Privacy Policy',
      'agreementTerms': 'By registering, you agree to our Terms of Use and Privacy Policy.',
      'userAgreementContent': '''
USER AGREEMENT (TERMS OF USE)

Last updated: May 18, 2026

Please read this User Agreement ("Agreement") carefully before using the ArcheoAI mobile application ("Application", "App", "Service"). By downloading, installing, registering an account, or otherwise using the Application, you ("User", "you") confirm that you have read, understood, and agreed to be bound by all terms set out below. If you do not agree with any part of this Agreement, you must not use the Application.

1. GENERAL PROVISIONS

1.1. This Agreement is a legally binding contract between you and the developer of ArcheoAI ("Developer", "we", "us", "our"), operating under the Bundle ID kz.haileybury.archeoai.

1.2. The Application is an educational product dedicated to the cultural and archaeological heritage of Kazakhstan. It uses artificial intelligence technologies to provide users with interactive content, descriptions of artifacts, historical references, and other educational materials.

1.3. The Developer reserves the right to modify this Agreement at any time. The current version is always available within the Application. Continued use of the Application after changes have been published constitutes your acceptance of the new terms.

2. ELIGIBILITY AND ACCOUNT REGISTRATION

2.1. The Application may be used by persons aged 13 and older. Users under the age of 18 must obtain consent from a parent or legal guardian before using the Application.

2.2. To access certain features, you must create an account by providing a valid email address, a password, and, optionally, a display name. You agree to provide accurate, current, and complete information during registration.

2.3. You are solely responsible for maintaining the confidentiality of your login credentials and for all activities that occur under your account. You agree to notify us immediately of any unauthorized use of your account.

2.4. One person may register only one account. Creating multiple accounts to bypass restrictions, manipulate ratings, or abuse Application features is prohibited.

3. USER RIGHTS AND OBLIGATIONS

3.1. You have the right to:
- access educational content provided in the Application;
- use AI-based features for interactive learning and exploration of archaeological topics;
- save your progress, bookmarks, and personal notes within the Application;
- request deletion of your account and associated personal data at any time.

3.2. You agree NOT to:
- use the Application for any unlawful purpose or in violation of any local, national, or international law;
- attempt to gain unauthorized access to the Application, its servers, or related systems;
- decompile, reverse-engineer, disassemble, or otherwise attempt to derive the source code of the Application;
- upload, share, or transmit any content that is offensive, defamatory, obscene, threatening, discriminatory, or otherwise harmful;
- use automated scripts, bots, or scrapers to collect data from the Application;
- impersonate any person or entity, or misrepresent your affiliation with any person or entity;
- interfere with or disrupt the integrity or performance of the Application or third-party services connected to it;
- use the Application to distribute spam, malware, viruses, or any other harmful code;
- exploit the Application for commercial purposes without prior written permission from the Developer.

4. INTELLECTUAL PROPERTY

4.1. All content within the Application, including but not limited to text, graphics, images, illustrations, photographs, 3D models, audio, video, AI-generated outputs, source code, design, logos, and trademarks, is the exclusive property of the Developer or its licensors and is protected by intellectual property laws of the Republic of Kazakhstan and international treaties.

4.2. You are granted a limited, non-exclusive, non-transferable, revocable license to use the Application for personal, non-commercial, educational purposes only.

4.3. Any reproduction, distribution, modification, public display, or creation of derivative works based on the Application content without the express written consent of the Developer is strictly prohibited.

4.4. User-generated content (notes, bookmarks, comments, if applicable) remains your property, but by submitting it to the Application you grant the Developer a worldwide, royalty-free, non-exclusive license to store, display, and process such content solely for the purpose of operating the Application.

5. ARTIFICIAL INTELLIGENCE FEATURES

5.1. The Application uses artificial intelligence models to generate descriptions, answer questions, and provide interactive learning experiences related to archaeological artifacts and Kazakh cultural heritage.

5.2. AI-generated content is provided for educational and informational purposes only. While we strive for accuracy, AI outputs may contain errors, inaccuracies, or interpretations that do not reflect established scientific consensus. The Developer does not guarantee the accuracy, completeness, or reliability of AI-generated content.

5.3. You acknowledge that AI responses should not be used as a substitute for professional academic research, peer-reviewed publications, or expert consultation.

5.4. Queries submitted to AI features may be transmitted to third-party AI service providers (such as Anthropic) for processing. Such transmission is subject to our Privacy Policy and the privacy policies of the respective providers.

6. ACCOUNT TERMINATION AND DELETION

6.1. You may delete your account at any time directly within the Application via the "Delete Account" option in the profile settings. Upon deletion, your personal data will be permanently removed from our servers within a reasonable technical period, except for information we are required to retain by law.

6.2. The Developer reserves the right to suspend or terminate your account, without prior notice or liability, in the event of a violation of this Agreement, fraudulent activity, or for any other reason at the Developer's sole discretion.

6.3. Upon termination, your right to use the Application will immediately cease. Provisions related to intellectual property, disclaimers of warranty, limitation of liability, and dispute resolution shall survive termination.

7. DISCLAIMERS AND LIMITATION OF LIABILITY

7.1. The Application is provided on an "as is" and "as available" basis, without warranties of any kind, either express or implied, including but not limited to warranties of merchantability, fitness for a particular purpose, non-infringement, or accuracy of content.

7.2. The Developer does not warrant that the Application will be uninterrupted, error-free, secure, or free from viruses or other harmful components.

7.3. To the maximum extent permitted by applicable law, the Developer shall not be liable for any direct, indirect, incidental, special, consequential, or punitive damages arising out of or related to your use of, or inability to use, the Application, including but not limited to loss of data, loss of profits, or business interruption.

7.4. The Developer is not responsible for any damages or losses resulting from third-party services integrated with the Application (cloud providers, AI providers, payment processors, etc.).

8. THIRD-PARTY SERVICES

8.1. The Application integrates with the following third-party services: Firebase (Google LLC) for authentication and data storage, Apple services for App Store distribution and in-app functionality, and AI providers for generative content. Your use of these services is also governed by their respective terms and privacy policies.

9. CHANGES TO THE APPLICATION

9.1. The Developer reserves the right to modify, suspend, or discontinue, temporarily or permanently, the Application or any feature thereof at any time, with or without notice. The Developer shall not be liable to you or any third party for any such modification, suspension, or discontinuance.

10. GOVERNING LAW AND DISPUTE RESOLUTION

10.1. This Agreement shall be governed by and construed in accordance with the laws of the Republic of Kazakhstan, without regard to its conflict of laws principles.

10.2. Any disputes arising out of or in connection with this Agreement shall be resolved through good-faith negotiations between the parties. If a resolution cannot be reached, the dispute shall be submitted to the competent courts at the place of registration of the Developer.

11. CONTACT INFORMATION

For any questions, comments, or complaints regarding this Agreement or the Application, please contact us at: [your support email].

By tapping "I agree" or by creating an account, you acknowledge that you have read, understood, and accepted the terms of this User Agreement.
''',
      'privacyPolicyContent': '''
PRIVACY POLICY

Last updated: May 18, 2026

This Privacy Policy describes how the ArcheoAI mobile application ("Application", "App", "we", "us", "our"), Bundle ID kz.haileybury.archeoai, collects, uses, stores, protects, and discloses personal information of its users ("User", "you", "your"). By using the Application, you consent to the practices described in this Policy.

1. INFORMATION WE COLLECT

1.1. Information you provide directly:
- Email address — required for account registration and authentication;
- Password — stored in encrypted form by Firebase Authentication, never accessible to the Developer in plain text;
- Display name (optional) — used to personalize your experience within the Application;
- Profile picture (optional) — if you choose to upload one;
- User-generated content — notes, bookmarks, saved artifacts, and queries you submit to AI features.

1.2. Information collected automatically:
- Device information — device model, operating system version, language settings, time zone, unique device identifiers;
- Usage data — features accessed, screens viewed, session duration, frequency of use, interaction events;
- Technical logs — crash reports, error logs, performance diagnostics, IP address;
- Approximate location — derived from IP address (no precise GPS data is collected unless explicitly requested for a specific feature).

1.3. Information from third parties:
- Authentication providers — if you sign in using third-party providers (such as Google or Apple Sign-In), we receive basic profile information authorized by you through those providers.

1.4. Information NOT collected:
- We do not collect precise GPS location;
- We do not collect contacts, photos, or files from your device without explicit permission;
- We do not collect financial or payment information directly (any in-app purchases are processed by Apple);
- We do not collect sensitive personal data such as race, religion, political views, health, or biometric data.

2. PURPOSES OF DATA PROCESSING

We use the collected information for the following purposes:
- to create and manage your user account;
- to provide and personalize educational content;
- to enable AI-based interactive features (queries, recommendations, explanations);
- to save your progress, bookmarks, and preferences across sessions;
- to communicate with you regarding updates, security notifications, or service-related messages;
- to monitor and analyze usage patterns in order to improve the Application;
- to detect, prevent, and address technical issues, fraud, and security incidents;
- to comply with legal obligations and respond to lawful requests from competent authorities.

3. LEGAL BASIS FOR PROCESSING

We process your personal data based on:
- your explicit consent, given when you register an account and accept this Policy;
- the necessity to perform the contract with you (provision of the Application);
- our legitimate interests in improving and securing the Application;
- compliance with applicable legal obligations.

4. DATA STORAGE AND SECURITY

4.1. Your data is stored on secure cloud servers operated by Google Firebase (Google LLC), which complies with internationally recognized security standards (ISO 27001, SOC 1/2/3).

4.2. Data may be stored on servers located outside the Republic of Kazakhstan, including in the United States and the European Union. By using the Application, you consent to the international transfer of your data.

4.3. We implement appropriate technical and organizational measures to protect your data, including:
- encryption of data in transit (HTTPS/TLS);
- encryption of credentials at rest;
- access control and authentication for administrative systems;
- regular security audits and dependency updates.

4.4. Despite our efforts, no method of transmission or storage over the Internet is 100% secure. We cannot guarantee absolute security and you acknowledge that you provide your data at your own risk.

5. DATA RETENTION

5.1. We retain your personal data for as long as your account remains active, or as long as necessary to provide you with the Application.

5.2. If you delete your account, your personal data will be permanently deleted from our active systems within 30 days. Backup copies may persist for up to 90 additional days, after which they will also be deleted.

5.3. Some data may be retained for a longer period if required by law (for example, for tax, audit, or anti-fraud purposes).

6. DATA SHARING AND DISCLOSURE

6.1. We do NOT sell, rent, or trade your personal data to third parties for marketing purposes.

6.2. We may share your data with:
- Service providers — Firebase (authentication, database, storage, analytics), AI providers (such as Anthropic for AI-based features), crash reporting tools — strictly for the purposes of operating the Application;
- Legal authorities — when required by law, court order, or to protect our rights, property, or safety, or that of our users or the public;
- Successors — in the event of a merger, acquisition, reorganization, or sale of assets, your data may be transferred to the successor entity, subject to the same level of protection described in this Policy.

6.3. All third-party service providers are contractually obligated to handle your data in accordance with applicable data protection laws.

7. AI FEATURES AND DATA PROCESSING

7.1. When you use AI-based features (such as asking questions about artifacts), the content of your query may be transmitted to third-party AI service providers (e.g., Anthropic Claude API) for processing.

7.2. We do not transmit personal identifiers (such as your email or name) together with AI queries unless strictly necessary.

7.3. AI providers may temporarily process your query content to generate responses but, according to their terms, do not use such content to train their models without your consent.

8. YOUR RIGHTS

In accordance with the Law of the Republic of Kazakhstan "On Personal Data and Its Protection" (and, where applicable, the EU GDPR), you have the right to:
- access — request a copy of the personal data we hold about you;
- rectification — correct inaccurate or incomplete data;
- erasure — request deletion of your data ("right to be forgotten"); this can be initiated directly within the Application via "Delete Account";
- restriction — limit the processing of your data in certain circumstances;
- portability — receive your data in a structured, machine-readable format;
- objection — object to the processing of your data based on legitimate interests;
- withdrawal of consent — withdraw your previously given consent at any time;
- complaint — lodge a complaint with the competent data protection authority of the Republic of Kazakhstan.

To exercise these rights, contact us at: [your support email]. We will respond within 30 calendar days.

9. ACCOUNT DELETION

9.1. You can delete your account at any time through the Application:
Profile → Settings → Delete Account → confirm deletion.

9.2. Upon confirmation, the following data will be permanently deleted:
- your authentication record (email, encrypted password);
- your profile information (display name, avatar);
- your user-generated content (notes, bookmarks, history);
- your usage logs associated with your account identifier.

9.3. Anonymized and aggregated data that no longer identifies you may be retained for analytical and statistical purposes.

10. CHILDREN'S PRIVACY

10.1. The Application is not directed to children under the age of 13. We do not knowingly collect personal data from children under 13. If we become aware that we have collected such data, we will delete it promptly.

10.2. Users aged 13 to 17 must obtain consent from a parent or legal guardian before using the Application.

11. COOKIES AND SIMILAR TECHNOLOGIES

The Application itself does not use browser cookies. However, embedded analytics and AI services may use device-level identifiers and similar technologies to function properly and measure performance.

12. INTERNATIONAL USERS

If you access the Application from outside the Republic of Kazakhstan, please be aware that your data may be transferred to, stored, and processed in countries where data protection laws may differ. By using the Application, you consent to such transfers.

13. CHANGES TO THIS PRIVACY POLICY

13.1. We may update this Privacy Policy from time to time to reflect changes in our practices, technologies, or legal requirements.

13.2. The updated version will be published within the Application with an updated "Last updated" date. For material changes, we will notify you through the Application or by email.

13.3. Your continued use of the Application after the publication of changes constitutes your acceptance of the updated Policy.

14. CONTACT INFORMATION

If you have any questions, concerns, or requests regarding this Privacy Policy or the processing of your personal data, please contact us:

Email: [your support email]
Developer: [your name / organization]
Bundle ID: kz.haileybury.archeoai

By tapping "I agree" or by using the Application, you acknowledge that you have read, understood, and accepted the terms of this Privacy Policy.
''',
      'alreadyHaveAccount': 'Already have an account? Login',
      'roleVisitor': 'Visitor',
      'roleArchaeologist': 'Archaeologist',
      'selectRole': 'Select your role',
      'exploreMuseum': 'Explore the museum and its secrets',
      'manageArtifacts': 'Add and manage historical finds',
      'fillAllFields': 'Fill in all fields',
      'passwordsDoNotMatch': 'Passwords do not match',
      'registrationSuccess': 'Registration successful!',
      'registrationError': 'Registration error',
      'confirmPassword': 'Confirm Password',
      'roleSelectionSubtitle': 'So we can provide you with the best experience',
      'iAmVisitor': 'I am a Visitor',
      'iAmArchaeologist': 'I am an Archaeologist',
      'scholarTitle': 'History Scholar',
      'scholarDesc': 'View 5 different artifacts.',
      'criticTitle': 'Art Critic',
      'criticDesc': 'Leave 3 comments on artifacts.',
      'masterTitle': 'Technophile',
      'masterDesc': 'Examine a 3D model for the first time.',
      'filterAll': 'All',
      'filterSaka': 'Saka Era',
      'filterEgypt': 'Ancient Egypt',
      'filterAntiquity': 'Antiquity',
      'filterMedieval': 'Middle Ages',
      'filterSteppe': 'Nomads',
      'unknown': 'Unknown',
      'addedBy': 'Added by',
      'searchByTitle': 'Search by title...',
      'loginToComment': 'Please login to leave a comment',
      'artifactDeleted': 'Artifact deleted',
      'mapError': 'Could not determine location',
      'loadingComments': 'Loading comments...',
      'noCommentsYet': 'No comments yet',
      'writeCommentHint': 'Write a comment...',
      'loginToWrite': 'Login to comment',
      'edited': 'edited',
      'emailAlreadyInUse': 'This email is already registered.',
      'weakPassword': 'Password too weak. Use at least 6 characters.',
      'scannerFocus': 'Focus on the object',
      'scannerPoints': 'Points captured',
      'scannerGenerating': 'Generating 3D model...',
      'scannerInstruction': 'Walk around the object taking photos',
      'scannerPolygon': 'POLYGON GENERATION',
      'addName': 'Add name',
      'saved': 'Saved',
      'nameLabel': 'Name',
      'artifactPath': 'Artifact Journey',
      'origin': 'Origin',
      'find': 'Find',
      'isTyping': 'is typing',
      'areTyping': 'people are typing',
      'deleteAccount': 'Delete Account',
      'deleteAccountConfirm': 'Are you sure you want to delete your account? This action is permanent and all your data will be lost.',
      'deleteAccountSuccess': 'Account deleted successfully',
      'deleteAccountError': 'Error deleting account'
    },
    'ru': {
      'appTitle': 'ArcheoAI',
      'home': 'Главная',
      'clubs': 'Клубы',
      'create': 'Создать',
      'projects': 'Проекты',
      'profile': 'Профиль',
      'welcome': 'Добро пожаловать в',
      'searchHint': 'Поиск артефактов...',
      'featured': 'Избранные',
      'allArtifacts': 'Все Артефакты',
      'noArtifacts': 'Ничего не найдено',
      'login': 'Вход',
      'register': 'Регистрация',
      'logout': 'Выйти',
      'editProfile': 'Редактировать',
      'statistics': 'Статистика',
      'artifactsAdded': 'Артефактов добавлено',
      'favorites': 'Избранное',
      'achievements': 'Достижения',
      'settings': 'Настройки',
      'language': 'Язык',
      'russian': 'Русский',
      'english': 'Английский',
      'museumArtifacts': 'Артефакты музея',
      'history': 'История',
      'details': 'Детали',
      'map': 'Карта',
      'comments': 'Комментарии',
      'save': 'Сохранить',
      'cancel': 'Отмена',
      'addArtifact': 'Добавить новый\nартефакт',
      'next': 'Далее',
      'back': 'Назад',
      'title': 'Название',
      'description': 'Описание',
      'category': 'Категория',
      'period': 'Период',
      'material': 'Материал',
      'condition': 'Состояние',
      'location': 'Место находки',
      'foundBy': 'Кем найден',
      'foundDate': 'Дата находки',
      'dimensions': 'Размеры',
      'height': 'Высота',
      'width': 'Ширина',
      'depth': 'Глубина',
      'notes': 'Заметки',
      'pickPhoto': 'Нажмите, чтобы выбрать фото',
      'museumSection': 'Раздел музея',
      'restorationStatus': 'Статус реставрации',
      'mainInfo': 'Основная информация',
      'discovery': 'Обнаружение',
      'eras': 'Эпохи',
      'threeD': '3D',
      'noModel': '3D модель пока не доступна',
      'editArtifact': 'Редактировать артефакт',
      'saveChanges': 'Сохранить изменения',
      'deleteArtifact': 'Удалить артефакт?',
      'deleteAction': 'Удалить',
      'cannotUndo': 'Это действие нельзя отменить.',
      'officialExpedition': 'Официальная находка экспедиции',
      'credit': 'Кредит (Экспедиция)',
      'communityPosts': 'Записи сообщества',
      'noPosts': 'В этом сообществе пока нет записей.',
      'officialAnnouncement': 'ОФИЦИАЛЬНОЕ ОБЪЯВЛЕНИЕ',
      'clubAnnouncement': 'ОБЪЯВЛЕНИЕ КЛУБА',
      'publishedBy': 'От',
      'newPost': 'Новое объявление',
      'postTitle': 'Заголовок',
      'postContent': 'Содержание',
      'publish': 'Опубликовать',
      'join': 'Вступить',
      'leave': 'Покинуть',
      'teamChat': 'Командный чат',
      'noMessages': 'Сообщений пока нет.\nНачните обсуждение!',
      'writeToTeam': 'Написать команде...',
      'admin': 'Админ',
      'moderator': 'Модератор',
      'newExpedition': 'Новая экспедиция',
      'expeditions': 'Экспедиции',
      'yourProjects': 'Ваши археологические проекты',
      'noProjects': 'Нет активных проектов',
      'createProjectMsg': 'Создайте новую экспедицию для своей команды или дождитесь приглашения от коллег.',
      'start': 'Старт',
      'invite': 'Пригласить',
      'delete': 'Удалить',
      'noDescription': 'Описание отсутствует...',
      'chat': 'Чат',
      'participants': 'Участники',
      'deleteProject': 'Удалить проект?',
      'deleteProjectConfirm': 'Вы уверены, что хотите навсегда удалить экспедицию?',
      'inviteColleague': 'Пригласить коллегу',
      'inviteEmailLabel': 'Введите email археолога, чтобы добавить его в вашу команду.',
      'emailLabel': 'Email археолога',
      'inviteSent': 'Приглашение отправлено!',
      'startExpedition': 'Начать экспедицию',
      'projectName': 'Название проекта*',
      'projectDescription': 'Описание (необязательно)',
      'enterName': 'Введите название',
      'communityNotFound': 'Сообщество не найдено',
      'publications': 'Публикации',
      'editing': 'Редактирование',
      'noPublishRequests': 'Нет заявок на публикацию',
      'noEditRequests': 'Нет запросов на редактирование',
      'artifactPublished': 'Артефакт опубликован!',
      'rejected': 'Отклонено',
      'editRequest': 'Запрос на редактирование',
      'editAllowed': 'Редактирование разрешено',
      'parseError': 'Ошибка данных артефакта',
      'artifactNotFound': 'Артефакт не найден',
      'noFavorites': 'У вас пока нет избранных артефактов',
      'communities': 'Сообщества',
      'searchCommunities': 'Поиск сообществ...',
      'myCommunities': 'Мои сообщества',
      'allCommunities': 'Все сообщества',
      'participantsCount': 'участников',
      'newCommunity': 'Новое сообщество',
      'communityPromo': 'Объедините исследователей по интересам.\nДелитесь находками и обсуждайте теории.',
      'communityName': 'Название сообщества',
      'communityHint': 'Например: Египтологи',
      'descriptionHint': 'О чем ваше сообщество?',
      'cover': 'Обложка',
      'addCover': 'Добавить обложку',
      'recommendSize': 'Рекомендуемый размер 800x400 (опционально)',
      'createCommunityAction': 'Создать сообщество',
      'fillFields': 'Заполните название и описание',
      'communityCreated': 'Сообщество успешно создано!',
      'loginTitle': 'Вход для археолога',
      'email': 'Email',
      'password': 'Пароль',
      'enterEmailPass': 'Введите email и пароль',
      'welcomeBack': 'Добро пожаловать!',
      'invalidEmail': 'Неверный формат email.',
      'userNotFound': 'Неверный email или пароль.',
      'userDisabled': 'Этот аккаунт был отключён.',
      'tooManyRequests': 'Слишком много попыток входа. Попробуйте позже.',
      'errorOccurred': 'Произошла ошибка. Попробуйте ещё раз.',
      'loginError': 'Ошибка входа',
      'createAccount': 'Создать аккаунт',
      'registerTitle': 'Регистрация археолога',
      'registerAction': 'Зарегистрироваться',
      'userAgreement': 'Пользовательское соглашение',
      'privacyPolicy': 'Политика конфиденциальности',
      'agreementTerms': 'Регистрируясь, вы соглашаетесь с Условиями использования и Политикой конфиденциальности.',
      'userAgreementContent': 'Это Пользовательское соглашение. Здесь вы можете описать условия использования вашего приложения, обязанности пользователя и другие юридические аспекты.',
      'privacyPolicyContent': 'Это Политика конфиденциальности. Здесь следует описать, какие данные вы собираете, как они используются и как вы защищаете конфиденциальность пользователей.',
      'alreadyHaveAccount': 'Уже есть аккаунт? Войти',
      'roleVisitor': 'Посетитель',
      'roleArchaeologist': 'Археолог',
      'selectRole': 'Выберите вашу роль',
      'exploreMuseum': 'Исследуйте музей и его секреты',
      'manageArtifacts': 'Добавляйте и управляйте находками',
      'fillAllFields': 'Заполните все поля',
      'passwordsDoNotMatch': 'Пароли не совпадают',
      'registrationSuccess': 'Регистрация успешна!',
      'registrationError': 'Ошибка регистрации',
      'confirmPassword': 'Подтвердите пароль',
      'roleSelectionSubtitle': 'Чтобы мы могли предоставить вам наилучший опыт',
      'iAmVisitor': 'Я Посетитель',
      'iAmArchaeologist': 'Я Археолог',
      'scholarTitle': 'Исследователь истории',
      'scholarDesc': 'Посмотрите 5 различных артефактов.',
      'criticTitle': 'Искусствовед',
      'criticDesc': 'Оставьте 3 комментария к артефактам.',
      'masterTitle': 'Технофил',
      'masterDesc': 'Изучите 3D модель в первый раз.',
      'filterAll': 'Все',
      'filterSaka': 'Эпоха саков',
      'filterEgypt': 'Древний Египет',
      'filterAntiquity': 'Античность',
      'filterMedieval': 'Средневековье',
      'filterSteppe': 'Кочевники',
      'unknown': 'Неизвестно',
      'addedBy': 'Добавил',
      'searchByTitle': 'Поиск по названию...',
      'loginToComment': 'Войдите, чтобы оставить комментарий',
      'artifactDeleted': 'Артефакт удалён',
      'mapError': 'Не удалось определить местоположение',
      'loadingComments': 'Загрузка комментариев...',
      'noCommentsYet': 'Пока нет комментариев',
      'writeCommentHint': 'Написать комментарий...',
      'loginToWrite': 'Войдите, чтобы писать',
      'edited': 'изменено',
      'emailAlreadyInUse': 'Этот email уже зарегистрирован.',
      'weakPassword': 'Слишком слабый пароль. Используйте минимум 6 символов.',
      'scannerFocus': 'Настройте фокус на объекте',
      'scannerPoints': 'Захвачено точек',
      'scannerGenerating': 'Генерация 3D модели...',
      'scannerInstruction': 'Обойдите объект, делая снимки',
      'scannerPolygon': 'ГЕНЕРАЦИЯ ПОЛИГОНОВ',
      'addName': 'Добавьте имя',
      'saved': 'Сохранено',
      'nameLabel': 'Имя',
      'artifactPath': 'Путь артефакта',
      'origin': 'Исток',
      'find': 'Находка',
      'isTyping': 'печатает...',
      'areTyping': 'человека печатают...',
      'deleteAccount': 'Удалить аккаунт',
      'deleteAccountConfirm': 'Вы уверены, что хотите удалить свой аккаунт? Это действие необратимо, и все ваши данные будут потеряны.',
      'deleteAccountSuccess': 'Аккаунт успешно удалён',
      'deleteAccountError': 'Ошибка при удалении аккаунта'
    },
  };

  String get(String key) => _localizedValues[locale.languageCode]?[key] ?? key;

  String get appTitle => get('appTitle');
  String get home => get('home');
  String get clubs => get('clubs');
  String get create => get('create');
  String get projects => get('projects');
  String get profile => get('profile');
  String get welcome => get('welcome');
  String get searchHint => get('searchHint');
  String get featured => get('featured');
  String get allArtifacts => get('allArtifacts');
  String get noArtifacts => get('noArtifacts');
  String get login => get('login');
  String get register => get('register');
  String get logout => get('logout');
  String get editProfile => get('editProfile');
  String get statistics => get('statistics');
  String get artifactsAdded => get('artifactsAdded');
  String get favorites => get('favorites');
  String get achievements => get('achievements');
  String get settings => get('settings');
  String get language => get('language');
  String get russian => get('russian');
  String get english => get('english');
  String get museumArtifacts => get('museumArtifacts');
  String get history => get('history');
  String get details => get('details');
  String get map => get('map');
  String get comments => get('comments');
  String get save => get('save');
  String get cancel => get('cancel');
  String get addArtifact => get('addArtifact');
  String get next => get('next');
  String get back => get('back');
  String get title => get('title');
  String get description => get('description');
  String get category => get('category');
  String get period => get('period');
  String get material => get('material');
  String get condition => get('condition');
  String get location => get('location');
  String get foundBy => get('foundBy');
  String get foundDate => get('foundDate');
  String get dimensions => get('dimensions');
  String get height => get('height');
  String get width => get('width');
  String get depth => get('depth');
  String get notes => get('notes');
  String get pickPhoto => get('pickPhoto');
  String get museumSection => get('museumSection');
  String get restorationStatus => get('restorationStatus');
  String get mainInfo => get('mainInfo');
  String get discovery => get('discovery');
  String get eras => get('eras');
  String get threeD => get('threeD');
  String get noModel => get('noModel');
  String get editArtifact => get('editArtifact');
  String get saveChanges => get('saveChanges');
  String get deleteArtifact => get('deleteArtifact');
  String get deleteAction => get('deleteAction');
  String get cannotUndo => get('cannotUndo');
  String get officialExpedition => get('officialExpedition');
  String get credit => get('credit');
  String get communityPosts => get('communityPosts');
  String get noPosts => get('noPosts');
  String get officialAnnouncement => get('officialAnnouncement');
  String get clubAnnouncement => get('clubAnnouncement');
  String get publishedBy => get('publishedBy');
  String get newPost => get('newPost');
  String get postTitle => get('postTitle');
  String get postContent => get('postContent');
  String get publish => get('publish');
  String get join => get('join');
  String get leave => get('leave');
  String get teamChat => get('teamChat');
  String get noMessages => get('noMessages');
  String get writeToTeam => get('writeToTeam');
  String get admin => get('admin');
  String get moderator => get('moderator');
  String get newExpedition => get('newExpedition');
  String get expeditions => get('expeditions');
  String get yourProjects => get('yourProjects');
  String get noProjects => get('noProjects');
  String get createProjectMsg => get('createProjectMsg');
  String get start => get('start');
  String get invite => get('invite');
  String get delete => get('delete');
  String get noDescription => get('noDescription');
  String get chat => get('chat');
  String get participants => get('participants');
  String get deleteProject => get('deleteProject');
  String get deleteProjectConfirm => get('deleteProjectConfirm');
  String get inviteColleague => get('inviteColleague');
  String get inviteEmailLabel => get('inviteEmailLabel');
  String get emailLabel => get('emailLabel');
  String get inviteSent => get('inviteSent');
  String get startExpedition => get('startExpedition');
  String get projectName => get('projectName');
  String get projectDescription => get('projectDescription');
  String get enterName => get('enterName');
  String get communityNotFound => get('communityNotFound');
  String get publications => get('publications');
  String get editing => get('editing');
  String get noPublishRequests => get('noPublishRequests');
  String get noEditRequests => get('noEditRequests');
  String get artifactPublished => get('artifactPublished');
  String get rejected => get('rejected');
  String get editRequest => get('editRequest');
  String get editAllowed => get('editAllowed');
  String get parseError => get('parseError');
  String get artifactNotFound => get('artifactNotFound');
  String get noFavorites => get('noFavorites');
  String get communities => get('communities');
  String get searchCommunities => get('searchCommunities');
  String get myCommunities => get('myCommunities');
  String get allCommunities => get('allCommunities');
  String get participantsCount => get('participantsCount');
  String get newCommunity => get('newCommunity');
  String get communityPromo => get('communityPromo');
  String get communityName => get('communityName');
  String get communityHint => get('communityHint');
  String get descriptionHint => get('descriptionHint');
  String get cover => get('cover');
  String get addCover => get('addCover');
  String get recommendSize => get('recommendSize');
  String get createCommunityAction => get('createCommunityAction');
  String get fillFields => get('fillFields');
  String get communityCreated => get('communityCreated');
  String get loginTitle => get('loginTitle');
  String get email => get('email');
  String get password => get('password');
  String get enterEmailPass => get('enterEmailPass');
  String get welcomeBack => get('welcomeBack');
  String get invalidEmail => get('invalidEmail');
  String get userNotFound => get('userNotFound');
  String get userDisabled => get('userDisabled');
  String get tooManyRequests => get('tooManyRequests');
  String get errorOccurred => get('errorOccurred');
  String get loginError => get('loginError');
  String get createAccount => get('createAccount');
  String get registerTitle => get('registerTitle');
  String get registerAction => get('registerAction');
  String get userAgreement => get('userAgreement');
  String get privacyPolicy => get('privacyPolicy');
  String get agreementTerms => get('agreementTerms');
  String get userAgreementContent => get('userAgreementContent');
  String get privacyPolicyContent => get('privacyPolicyContent');
  String get alreadyHaveAccount => get('alreadyHaveAccount');
  String get roleVisitor => get('roleVisitor');
  String get roleArchaeologist => get('roleArchaeologist');
  String get selectRole => get('selectRole');
  String get exploreMuseum => get('exploreMuseum');
  String get manageArtifacts => get('manageArtifacts');
  String get fillAllFields => get('fillAllFields');
  String get passwordsDoNotMatch => get('passwordsDoNotMatch');
  String get registrationSuccess => get('registrationSuccess');
  String get registrationError => get('registrationError');
  String get confirmPassword => get('confirmPassword');
  String get roleSelectionSubtitle => get('roleSelectionSubtitle');
  String get iAmVisitor => get('iAmVisitor');
  String get iAmArchaeologist => get('iAmArchaeologist');
  String get scholarTitle => get('scholarTitle');
  String get scholarDesc => get('scholarDesc');
  String get criticTitle => get('criticTitle');
  String get criticDesc => get('criticDesc');
  String get masterTitle => get('masterTitle');
  String get masterDesc => get('masterDesc');
  String get filterAll => get('filterAll');
  String get filterSaka => get('filterSaka');
  String get filterEgypt => get('filterEgypt');
  String get filterAntiquity => get('filterAntiquity');
  String get filterMedieval => get('filterMedieval');
  String get filterSteppe => get('filterSteppe');
  String get unknown => get('unknown');
  String get addedBy => get('addedBy');
  String get searchByTitle => get('searchByTitle');
  String get loginToComment => get('loginToComment');
  String get artifactDeleted => get('artifactDeleted');
  String get mapError => get('mapError');
  String get loadingComments => get('loadingComments');
  String get noCommentsYet => get('noCommentsYet');
  String get writeCommentHint => get('writeCommentHint');
  String get loginToWrite => get('loginToWrite');
  String get edited => get('edited');
  String get emailAlreadyInUse => get('emailAlreadyInUse');
  String get weakPassword => get('weakPassword');
  String get scannerFocus => get('scannerFocus');
  String get scannerPoints => get('scannerPoints');
  String get scannerGenerating => get('scannerGenerating');
  String get scannerInstruction => get('scannerInstruction');
  String get scannerPolygon => get('scannerPolygon');
  String get addName => get('addName');
  String get saved => get('saved');
  String get nameLabel => get('nameLabel');
  String get artifactPath => get('artifactPath');
  String get origin => get('origin');
  String get find => get('find');
  String get isTyping => get('isTyping');
  String get areTyping => get('areTyping');
  String get deleteAccount => get('deleteAccount');
  String get deleteAccountConfirm => get('deleteAccountConfirm');
  String get deleteAccountSuccess => get('deleteAccountSuccess');
  String get deleteAccountError => get('deleteAccountError');
}

class SDelegate extends LocalizationsDelegate<S> {
  const SDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ru'].contains(locale.languageCode);

  @override
  Future<S> load(Locale locale) => Future.value(S(locale));

  @override
  bool shouldReload(SDelegate old) => false;
}
