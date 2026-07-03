import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/category_provider.dart';

class CategoryDropdown extends StatefulWidget {
  final int? value;

  final ValueChanged<int?> onChanged;

  const CategoryDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<CategoryDropdown> createState() =>
      _CategoryDropdownState();
}

class _CategoryDropdownState
    extends State<CategoryDropdown> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<CategoryProvider>()
          .loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {

    final provider =
    context.watch<CategoryProvider>();

    if (provider.isLoading) {

      return const Center(
        child: CircularProgressIndicator(),
      );

    }

    if (provider.errorMessage != null) {

      return Text(
        provider.errorMessage!,
        style: const TextStyle(
          color: Colors.red,
        ),
      );

    }

    return DropdownButtonFormField<int>(

      value: widget.value,

      decoration: const InputDecoration(

        labelText: "Catégorie",

        border: OutlineInputBorder(),

      ),

      items: provider.categories.map((category) {

        return DropdownMenuItem<int>(

          value: category.id,

          child: Text(category.name),

        );

      }).toList(),

      validator: (value) {

        if (value == null) {

          return "Choisissez une catégorie";

        }

        return null;

      },

      onChanged: widget.onChanged,

    );

  }

}