import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karunamitra/widgets/widgets.dart';

class ServiceBookings extends StatefulWidget {
  const ServiceBookings({super.key});

  @override
  State<ServiceBookings> createState() => _ServiceBookingsState();
}

class _ServiceBookingsState extends State<ServiceBookings> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userName;
  String? _userUid;
  late String serviceCity;

  @override
  void initState() {
    super.initState();
    serviceCity = "";
  }

  final FirebaseFirestore firestoreIns = FirebaseFirestore.instance;

  Future<void> getData() async {
    final User? user = FirebaseAuth.instance.currentUser;

    /// ==================current user (service)=============
    final DocumentSnapshot<Map<String, dynamic>> servSnapshot =
        await firestoreIns.collection("service").doc(user!.uid).get();
    _userName = servSnapshot.get("userName");
    _userUid = servSnapshot.get("userUID");
    // Get the current user's city from the "service" subcollection
    serviceCity = servSnapshot.get("city");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // If the future is not yet complete, show a loading indicator
            return const Center(child: CircularProgressIndicator());
          }
          // If the future is complete, build the widget tree with the obtained data
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bck2.jpg'),
                fit: BoxFit.contain,
                opacity: 0.3,
              ),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collectionGroup('Bookings')
                  .where("city", isEqualTo: serviceCity)
                  .where('status', isEqualTo: 'pending')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...');
                } else if (!snapshot.hasData) {
                  return Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'No Items to show',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final sellList = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: sellList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final sell = sellList[index];
                    final Map<String, dynamic>? doc =
                        sell.data() as Map<String, dynamic>?;
                    if (doc == null) {
                      return const SizedBox.shrink();
                    }
                    return Container(
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.blue,
                              blurRadius: 2.0,
                              spreadRadius: 0.0,
                              offset: Offset(
                                  0.4, 0.4) // shadow direction: bottom right
                              )
                        ],
                        color: Colors.white,
                        // image: const DecorationImage(
                        //     image: AssetImage('assets/images/bck1.png'),
                        //     opacity: 0.4)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${doc.containsKey('name') ? doc['name'] : ''}',
                            style: GoogleFonts.merienda(
                                fontSize: 20,
                                color: const Color.fromARGB(255, 255, 81, 7)),
                          ),
                          Text(
                            'City: ${doc.containsKey('city') ? doc['city'] : ''}',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.cabin(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Service Type : ${doc.containsKey('type') ? doc['type'] : ''}',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.cabin(
                              fontSize: 18,
                            ),
                          ),
                          Button(
                            text: 'Accept',
                            icons: Icons.add,
                            onPress: () async {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Are you sure want to Accept and add to task.!',
                                        style: GoogleFonts.alef(fontSize: 28),
                                      ),
                                      actions: [
                                        Button(
                                            btncolor: Colors.red,
                                            text: 'Yes',
                                            icons: Icons.check_circle_outlined,
                                            onPress: () async {
                                              try {
                                                final userRef = firestoreIns
                                                    .collection('users')
                                                    .doc(doc['UID'])
                                                    .collection('Bookings')
                                                    .doc(doc['docID']);
                                                await userRef.update({
                                                  'status': 'Accept',
                                                  'ServiceName': _userName,
                                                  'ServiceId': _userUid,
                                                });
                                              } catch (e) {
                                                if (kDebugMode) {
                                                  print('Error: $e');
                                                }
                                              }

                                              Navigator.of(context).pop();
                                            }),
                                        Button(
                                            btncolor: Colors.blue,
                                            text: 'No',
                                            icons: Icons.highlight_remove_sharp,
                                            onPress: () {
                                              Navigator.of(context).pop();
                                            })
                                      ],
                                    );
                                  });
                            },
                          ),
                          ExpansionTile(
                            title: const Text(
                              'More',
                              textAlign: TextAlign.end,
                            ),
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            expandedAlignment: Alignment.topLeft,
                            children: <Widget>[
                              Text(
                                'Status: : ${doc.containsKey('status') ? doc['status'] : ''}',
                                style: GoogleFonts.cabin(
                                    fontSize: 18,
                                    color:
                                        const Color.fromARGB(255, 15, 80, 17)),
                              ),
                              Text(
                                'ID : ${doc.containsKey('docID') ? doc['docID'] : ''}',
                                style: GoogleFonts.cabin(
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'Duration : ${doc.containsKey('duration') ? doc['duration'] : ''}',
                                style: GoogleFonts.cabin(
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'Address : ${doc.containsKey('address') ? doc['address'] : ''}',
                                style: GoogleFonts.cabin(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
