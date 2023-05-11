// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../screens/user/user_home.dart';
import '../../widgets/widgets.dart';
import '../auth.dart';
 

class UserAuth extends StatelessWidget {
  // Key ULogin;
  const UserAuth({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 239, 239, 239),
        appBar: AppBar(
          backgroundColor: Colors.redAccent.shade200,
          title: const Text('User Auth Screen'),
          centerTitle: true,
          bottom: const TabBar(tabs: [
            Tab(
              text: 'User Login',
            ),
            Tab(
              text: 'User SignUP',
            ),
          ]),
        ),
        // ignore: avoid_unnecessary_containers
        body: Container(
            // color: Color.fromARGB(255, 200, 217, 237),
            child: const TabBarView(children: [
          UserLogin(),
          UserSignUp(),
        ])),
      ),
    );
  }
}




class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final _userformKey = GlobalKey<FormState>();
  final _userEmail = TextEditingController();
  final _userPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  'User Login',
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
                          collName: 'users',
                          role: 'user',
                          route: const UsersHome());
                    }
                  }),
              const SizedBox(
                height: 25,
              ),
              TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserLogin()));
                  },
                  icon: const Icon(Icons.new_label),
                  label: const Text(
                    'New User, please use Signup',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}



class UserSignUp extends StatefulWidget {
  const UserSignUp({super.key});

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
   String? _cityController;
  final _namecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _passcontroller = TextEditingController();
  final _conpasscontroller = TextEditingController();
  final _phonecontroller = TextEditingController();
  final _userSignup = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Center(
          child: Text(
            'User Sign UP',
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
                           icons: Icons.face,
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
                         icons: Icons.password,
                      validater: FormBuilderValidators.compose([
                        FormBuilderValidators.minLength(8),
                      ]),
                      boxlable: 'Password',
                      boxname: 'Enter your Password',
                    ),
                    //  Conform Password
                    TextFieldCustom(
                      controller: _conpasscontroller,
                         icons: Icons.password,
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

                         SizedBox(
                        width: 150,
                        child: ColoredBox(
                          color: Colors.white,

                          // color: Colors.white,

                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                                hoverColor: Colors.green,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a type of material';
                              }
                              return null;
                            },
                            hint: const Text('Select City'),
                            value: _cityController,
                            onChanged: (newValue) {
                              setState(() {
                                _cityController = newValue;
                              });
                            },
                            items: [
                              'Ballari',
                              'Hospet',
                              // 'E-Waste',
                              // 'Other'
                            ].map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                    Row(
                      children: [
                        Button(text: 'Sign UP', icons: Icons.playlist_add_circle_outlined, 
                        btncolor: Colors.green,
                        onPress: (){
                                       if (_userSignup.currentState!.validate()) {
                                _userSignup.currentState!.save();
                                setState(() {
                                  signUpSaveData(
                                      _emailcontroller, _conpasscontroller,
                                      context: context,
                                      route: const UsersHome(),
                                      collName: 'users',
                                      role: 'user',
                                      nameCont: _namecontroller,
                                      subCol_1: 'Bookings',
                                      subCol_2: 'Sell',
                                      phonCont: _phonecontroller,
                                      city:_cityController,
                                      );
                                });
                              }

                        }),
                  
                        const SizedBox(
                          width: 50,
                        ),
            Button(text: 'Clear', icons: Icons.clear, onPress: (){
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
    );
  }
}
