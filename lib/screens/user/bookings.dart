// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
 
import 'package:intl/intl.dart';
 

import '../../widgets/error_dialog.dart';
import '../../widgets/widgets.dart';
import 'user_drawer.dart';
import 'user_home.dart';

class Bookings extends StatefulWidget {
  final List<String>? items;

  const Bookings({super.key, this.items});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? _bookingsStream;
  List<Map<String, dynamic>> data = [];

  void deleteBookingsData(String id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Bookings")
        .doc(id)
        .delete();
  }

  @override
  void initState() {
    super.initState();
    _bookingsStream = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Bookings")
        .where("status", whereIn: ["pending", "Assigned worker"]).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const UserDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          'Bookings Screen',
          style: GoogleFonts.merienda(
            fontSize: 25,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (c) => const UsersHome()));
              },
              icon: const Icon(Icons.home)),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const BookingsItem()));
        },
        child: Wrap(
          direction: Axis.vertical,
          children: const [
            Icon(Icons.add_circle_outline_outlined),
            Text('Book')
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bck2.jpg'),
            fit: BoxFit.contain,
            opacity: 0.6,
          ),
        ),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _bookingsStream,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No items to show'));
            }
            return ListView.builder(
              // reverse: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                return BookingsCard(
                    name: doc.data().toString().contains('name')
                        ? doc.get('name')
                        : '',
                    gmail: doc.data().toString().contains('email')
                        ? doc.get('email')
                        : '',
                    phone: doc.data().toString().contains('phone')
                        ? doc.get('phone')
                        : '',
                      desc: doc.data().toString().contains('city')
                        ? doc.get('city')
                        : '',
                      
                    duration: doc.data().toString().contains('duration')
                        ? doc.get('duration')
                        : '',
                    type: doc.data().toString().contains('type')
                        ? doc.get('type')
                        : '',
                    address: doc.data().toString().contains('address')
                        ? doc.get('address')
                        : '',
                    status: doc.data().toString().contains('status')
                        ? doc.get('status')
                        : '',
                    date: doc.data().containsKey('dateTime')
                        ? DateFormat.yMd()
                            .add_jm()
                            .format(doc.get('dateTime').toDate())
                        : '',
                    onpress: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Are you sure want to delete',
                                style: GoogleFonts.alef(fontSize: 32),
                              ),
                              actions: [
                                Button(
                                    btncolor: Colors.red,
                                    text: 'Yes',
                                    icons: Icons.check_circle_outlined,
                                    onPress: () {
                                      deleteBookingsData(doc.id);
                                      Navigator.of(context).pop();
                                    }),
                                Button(
                                    btncolor: Colors.blue,
                                    text: 'No',
                                    icons: Icons.highlight_remove_sharp,
                                    onPress: () {
                                      // deleteBookingsData(doc.id);
                                      Navigator.of(context).pop();
                                    })
                              ],
                            );
                          });
                    });
              },
            );
          },
        ),
      ),
    );
  }
}

// This code sets up a StreamBuilder that listens for changes in the Bookings collection in Firestore. Whenever there is a change,
class BookingsItem extends StatefulWidget {
  const BookingsItem({super.key});

  @override
  State<BookingsItem> createState() => _BookingsItemState();
}

class _BookingsItemState extends State<BookingsItem> {
  String? _bookingstypeController;

  String? _userCityController;
  final _namecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();

  TextEditingController locationController = TextEditingController();
  final _phonecontroller = TextEditingController();
  final _deccontroller = TextEditingController();
  final _addresscontroller = TextEditingController();
  final _durationcontroller = TextEditingController();
  final _bookingsProduct = GlobalKey<FormState>();
  String completeAddress = "";
  Position? position;
  List<Placemark>? placeMarks;

