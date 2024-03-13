import 'package:expense_tracker/models/category.dart';
import 'package:flutter/material.dart';

class CategoryForm extends StatefulWidget {
  final Category category;
  final Function(Category) onCategorySubmit;

  CategoryForm(
      {super.key, required this.category, required this.onCategorySubmit});

  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _colorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category.name;
      _colorController.text = widget.category.color.value.toRadixString(16);
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final color = Color(int.parse(_colorController.text, radix: 16));
      final newCategory = Category(
          name: name,
          color: color,
          id: widget.category?.id ?? DateTime.now().toString(),
          categoryType: widget.category?.categoryType ?? CategoryType.other,
          icon: 0);
      widget.onCategorySubmit(newCategory);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _colorController,
              decoration: const InputDecoration(labelText: 'Color'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a color';
                }
                if (value!.length != 6) {
                  return 'Please enter a valid color';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
