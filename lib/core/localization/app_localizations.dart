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
      'find': 'Find'
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
      'find': 'Находка'
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
