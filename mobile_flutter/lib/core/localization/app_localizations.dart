import 'package:flutter/widgets.dart';

class AppLocalizations {

  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [

    Locale("fr"),

    Locale("ar"),

  ];

  static AppLocalizations of(
      BuildContext context,
      ) {

    return Localizations.of<
        AppLocalizations>(
      context,
      AppLocalizations,
    )!;

  }

  static const delegate =
  _AppLocalizationsDelegate();

  static const _values = {

    "fr": {

      "appName":
      "Sawti",

      "home": "Accueil",
      "claims": "Réclamations",
      "notifications": "Notifications",
      "profile": "Profil",

      "login":
      "Connexion",

      "reussi" : 'Succès',

      "login_failed" :'Connexion impossible',

      "logout":
      "Déconnexion",

      'email' : 'Email',

      'email_ob' : 'Email obligatoire',

      'welcome' : 'Bienvenue sur la plateforme',
      'prenom' :'Prénom',

      "my_claims": "Mes réclamations",


      "search": "Rechercher",

      "language": "Langue",
      "claim_details":"Détails de la réclamation",

      "claim_not_found":"Réclamation introuvable",

      "created_at":"Créée le",

      "updated_at":"Mise à jour",

      "commune":"Commune",

      "photos":"Photos",

      "history":"Historique",

      "no_history":"Aucun historique",

      "no_photo":"Aucune photo",

      "no_location":"Aucune localisation.",

      "status_new":"Nouvelle",

      "status_in_progress":"En cours",

      "status_resolved":"Résolue",

      "status_rejected":"Rejetée",

      "save": "Enregistrer",
      'password' :'Mot de passe',
      'password_ob' : 'Mot de passe obligatoire',
      'connecter' : 'Se connecter',
      'new_compte' : 'Créer un compte',
      'succes' : 'Votre compte a été créé avec succès.',
      'errer' : 'Erreur',
      'message_errer' : 'Impossible de créer le compte.',
      'rejoin' : 'Rejoignez la plateforme citoyenne',
      'obligatoire' :'Champ obligatoire',
      "nom":"Nom",
      "telephone":"Téléphone",
      "email_invalide":"Email invalide",
      "confirm_password":"Confirmer le mot de passe",
      "password_min":"Minimum 6 caractères",
      "password_not_same":"Les mots de passe sont différents",
      "no_data": "Aucune donnée",

      "hello": "Bonjour 👋",

      "welcome_message":
      "Bienvenue sur la plateforme citoyenne",

      "your_statistics":
      "Vos statistiques",

      "in_progress":
      "En cours",

      "resolved":
      "Résolues",

      "recent_claims":
      "Dernières réclamations",

      "no_claims":
      "Aucune réclamation",

      "already_register":"Déjà inscrit ? Se connecter",
      "user_not_found":
      "Utilisateur introuvable",

      "my_profile":
      "Mon profil",

      "role":
      "Rôle",


    },

    "ar": {

      "appName":"صوتي",
      'rejoin' : 'انضم إلى منصة المواطنين',
      "home": "الرئيسية",
      "claims": "شكاياتي",
      "notifications": "الإشعارات",
      "profile": "الملف الشخصي",
      "no_data": "لا توجد بيانات",
      "user_not_found":
      "المستخدم غير موجود",
      "claim_details":"تفاصيل الشكوى",

      "claim_not_found":"الشكوى غير موجودة",

      "created_at":"تاريخ الإنشاء",

      "updated_at":"آخر تحديث",

      "commune":"البلدية",

      "photos":"الصور",

      "history":"سجل التغييرات",

      "no_history":"لا يوجد سجل.",

      "no_photo":"لا توجد صور.",

      "no_location":"لا يوجد موقع.",

      "status_new":"جديدة",

      "status_in_progress":"قيد المعالجة",

      "status_resolved":"تمت المعالجة",

      "status_rejected":"مرفوضة",

      "my_profile":
      "ملفي الشخصي",

      "role":
      "الدور",

      "hello": "مرحبًا 👋",

      "welcome_message":
      "مرحبًا بك في المنصة الوطنية للشكاوى",

      "your_statistics":
      "إحصائياتك",

      "in_progress":
      "قيد المعالجة",

      "resolved":
      "تمت المعالجة",

      "recent_claims":
      "آخر الشكاوى",

      "no_claims":
      "لا توجد شكاوى",

      "login": "تسجيل الدخول",
      'reussi' : 'نجاح',
      'succes' : 'تم إنشاء حسابك بنجاح.',
      'errer' :'خطأ' ,
      'message_errer' : 'تعذّر إنشاء الحساب.',
      'welcome' : 'مرحباً بك في المنصة',
      'email_ob' : 'البريد الإلكتروني مطلوب',
      'password' : 'كلمة المرور',
      'password_ob': 'كلمة المرور مطلوبة',
      'prenom' : 'الاسم الأول',
      'email' : 'بريد إلكتروني',
      'new_compte' : 'إنشاء حساب',
      'obligatoire' : 'حقل إلزامي',
      "nom":"اللقب",
      "email_invalide":"البريد الإلكتروني غير صالح",
"telephone":"الهاتف",
      "confirm_password":"تأكيد كلمة المرور",
      "password_min":"الحد الأدنى 6 أحرف",
      "password_not_same":"كلمتا المرور غير متطابقتين",
      "already_register":"لديك حساب؟ تسجيل الدخول",


      "logout":
      "تسجيل الخروج",

      "my_claims":
      "شكاياتي",

      "login_failed" : 'تعذّر الاتصال',


      "search": "بحث",
      'connecter' : 'تسجيل الدخول',

      "language":
      "اللغة",

      "save":
      "حفظ",

    },

  };

  String text(
      String key,
      ) {

    return

      _values[
      locale.languageCode
      ]?[key]

          ??

          key;

  }

}


class _AppLocalizationsDelegate
    extends
    LocalizationsDelegate<
        AppLocalizations> {

  const _AppLocalizationsDelegate();

  @override
  bool isSupported(
      Locale locale,
      ) {

    return AppLocalizations
        .supportedLocales
        .any(

          (e)=>

      e.languageCode
          ==
          locale.languageCode,

    );

  }

  @override
  Future<
      AppLocalizations>
  load(
      Locale locale,
      ) async {

    return AppLocalizations(
      locale,
    );

  }

  @override
  bool shouldReload(
      _) =>
      false;

}