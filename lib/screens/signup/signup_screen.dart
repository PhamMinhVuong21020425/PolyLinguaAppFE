import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:poly_lingua_app/classes/user.dart';
import 'package:poly_lingua_app/screens/signup/signup_controller.dart';
import 'package:poly_lingua_app/services/user_controller.dart';

class SignupScreen extends GetView<SignupController> {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var fullNameController = TextEditingController();
    var passwordController = TextEditingController();
    var confirmController = TextEditingController();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final userController = Get.find<UserController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: fullNameController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: confirmController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Confirm Password is invalid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF00B761),
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      side: const BorderSide(
                        color: Color(0xFF00B761),
                        width: 1.5,
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (passwordController.text != confirmController.text) {
                      Get.snackbar(
                        'Error',
                        'Passwords do not match',
                        duration: const Duration(seconds: 10),
                      );
                    } else if (emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty &&
                        fullNameController.text.isNotEmpty) {
                      _auth
                          .createUserWithEmailAndPassword(
                              email: emailController.text.toString(),
                              password: passwordController.text.toString())
                          .then((value) async {
                        String documentId =
                            _firestore.collection("users").doc().id;
                        final data = UserClient(
                          documentId,
                          emailController.text.toString(),
                          passwordController.text.toString(),
                          fullNameController.text.toString(),
                          'https://firebasestorage.googleapis.com/v0/b/polylinguaapp.appspot.com/o/images%2Fanonymous_user.png?alt=media&token=ab68e21b-6457-4400-9a02-eb772889d01d',
                          '',
                          '',
                          '',
                          'en',
                          [],
                          [],
                        );

                        // Save to Firestore
                        await _firestore
                            .collection('users')
                            .withConverter(
                              fromFirestore: UserClient.fromFirestore,
                              toFirestore: (UserClient userData, options) =>
                                  userData.toFirestore(),
                            )
                            .doc(documentId)
                            .set(data);

                        userController.setUser(data);

                        Get.offNamed('/home');
                      }).catchError((error) {
                        Get.snackbar('Error', error.toString());
                      });
                    } else {
                      Get.snackbar(
                        'Error',
                        'Please fill in the form',
                        duration: const Duration(seconds: 10),
                      );
                    }
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already an account? ',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.offNamed('/signin');
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
