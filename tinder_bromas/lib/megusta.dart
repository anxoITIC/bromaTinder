// megusta.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MegustaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (snapshot.hasData) {
          return Text(
              snapshot.data!.getString('megusta') ?? 'No hay datos guardados');
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}
