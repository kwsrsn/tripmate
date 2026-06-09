import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TripListScreen extends StatelessWidget {
  const TripListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Trip',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight(600)),
          ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(10),
            child: Card(
              color: Theme.of(context).colorScheme.secondary,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 10),
                    Text(
                      'Create new trip',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}