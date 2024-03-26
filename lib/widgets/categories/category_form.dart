import 'dart:convert';
import 'dart:io';

import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/services/category_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/providers/categories.dart';

class CategoryForm extends ConsumerStatefulWidget {
  final Category? category;

  CategoryForm({super.key, required this.category});

  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends ConsumerState<CategoryForm> {
  final _formKey = GlobalKey<FormState>();

  var categoryId = '';
  final _nameController = TextEditingController();
  final _colorController = TextEditingController();
  final _subcategoryController = TextEditingController();
  final _iconController = TextEditingController();
  List _subCategories = [];
  IconData? icon;
  Color? color;

  var saving = false;

  _pickIcon() async {
    icon = await showIconPicker(
      context,
      adaptiveDialog: true,
      showTooltips: false,
      showSearchBar: true,
      iconPickerShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      iconPackModes: [
        (Platform.isIOS) ? IconPack.cupertino : IconPack.material
      ],
    );

    if (icon != null) {
      setState(() {
        _iconController.text = jsonEncode(serializeIcon(icon!));
      });
    }
  }

  _pickColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: MaterialPicker(
              pickerColor: Colors.white,
              onColorChanged: (Color color) {
                _colorController.text = color.value.toRadixString(16);
                this.color = color;
                setState(() {});
                Navigator.of(context).pop();
              },
              enableLabel: true,
              portraitOnly: true,
            ),
          ),
        );
      },
    );
  }

  subcategoryForm(subcategory) {
    dynamic index =
        (subcategory != '') ? _subCategories.indexOf(subcategory) : '';
    _subcategoryController.text = subcategory;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Subcategory'),
          content: TextField(
            controller: _subcategoryController,
            decoration: const InputDecoration(
              labelText: 'Subcategory name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Add subcategory to list
                if (_subcategoryController.text.isNotEmpty) {
                  setState(() {
                    if (index != '') {
                      _subCategories.removeAt(index);
                    }
                    _subcategoryController.clear();
                  });
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text(
                'Remove',
                style: TextStyle(color: Colors.red),
              ),
            ),
            CupertinoButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                // Add subcategory to list
                if (_subcategoryController.text.isNotEmpty) {
                  setState(() {
                    if (index != '') {
                      _subCategories[index] = _subcategoryController.text;
                    } else {
                      _subCategories.add(_subcategoryController.text);
                    }
                    _subcategoryController.clear();
                  });
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      categoryId = widget.category!.id;
      _nameController.text = widget.category!.name;
      _colorController.text = widget.category!.color;
      _iconController.text = widget.category!.icon;
      _subCategories = widget.category!.subcategories;
      icon = deserializeIcon(
        Map<String, dynamic>.from(jsonDecode(widget.category!.icon)),
        iconPack: IconPack.allMaterial,
      );
      color = Color(int.parse(widget.category!.color, radix: 16));
    }
  }

  void _submitForm() async {
    setState(() {
      saving = true;
    });
    bool error = false;
    String errorMessage = '';
    if (_colorController.text.isEmpty) {
      error = true;
      errorMessage = 'Please select a color';
    }
    if (_iconController.text.isEmpty) {
      error = true;
      errorMessage = 'Please select an icon';
    }
    if (!error && _formKey.currentState!.validate()) {
      final newCategory = Category(
        name: _nameController.text,
        color: _colorController.text,
        icon: _iconController.text,
        subcategories: _subCategories,
      );
      if (categoryId.isNotEmpty) {
        newCategory.id = categoryId;
        await CategoryService().updateCategory(newCategory);
        ref.read(categoriesProvider.notifier).updateCategory(newCategory);
      } else {
        final response = await CategoryService().addCategory(newCategory);
        newCategory.id = response.body;
        ref.read(categoriesProvider.notifier).addCategory(newCategory);
      }
      setState(() {
        saving = false;
      });
      Navigator.of(context).pop();
    } else if (errorMessage.isNotEmpty) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Invalid data'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Okay'),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            const SizedBox(height: 16),
            Row(
              children: [
                if (color != null)
                  GestureDetector(
                    onTap: _pickColor,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: color,
                      ),
                      margin: const EdgeInsets.only(right: 16),
                    ),
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _pickColor,
                  child: Text(color != null ? 'Change Color' : 'Select Color'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (icon != null)
                  GestureDetector(
                      onTap: _pickIcon, child: Icon(icon, size: 40)),
                if (icon != null) const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _pickIcon,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(icon != null ? 'Change Icon' : 'Select Icon'),
                ),
              ],
            ),
            // Grid list to list and add subcategories
            Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    Text(
                      'Subcategories',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    GridView(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        childAspectRatio: 2,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      children: [
                        //map with for subcategories
                        for (final subcategory in _subCategories)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              backgroundColor:
                                  color ?? Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(4),
                            ),
                            onPressed: () {
                              setState(() {
                                subcategoryForm(subcategory);
                              });
                            },
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                subcategory,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor: Colors.grey[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(4),
                          ),
                          onPressed: () {
                            subcategoryForm('');
                          },
                          child: const Icon(
                            Icons.add_box_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            const SizedBox(height: 32),
            if (Platform.isIOS)
              CupertinoButton.filled(
                onPressed: _submitForm,
                child: (saving)
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Save category',
                        style: TextStyle(color: Colors.white),
                      ),
              )
            else
              ElevatedButton(
                onPressed: _submitForm,
                child: (saving)
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Save category',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
