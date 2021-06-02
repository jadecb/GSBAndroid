# Gestion de rendez-vous

Un projet flutter permettant la gestion de rendez-vous

Si vous souhaitez build vous même le projet il vous faut créer un projet Firebase et utiliser votre fichier de configuration JSON en la plaçant dans le dossier android/app

Il est également nécessaire de mettre votre clé d'API Google Map dans le fichier android/app/src/main/AndroidManifest.xml:
```xml
<meta-data android:name="com.google.android.geo.API_KEY" android:value="VOTRE CLE ICI"/>
```

Pour générer un fichier .apk utiliser la commande:
```
flutter clean
flutter build apk
```

Dans le cas contraire il est possible d'utiliser l'apk disponible sur ce repository Gitlab.
