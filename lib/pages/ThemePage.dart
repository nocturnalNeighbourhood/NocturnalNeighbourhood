import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Themepage extends StatelessWidget {
  const Themepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Theme",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          child: Column(
            children: [
              Text(
                "Nocturnal Neighbourhood is fixed to have a minimal dark theme to reflect and support the nocturnal beings (who stay up at night...).",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                  "But don't worry!, we'll think of new themes in our next update so stay tuned!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
            ],
          ),
        ),
      ),
    );
  }
}
