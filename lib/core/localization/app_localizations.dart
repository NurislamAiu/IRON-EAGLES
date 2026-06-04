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
      'kazakh': 'Kazakh',
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
      'userAgreementContent': 'By using ArcheoAI, you agree to comply with community guidelines. We maintain a ZERO TOLERANCE policy for inappropriate content (insults, spam, hate speech). Any user can report such content. Violators will be blocked and their content removed within 24 hours.',
      'privacyPolicyContent': 'This is the Privacy Policy. It describes what data is collected and how it is protected.',
      'alreadyHaveAccount': 'Already have an account? Login',
      'roleArchaeologist': 'Archaeologist',
      'exploreMuseum': 'Explore the museum and its secrets',
      'manageArtifacts': 'Add and manage historical finds',
      'fillAllFields': 'Fill in all fields',
      'passwordsDoNotMatch': 'Passwords do not match',
      'registrationSuccess': 'Registration successful!',
      'registrationError': 'Registration error',
      'confirmPassword': 'Confirm Password',
      'iAmArchaeologist': 'I am an Archaeologist',
      'scholarTitle': 'History Scholar',
      'scholarDesc': 'View 5 different artifacts.',
      'criticTitle': 'Art Critic',
      'criticDesc': 'Leave 3 comments on artifacts.',
      'masterTitle': 'Technophile',
      'masterDesc': 'Examine a 3D model for the first time.',
      'scannerTitle': 'Digital Surveyor',
      'scannerDesc': 'Open the 3D scanner for the first time.',
      'account': 'Account',
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
      'initSensors': 'Initializing Sensors...',
      'cameraUnavailable': 'Camera unavailable (Simulator Mode)',
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
      'deleteAccountError': 'Error deleting account',
      'report': 'Report',
      'block': 'Block',
      'blockUser': 'Block User',
      'reportContent': 'Report Content',
      'contentReported': 'Thank you. We will review this content within 24 hours.',
      'userBlocked': 'User blocked.',
      'dailyQuests': 'Daily Quests',
      'quest3D': 'Examine a 3D artifact',
      'questAI': 'Ask the AI archaeologist about finds',
      'announce': 'Announce',
      'exploreTreasures': 'Explore the ancient treasures',
      'myArtifacts': 'My Artifacts',
      'pendingPublication': 'Pending (Publication)',
      'pendingEdit': 'Pending (Edit)',
      'editRejected': 'Edit Rejected',
      'requestEdit': 'Request Edit',
      'requestSent': 'Request sent to moderators',
      'noMyArtifacts': 'You don\'t have any artifacts yet',
      'edit': 'Edit',
      'notSpecified': 'Not specified',
      'stoneAge': 'Stone Age',
      'bronzeAge': 'Bronze Age',
      'ironAge': 'Iron Age',
      'antiquity': 'Antiquity',
      'middleAges': 'Middle Ages',
      'modernEra': 'Modern Era',
      'contemporary': 'Contemporary',
      'excellentCondition': 'Excellent',
      'goodCondition': 'Good',
      'fairCondition': 'Fair',
      'poorCondition': 'Poor',
      'gpsCoords': 'GPS Coordinates',
      'latitude': 'Latitude',
      'longitude': 'Longitude',
      'locationHint': 'Location (city, region, monument)',
      'canAddGps': 'GPS location can be added here',
      'timeTravel': 'Time Travel',
      'past': 'Past',
      'today': 'Today',
      'photoRequired': 'Artifact photo is required',
      'titleDescRequired': 'Title and description are required',
      'artifactAdded': 'Artifact added successfully!',
      'parsingError': 'Parsing error',
      'requestModeration': 'Request sent to moderators',
      'newInvitations': 'NEW INVITATIONS',
      'inviteToProject': 'Invitation to project',
      'from': 'from',
      'startLabel': 'Start',
      'editLabel': 'Edit',
      'deleteLabel': 'Delete',
      'announcement': 'Announcement',
      'chatLabel': 'Chat',
      'deleteProjectConfirmMsg': 'Are you sure you want to delete expedition \'{name}\'?',
      'editExpedition': 'Edit Expedition',
      'searchArchaeologist': 'Find archaeologist by email',
      'aiRecognition': 'AI Artifact Recognition',
      'comingSoon': 'Coming soon...\nWe are training the neural network!',
      'close': 'Close',
      'achievementUnlocked': 'ACHIEVEMENT UNLOCKED!',
      'ok': 'OK',
      'aiArchaeologist': 'AI Archaeologist',
      'aiThanks': 'Thank you! The AI response will be reviewed.',
      'archaeologistTyping': 'Archaeologist is typing...',
      'askHistory': 'Ask about history...',
      'clearChat': 'Clear chat?',
      'clearChatHistory': 'All history of conversation with AI will be deleted.',
      'anonymous': 'Anonymous',
      'noAnnouncements': 'No announcements',
      'expeditionAnnouncements': 'Expedition Announcements',
      'iAgreeWith': 'I agree with',
      'aiWelcome': 'Hello! I am your AI archaeologist. Ask me any question about history, artifacts, or excavations. How can I help you today?',
      'aiGuestWelcome': 'Hello! I am your AI archaeologist. As a guest, your history will not be saved. Please log in to save chats.',
      'historyCleared': 'History cleared. What would you like to talk about?',
      'audio': 'Audio',
      'aiAudioGuide': 'AI Audio Guide',
      'listenToHistory': 'Listen to the history of this artifact',
      'aiVoicing': 'AI is voicing the description...',
      'officialExpeditionLabel': 'Official Expedition',
      'threeDModel': '3D Model',
      'onlineAssistant': 'Online Assistant',
      'scannerVersion': 'ARCHAEOLOGY SCAN V2.4',
      'artifactIdLabel': 'Artifact ID',
      'fromLabel': 'From',
      'statusLabel': 'Status',
      'encyclopedia': 'Knowledge Base',
      'kurgan': 'Kurgan',
      'kurganDesc': 'A type of tumulus or burial mound, often found in Central Asia and Eastern Europe.',
      'petroglyph': 'Petroglyph',
      'petroglyphDesc': 'Images created by removing part of a rock surface by incising, picking, or carving.',
      'sakas': 'Sakas',
      'sakasDesc': 'A group of nomadic Indo-Iranian peoples who historically inhabited the northern and eastern Eurasian Steppe.',
      'animalStyle': 'Animal Style',
      'animalStyleDesc': 'An approach to decoration found from China to Central Europe in the Iron Age, characterized by animal motifs.',
      'dromos': 'Dromos',
      'dromosDesc': 'An entrance passage or avenue leading to a building or tomb.',
      'esp32Monitor': 'ESP32 Climate Monitor',
      'esp32Address': 'ESP32 Address',
      'connect': 'Connect',
      'disconnect': 'Disconnect',
      'disconnected': 'Disconnected',
      'temperature': 'Temperature',
      'humidity': 'Humidity',
      'connected': 'Connected',
      'connecting': 'Connecting...',
      'scanQrCode': 'Scan QR Code',
      'simulatorScannerNote': 'Note: Camera scanning requires a real device. On simulator, please use manual entry.',
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
      'kazakh': 'Казахский',
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
      'userAgreementContent': 'Используя ArcheoAI, вы соглашаетесь соблюдать правила сообщества. Мы придерживаемся политики НУЛЕВОЙ ТЕРПИМОСТИ к неприемлемому контенту (оскорблениям, спаму, враждебным высказываниям). Любой пользователь может пожаловаться на такой контент. Нарушители будут заблокированы, а их контент удален в течение 24 часов.',
      'privacyPolicyContent': 'Это Политика конфиденциальности. Здесь следует описать, какие данные вы собираете, как они используются и как вы защищаете конфиденциальность пользователей.',
      'alreadyHaveAccount': 'Уже есть аккаунт? Войти',
      'roleArchaeologist': 'Археолог',
      'exploreMuseum': 'Исследуйте музей и его секреты',
      'manageArtifacts': 'Добавляйте и управляйте находками',
      'fillAllFields': 'Заполните все поля',
      'passwordsDoNotMatch': 'Пароли не совпадают',
      'registrationSuccess': 'Регистрация успешна!',
      'registrationError': 'Ошибка регистрации',
      'confirmPassword': 'Подтвердите пароль',
      'iAmArchaeologist': 'Я Археолог',
      'scholarTitle': 'Исследователь истории',
      'scholarDesc': 'Посмотрите 5 различных артефактов.',
      'criticTitle': 'Искусствовед',
      'criticDesc': 'Оставьте 3 комментария к артефактам.',
      'masterTitle': 'Технофил',
      'masterDesc': 'Изучите 3D модель в первый раз.',
      'scannerTitle': 'Цифровой геодезист',
      'scannerDesc': 'Откройте 3D-сканер в первый раз.',
      'account': 'Аккаунт',
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
      'deleteAccountError': 'Ошибка при удалении аккаунта',
      'report': 'Пожаловаться',
      'block': 'Заблокировать',
      'blockUser': 'Заблокировать пользователя',
      'reportContent': 'Сообщить о нарушении',
      'contentReported': 'Спасибо. Мы проверим этот контент в течение 24 часов.',
      'userBlocked': 'Пользователь заблокирован.',
      'dailyQuests': 'Ежедневные задания',
      'quest3D': 'Изучить 3D-экспонат',
      'questAI': 'Спросить ИИ-археолога о находках',
      'announce': 'Объявить',
      'exploreTreasures': 'Исследуйте древние сокровища',
      'myArtifacts': 'Мои находки',
      'pendingPublication': 'Ожидает (публикация)',
      'pendingEdit': 'Ожидает (ред.)',
      'editRejected': 'Редактирование отклонено',
      'requestEdit': 'Редактирование',
      'requestSent': 'Запрос отправлен модерации',
      'noMyArtifacts': 'У вас пока нет артефактов',
      'edit': 'Редактировать',
      'notSpecified': 'Не указано',
      'stoneAge': 'Каменный век',
      'bronzeAge': 'Бронзовый век',
      'ironAge': 'Железный век',
      'antiquity': 'Античность',
      'middleAges': 'Средневековье',
      'modernEra': 'Новое время',
      'contemporary': 'Современный период',
      'excellentCondition': 'Отличное состояние',
      'goodCondition': 'Хорошее состояние',
      'fairCondition': 'Среднее состояние',
      'poorCondition': 'Плохое состояние',
      'gpsCoords': 'GPS координаты',
      'latitude': 'Широта',
      'longitude': 'Долгота',
      'locationHint': 'Место (город, область, памятник)',
      'canAddGps': 'Можно будет добавить геолокацию GPS',
      'timeTravel': 'Путешествие во времени',
      'past': 'Прошлое',
      'today': 'Сегодня',
      'photoRequired': 'Требуется фото артефакта',
      'titleDescRequired': 'Название и описание обязательны',
      'artifactAdded': 'Артефакт успешно добавлен!',
      'parsingError': 'Ошибка парсинга',
      'requestModeration': 'Запрос отправлен модерации',
      'newInvitations': 'НОВЫЕ ПРИГЛАШЕНИЯ',
      'inviteToProject': 'Приглашение в проект',
      'from': 'от',
      'startLabel': 'Старт',
      'editLabel': 'Изменить',
      'deleteLabel': 'Удалить',
      'announcement': 'Объявление',
      'chatLabel': 'Чат',
      'deleteProjectConfirmMsg': 'Вы уверены, что хотите удалить экспедицию \'{name}\'?',
      'editExpedition': 'Редактировать экспедицию',
      'searchArchaeologist': 'Найдите археолога по email.',
      'aiRecognition': 'AI-распознавание артефактов',
      'comingSoon': 'Скоро будет доступно...\nМы обучаем нейросеть!',
      'close': 'Закрыть',
      'achievementUnlocked': 'ДОСТИЖЕНИЕ ПОЛУЧЕНО!',
      'ok': 'ОК',
      'aiArchaeologist': 'ИИ Археолог',
      'aiThanks': 'Спасибо! Ответ ИИ будет проверен.',
      'archaeologistTyping': 'Археолог печатает...',
      'askHistory': 'Спросите об истории...',
      'clearChat': 'Очистить чат?',
      'clearChatHistory': 'Вся история общения с ИИ будет удалена.',
      'anonymous': 'Аноним',
      'noAnnouncements': 'Нет объявлений',
      'expeditionAnnouncements': 'Объявления экспедиции',
      'iAgreeWith': 'Я согласен с',
      'aiWelcome': 'Здравствуйте! Я ваш ИИ-археолог. Задайте мне любой вопрос об истории, артефактах или раскопках. Чем я могу помочь вам сегодня?',
      'aiGuestWelcome': 'Здравствуйте! Я ваш ИИ-археолог. Как гость, ваша история не будет сохранена. Пожалуйста, войдите, чтобы сохранять чаты.',
      'historyCleared': 'История очищена. О чем хотите поговорить?',
      'audio': 'Аудио',
      'aiAudioGuide': 'ИИ Аудиогид',
      'listenToHistory': 'Слушайте историю этого артефакта',
      'aiVoicing': 'ИИ озвучивает описание...',
      'officialExpeditionLabel': 'Официальная экспедиция',
      'threeDModel': '3D Модель',
      'onlineAssistant': 'Онлайн-помощник',
      'scannerVersion': 'АРХЕОЛОГИЧЕСКИЙ СКАНЕР V2.4',
      'artifactIdLabel': 'ID артефакта',
      'fromLabel': 'От',
      'statusLabel': 'Статус',
      'encyclopedia': 'База знаний',
      'kurgan': 'Курган',
      'kurganDesc': 'Тип погребального кургана, часто встречающийся в Центральной Азии и Восточной Европе.',
      'petroglyph': 'Петроглифы',
      'petroglyphDesc': 'Изображения, созданные путем удаления части поверхности скалы путем высекания, выбивания или резьбы.',
      'sakas': 'Саки',
      'sakasDesc': 'Группа кочевых индоиранских народов, которые исторически населяли северную и восточную часть Евразийской степи.',
      'animalStyle': 'Звериный стиль',
      'animalStyleDesc': 'Подход к декору, встречающийся от Китая до Центральной Европы в железном веке, характеризующийся анималистическими мотивами.',
      'dromos': 'Дромос',
      'dromosDesc': 'Входной проход или аллея, ведущая к зданию или гробнице.',
      'esp32Monitor': 'Монитор климата ESP32',
      'esp32Address': 'Адрес ESP32',
      'connect': 'Подключиться',
      'disconnect': 'Отключиться',
      'disconnected': 'Отключено',
      'temperature': 'Температура',
      'humidity': 'Влажность',
      'connected': 'Подключено',
      'connecting': 'Подключение...',
      'scanQrCode': 'Сканировать QR-код',
      'simulatorScannerNote': 'Примечание: Сканирование камерой требует реального устройства. На симуляторе используйте ручной ввод.',
    },
    'kk': {
      'appTitle': 'ArcheoAI',
      'home': 'Басты бет',
      'clubs': 'Клубтар',
      'create': 'Құру',
      'projects': 'Жобалар',
      'profile': 'Профиль',
      'welcome': 'Қош келдіңіз',
      'searchHint': 'Артефакттарды іздеу...',
      'featured': 'Таңдаулы',
      'allArtifacts': 'Барлық артефакттар',
      'noArtifacts': 'Артефакттар табылмады',
      'login': 'Кіру',
      'register': 'Тіркелу',
      'logout': 'Шығу',
      'editProfile': 'Профильді өңдеу',
      'statistics': 'Статистика',
      'artifactsAdded': 'Қосылған артефакттар',
      'favorites': 'Таңдаулылар',
      'achievements': 'Жетістіктер',
      'settings': 'Баптаулар',
      'language': 'Тіл',
      'russian': 'Орыс тілі',
      'english': 'Ағылшын тілі',
      'kazakh': 'Қазақ тілі',
      'museumArtifacts': 'Мұражай артефакттары',
      'history': 'Тарих',
      'details': 'Толығырақ',
      'map': 'Карта',
      'comments': 'Пікірлер',
      'save': 'Сақтау',
      'cancel': 'Бас тарту',
      'addArtifact': 'Жаңа артефакт\nқосу',
      'next': 'Келесі',
      'back': 'Артқа',
      'title': 'Атауы',
      'description': 'Сипаттамасы',
      'category': 'Санат',
      'period': 'Кезең',
      'material': 'Материал',
      'condition': 'Күйі',
      'location': 'Табылған жері',
      'foundBy': 'Тапқан адам',
      'foundDate': 'Табылған күні',
      'dimensions': 'Өлшемдері',
      'height': 'Биіктігі',
      'width': 'Ені',
      'depth': 'Тереңдігі',
      'notes': 'Ескертулер',
      'pickPhoto': 'Фото таңдау үшін басыңыз',
      'museumSection': 'Мұражай бөлімі',
      'restorationStatus': 'Реставрация күйі',
      'mainInfo': 'Негізгі ақпарат',
      'discovery': 'Табылуы',
      'eras': 'Дәуірлер',
      'threeD': '3D',
      'noModel': '3D модель қолжетімсіз',
      'editArtifact': 'Артефактты өңдеу',
      'saveChanges': 'Өзгерістерді сақтау',
      'deleteArtifact': 'Артефактты жою?',
      'deleteAction': 'Жою',
      'cannotUndo': 'Бұл әрекетті болдырмау мүмкін емес.',
      'officialExpedition': 'Ресми экспедиция олжасы',
      'credit': 'Кредит (Экспедиция)',
      'communityPosts': 'Қауымдастық жазбалары',
      'noPosts': 'Бұл қауымдастықта әлі жазбалар жоқ.',
      'officialAnnouncement': 'РЕСМИ ХАБАРЛАНДЫРУ',
      'clubAnnouncement': 'КЛУБ ХАБАРЛАНДЫРУЫ',
      'publishedBy': 'Кімнен',
      'newPost': 'Жаңа жазба',
      'postTitle': 'Тақырыбы',
      'postContent': 'Мазмұны',
      'publish': 'Жариялау',
      'join': 'Қосылу',
      'leave': 'Шығу',
      'teamChat': 'Командалық чат',
      'noMessages': 'Хабарламалар жоқ.\nТалқылауды бастаңыз!',
      'writeToTeam': 'Командаға жазу...',
      'admin': 'Админ',
      'moderator': 'Модератор',
      'newExpedition': 'Жаңа экспедиция',
      'expeditions': 'Экспедициялар',
      'yourProjects': 'Сіздің археологиялық жобаларыңыз',
      'noProjects': 'Белсенді жобалар жоқ',
      'createProjectMsg': 'Командаңыз үшін жаңа экспедиция құрыңыз немесе әріптестеріңізден шақыру күтіңіз.',
      'start': 'Бастау',
      'invite': 'Шақыру',
      'delete': 'Жою',
      'noDescription': 'Сипаттамасы жоқ...',
      'chat': 'Чат',
      'participants': 'Қатысушылар',
      'deleteProject': 'Жобаны жою?',
      'deleteProjectConfirm': 'Экспедицияны біржола жойғыңыз келетініне сенімдісіз бе?',
      'inviteColleague': 'Әріптесті шақыру',
      'inviteEmailLabel': 'Командаңызға қосу үшін археологтың email-ын енгізіңіз.',
      'emailLabel': 'Археологтың Email-ы',
      'inviteSent': 'Шақыру жіберілді!',
      'startExpedition': 'Экспедицияны бастау',
      'projectName': 'Жоба атауы*',
      'projectDescription': 'Сипаттамасы (міндетті емес)',
      'enterName': 'Атауын енгізіңіз',
      'communityNotFound': 'Қауымдастық табылмады',
      'publications': 'Жарияланымдар',
      'editing': 'Өңдеу',
      'noPublishRequests': 'Жариялауға сұраныстар жоқ',
      'noEditRequests': 'Өңдеуге сұраныстар жоқ',
      'artifactPublished': 'Артефакт жарияланды!',
      'rejected': 'Қабылданбады',
      'editRequest': 'Өңдеу сұранысы',
      'editAllowed': 'Өңдеуге рұқсат берілді',
      'parseError': 'Артефакт деректерінің қатесі',
      'artifactNotFound': 'Артефакт табылмады',
      'noFavorites': 'Сізде әлі таңдаулы артефакттар жоқ',
      'communities': 'Қауымдастықтар',
      'searchCommunities': 'Қауымдастықтарды іздеу...',
      'myCommunities': 'Менің қауымдастықтарым',
      'allCommunities': 'Барлық қауымдастықтар',
      'participantsCount': 'қатысушы',
      'newCommunity': 'Жаңа қауымдастық',
      'communityPromo': 'Зерттеушілерді қызығушылықтары бойынша біріктіріңіз.\nОлжалармен бөлісіп, теорияларды талқылаңыз.',
      'communityName': 'Қауымдастық атауы',
      'communityHint': 'мысалы, Египтологтар',
      'descriptionHint': 'Қауымдастығыңыз не туралы?',
      'cover': 'Мұқаба',
      'addCover': 'Мұқаба қосу',
      'recommendSize': 'Ұсынылатын өлшем 800x400 (міндетті емес)',
      'createCommunityAction': 'Қауымдастық құру',
      'fillFields': 'Тақырыбы мен сипаттамасын толтырыңыз',
      'communityCreated': 'Қауымдастық сәтті құрылды!',
      'loginTitle': 'Археологтың кіруі',
      'email': 'Email',
      'password': 'Құпия сөз',
      'enterEmailPass': 'Email мен құпия сөзді енгізіңіз',
      'welcomeBack': 'Қош келдіңіз!',
      'invalidEmail': 'Email форматы қате.',
      'userNotFound': 'Қате email немесе құпия сөз.',
      'userDisabled': 'Бұл аккаунт бұғатталған.',
      'tooManyRequests': 'Кіру әрекеттері тым көп. Кейінікер қайталап көріңіз.',
      'errorOccurred': 'Қате орын алды. Қайталап көріңіз.',
      'loginError': 'Кіру қатесі',
      'createAccount': 'Аккаунт құру',
      'registerTitle': 'Археологты тіркеу',
      'registerAction': 'Тіркелу',
      'userAgreement': 'Пайдаланушы келісімі',
      'privacyPolicy': 'Құпиялылық саясаты',
      'agreementTerms': 'Тіркелу арқылы сіз біздің Пайдалану шарттарымыз бен Құпиялылық саясатымызға келісесіз.',
      'userAgreementContent': 'ArcheoAI пайдалану арқылы сіз қауымдастық ережелерін сақтауға келісесіз. Біз орынсыз мазмұнға (балағаттау, спам, өшпенділік тілі) МҮЛДЕМ ТӨЗБЕУ саясатын ұстанамыз. Кез келген пайдаланушы мұндай мазмұн туралы хабарлай алады. Тәртіп бұзушылар бұғатталады, ал олардың мазмұны 24 сағат ішінде жойылады.',
      'privacyPolicyContent': 'Бұл Құпиялылық саясаты. Ол қандай деректер жиналатынын және олардың қалай қорғалатынын сипаттайды.',
      'alreadyHaveAccount': 'Аккаунтыңыз бар ма? Кіру',
      'roleArchaeologist': 'Археолог',
      'exploreMuseum': 'Мұражай мен оның құпияларын зерттеңіз',
      'manageArtifacts': 'Тарихи олжаларды қосыңыз және басқарыңыз',
      'fillAllFields': 'Барлық өрістерді толтырыңыз',
      'passwordsDoNotMatch': 'Құпия сөздер сәйкес келмейді',
      'registrationSuccess': 'Тіркелу сәтті аяқталды!',
      'registrationError': 'Тіркелу қатесі',
      'confirmPassword': 'Құпия сөзді растаңыз',
      'iAmArchaeologist': 'Мен Археологпын',
      'scholarTitle': 'Тарих зерттеушісі',
      'scholarDesc': '5 түрлі артефактты қараңыз.',
      'criticTitle': 'Өнертанушы',
      'criticDesc': 'Артефакттарға 3 пікір қалдырыңыз.',
      'masterTitle': 'Технофил',
      'masterDesc': '3D модельді алғаш рет зерттеңіз.',
      'scannerTitle': 'Сандық геодезист',
      'scannerDesc': '3D сканерді алғаш рет ашыңыз.',
      'account': 'Тіркелгі',
      'filterAll': 'Барлығы',
      'filterSaka': 'Сақ дәуірі',
      'filterEgypt': 'Ежелгі Египет',
      'filterAntiquity': 'Антикалық дәуір',
      'filterMedieval': 'Орта ғасырлар',
      'filterSteppe': 'Көшпелілер',
      'unknown': 'Белгісіз',
      'addedBy': 'Қосқан адам',
      'searchByTitle': 'Тақырыбы бойынша іздеу...',
      'loginToComment': 'Пікір қалдыру үшін жүйеге кіріңіз',
      'artifactDeleted': 'Артефакт жойылды',
      'mapError': 'Орналасқан жерді анықтау мүмкін болмады',
      'loadingComments': 'Пікірлер жүктелуде...',
      'noCommentsYet': 'Әлі пікірлер жоқ',
      'writeCommentHint': 'Пікір жазыңыз...',
      'loginToWrite': 'Жазу үшін жүйеге кіріңіз',
      'edited': 'өңделген',
      'emailAlreadyInUse': 'Бұл email бұрыннан тіркелген.',
      'weakPassword': 'Құпия сөз тым әлсіз. Кемінде 6 таңба пайдаланыңыз.',
      'scannerFocus': 'Объектіге фокустаңыз',
      'scannerPoints': 'Түсірілген нүктелер',
      'scannerGenerating': '3D модель жасалуда...',
      'scannerInstruction': 'Фотоға түсіре отырып, объектіні айналып шығыңыз',
      'scannerPolygon': 'ПОЛИГОНДАРДЫ ГЕНЕРАЦИЯЛАУ',
      'initSensors': 'Датчиктер инициализациялануда...',
      'cameraUnavailable': 'Камера қолжетімсіз (Симулятор режимі)',
      'addName': 'Есім қосыңыз',
      'saved': 'Сақталды',
      'nameLabel': 'Есім',
      'artifactPath': 'Артефакт жолы',
      'origin': 'Шығу тегі',
      'find': 'Олжа',
      'isTyping': 'жазып жатыр...',
      'areTyping': 'адам жазып жатыр...',
      'deleteAccount': 'Аккаунтты жою',
      'deleteAccountConfirm': 'Аккаунтыңызды жойғыңыз келетініне сенімдісіз бе? Бұл әрекет қайтымсыз.',
      'deleteAccountSuccess': 'Аккаунт сәтті жойылды',
      'deleteAccountError': 'Аккаунтты жою қатесі',
      'report': 'Шағымдану',
      'block': 'Бұғаттау',
      'blockUser': 'Пайдаланушыны бұғаттау',
      'reportContent': 'Мазмұн туралы хабарлау',
      'contentReported': 'Рахмет. Біз бұл мазмұнды 24 сағат ішінде тексереміз.',
      'userBlocked': 'Пайдаланушы бұғатталды.',
      'dailyQuests': 'Күнделікті тапсырмалар',
      'quest3D': '3D артефактты зерттеу',
      'questAI': 'ИИ археологынан олжалар туралы сұрау',
      'announce': 'Хабарлау',
      'exploreTreasures': 'Ежелгі қазыналарды зерттеңіз',
      'myArtifacts': 'Менің артефакттарым',
      'pendingPublication': 'Күтуде (Жариялау)',
      'pendingEdit': 'Күтуде (Өңдеу)',
      'editRejected': 'Өңдеу қабылданбады',
      'requestEdit': 'Өңдеуге сұраныс',
      'requestSent': 'Сұраныс модераторларға жіберілді',
      'noMyArtifacts': 'Сізде әлі артефакттар жоқ',
      'edit': 'Өңдеу',
      'notSpecified': 'Көрсетілмеген',
      'stoneAge': 'Тас дәуірі',
      'bronzeAge': 'Қола дәуірі',
      'ironAge': 'Темір дәуірі',
      'antiquity': 'Антикалық дәуір',
      'middleAges': 'Орта ғасырлар',
      'modernEra': 'Жаңа заман',
      'contemporary': 'Қазіргі заман',
      'excellentCondition': 'Өте жақсы',
      'goodCondition': 'Жақсы',
      'fairCondition': 'Орташа',
      'poorCondition': 'Нашар',
      'gpsCoords': 'GPS координаттары',
      'latitude': 'Ендік',
      'longitude': 'Бойлық',
      'locationHint': 'Орны (қала, облыс, ескерткіш)',
      'canAddGps': 'GPS геолокациясын қосуға болады',
      'timeTravel': 'Уақыт саяхаты',
      'past': 'Өткен шақ',
      'today': 'Бүгін',
      'photoRequired': 'Артефакт фотосы қажет',
      'titleDescRequired': 'Атауы мен сипаттамасы міндетті',
      'artifactAdded': 'Артефакт сәтті қосылды!',
      'parsingError': 'Парсинг қатесі',
      'requestModeration': 'Сұраныс модераторларға жіберілді',
      'newInvitations': 'ЖАҢА ШАҚЫРУЛАР',
      'inviteToProject': 'Жобаға шақыру',
      'from': 'кімнен',
      'startLabel': 'Бастау',
      'editLabel': 'Өңдеу',
      'deleteLabel': 'Жою',
      'announcement': 'Хабарландыру',
      'chatLabel': 'Чат',
      'deleteProjectConfirmMsg': '\'{name}\' экспедициясын жойғыңыз келетініне сенімдісіз бе?',
      'editExpedition': 'Экспедицияны өңдеу',
      'searchArchaeologist': 'Археологты email арқылы табыңыз',
      'aiRecognition': 'AI арқылы артефактты тану',
      'comingSoon': 'Жақында қолжетімді болады...\nБіз нейрожеліні оқытып жатырмыз!',
      'close': 'Жабу',
      'achievementUnlocked': 'ЖЕТІСТІК АШЫЛДЫ!',
      'ok': 'ОК',
      'aiArchaeologist': 'ИИ Археолог',
      'aiThanks': 'Рахмет! ИИ жауабы тексеріледі.',
      'archaeologistTyping': 'Археолог жазып жатыр...',
      'askHistory': 'Тарих туралы сұраңыз...',
      'clearChat': 'Чатты тазалау?',
      'clearChatHistory': 'ИИ-мен сөйлесу тарихының барлығы жойылады.',
      'anonymous': 'Аноним',
      'noAnnouncements': 'Хабарландырулар жоқ',
      'expeditionAnnouncements': 'Экспедиция хабарландырулары',
      'iAgreeWith': 'Мен келісемін',
      'aiWelcome': 'Сәлеметсіз бе! Мен сіздің ИИ-археологыңызбын. Маған тарих, артефакттар немесе қазба жұмыстары туралы кез келген сұрақ қойыңыз. Бүгін сізге қалай көмектесе аламын?',
      'aiGuestWelcome': 'Сәлеметсіз бе! Мен сіздің ИИ-археологыңызбын. Қонақ ретінде сіздің тарихыңыз сақталмайды. Сақтау үшін жүйеге кіріңіз.',
      'historyCleared': 'Тарих тазартылды. Не туралы сөйлескіңіз келеді?',
      'audio': 'Аудио',
      'aiAudioGuide': 'ИИ Аудиогид',
      'listenToHistory': 'Артефакт тарихын тыңдаңыз',
      'aiVoicing': 'ИИ сипаттаманы оқып жатыр...',
      'officialExpeditionLabel': 'Ресми экспедиция',
      'threeDModel': '3D модель',
      'onlineAssistant': 'Онлайн көмекші',
      'scannerVersion': 'АРХЕОЛОГИЯЛЫҚ СКАНЕР V2.4',
      'artifactIdLabel': 'Артефакт ID',
      'fromLabel': 'Кімнен',
      'statusLabel': 'Күйі',
      'encyclopedia': 'Білгілер базасы',
      'kurgan': 'Қорған',
      'kurganDesc': 'Орталық Азия мен Шығыс Еуропада жиі кездесетін төбешік немесе зират түрі.',
      'petroglyph': 'Петроглифтер',
      'petroglyphDesc': 'Жартас бетіне қашап, кесіп немесе ойып салынған суреттер.',
      'sakas': 'Сақтар',
      'sakasDesc': 'Еуразия даласының солтүстігі мен шығысында тарихи мекендеген көшпелі үнді-иран халықтарының тобы.',
      'animalStyle': 'Аң стилі',
      'animalStyleDesc': 'Темір дәуірінде Қытайдан Орталық Еуропаға дейін таралған, жануарлар мотивтерімен сипатталатын безендіру тәсілі.',
      'dromos': 'Дромос',
      'dromosDesc': 'Ғимаратқа немесе қабірге апаратын кіреберіс өткел немесе даңғыл.',
      'esp32Monitor': 'ESP32 климат мониторы',
      'esp32Address': 'ESP32 мекенжайы',
      'connect': 'Қосылу',
      'disconnect': 'Ажырату',
      'disconnected': 'Ажыратылған',
      'temperature': 'Температура',
      'humidity': 'Ылғалдылық',
      'connected': 'Қосылды',
      'connecting': 'Қосылуда...',
      'scanQrCode': 'QR-кодты сканерлеу',
      'simulatorScannerNote': 'Ескерту: Камерамен сканерлеу үшін нақты құрылғы қажет. Симуляторда қолмен енгізуді пайдаланыңыз.',
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
  String get kazakh => get('kazakh');
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
  String get initSensors => get('initSensors');
  String get cameraUnavailable => get('cameraUnavailable');
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
  String get report => get('report');
  String get block => get('block');
  String get blockUser => get('blockUser');
  String get reportContent => get('reportContent');
  String get contentReported => get('contentReported');
  String get userBlocked => get('userBlocked');
  String get dailyQuests => get('dailyQuests');
  String get quest3D => get('quest3D');
  String get questAI => get('questAI');
  String get announce => get('announce');
  String get exploreTreasures => get('exploreTreasures');
  String get myArtifacts => get('myArtifacts');
  String get pendingPublication => get('pendingPublication');
  String get pendingEdit => get('pendingEdit');
  String get editRejected => get('editRejected');
  String get requestEdit => get('requestEdit');
  String get requestSent => get('requestSent');
  String get noMyArtifacts => get('noMyArtifacts');
  String get edit => get('edit');
  String get notSpecified => get('notSpecified');
  String get stoneAge => get('stoneAge');
  String get bronzeAge => get('bronzeAge');
  String get ironAge => get('ironAge');
  String get antiquity => get('antiquity');
  String get middleAges => get('middleAges');
  String get modernEra => get('modernEra');
  String get contemporary => get('contemporary');
  String get excellentCondition => get('excellentCondition');
  String get goodCondition => get('goodCondition');
  String get fairCondition => get('fairCondition');
  String get poorCondition => get('poorCondition');
  String get gpsCoords => get('gpsCoords');
  String get latitude => get('latitude');
  String get longitude => get('longitude');
  String get locationHint => get('locationHint');
  String get canAddGps => get('canAddGps');
  String get timeTravel => get('timeTravel');
  String get past => get('past');
  String get today => get('today');
  String get photoRequired => get('photoRequired');
  String get titleDescRequired => get('titleDescRequired');
  String get artifactAdded => get('artifactAdded');
  String get parsingError => get('parsingError');
  String get requestModeration => get('requestModeration');
  String get newInvitations => get('newInvitations');
  String get inviteToProject => get('inviteToProject');
  String get from => get('from');
  String get startLabel => get('startLabel');
  String get editLabel => get('editLabel');
  String get deleteLabel => get('deleteLabel');
  String get announcement => get('announcement');
  String get chatLabel => get('chatLabel');
  String deleteProjectConfirmMsg(String name) => get('deleteProjectConfirmMsg').replaceAll('{name}', name);
  String get editExpedition => get('editExpedition');
  String get searchArchaeologist => get('searchArchaeologist');
  String get aiRecognition => get('aiRecognition');
  String get comingSoon => get('comingSoon');
  String get close => get('close');
  String get achievementUnlocked => get('achievementUnlocked');
  String get ok => get('ok');
  String get aiArchaeologist => get('aiArchaeologist');
  String get aiThanks => get('aiThanks');
  String get archaeologistTyping => get('archaeologistTyping');
  String get askHistory => get('askHistory');
  String get clearChat => get('clearChat');
  String get clearChatHistory => get('clearChatHistory');
  String get anonymous => get('anonymous');
  String get noAnnouncements => get('noAnnouncements');
  String get expeditionAnnouncements => get('expeditionAnnouncements');
  String get iAgreeWith => get('iAgreeWith');
  String get audio => get('audio');
  String get aiAudioGuide => get('aiAudioGuide');
  String get listenToHistory => get('listenToHistory');
  String get aiVoicing => get('aiVoicing');
  String get officialExpeditionLabel => get('officialExpeditionLabel');
  String get threeDModel => get('threeDModel');
  String get onlineAssistant => get('onlineAssistant');
  String get scannerVersion => get('scannerVersion');
  String get artifactIdLabel => get('artifactIdLabel');
  String get fromLabel => get('fromLabel');
  String get statusLabel => get('statusLabel');
  String get encyclopedia => get('encyclopedia');
  String get kurgan => get('kurgan');
  String get kurganDesc => get('kurganDesc');
  String get petroglyph => get('petroglyph');
  String get petroglyphDesc => get('petroglyphDesc');
  String get sakas => get('sakas');
  String get sakasDesc => get('sakasDesc');
  String get animalStyle => get('animalStyle');
  String get animalStyleDesc => get('animalStyleDesc');
  String get dromos => get('dromos');
  String get dromosDesc => get('dromosDesc');
  String get esp32Monitor => get('esp32Monitor');
  String get esp32Address => get('esp32Address');
  String get connect => get('connect');
  String get disconnect => get('disconnect');
  String get disconnected => get('disconnected');
  String get temperature => get('temperature');
  String get humidity => get('humidity');
  String get connected => get('connected');
  String get connecting => get('connecting');
  String get scanQrCode => get('scanQrCode');
  String get simulatorScannerNote => get('simulatorScannerNote');
}

class SDelegate extends LocalizationsDelegate<S> {
  const SDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ru', 'kk'].contains(locale.languageCode);

  @override
  Future<S> load(Locale locale) => Future.value(S(locale));

  @override
  bool shouldReload(SDelegate old) => false;
}
