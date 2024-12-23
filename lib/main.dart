import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const apiKey = "AIzaSyAA-CyP5xaquVVqdDqTw7O3mivBc7TuwEY";


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personalized Recommendations',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RecommendationScreen(),
    );
  }
}

class RecommendationScreen extends StatefulWidget {
  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  final TextEditingController _userProfileController = TextEditingController();
  String _recommendation = '';
  bool _isLoading = false;

  Future<void> _generateRecommendation() async {
    setState(() {
      _isLoading = true;
    });

    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    final userProfile = _userProfileController.text;
    final content = [Content.text(userProfile)];
    final response = await model.generateContent(content);

    setState(() {
      _recommendation = response.text ?? "";
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personalized Recommendations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _userProfileController,
              decoration: InputDecoration(labelText: 'Enter user profile data'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateRecommendation,
              child: Text('Generate Recommendation'),
            ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
              child: SingleChildScrollView(
                child: Text(_recommendation),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

