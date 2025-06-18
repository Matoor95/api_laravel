import 'package:flutter/material.dart';
import 'package:api_laravel/services/api_service.dart';

class AddArticlePage extends StatefulWidget {
  @override
  _AddArticlePageState createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  final _formKey = GlobalKey<FormState>();
  String titre = '';
  String contenu = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un article')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Titre'),
                onChanged: (value) => titre = value,
                validator: (value) =>
                    value!.isEmpty ? 'Le titre est requis' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Contenu'),
                onChanged: (value) => contenu = value,
                validator: (value) =>
                    value!.isEmpty ? 'Le contenu est requis' : null,
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => isLoading = true);
                          final success = await ApiService()
                              .addArticle(titre.trim(), contenu.trim());
                          setState(() => isLoading = false);
                          if (success) {
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context, true);
                          } else {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("ajout reussi")),
                            );
                          }
                        }
                      },
                      child: const Text('Ajouter'),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
