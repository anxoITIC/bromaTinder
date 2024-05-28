import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'megusta.dart'; // Ensure this import is correct and points to the file where MegustaPage is defined
import 'nomegusta.dart'; // Ensure this import is correct and points to the file where NomegustaPage is defined

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
        '/nomegusta': (context) =>
            NomegustaPage(dislikedJokes: []), // Providing an initial empty list
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
  List<String> dislikedJokes = [];

  @override
  void initState() {
    super.initState();
    _loadJokes();
  }

  // Carga las listas de chistes guardadas
  Future<void> _loadJokes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      likedJokes = prefs.getStringList('likedJokes') ?? [];
      dislikedJokes = prefs.getStringList('dislikedJokes') ?? [];
    });
    print('Liked Jokes Loaded: $likedJokes');
    print('Disliked Jokes Loaded: $dislikedJokes');
  }

  // Guarda las listas de chistes
  Future<void> _saveJokes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('likedJokes', likedJokes);
    await prefs.setStringList('dislikedJokes', dislikedJokes);
    print('Liked Jokes Saved: $likedJokes');
    print('Disliked Jokes Saved: $dislikedJokes');
  }

  void addJokeToLikedList(String joke) {
    setState(() {
      likedJokes.add(joke);
    });
    _saveJokes();
  }

  void addJokeToDislikedList(String joke) {
    setState(() {
      dislikedJokes.add(joke);
    });
    _saveJokes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('EL BROMITAS')), // Centro el Titulo
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NomegustaPage(
                          dislikedJokes: dislikedJokes,
                        ),
                      ),
                    );
                  },
                  child: Text('Ir a No Me Gusta'),
                ),
                SizedBox(width: 16),
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
              ],
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
                          ElevatedButton.icon(
                            onPressed: () {
                              addJokeToDislikedList(snapshot.data!);
                            },
                            icon: Icon(Icons.thumb_down),
                            label: Text('No me gusta'),
                          ),
                          SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              addJokeToLikedList(snapshot.data!);
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
