import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:itinerary_generator_with_gemini_ai/network/firestore_service.dart';



class GeminiService {
  static final FirestoreService _firestoreService = FirestoreService();


  static const String apiKey = "AIzaSyC35F1lTeVbAcH5yIXuuA2TBIVECXfD4sM";

  static Future<Map<String, dynamic>> generateItinerary(
      String location, String timePreference, double budget) async {
    final prompt = _buildPrompt(location, timePreference, budget);

    final model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
    );

    final chat = model.startChat(history: [
      Content.multi([
        TextPart(
            '"You are an AI travel planner that generates a personalized itinerary based on user input. The user will provide their location, preferred time (morning, afternoon, or evening), and budget. Create an optimized travel plan that includes a recommended place, activity, estimated duration, and estimated cost. Ensure the itinerary is practical, enjoyable, and within budget. Provide output in JSON format with including place, activity, and estimated_cost. Always include a \'suggestions\'. Use relevant emojis to make the itinerary engaging. Do not include any additional text outside the JSON structure."'),
      ]),
      Content.model([
        TextPart(
            '```json\n{\n  "itinerary": [\n    {\n      "time": "morning",\n      "place": "Golden Gate Park, San Francisco",\n      "activity": "Bike Ride along JFK Drive 🚴‍♀️🌳",\n      "estimated_duration": "2-3 hours",\n      "estimated_cost": "\$0-30 (bike rental)"\n    },\n    {\n      "time": "afternoon",\n      "place": "Fisherman\'s Wharf",\n      "activity": "Sea Lion Viewing & Seafood Lunch 🐟🦭",\n      "estimated_duration": "2-3 hours",\n      "estimated_cost": "\$20-50 (lunch)"\n    },\n    {\n      "time": "evening",\n      "place": "Lombard Street",\n      "activity": "Driving down \'the most crooked street\' and enjoy the city view 🌃🚗",\n      "estimated_duration": "30 minutes",\n      "estimated_cost": "\$0 (fuel)"\n    }\n  ],\n  "suggestions": [\n    "Wear comfortable shoes, especially for walking or biking.",\n    "Check the weather forecast and dress accordingly (San Francisco can be unpredictable).",\n    "Book bike rentals in advance, especially during peak season.",\n    "Be mindful of your belongings in touristy areas."\n  ]\n}\n```'),
      ]),
    ]);

    final message = prompt;
    final content = Content.text(message);

    try {
      final response = await chat.sendMessage(content);
      final responseText =
          (response.candidates.first.content.parts.first as TextPart).text;

      if (responseText.isEmpty) {
        return {"Error": "API Failed to generate itinerary :("};
      }

      // JSON Pattern
      RegExp jsonPattern = RegExp(r'\{.*\}', dotAll: true);
      final match = jsonPattern.firstMatch(responseText);

      if (match != null) {
        final itineraryData = json.decode(match.group(0)!);

        // Simpan ke Firestore
        await _firestoreService.saveItinerary({
          'location': location,
          'timePreference': timePreference,
          'budget': budget,
          'itinerary': itineraryData['itinerary'],
        });

        return itineraryData;
      }

      return jsonDecode(responseText);
    } catch (e) {
      return {"Error": "API Failed to generate itinerary :(\n$e"};
    }
  }

  static String _buildPrompt(
      String location, String timePreference, double budget) {
    return "Generate an optimized travel itinerary for the following details: \n"
        "Location: $location\n"
        "Preferred Time: $timePreference\n"
        "Budget: \$$budget\n"
        "Provide output in JSON format.";
  }
}






// import 'dart:convert';
// import 'package:google_generative_ai/google_generative_ai.dart';

// class GeminiService {
//   static const String apiKey = "AIzaSyC35F1lTeVbAcH5yIXuuA2TBIVECXfD4sM";

//   static Future<Map<String, dynamic>> generateItinerary(
//       String location, String timePreference, double budget) async {
//     final prompt = _buildPrompt(location, timePreference, budget);

//     final model = GenerativeModel(
//       model: 'gemini-2.0-flash',
//       apiKey: apiKey,
//       generationConfig: GenerationConfig(
//         temperature: 1,
//         topK: 40,
//         topP: 0.95,
//         maxOutputTokens: 8192,
//         responseMimeType: 'text/plain',
//       ),
//     );

//     final chat = model.startChat(history: [
//       Content.multi([
//         TextPart(
//             '"You are an AI travel planner that generates a personalized itinerary based on user input. The user will provide their location, preferred time (morning, afternoon, or evening), and budget. Create an optimized travel plan that includes a recommended place, activity, estimated duration, and estimated cost. Ensure the itinerary is practical, enjoyable, and within budget. Provide output in JSON format with including place, activity, and estimated_cost. Always include a \'suggestions\'. Use relevant emojis to make the itinerary engaging. Do not include any additional text outside the JSON structure."'),
//       ]),
//       Content.model([
//         TextPart(
//             '```json\n{\n  "itinerary": [\n    {\n      "time": "morning",\n      "place": "Golden Gate Park, San Francisco",\n      "activity": "Bike Ride along JFK Drive 🚴‍♀️🌳",\n      "estimated_duration": "2-3 hours",\n      "estimated_cost": "\$0-30 (bike rental)"\n    },\n    {\n      "time": "afternoon",\n      "place": "Fisherman\'s Wharf",\n      "activity": "Sea Lion Viewing & Seafood Lunch 🐟🦭",\n      "estimated_duration": "2-3 hours",\n      "estimated_cost": "\$20-50 (lunch)"\n    },\n    {\n      "time": "evening",\n      "place": "Lombard Street",\n      "activity": "Driving down \'the most crooked street\' and enjoy the city view 🌃🚗",\n      "estimated_duration": "30 minutes",\n      "estimated_cost": "\$0 (fuel)"\n    }\n  ],\n  "suggestions": [\n    "Wear comfortable shoes, especially for walking or biking.",\n    "Check the weather forecast and dress accordingly (San Francisco can be unpredictable).",\n    "Book bike rentals in advance, especially during peak season.",\n    "Be mindful of your belongings in touristy areas."\n  ]\n}\n```'),
//       ]),
//     ]);

//     final message = prompt;
//     final content = Content.text(message);

//     try {
//       final response = await chat.sendMessage(content);
//       final responseText =
//           (response.candidates.first.content.parts.first as TextPart).text;

//       if (responseText.isEmpty) {
//         return {"Error": "API Failed to generate itinerary :("};
//       }

//       // JSON Pattern
//       RegExp jsonPattern = RegExp(r'\{.*\}', dotAll: true);
//       final match = jsonPattern.firstMatch(responseText);

//       if (match != null) {
//         return json.decode(match.group(0)!);
//       }

//       return jsonDecode(responseText);
//     } catch (e) {
//       return {"Error": "API Failed to generate itinerary :(\n$e"};
//     }
//   }

//   static String _buildPrompt(
//       String location, String timePreference, double budget) {
//     return "Generate an optimized travel itinerary for the following details: \n"
//         "Location: $location\n"
//         "Preferred Time: $timePreference\n"
//         "Budget: \$$budget\n"
//         "Provide output in JSON format.";
//   }
// }
