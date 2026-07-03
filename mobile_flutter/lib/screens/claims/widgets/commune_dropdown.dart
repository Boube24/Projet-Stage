import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/commune_provider.dart';

class CommuneDropdown extends StatefulWidget {
  final int? value;
  final ValueChanged<int?> onChanged;

  const CommuneDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<CommuneDropdown> createState() =>
      _CommuneDropdownState();
}

class _CommuneDropdownState
    extends State<CommuneDropdown> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<CommuneProvider>()
          .loadCommunes();
    });
  }

  @override
  Widget build(BuildContext context) {

    final provider =
    context.watch<CommuneProvider>();

    if (provider.isLoading) {

      return const Center(
        child: CircularProgressIndicator(),
      );

    }

    if (provider.error != null) {

      return Text(
        provider.error!,
        style: const TextStyle(
          color: Colors.red,
        ),
      );

    }

    return DropdownButtonFormField<int>(

      value: widget.value,

      decoration: const InputDecoration(

        labelText: "Commune",

        border: OutlineInputBorder(),

      ),

      items: provider.communes.map((commune) {

        return DropdownMenuItem<int>(

          value: commune.id,

          child: Text(commune.name),

        );

      }).toList(),

      validator: (value) {

        if (value == null) {

          return "Choisissez une commune";

        }

        return null;

      },

      onChanged: widget.onChanged,

    );

  }

}