  Future getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle the case where the user denied location permission
    } else {
      // Show a circular progress indicator while getting the location
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Hide the progress indicator
      Navigator.pop(context);

      position = newPosition;

      placeMarks = await placemarkFromCoordinates(
        position!.latitude,
        position!.longitude,
      );

      Placemark pMark = placeMarks![0];

      completeAddress =
          '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

      locationController.text = completeAddress;
    }
    Navigator.pop(context);
  }

  Future<void> addBookingsData() async {
    // Get a reference to the Firestore instance
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Get the current user's UID
    final String uids = FirebaseAuth.instance.currentUser!.uid;

    // Create a reference to the user's document
    final DocumentReference userDoc = firestore.collection('users').doc(uids);

    // Create a reference to the subcollection for the user's document
    final CollectionReference subCollection = userDoc.collection('Bookings');

    // Generate a unique ID for the subcollection document
    final subDocRef = subCollection.doc();

    final subDocId = subDocRef.id;

    final DateTime now = DateTime.now();
    // Add a new document to the subcollection
    subDocRef.set({
      'UID': uids,
      'name': _namecontroller.text.trim(),
      'email': _emailcontroller.text.trim(),
      'phone': _phonecontroller.text.trim(),
      'type': _bookingstypeController.toString(),
      'duration': _durationcontroller.text.trim(),
      'city': _userCityController.toString(),
      'address': _addresscontroller.text.trim(),
      'description': _deccontroller.text.trim(),
      'status': 'pending',
      'docID': subDocId,
      'dateTime': now,
      //  "address": completeAddress,
      "lat": position!.latitude,
      "lng": position!.longitude,
      //      'latitude': latitudeController.text.trim(),
      // 'longitude': longitudeController.text.trim(),
    }).then((value) {
 const ErrorDialog(message: 'Data Added',);
 
    }).catchError((error) {
      // print('Error adding document to subcollection: $error');
const ErrorDialog(message: 'Data Problem',);
    //  onlodingDilog(context, 'Data Problem ');
    });
    //  Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(247, 232, 232, 199),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Wrap(
            runSpacing: 10,
            spacing: 20,
            children: [
              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Book Service',
                    style: GoogleFonts.merienda(
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 30,
                      )),
                ],
              ),
              Form(
                key: _bookingsProduct,
                child: Wrap(
                    alignment: WrapAlignment.start,
                    runSpacing: 10,
                    spacing: 20,
                    children: <Widget>[
                      //Name
                      TextFieldCustom(
                          controller: _namecontroller,
                          icons: Icons.account_circle,
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
                            FormBuilderValidators.match('@gmail.com',
                                errorText: 'use @gmail.com only')
                          ]),
                          boxname: 'Enter Email',
                          boxlable: 'Email'),

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

                      //  Type
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
                                return 'Please select a type of Services';
                              }
                              return null;
                            },
                            hint: const Text('Select Service'),
                            value: _bookingstypeController,
                            onChanged: (newValue) {
                              setState(() {
                                _bookingstypeController = newValue;
                              });
                            },
                            items: [
                              'Hospital',
                              'Outing',
                              'Shooping',
                              'Other'
                            ].map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      //Quantity
                      TextFieldCustom(
                          maxline: 1,
                          keyBord: TextInputType.emailAddress,
                          controller: _durationcontroller,
                          icons: Icons.scale,
                          validater: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                      
                          ]),
                          boxname: 'Enter the service duration',
                          boxlable: 'Duration'),
                      // Address
                      TextFieldCustom(
                          maxline: 4,
                          icons: Icons.abc,
                          keyBord: TextInputType.emailAddress,
                          controller: _addresscontroller,
                          validater: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                          boxname:
                              '''Ex:House no , Street/area Landmark City, State, Pincode''',
                          boxlable: 'Address'),

                      TextFieldCustom(
                          maxline: 4,
                          keyBord: TextInputType.emailAddress,
                          controller: _deccontroller,
                          icons: Icons.abc,
                          validater: FormBuilderValidators.compose([
                            FormBuilderValidators.maxLength(500),
                          ]),
                          boxname: 'Provide some information',
                          boxlable: 'Description'),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 150,
                            child: ColoredBox(
                              color: Colors.white,

                              // color: Colors.white,

                              child: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                    hoverColor: Colors.green,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)))),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a type of material';
                                  }
                                  return null;
                                },
                                hint: const Text('Select Type'),
                                value: _userCityController,
                                onChanged: (newValue) {
                                  setState(() {
                                    _userCityController = newValue;
                                  });
                                },
                                items: [
                                  'Ballari',
                                   'Hospet',
                                   
                                ].map((type) {
                                  return DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          Button(
                            text: 'Get Location',
                            icons: Icons.location_on,
                            onPress: () {
                              setState(() {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );

                                getCurrentLocation();
                              });
                            },
                          ),
                        ],
                      ),

                      TextFieldCustom(
                        boxname: 'Location',
                        boxlable: 'GPS',
                        icons: Icons.location_searching,
                        controller: locationController,
                        enabled: false,
                        validater: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                    ]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Button(
                      btncolor: Colors.red,
                      icons: Icons.cancel,
                      text: 'Clear',
                      onPress: () {
                        _namecontroller.text = '';
                        _emailcontroller.text = '';
                        _phonecontroller.text = '';
                        _durationcontroller.text = '';
                        _deccontroller.text = '';
                        _addresscontroller.text = '';
                      }),
                  Button(
                      btncolor: Colors.green,
                      icons: Icons.add,
                      text: 'Submit',
                      onPress: () {
                        if (_bookingsProduct.currentState!.validate()) {
                          _bookingsProduct.currentState!.save();
                          setState(() {
                            addBookingsData();
                            Navigator.of(context).pop();
                     
                          });
                        }
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
