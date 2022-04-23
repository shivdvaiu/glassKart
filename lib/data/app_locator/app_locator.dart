
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Using GetIt is a convenient way to provide objects anywhere we need them in the app
GetIt locator = GetIt.instance;

void initLocator() {
 
locator.registerSingletonAsync(() =>SharedPreferences.getInstance());


locator..registerLazySingleton(() => FirebaseFirestore.instance);
locator.registerLazySingleton(() => FirebaseAuth.instance);

}
