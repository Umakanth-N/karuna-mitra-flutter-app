import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:karunamitra/screens/Service_provider/ser_drawer.dart';
import 'package:karunamitra/screens/Service_provider/service_task.dart';
import '../../widgets/widgets.dart';
import '../home/home.dart';
import 'service_bokking.dart';

class ServiceHome extends StatefulWidget {
  const ServiceHome({super.key});

  @override
  State<ServiceHome> createState() => _ServiceHomeState();
}

class _ServiceHomeState extends State<ServiceHome> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(235, 255, 255, 255),
      // backgroundColor: Colors.black,
      drawer: const ServiceDrawer(),
      appBar: AppBar(
        title: const Text('Service App'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(204, 139, 161, 239),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const HomeScreen()));
                });
              },
              icon: const Icon(Icons.logout_rounded))
        ],
        // backgroundColor: const Color.fromARGB(200, 255, 255, 255),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: const [
           
            ServiceBookings(),
            Home(),
            ServiceTask(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },

          // backgroundColor: const Color.fromARGB(166, 242, 171, 171),
          backgroundColor: const Color.fromARGB(204, 139, 161, 239),
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: const Color.fromARGB(199, 255, 255, 255),
          // selectedFontSize: 35,
          selectedIconTheme: const IconThemeData(
            size: 28,
            color: Colors.white,
          ),
          selectedItemColor: const Color.fromARGB(255, 131, 9, 125),
          selectedLabelStyle: GoogleFonts.merienda(
            fontSize: 16,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.badge),
              label: '''Bookings''',
              // backgroundColor: Color.fromARGB(203, 241, 231, 143)
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              // backgroundColor: Color.fromARGB(175, 255, 255, 255)
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 5,
                child: Icon(
                  Icons.delivery_dining,
                ),
              ),
              label: 'Task',
              // backgroundColor: Colors.blue,
            ),
          ]),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return (await onClose(context)) ?? false;
      },
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: Container(
          // padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bck2.jpg'),
              fit: BoxFit.contain,
              opacity: 0.6,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Button(
                        text: 'Task',
                        icons: Icons.recycling,
                        btncolor: Colors.green,
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ServiceTask()));
                        }),
                    // Button(text: 'Sell', icons: Icons.send, onPress: () {}),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// class ServiceBookings extends StatefulWidget {
//   const ServiceBookings({Key? key}) : super(key: key);

//   @override
//   State<ServiceBookings> createState() => _ServiceBookingsState();
// }

// class _ServiceBookingsState extends State<ServiceBookings> {
//   late List<Map<String, dynamic>> data = [];
//   late User user;

//   @override
//   void initState() {
//     super.initState();
//     user = FirebaseAuth.instance.currentUser!;
//     getData();
//   }

//   Future<void> getData() async {
//     final FirebaseFirestore firestoreIns = FirebaseFirestore.instance;

//     // Get the current user's data from the "service" collection
//     final DocumentSnapshot<Map<String, dynamic>> servSnapshot =
//         await firestoreIns.collection("service").doc(user.uid).get();

//     // Get the current user's city from the "service" subcollection
//     final String userCity = servSnapshot.get("city");

//     final QuerySnapshot<Map<String, dynamic>> userSnapshot =
//         await firestoreIns.collection("users").get();

//     for (final userDoc in userSnapshot.docs) {
//       final QuerySnapshot<Map<String, dynamic>> sellSnapshot = await userDoc
//           .reference
//           .collection("Bookings")
//           .where("status", isEqualTo: "pending")
//           .where("city", isEqualTo: userCity)
//           .get();
//       for (final sellDoc in sellSnapshot.docs) {
//         setState(() {
//           data.add(sellDoc.data());
//         });
//       }
//     }
//   }

//   Future<void> _updateBookingStatus(Map<String, dynamic> doc) async {
//     final String uid = doc['UID'];
//     final FirebaseFirestore firestoreIns = FirebaseFirestore.instance;

//     // Update the booking status to "accept"
//     await firestoreIns
//         .collection('users')
//         .doc(uid)
//         .collection('Bookings')
//         .doc(doc['docID'])
//         .update({'status': 'accept', 'serviceName': user.displayName, 'serviceUid': user.uid});

//     // Refresh the data
//     await getData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(194, 255, 255, 255),
//       body: data.isNotEmpty
//           ? ListView.builder(
//               itemCount: data.length,
//               itemBuilder: (context, index) {
//                 final doc = data[index];
//                 return PickUpCard(
//                   subcollection: 'Bookings',
//                   name: doc.containsKey('name') ? doc['name'] : '',
//                   gmail: doc.containsKey('email') ? doc['email'] : '',
//                   phone: doc.containsKey('phone') ? doc['phone'] : '',
//                   city: doc.containsKey('city') ? doc['city'] : '',
//                   quantity: doc.containsKey('quantity') ? doc['quantity'] : '',
//                   type: doc.containsKey('type') ? doc['type'] : '',
//                   address: doc.containsKey('address') ? doc['address'] : '',
//                   status: doc.containsKey('status') ? doc['status'] : '',
//                   date: doc.containsKey('dateTime')
//                       ? DateFormat.yMd().add_jm().format(doc['dateTime'].toDate())
//                       : '',
//                   docID: doc.containsKey('docID') ? doc['docID'] : '',
//                   cuid: doc.containsKey('UID') ? doc['UID'] : '',
//                   onpressbtn:(){
//                         _updateBookingStatus(doc);
//                   } 
//                   // acceptButton: ElevatedButton(
//                   //   onPressed: () => _updateBookingStatus(doc),
//                   //   child: const Text('Accept'),
//                   // ),
//                 );
//               },
//             )
//           : const Center(child: Text('No items to show')),
//     );
//   }
// }


