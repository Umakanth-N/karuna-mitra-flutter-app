import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class History extends StatefulWidget {
  const History({
    super.key,
  });

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _userUid;
  // Object? _userUid;
 

  @override
  void initState() {
    super.initState();
  
  }

  final FirebaseFirestore firestoreIns = FirebaseFirestore.instance;

  Future<void> getData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    _userUid = user!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'History',
          style: GoogleFonts.merienda(fontSize: 30),
        ),
        centerTitle: true,
      ),
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
                  .where('status', isEqualTo: 'Task Complete')
                  .where('UID' , isEqualTo: _userUid)
                       //  .where( 'UID' == _userUid || 'ServiceId' == _userUid)
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
                          image: const DecorationImage(
                              image: AssetImage('assets/images/bck1.png'),
                              opacity: 0.4)),
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
                            'Email : ${doc.containsKey('email') ? doc['email'] : ''}',
                            style: GoogleFonts.cabin(
                              fontSize: 18,
                              color: const Color.fromARGB(255, 11, 54, 90),
                            ),
                          ),
                          Text(
                            'Status: Completed',
                            style: GoogleFonts.cabin(
                                fontSize: 18,
                                color: const Color.fromARGB(255, 15, 80, 17)),
                          ),
                                  Text(
                                     'Service Provider: ${doc.containsKey('ServiceName') ? doc['ServiceName'] : ''}',
                          
                            style: GoogleFonts.cabin(
                                fontSize: 18,
                                color: const Color.fromARGB(255, 15, 80, 17)),
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
                                'Waste Type : ${doc.containsKey('type') ? doc['type'] : ''}',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.cabin(
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'ID : ${doc.containsKey('docID') ? doc['docID'] : ''}',
                                style: GoogleFonts.cabin(
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'Quantity : ${doc.containsKey('quantity') ? doc['quantity'] : ''}',
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
                              const Divider(
                                color: Colors.red,
                              ),
                              Text(
                                'Worker Name : ${doc.containsKey('workerName') ? doc['workerName'] : ''}',
                                style: GoogleFonts.cabin(
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'Worker ID : ${doc.containsKey('workerId') ? doc['workerId'] : ''}',
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
