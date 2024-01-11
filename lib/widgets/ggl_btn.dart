import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/root_screen.dart';
import 'package:e_commerce/services/methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});
  Future<void> _googleSignIn({required context}) async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleAccount = await googleSignIn.signIn();
      if (googleAccount != null) {
        final googleAuth = await googleAccount.authentication;
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          final authRes = await FirebaseAuth.instance
              .signInWithCredential(GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ));
          if (authRes.additionalUserInfo!.isNewUser) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(authRes.user!.uid)
                .set({
              'userId': authRes.user!.uid,
              'userName': authRes.user!.displayName,
              'userImage': authRes.user!.photoURL,
              'userEmail': authRes.user!.email,
              'createdAt': Timestamp.now(),
              'userCart': [],
              'userWish': [],
            });
          }
        }
      }
      WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
        Navigator.pushReplacementNamed(context, RootScreen.id);
      });
    } on FirebaseException catch (e) {
      MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: e.message.toString(),
        fct: () {},
      );
    } catch (e) {
      MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: e.toString(),
        fct: () {},
      );
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        padding: const EdgeInsets.all(12.0),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            12.0,
          ),
        ),
      ),
      icon: const Icon(
        Ionicons.logo_google,
        color: Colors.red,
      ),
      label: const Text(
        "Sign in with google",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () async {
        _googleSignIn(context: context);
      },
    );
  }
}
