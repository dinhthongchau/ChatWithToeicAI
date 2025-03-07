import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../chat/chat_screen.dart';
import '../setting/theme_provider.dart';

class GuideScreen extends StatelessWidget {
  static const String route = "/guide";
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.backgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: themeProvider.textColor),
        ),
      ),
      bottomNavigationBar: IconButton(
        onPressed: () {
          Navigator.of(context).pushNamed(ChatScreen.route);
        },
        icon: Icon(Icons.home_outlined, color: themeProvider.textColor),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "TOEIC AI Chatbox User Guide",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: themeProvider.textColor,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "1. Introduction",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.textColor),
            ),
            Text(
              "TOEIC AI Chatbox is an intelligent learning tool designed to help you improve your TOEIC skills.",
              style: TextStyle(color: themeProvider.textColor),
            ),
            SizedBox(height: 10),
            Text(
              "2. Main Features",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.textColor),
            ),
            _buildFeatureItem(
                "a. Translate Words and Provide TOEIC-Related Vocabulary",
                themeProvider,
                "Example: Type 'What does 'ubiquitous' mean?' and the chatbox will provide the definition, pronunciation, and example sentences."),
            _buildFeatureItem("b. Explain Grammar Rules", themeProvider,
                "Example: Ask 'When should I use present perfect tense?' and the chatbox will provide explanations with sample sentences."),
            _buildFeatureItem(
                "c. Synonyms and Antonyms for TOEIC Words",
                themeProvider,
                "Example: Ask 'What are synonyms for 'efficient'?' to get words like 'productive' and 'effective'."),
            _buildFeatureItem("d. TOEIC Listening Tips", themeProvider,
                "Example: Ask 'How can I improve my listening skills?' to get strategic tips and practice exercises."),
            _buildFeatureItem("e. Formal Email Writing", themeProvider,
                "Example: Type 'How to write a formal email?' and get templates and key phrases for professional emails."),
            _buildFeatureItem("f. Common TOEIC Idioms", themeProvider,
                "Example: Ask 'What does 'hit the nail on the head' mean?' to receive its meaning and usage examples."),
            _buildFeatureItem(
                "g. TOEIC Test Time Management Strategies",
                themeProvider,
                "Example: Ask 'How should I manage my time in the TOEIC test?' to receive tips for each section."),
            SizedBox(height: 10),
            Text(
              "3. How to Use the Chatbox",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.textColor),
            ),
            Text(
              "- Open the chatbox and enter your TOEIC-related question.\n"
              "- Receive an instant response from the system.\n"
              "- Apply the provided information to your studies.",
              style: TextStyle(color: themeProvider.textColor),
            ),
            SizedBox(height: 10),
            Text(
              "4. Effective Usage Tips",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.textColor),
            ),
            Text(
              "- Ask multiple questions for better understanding.\n"
              "- Take notes on essential vocabulary and grammar rules.\n"
              "- Practice with real TOEIC-style questions.",
              style: TextStyle(color: themeProvider.textColor),
            ),
            SizedBox(height: 10),
            Text(
              "5. Support Contact",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.textColor),
            ),
            Text(
              "If you need assistance, please contact us via email [FlutterProject.Email].",
              style: TextStyle(color: themeProvider.textColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
      String title, ThemeProvider themeProvider, String example) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: themeProvider.textColor),
          ),
          Text(
            example,
            style: TextStyle(fontSize: 14, color: themeProvider.textColor),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}
