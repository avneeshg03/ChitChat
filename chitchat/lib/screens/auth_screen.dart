import 'package:chitchat/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  var _isLoading = false;

  void _submitAuthForm(String email, String userName, String password,
      bool isLogin, BuildContext ctx) async {
    UserCredential usercredential;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        usercredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        usercredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // Adding Extra User Info to firestore Database!
        await FirebaseFirestore.instance
            .collection('users')
            .doc(usercredential.user!.uid)
            .set({
          'username': userName,
          'email': email,
        });
      }
    } on PlatformException catch (err) {
      var message = "An error occured please check your credentials!";
      if (err.message != null) {
        message = '${err.message}';
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
