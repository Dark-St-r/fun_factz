import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> facts = [];
  bool isLoading = true;

  void getData() async {
    try {
      Response response = await Dio().get(
          'https://gist.githubusercontent.com/Dark-St-r/f570f9cd146bf3dd03b3bca86d7993de/raw/c4fa9dedf35516eed83af64aa208c8ac786d903f/facts.json');
      facts = jsonDecode(response.data);
      isLoading = false;
      setState(() {});
    } catch (e) {
      isLoading = false;
      facts = ['Failed to fetch data.'];
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Fun Factz'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : PageView.builder(
                    itemBuilder: (context, index) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            facts[index] +
                                '\n[' +
                                (index + 1).toString() +
                                '/' +
                                facts.length.toString() +
                                ']',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 35),
                          ),
                        ),
                      );
                    },
                    itemCount: facts.length,
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Swipe left/right for more',
            ),
          )
        ],
      ),
    );
  }
}
