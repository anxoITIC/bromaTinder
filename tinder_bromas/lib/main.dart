import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
            MegustaPage(likedJokes: []), // Providing an initial empty list
      },
    );
  }
}

// Conexión a la API de chistes y petición de datos
Future<String> fetchData() async {
  final response = await http.get(
    Uri.parse('https://icanhazdadjoke.com/'),
    headers: {'Accept': 'text/plain'},
  );

  if (response.statusCode == 200) {
    // Si todo va bien te devuelve los datos en texto plano.
    return response.body;
  } else {
    // Si va mal devuelve una excepción.
    throw Exception('Failed to load data');
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> likedJokes = [];

  void addJokeToList(String joke) {
    setState(() {
      likedJokes.add(joke);
    });
  }

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
                  MaterialPageRoute(
                    builder: (context) => MegustaPage(
                      likedJokes: likedJokes,
                    ),
                  ),
                );
              },
              child: Text('Ir a Me Gusta'),
            ),
            FutureBuilder<String>(
              future: fetchData(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          snapshot.data!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onPanEnd: (DragEndDetails details) {
                              if (details.velocity.pixelsPerSecond.dx > 0) {
                                // Swipe Right - replace this with your like logic
                              } else if (details.velocity.pixelsPerSecond.dx <
                                  0) {
                                // Swipe Left - replace this with your dislike logic
                              }
                            },
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Lógica para el botón de no me gusta
                              },
                              icon: Icon(Icons.thumb_down),
                              label: Text('No me gusta'),
                            ),
                          ),
                          SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              addJokeToList(snapshot.data!);
                            },
                            icon: Icon(Icons.thumb_up),
                            label: Text('Me gusta'),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Text('No data');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
