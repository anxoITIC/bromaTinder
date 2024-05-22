import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tinder_bromas/megusta.dart';
import 'megusta.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      initialRoute: '/', // Esta es la ruta inicial de tu aplicación
      routes: {
        '/': (context) => HomePage(), // Esta es tu página de inicio
        '/megusta': (context) =>
            MegustaPage(), // Esta es la ruta a la página MegustaPage
      },
    );
  }
}

//Conexión a la API de chistes y petición de datos
Future<String> fetchData() async {
  final response = await http.get(Uri.parse('https://icanhazdadjoke.com/'),
      headers: {'Accept': 'text/plain'});

  if (response.statusCode == 200) {
    // Si todo va bien te devuelve el los datos en texto plano.
    return response.body;
  } else {
    // Si va mal devuelve una excepción.
    throw Exception('Failed to load data');
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('API BROMAS')), // Centro el Titulo
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MegustaPage()),
                );
              },
              child: Text('Ir a Me Gusta'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Lógica para el botón de no me gusta
                  },
                  //Iconno de Dislike
                  child: Icon(Icons.thumb_down),
                ),
                SizedBox(width: 10), // Espacio entre los botones
                Expanded(
                  child: Center(
                    //Centro el texto que recibi de la API
                    child: FutureBuilder(
                      future: fetchData(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data);
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10), // Espacio entre los botones
                ElevatedButton(
                  onPressed: () {
                    // Lógica para el botón de me gusta
                  },
                  //Iconno de Like
                  child: Icon(Icons.thumb_up),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
