import 'package:api_laravel/models/article.dart';
import 'package:api_laravel/services/api_service.dart';
import 'package:flutter/material.dart';

class AddArticlePage extends StatefulWidget {
  final Article? article;
  const AddArticlePage({super.key, this.article});

  @override
  State<AddArticlePage> createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  final _formKey = GlobalKey<FormState>();
  String titre = '';
  String contenu = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.article != null) {
      titre = widget.article!.titre;
      contenu = widget.article!.contenu;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.article == null ? 'Ajouter' : 'Modifier')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: titre,
                decoration: const InputDecoration(labelText: 'Titre'),
                onChanged: (value) => titre = value,
                validator: (value) =>
                    value!.isEmpty ? 'Le titre est requis' : null,
              ),
              TextFormField(
                initialValue: contenu,
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
                          bool success;
                          if (widget.article == null) {
                            success = await ApiService()
                                .addArticle(titre.trim(), contenu.trim());
                          } else {
                            success = await ApiService().updateArticle(
                              widget.article!.id,
                              titre.trim(),
                              contenu.trim(),
                            );
                          }
                          setState(() => isLoading = false);
                          if (success) {
                            Navigator.pop(context, true);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Échec de l'enregistrement")),
                            );
                          }
                        }
                      },
                      child: Text(widget.article == null ? 'Ajouter' : 'Mettre à jour'),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
