import 'package:api_laravel/models/article.dart';
import 'package:api_laravel/pages/AddArticlePage.dart';
import 'package:api_laravel/services/api_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter + Laravel API',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Liste des articles'),
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
    super.initState();
    futureArticles = ApiService().fetchArticles();
  }

  void _refreshArticles() {
    setState(() {
      futureArticles = ApiService().fetchArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Article>>(
        future: futureArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }

          final articles = snapshot.data ?? [];

          if (articles.isEmpty) {
            return const Center(child: Text("Aucun article disponible."));
          }

          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return ListTile(
                title: Text(article.titre),
                subtitle: Text(article.contenu),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddArticlePage()),
          );

          if (result == true) {
            _refreshArticles();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Article ajouté avec succès !")),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
