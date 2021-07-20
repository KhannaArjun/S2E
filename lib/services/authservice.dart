// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator2/error_handler.dart';

import '../login_page.dart';
import '../translator.dart';

class AuthService {
  //Determine if the user is authenticated.
  handleAuth() {
    return StreamBuilder(

        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return Translator("");
          } else
            return LoginPage();
        });
  }

  //Sign out
  Future<void> signOut(context) async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('email');
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));

  }

  //Sign In
  Future<String> signIn(String email, String password, context) async {
   await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((val) {
          print('Signed in');
          Navigator.pop(context);
          saveEmailToSp(email);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Translator('')));
    }).catchError((e) {
     Navigator.pop(context);
     ErrorHandler().Dialog(context, e.message);
      return null;
    });
  }

  //fb signin

  Future<String> fbSignIn(context) async {
    final fb = FacebookLogin();

// Log in
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

    String _email = "";

// Check result status
    switch (res.status) {
      case FacebookLoginStatus.success:
        // Logged in

        // Send access token to server for validation and auth
        final FacebookAccessToken accessToken = res.accessToken;
        final AuthCredential authCredential =

            FacebookAuthProvider.credential(accessToken.token);
        final result =
            await FirebaseAuth.instance.signInWithCredential(authCredential);

        print(result);

        // Get profile data
        final profile = await fb.getUserProfile();
        print('Hello, ${profile.name}! You ID: ${profile.userId}');

        // Get user profile image url
        final imageUrl = await fb.getProfileImageUrl(width: 100);
        print('Your profile image: $imageUrl');

        // Get email (since we request email permission)
        final email = await fb.getUserEmail();
        // But user can decline permission
        if (email != null)
          _email = email;


        Navigator.pop(context);
        saveEmailToSp(_email);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Translator(_email)));

        break;
      case FacebookLoginStatus.cancel:
        // User cancel log in
      print("cancelled");
        break;
      case FacebookLoginStatus.error:
        // Log in failed
        print('Error while log in: ${res.error}');
        break;
    }
  }

  //Signup a new user
  signUp(String email, String password) {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  //Reset Password
  resetPasswordLink(String email) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  void saveEmailToSp (String email) async
  {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("email", email);
  }

  Future<User> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    try{
      final GoogleSignInAccount googleSignInAccount =
      await googleSignIn.signIn();

      if (googleSignInAccount != null)
      {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try
        {
          final UserCredential userCredential =
          await auth.signInWithCredential(credential);

          user = userCredential.user;
          print('user...................... ' + user.email);
        }
        on FirebaseAuthException catch (e)
        {
          print("eeee...... " + e.message);
          if (e.code == 'account-exists-with-different-credential') {
            // handle the error here
          }
          else if (e.code == 'invalid-credential') {
            // handle the error here
          }
        }
        catch (e)
        {
          // handle the error here
          print('Error ' + e.toString());
        }
      }
    }
    catch(e)
    {
      print("Exception " + e.toString());
    }


    return user;
  }

  /*static Future<void> signOut({@required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      *//*if (!kIsWeb) {
        await googleSignIn.signOut();
      }*//*
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      *//*ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );*//*

      print('Error in sign out');
    }*/

    SnackBar customSnackBar({@required String content}) {
      return SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          content,
          style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
        ),
      );
    }
}
