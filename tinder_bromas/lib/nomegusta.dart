import 'package:flutter/material.dart';

class NomegustaPage extends StatelessWidget {
  final List<String> dislikedJokes;

  NomegustaPage({required this.dislikedJokes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('No Me Gusta'),
      ),
      body: Center(
        child: dislikedJokes.isEmpty
            ? Text('No hay chistes que no te gusten.')
            : ListView.builder(
                itemCount: dislikedJokes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(dislikedJokes[index]),
                  );
                },
              ),
      ),
    );
  }
}
