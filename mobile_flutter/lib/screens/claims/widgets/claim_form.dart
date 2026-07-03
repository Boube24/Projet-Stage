import 'package:flutter/material.dart';

class ClaimForm extends StatelessWidget {

  final TextEditingController titleController;

  final TextEditingController descriptionController;

  const ClaimForm({

    super.key,

    required this.titleController,

    required this.descriptionController,

  });

  @override
  Widget build(BuildContext context) {

    return Column(

      children: [

        TextFormField(

          controller: titleController,

          decoration: const InputDecoration(

            labelText: "Titre",

            border:
            OutlineInputBorder(),

          ),

          validator: (value) {

            if (value == null ||
                value.isEmpty) {

              return "Titre obligatoire";

            }

            return null;

          },

        ),

        const SizedBox(height: 16),

        TextFormField(

          controller:
          descriptionController,

          maxLines: 5,

          decoration: const InputDecoration(

            labelText: "Description",

            border:
            OutlineInputBorder(),

          ),

          validator: (value) {

            if (value == null ||
                value.isEmpty) {

              return "Description obligatoire";

            }

            return null;

          },

        ),

      ],

    );

  }

}