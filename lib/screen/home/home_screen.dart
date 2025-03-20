import 'package:flutter/material.dart';
import 'package:itinerary_generator_with_gemini_ai/network/gemini_service.dart';
import 'package:itinerary_generator_with_gemini_ai/screen/history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  bool isFormVisible = false;
  bool isLoading = false;
  String _selectedTime = "Morning";
  bool isTimeSelected = false;
  Future<Map<String, dynamic>>? _itineraryFuture;

  void _generateItinerary() {
    setState(() {
      _itineraryFuture = GeminiService.generateItinerary(
        _locationController.text,
        _selectedTime,
        double.tryParse(_budgetController.text) ?? 0.0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isFormFilled = _locationController.text.isNotEmpty &&
    _budgetController.text.isNotEmpty &&
    isTimeSelected;


    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/pp2.jpg'),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hi, Panjoel 👋🏼", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text("Travel Enthusiast", style: TextStyle(fontSize: 14, color: Colors.white54)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome to Navinera 🗺️", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 8),
                  Text("Let AI Handle the Planning, You Enjoy the Trip.", style: TextStyle(fontSize: 16, color: Colors.white54)),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Got money, need destination? 🤔",
                        style:
                            TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Let's go somewhere!",
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity, 
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFC86FAE),
                              Color(0xFF0084FF),
                            ],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              isFormVisible = true;
                            });
                          },
                          label: const Text(
                            'Make an Itinerary',
                            style: TextStyle(color: Colors.white),
                          ),
                          icon:
                              const Icon(Icons.auto_awesome, color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity, 
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 202, 206, 0),
                              Color.fromARGB(255, 7, 108, 0),
                            ],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HistoryScreen())
                            );
                          },
                          label: const Text(
                            'View History',
                            style: TextStyle(color: Colors.white),
                          ),
                          icon:
                              const Icon(Icons.history, color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (isFormVisible) ...[
                const SizedBox(height: 40),
                TextField(
                  controller: _locationController,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(() {
                      
                    });
                  },
                  decoration: InputDecoration(
                      labelText: "Enter Location",
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      prefixIcon: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2,
                          ))),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _budgetController,
                  onChanged: (value) {
                    setState(() {
                      
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      labelText: "Enter Budget (\$)",
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      prefixIcon: const Icon(Icons.monetization_on,
                          color: Colors.orange),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2,
                          color: Colors.white
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(width: 2, color: Colors.white,))),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedTime,
                  dropdownColor: Colors.black87,
                  items: ["Morning", "Afternoon", "Evening"]
                      .map((time) => DropdownMenuItem(
                            value: time,
                            child: Text(time),
                          ))
                      .toList(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16),
                  onChanged: (value) {
                    setState(() {
                      _selectedTime = value!;
                      isTimeSelected = true;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: "Select Time Preference",
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      prefixIcon: const Icon(
                        Icons.access_time_filled,
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2,
                          ))),
                ),
                const SizedBox(height: 24),
                if (isFormFilled)
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFC86FAE),
                          Color(0xFF0084FF),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _generateItinerary,
                      label: const Text(
                        'Generate Itinerary',
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(Icons.auto_awesome,
                          color: Colors.white),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: _itineraryFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData ||
                          snapshot.data == null) {
                        return const Center(
                            child: Text(
                          "You haven't generate any itinerary 🗿",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ));
                      }
                                
                      final itineraryData = snapshot.data!;
                      final itineraryList =
                          itineraryData['itinerary'] as List<dynamic>? ??
                              [];
                      final suggestions = itineraryData['suggestions']
                              as List<dynamic>? ??
                          [];
                                
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            ...itineraryList.map((item) => Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFC86FAE),
                                          Color(0xFF0084FF),
                                        ],
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                          "${item['place']} - ${item['time']}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                              color: Colors.white)),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 15),
                                          Text(
                                              "🎯 Activity : ${item['activity']}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white)),
                                          const SizedBox(height: 10),
                                          Text(
                                              "⏱️ Duration : ${item['estimated_duration']}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white)),
                                          const SizedBox(height: 10),
                                          Text(
                                              "💲 Cost : ${item['estimated_cost']}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                            if (suggestions.isNotEmpty)
                              Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFC86FAE),
                                        Color(0xFF0084FF),
                                      ],
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Suggestions 📒",
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight:
                                                    FontWeight.bold,
                                                color: Colors.white)),
                                        ...suggestions.map((suggestion) =>
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                      top: 10),
                                              child: Text(
                                                  "💡 $suggestion",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color:
                                                          Colors.white)),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

