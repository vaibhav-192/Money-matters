import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

static final auth =
FirebaseAuth.instance;

static Future<User?> signIn() async {

try {

final GoogleSignIn signIn =

GoogleSignIn.instance;

await signIn.initialize();

final account =

await signIn.authenticate();

final authData =

account.authentication;

final credential =

GoogleAuthProvider.credential(

idToken:

authData.idToken,

);

final result =

await auth.signInWithCredential(

credential,

);

return result.user;

}

catch (

e

) {

print(
e,
);

return null;

}

}

static Future<void> signOut() async {

try {

await GoogleSignIn.instance.disconnect();

}

catch (_) {}

await GoogleSignIn.instance.signOut();

await auth.signOut();

}

static User? currentUser() {

return auth.currentUser;

}

}