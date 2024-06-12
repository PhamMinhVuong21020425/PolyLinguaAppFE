import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:poly_lingua_app/classes/user.dart';
import 'package:poly_lingua_app/screens/signin/signin_controller.dart';
import 'package:poly_lingua_app/services/user_controller.dart';

class SigninScreen extends GetView<SigninController> {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
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
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 8.0),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Checkbox(
                        checkColor: Colors.white,
                        activeColor: const Color(0xFF00B761),
                        value: controller.rememberMe.value,
                        side: const BorderSide(
                          color: Color(0xFF00B761),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        onChanged: (value) {
                          controller.rememberMe.value = value!;
                        },
                      ),
                    ),
                    const Text('Remember me'),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: InkWell(
                        onTap: () {},
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Color(0xFF00B761),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
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
                      if (emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        _auth
                            .signInWithEmailAndPassword(
                          email: emailController.text.toString(),
                          password: passwordController.text.toString(),
                        )
                            .then((value) {
                          User? user = value.user;
                          if (user != null) {
                            FirebaseFirestore db = FirebaseFirestore.instance;
                            db
                                .collection("users")
                                .where('email', isEqualTo: user.email)
                                .get()
                                .then((QuerySnapshot<Map<String, dynamic>>
                                    snapshot) {
                              if (snapshot.docs.isNotEmpty) {
                                for (DocumentSnapshot<
                                        Map<String, dynamic>> document
                                    in snapshot.docs) {
                                  var data = document.data();
                                  var profile = UserClient.fromJson(data!);

                                  // Set user profile in the user controller
                                  userController.setUser(profile);

                                  // Perform navigation or other tasks with the retrieved user profile
                                  // Example: Navigate to another route
                                  Get.offNamed('/home');
                                }
                              } else {
                                Get.snackbar(
                                  'Invalid',
                                  'No user found for that email.',
                                );
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
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account? ',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.offNamed('/signup');
                    },
                    child: const Text(
                      'Sign up',
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
