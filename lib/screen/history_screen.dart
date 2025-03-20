import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  void _deleteItinerary(String docId) {
    FirebaseFirestore.instance.collection('itineraries').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "History",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('itineraries')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No itineraries saved yet 🗿",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var itinerary = doc['itinerary'] as List<dynamic>;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFC86FAE), Color(0xFF0084FF)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${doc['location']} - ${doc['timePreference']}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.white),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () => _deleteItinerary(doc.id),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ...itinerary.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text("${item['place']}",
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 7),
                              Text("🎯 Activity : ${item['activity']}",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white)),
                              const SizedBox(height: 7),
                              Text("⏱️ Duration : ${item['estimated_duration']}",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white)),
                              const SizedBox(height: 7),
                              Text("💲 Cost : ${item['estimated_cost']}",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white)),
                            ],
                          ),
                        )),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class HistoryScreen extends StatelessWidget {
//   const HistoryScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text(
//           "History",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('itineraries')
//             .orderBy('createdAt', descending: true)
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text("No itineraries saved yet.",
//                   style: TextStyle(color: Colors.white)),
//             );
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               var doc = snapshot.data!.docs[index];
//               var itinerary = doc['itinerary'] as List<dynamic>;
              
//               return Container(
//                 margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFFC86FAE), Color(0xFF0084FF)],
//                     begin: Alignment.topRight,
//                     end: Alignment.bottomLeft,
//                   ),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "${doc['location']} - ${doc['timePreference']}",
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 24,
//                           color: Colors.white),
//                     ),
//                     const SizedBox(height: 15),
//                     ...itinerary.map((item) => Padding(
//                           padding: const EdgeInsets.only(bottom: 10),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const SizedBox(height: 10),
//                               Text("🎯 Activity : ${item['activity']}",
//                                   style: const TextStyle(
//                                       fontSize: 16, color: Colors.white)),
//                               const SizedBox(height: 5),
//                               Text("⏱️ Duration : ${item['estimated_duration']}",
//                                   style: const TextStyle(
//                                       fontSize: 16, color: Colors.white)),
//                               const SizedBox(height: 5),
//                               Text("💲 Cost : ${item['estimated_cost']}",
//                                   style: const TextStyle(
//                                       fontSize: 16, color: Colors.white)),
//                             ],
//                           ),
//                         )),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


