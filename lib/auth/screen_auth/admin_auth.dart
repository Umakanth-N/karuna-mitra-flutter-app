import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../screens/admin/admin_home.dart';
import '../../widgets/widgets.dart';
import '../auth.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _userformKey = GlobalKey<FormState>();
  final _userEmail = TextEditingController();
  final _userPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(240, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.red.shade400,
        centerTitle: true,
        title: Text(
          'Admin Auth Screen',
          style: GoogleFonts.merienda(
            fontSize: 20,
          ),
        ),
      ),
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
                    'Admin Login',
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
                    btncolor: Colors.green,
                    onPress: () {
                      if (_userformKey.currentState!.validate()) {
                        _userformKey.currentState!.save();
                        loginAuth(context,
                            emailCont: _userEmail,
                            passCont: _userPass,
                            collName: 'admin',
                            role: 'admin',
                            route: const AdminHome());
                      }
                    }),

                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdminSignUp extends StatefulWidget {
  const AdminSignUp({super.key});

  @override
  State<AdminSignUp> createState() => _AdminSignUpState();
}

class _AdminSignUpState extends State<AdminSignUp> {
  final _namecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _passcontroller = TextEditingController();
  final _conpasscontroller = TextEditingController();
  final _phonecontroller = TextEditingController();
  final _userSignup = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade400,
        centerTitle: true,
        title: Text(
          'Add New Admin',
          style: GoogleFonts.merienda(
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Center(
            child: Text(
              'Admin Sign UP',
              style: GoogleFonts.merienda(
                  fontSize: 30, color: const Color.fromARGB(255, 255, 81, 7)),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _userSignup,
                child: Wrap(
                    alignment: WrapAlignment.start,
                    runSpacing: 10,
                    spacing: 20,
                    children: [
                      // Name
                      TextFieldCustom(
                          controller: _namecontroller,
                          icons: Icons.face_6,
                          validater: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                          boxname: 'Enter Name',
                          boxlable: 'Name'),
                      // Email
                      TextFieldCustom(
                          keyBord: TextInputType.emailAddress,
                          controller: _emailcontroller,
                          icons: Icons.email,
                          validater: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.email(),
                          ]),
                          boxname: 'Enter Email',
                          boxlable: 'Email'),
                      // Password
                      TextFieldCustom(
                        controller: _passcontroller,
                        icons: Icons.password_outlined,
                        validater: FormBuilderValidators.compose([
                          FormBuilderValidators.minLength(8),
                        ]),
                        boxlable: 'Password',
                        boxname: 'Enter your Password',
                      ),
                      //  Conform Password
                      TextFieldCustom(
                        icons: Icons.password,
                        controller: _conpasscontroller,
                        validater: FormBuilderValidators.compose([
                          FormBuilderValidators.minLength(8),
                          (val) {
                            // if (val.isEmpty) return 'Empty';
                            if (val != _passcontroller.text) return 'Not Match';
                            return null;
                          }
                        ]),
                        boxlable: 'Confirm Password',
                        boxname: 'Re-Enter your Password',
                      ),
                      // Phone Number
                      TextFieldCustom(
                          controller: _phonecontroller,
                          icons: Icons.phone,
                          validater: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.minLength(10),
                            FormBuilderValidators.maxLength(10)
                          ]),
                          boxname: 'Enter Phone',
                          boxlable: 'Phone'),

                      Row(
                        children: [
                          Button(
                              text: 'Sign UP',
                              icons: Icons.admin_panel_settings,
                              btncolor: Colors.green,
                              onPress: () {
                                if (_userSignup.currentState!.validate()) {
                                  _userSignup.currentState!.save();
                                  setState(() {
                                    signUpSaveData(
                                        _emailcontroller, _conpasscontroller,
                                        context: context,
                                        route: const AdminHome(),
                                        collName: 'admin',
                                        role: 'admin',
                                        nameCont: _namecontroller,
                                        subCol_1: 'history',
                                        subCol_2: 'orders',
                                        phonCont: _phonecontroller,  city: ' ',);
                                  });
                                }
                              }),
                          const SizedBox(
                            width: 50,
                          ),
                          Button(
                              text: 'Clear Details',
                              icons: Icons.clear,
                              btncolor: const Color.fromARGB(255, 244, 54, 54),
                              onPress: () {
                                _namecontroller.text = '';
                                _emailcontroller.text = '';
                                _phonecontroller.text = '';
                                _conpasscontroller.text = '';
                                _passcontroller.text = '';
                              }),
                        ],
                      )
                    ]),
              )),
        ]),
      ),
    );
  }
}
