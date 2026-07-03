import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreviewList extends StatelessWidget {

  final List<File> images;

  final Function(int index) onDelete;

  const ImagePreviewList({
    super.key,
    required this.images,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {

    if (images.isEmpty) {

      return const SizedBox();

    }

    return SizedBox(

      height: 110,

      child: ListView.builder(

        scrollDirection:
        Axis.horizontal,

        itemCount: images.length,

        itemBuilder: (_, index) {

          return Stack(

            children: [

              Container(

                margin:
                const EdgeInsets.all(8),

                width: 100,

                decoration: BoxDecoration(

                  borderRadius:
                  BorderRadius.circular(10),

                  image: DecorationImage(

                    image:
                    FileImage(images[index]),

                    fit: BoxFit.cover,

                  ),

                ),

              ),

              Positioned(

                right: 0,

                child: CircleAvatar(

                  radius: 14,

                  backgroundColor:
                  Colors.red,

                  child: IconButton(

                    padding: EdgeInsets.zero,

                    icon: const Icon(

                      Icons.close,

                      size: 15,

                      color: Colors.white,

                    ),

                    onPressed: () {

                      onDelete(index);

                    },

                  ),

                ),

              )

            ],

          );

        },

      ),

    );

  }

}