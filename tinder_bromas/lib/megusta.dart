import 'package:flutter/material.dart';

class MegustaPage extends StatelessWidget {
  final List<String> likedJokes;

  MegustaPage({required this.likedJokes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Me Gusta'),
      ),
      body: Center(
        child: likedJokes.isEmpty
            ? Text('No hay chistes que te gusten.')
            : ListView.builder(
                itemCount: likedJokes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(likedJokes[index]),
                  );
                },
              ),
      ),
    );
  }
}
