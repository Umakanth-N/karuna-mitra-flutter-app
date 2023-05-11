import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth/auth.dart';
import '../../widgets/widgets.dart';
import 'admin_home.dart';

class AddCoAdmin extends StatefulWidget {
  const AddCoAdmin({super.key});

  @override
  State<AddCoAdmin> createState() => _AddCoAdminState();
}

class _AddCoAdminState extends State<AddCoAdmin> {
 String? _empCityController;
  final _namecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _passcontroller = TextEditingController();
  final _conpasscontroller = TextEditingController();
  final _phonecontroller = TextEditingController();
  final _empSignup = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(237, 238, 243, 252),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
              'Admin App',
              style: GoogleFonts.merienda(
                  fontSize: 20,),
            ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Center(
            child: Text(
              'Add New Co-Admin',
              style: GoogleFonts.merienda(
                  fontSize: 25, color: const Color.fromARGB(255, 255, 81, 7)),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _empSignup,
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
                            value: _empCityController,
                            onChanged: (newValue) {
                              setState(() {
                                _empCityController = newValue;
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
                          ElevatedButton(
                              style: const ButtonStyle(
                                  // backgroundColor: MaterialColor,
                                  ),
                              onPressed: () {
                                if (_empSignup.currentState!.validate()) {
                                  _empSignup.currentState!.save();
                                  setState(() {
                                    signUpSaveData(
                                        _emailcontroller, _conpasscontroller,
                                        context: context,
                                        route: const AdminHome(),
                                        collName: 'coadmin',
                                        role: 'coadmin',
                                        nameCont: _namecontroller,
                                        subCol_1: 'hist',
                                        subCol_2: 'Cha',
                                        phonCont: _phonecontroller,
                                        city: _empCityController
                                        );
                                  });
                                }
                              },
                              child: const Text('Sign UP')),
                          const SizedBox(
                            width: 50,
                          ),
                          TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 244, 54, 54),
                                  textStyle: const TextStyle(fontSize: 15)),
                              onPressed: () {
                                _namecontroller.text = '';
                                _emailcontroller.text = '';
                                _phonecontroller.text = '';
                                _conpasscontroller.text = '';
                                _passcontroller.text = '';
                              },
                              child: const Text('Clear Details')),
                        ],
                      )
                    ]),
              )),
        ]),
      ),
    );
  }
}
