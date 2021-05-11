import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:starter_architecture_flutter_firebase/services/firebase_database.dart';

final firebaseAppProvider =
    Provider<FirebaseApp>((ref) => throw UnimplementedError());

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authStateChangesProvider = StreamProvider<User?>(
    (ref) => ref.watch(firebaseAuthProvider).authStateChanges());

final databaseProvider = Provider<Database>((ref) {
  final auth = ref.watch(authStateChangesProvider);
  final app = ref.watch(firebaseAppProvider);

  if (auth.data?.value?.uid != null) {
    return Database(
        app: FirebaseDatabase(
            app: app,
            databaseURL:
                'http://localhost:9000/?ns=flutter-test-5df78-default-rtdb'),
        uid: auth.data!.value!.uid);
  }
  throw UnimplementedError();
});

final loggerProvider = Provider<Logger>((ref) => Logger(
      printer: PrettyPrinter(
        methodCount: 1,
        printEmojis: false,
      ),
    ));
