import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:poly_lingua_app/classes/user.dart';
import 'package:poly_lingua_app/screens/signin/signin_controller.dart';

class SigninScreen extends GetView<SigninController> {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
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
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    await _auth
                        .signInWithEmailAndPassword(
                      email: emailController.text.toString(),
                      password: passwordController.text.toString(),
                    )
                        .then((value) async {
                      User? user = value.user;
                      if (user != null) {
                        FirebaseFirestore db = FirebaseFirestore.instance;
                        await db
                            .collection("users")
                            .where('email', isEqualTo: user.email)
                            .get()
                            .then(
                                (QuerySnapshot<Map<String, dynamic>> snapshot) {
                          if (snapshot.docs.isNotEmpty) {
                            for (DocumentSnapshot<Map<String, dynamic>> document
                                in snapshot.docs) {
                              var data = document.data();
                              var profile = UserClient(
                                data?['id'],
                                data?['image'],
                                data?['fullName'],
                                data?['birthday'],
                                data?['email'],
                                data?['password'],
                                data?['numberPhone'],
                              );
                              // Perform navigation or other tasks with the retrieved user profile
                              // Example: Navigate to another route
                              Get.offNamed('/home', parameters: {
                                "id": profile.id ?? "",
                                "fullName": profile.fullName ?? "",
                                "email": profile.email ?? ""
                              });
                            }
                          } else {
                            print('No user found for that email.');
                          }
                        }).catchError((error) {
                          print('Error retrieving user data: $error');
                        });
                      }
                    }).catchError((error) {
                      Get.snackbar('Error', error.toString());
                    });
                  } else {
                    Get.snackbar('Error', 'Please fill in all fields');
                  }
                },
                child: const Text('Sign in'),
              ),
              TextButton(
                onPressed: () {
                  Get.offNamed('/signup');
                },
                child: const Text('Don\'t have an account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
