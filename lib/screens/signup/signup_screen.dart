import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:poly_lingua_app/classes/user.dart';
import 'package:poly_lingua_app/screens/signup/signup_controller.dart';

class SignupScreen extends GetView<SignupController> {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter an email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Password cannot be empty';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Confirm Password is invalid';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  _auth
                      .createUserWithEmailAndPassword(
                          email: emailController.text.toString(),
                          password: passwordController.text.toString())
                      .then((value) async {
                    String documentId = _firestore.collection("users").doc().id;
                    final data = UserClient(
                      documentId,
                      '',
                      '',
                      '',
                      emailController.text.toString(),
                      passwordController.text.toString(),
                      '',
                    );
                    await _firestore
                        .collection('users')
                        .withConverter(
                          fromFirestore: UserClient.fromFirestore,
                          toFirestore: (UserClient userData, options) =>
                              userData.toFirestore(),
                        )
                        .doc(documentId)
                        .set(data);

                    Get.offNamed('/home');
                  }).catchError((error) {
                    Get.snackbar('Error', error.toString());
                  });
                } else {
                  Get.snackbar('Error', 'Please fill in the form',
                      duration: const Duration(seconds: 10));
                }
              },
              child: const Text('Sign up'),
            ),
            TextButton(
              onPressed: () {
                Get.offNamed('/signin');
              },
              child: const Text('Already an account? Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
