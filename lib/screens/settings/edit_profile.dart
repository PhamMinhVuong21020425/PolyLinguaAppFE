import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_lingua_app/services/user_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _numberPhoneController = TextEditingController();
  final _addressController = TextEditingController();
  final userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    _fullNameController.text = userController.user!.fullName!;
    _imageUrlController.text = userController.user!.image!;
    _birthdayController.text = userController.user!.birthday!;
    _numberPhoneController.text = userController.user!.numberPhone!;
    _addressController.text = userController.user!.address!;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _imageUrlController.dispose();
    _birthdayController.dispose();
    _numberPhoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the settings page
            Get.toNamed('/settings');
          },
        ),
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    prefixIcon: Icon(Icons.image, color: Colors.blueAccent),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an image URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _birthdayController,
                  decoration: const InputDecoration(
                    labelText: 'Birthday',
                    prefixIcon: Icon(
                      Icons.calendar_month,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      String formattedDate =
                          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                      setState(() {
                        _birthdayController.text = formattedDate;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _numberPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon:
                        Icon(Icons.phone_android_rounded, color: Colors.teal),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    prefixIcon:
                        Icon(Icons.location_on, color: Colors.redAccent),
                  ),
                ),
                const SizedBox(height: 36.0),
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
                      if (_formKey.currentState!.validate()) {
                        // Perform form submission or data processing here
                        userController.updateUser(
                          fullName: _fullNameController.text,
                          image: _imageUrlController.text,
                          birthday: _birthdayController.text,
                          numberPhone: _numberPhoneController.text,
                          address: _addressController.text,
                        );
                        Get.snackbar(
                          'Success',
                          'Profile updated successfully',
                          duration: const Duration(seconds: 5),
                          titleText: const Text(
                            'Success',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          colorText: Colors.white,
                          backgroundColor: Colors.black.withOpacity(0.5),
                          borderRadius: 6.0,
                          margin: const EdgeInsets.all(16.0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 16.0,
                          ),
                        );
                        Get.toNamed('/settings');
                      }
                    },
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
