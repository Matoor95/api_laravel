import 'package:api_laravel/models/article.dart';
import 'package:api_laravel/services/api_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Article>> futureArticles;
  @override
  void initState() {
    futureArticles = ApiService().fetchArticles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("liste de mes articles"),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
      body: FutureBuilder<List<Article>>(
          future: futureArticles,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Erreur :${snapshot.error}"),
              );
            }
            return ListView(
              children: snapshot.data!.map((article)=>ListTile(
                title: Text(article.titre),
                subtitle: Text(article.contenu),
              ))
              .toList(),
            );
          }),
    );
  }
}
