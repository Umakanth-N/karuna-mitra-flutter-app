import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../screens/co_admin/co_admin_home.dart';
import '../../widgets/widgets.dart';
import '../auth.dart';

class CoAdminLogin extends StatefulWidget {
  const CoAdminLogin({super.key});

  @override
  State<CoAdminLogin> createState() => _CoAdminLoginState();
}

class _CoAdminLoginState extends State<CoAdminLogin> {
   final _userformKey = GlobalKey<FormState>();
  final _userEmail = TextEditingController();
  final _userPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(241, 255, 255, 255),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Admin Auth Screen',
          style: GoogleFonts.merienda(
            fontSize: 20,
          ),
        ),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _userformKey,
            child: Wrap(
              alignment: WrapAlignment.start,
              runSpacing: 10,
              spacing: 20,
              children: [
                Center(
                  child: Text(
                    'Co-Admin Login',
                    style: GoogleFonts.merienda(
                        fontSize: 30,
                        color: const Color.fromARGB(255, 255, 81, 7)),
                  ),
                ),
                TextFieldCustom(
                  controller: _userEmail,
                  icons: Icons.email,
                  validater: FormBuilderValidators.compose([
                    FormBuilderValidators.email(),
                    FormBuilderValidators.required(),
                  ]),
                  boxlable: 'Email',
                  boxname: 'Enter your Email',
                ),
                // SizedBox(
                //   height: 25,
                // ),
                TextFieldCustom(
                  controller: _userPass,
                     icons: Icons.password,
                  validater: FormBuilderValidators.compose(
                      [FormBuilderValidators.required()]),
                  boxlable: 'Password',
                  boxname: 'Enter your Password',
                ),
                Button(
                    text: 'SignIN',
                    icons: Icons.login,
                    onPress: () {
                      if (_userformKey.currentState!.validate()) {
                        _userformKey.currentState!.save();
                        loginAuth(context,
                            emailCont: _userEmail,
                            passCont: _userPass,
                            collName: 'coadmin',
                            role: 'coadmin',
                            route: const CoAdminHome());
                      }
                    }),
         
           
              ],
            ),
          ),
        ),
      ),
    );
  }
}