// ignore: must_be_immutable
class PickUpCard extends StatefulWidget {
  final dynamic name;
  String subcollection;
  dynamic gmail;
  dynamic phone;
  dynamic type;
  dynamic address;
  dynamic quantity;
  dynamic desc;
  dynamic city;
  dynamic status;
  dynamic date;
  dynamic docID;
  dynamic cuid;
  dynamic onpressbtn;
  Widget? drop;

  PickUpCard({
    super.key,
    this.address,
    this.city,
    this.gmail,
    this.docID,
    this.phone,
    this.desc,
    this.status,
    this.date,
    this.cuid,
   required this.onpressbtn,
    required this.subcollection,
    required this.name,
    required this.quantity,
    required this.type,
  });

  @override
  State<PickUpCard> createState() => _PickUpCardState();
}

class _PickUpCardState extends State<PickUpCard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


    late List<Map<String, dynamic>> data = [];
  late User user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    getData();
  }

  Future<void> getData() async {
    final FirebaseFirestore firestoreIns = FirebaseFirestore.instance;

    // Get the current user's data from the "service" collection
    final DocumentSnapshot<Map<String, dynamic>> servSnapshot =
        await firestoreIns.collection("service").doc(user.uid).get();

    // Get the current user's city from the "service" subcollection
    final String userCity = servSnapshot.get("city");

    final QuerySnapshot<Map<String, dynamic>> userSnapshot =
        await firestoreIns.collection("users").get();

    for (final userDoc in userSnapshot.docs) {
      final QuerySnapshot<Map<String, dynamic>> sellSnapshot = await userDoc
          .reference
          .collection("Bookings")
          .where("status", isEqualTo: "pending")
          .where("city", isEqualTo: userCity)
          .get();
      for (final sellDoc in sellSnapshot.docs) {
        setState(() {
          data.add(sellDoc.data());
        });
      }
    }
  }


    Future<void> _updateBookingStatus(Map<String, dynamic> doc) async {
    final String uid = doc['UID'];
    final FirebaseFirestore firestoreIns = FirebaseFirestore.instance;

    // Update the booking status to "accept"
    await firestoreIns
        .collection('users')
        .doc(uid)
        .collection('Bookings')
        .doc(doc['docID'])
        .update({'status': 'accept', 'serviceName': user.displayName, 'serviceUid': user.uid});

    // Refresh the data
    await getData();
  }
 
  @override
  Widget build(BuildContext context) {
    return 
    
    
    Scaffold(
      backgroundColor: const Color.fromARGB(194, 255, 255, 255),
      body: data.isNotEmpty
          ? ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final doc = data[index];
                return
    Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
            BoxShadow(
                color: Colors.blue,
                blurRadius: 2.0,
                spreadRadius: 0.0,
                offset: Offset(0.4, 0.4) // shadow direction: bottom right
                )
          ],
          color: Colors.white,
          // image: const DecorationImage(
          //     image: AssetImage('assets/images/bck1.png'), opacity: 0.4)
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name: ${widget.name}',
            style: GoogleFonts.oswald(
                fontSize: 22, color: const Color.fromARGB(255, 33, 112, 35)),
          ),
          Text(
            'Gmail: ${widget.gmail}',
            style: GoogleFonts.bitter(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          Text(
            'Phone: ${widget.phone}',
            style: GoogleFonts.bitter(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          Text(
            'Status: ${widget.status}',
            style: GoogleFonts.bitter(
                fontSize: 18,
                color: const Color.fromARGB(255, 216, 68, 68),
                fontWeight: FontWeight.bold),
          ),
          Button(
            text: 'Accept Booking',
            icons: Icons.edit,
            onPress: () {

 
              
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
                                    onPress:(){

                                      _updateBookingStatus(doc);
                                    }

                  
                                    
                                    ),
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
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            expandedAlignment: Alignment.topLeft,
            children: <Widget>[
              Text(
                'UID: ${widget.cuid}',
                style: GoogleFonts.bitter(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Text(
                'SID: ${widget.docID}',
                style: GoogleFonts.bitter(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Text(
                'Type: ${widget.type}',
                style: GoogleFonts.bitter(fontSize: 18, color: Colors.black),
              ),
              Text(
                'City: ${widget.city}',
                style: GoogleFonts.bitter(fontSize: 18, color: Colors.black),
              ),
              Text(
                'Quantity: ${widget.quantity}',
                style: GoogleFonts.bitter(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Text(
                'Address: ${widget.address}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.bitter(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Text(
                'Date Time: ${widget.date}',
                style: GoogleFonts.bitter(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const Divider(
                color: Colors.red,
              ),
            ],
          ),

          // drop,
        ],
      ),
    );
  })  : const Center(child: Text('No items to show')),
          );
  }
}






