import 'package:divichanger/screens/my_drawer.dart';
import 'package:flutter/material.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text(
          'CRÉDITOS',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff259AC5),
      ),
      body: const Center(
        child: Text(
          'APP CREADA POR PABLO AMORES MUÑOZ',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
