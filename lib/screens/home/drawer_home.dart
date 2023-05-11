import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karunamitra/auth/screen_auth/admin_auth.dart';
import 'package:karunamitra/auth/screen_auth/co_admin_auth.dart';
import 'package:karunamitra/screens/co_admin/co_admin_home.dart';

import '../../auth/screen_auth/service_auth.dart';
import '../../auth/screen_auth/user_auth.dart';
import '../../widgets/widgets.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: MediaQuery.of(context).size.width / 1.6,
        backgroundColor: const Color.fromARGB(239, 255, 255, 255),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UserAccountsDrawerHeader(
                currentAccountPicture: const Icon(Icons.account_box_rounded),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.scaleDown,
                        opacity: 0.3,
                        image: AssetImage('assets/images/bck1.png')),
                    color: Colors.white),
                accountName: Text('Karuna',
                    style:
                        GoogleFonts.benne(fontSize: 30, color: Colors.purple)),
                accountEmail: Text('Karuna@gmail.com',
                    style:
                        GoogleFonts.benne(fontSize: 20, color: Colors.purple))),
            Button(text: 'ABOUT', icons: Icons.mobile_friendly, onPress: () {}),
            Button(
                btncolor: Colors.green,
                text: 'User App',
                icons: Icons.account_circle_outlined,
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserAuth()));
                }),
            Button(
                btncolor: Colors.orange,
                text: 'Co-Admin App',
                icons: Icons.delivery_dining_rounded,
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CoAdminLogin()));
                }),
            Button(
                btncolor: Colors.amber.shade600,
                text: 'Service App',
                icons: Icons.work_outline,
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ServiceLogin()

                          ));
                }),
            Button(
                btncolor: Colors.red.shade400,
                text: 'Admin App',
                icons: Icons.admin_panel_settings_outlined,
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminLogin()));
                }),
            BottomAppBar(
              height: 70,
              child: Container(
                color: const Color.fromARGB(255, 191, 124, 211),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  title: Text('Umakanth N'),
                                  content:
                                      Text('The App contains May features'),
                                  actions: [],
                                );
                              });
                        },
                        child: Text(
                          'Developer Contact.?',
                          style: GoogleFonts.benne(
                              fontSize: 15, color: Colors.white),
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
