import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveItinerary(Map<String, dynamic> itineraryData) async {
    try {
      await _firestore.collection('itineraries').add({
        'location': itineraryData['location'],
        'timePreference': itineraryData['timePreference'],
        'budget': itineraryData['budget'],
        'itinerary': itineraryData['itinerary'],
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error saving itinerary: $e");
    }
  }
}
