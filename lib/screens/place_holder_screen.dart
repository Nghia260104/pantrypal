import 'package:flutter/material.dart';
import 'package:pantrypal/models/recipe.dart';

class PlaceHolderScreen extends StatefulWidget {
  final String title;

  const PlaceHolderScreen({super.key, required this.title});

  @override
  _PlaceHolderScreenState createState() => _PlaceHolderScreenState();
}

class _PlaceHolderScreenState extends State<PlaceHolderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _durationController = TextEditingController();
  final _difficultyController = TextEditingController();
  final _briefDescriptionController = TextEditingController();

  void _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      final recipe = Recipe(
        id: 2, // Unique ID
        name: _nameController.text,
        instructions: _instructionsController.text,
        duration: int.parse(_durationController.text),
        difficulty: _difficultyController.text,
        briefDescription: _briefDescriptionController.text,
        ingredientRequirements: [], // Empty for now
      );

      // Save the recipe to Hive
      print('Recipe 1 saved: ${recipe.name}');
      await Recipe.create(recipe);
      print('Recipe saved: ${recipe.name}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Recipe saved successfully!')));

      // Clear the form
      _nameController.clear();
      _instructionsController.clear();
      _durationController.clear();
      _difficultyController.clear();
      _briefDescriptionController.clear();
    }
  }

  void _viewRecipes() {
    final recipes = Recipe.all();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Stored Recipes'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return ListTile(
                  title: Text(recipe.name),
                  subtitle: Text('Duration: ${recipe.duration} min'),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Recipe Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a recipe name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _instructionsController,
                decoration: InputDecoration(labelText: 'Instructions'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter instructions';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the duration';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _difficultyController,
                decoration: InputDecoration(labelText: 'Difficulty'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the difficulty';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _briefDescriptionController,
                decoration: InputDecoration(labelText: 'Brief Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a brief description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveRecipe,
                child: Text('Save Recipe'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _viewRecipes,
                child: Text('View Stored Recipes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
