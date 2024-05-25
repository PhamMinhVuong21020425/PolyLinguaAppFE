import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_lingua_app/services/user_controller.dart';
import 'package:poly_lingua_app/widgets/bottom_navigator_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final userController = Get.find<UserController>();
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate back to the home page
              Get.toNamed('/home');
            },
          ),
          title: const Text('Settings'),
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ListView(
              children: [
                _SingleSection(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _isDark ? Colors.white : Colors.black,
                          width: 1.6,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Image.network(
                                userController.user!.image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${userController.user!.fullName}',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${userController.user!.email}',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const Expanded(child: SizedBox()),
                          const Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(Icons.arrow_drop_down_circle_outlined),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                _SingleSection(
                  title: "General",
                  children: [
                    _CustomListTile(
                      title: "Dark Mode",
                      icon: Icons.dark_mode_outlined,
                      trailing: Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: _isDark,
                          activeColor: Colors.green,
                          onChanged: (value) {
                            setState(() {
                              _isDark = value;
                            });
                          },
                        ),
                      ),
                    ),
                    _CustomListTile(
                      title: "Languages",
                      icon: Icons.language_rounded,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                userController.updateUser(
                                  language: 'en',
                                );
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: userController.user!.language == 'en'
                                    ? Colors.deepOrange
                                    : Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              child: Text(
                                'EN',
                                style: TextStyle(
                                  color: userController.user!.language == 'en'
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                userController.updateUser(
                                  language: 'ja',
                                );
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: userController.user!.language == 'ja'
                                    ? Colors.deepOrange
                                    : Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              child: Text(
                                'JA',
                                style: TextStyle(
                                  color: userController.user!.language == 'ja'
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _CustomListTile(
                      title: "Notifications",
                      icon: Icons.notifications_none_rounded,
                      onTap: () {
                        Get.toNamed('/notifications');
                      },
                    ),
                  ],
                ),
                const Divider(),
                _SingleSection(
                  title: "Account",
                  children: [
                    _CustomListTile(
                      title: "Edit Profile",
                      icon: Icons.person_outline_rounded,
                      onTap: () {
                        Get.toNamed('/profile');
                      },
                    ),
                    _CustomListTile(
                      title: "Change Password",
                      icon: Icons.lock_outline_rounded,
                      onTap: () {
                        Get.toNamed('/change-password');
                      },
                    ),
                  ],
                ),
                const Divider(),
                _SingleSection(
                  children: [
                    _CustomListTile(
                      title: "Help & Feedback",
                      icon: Icons.help_outline_rounded,
                      onTap: () {
                        Get.toNamed('/home');
                      },
                    ),
                    _CustomListTile(
                      title: "About",
                      icon: Icons.info_outline_rounded,
                      onTap: () {
                        Get.toNamed('/home');
                      },
                    ),
                    _CustomListTile(
                      title: "Sign out",
                      icon: Icons.exit_to_app_rounded,
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Get.offNamed('/signin');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar:
            CustomBottomNavigationBar(currentIndex: 3, darkMode: _isDark),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final Function()? onTap;
  const _CustomListTile(
      {required this.title, required this.icon, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({
    this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}
