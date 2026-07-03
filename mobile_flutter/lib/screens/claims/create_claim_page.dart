import 'dart:io';

import 'package:flutter/material.dart';
import 'widgets/claim_form.dart';
import 'widgets/category_dropdown.dart';
import 'widgets/commune_dropdown.dart';
import 'package:provider/provider.dart';
import '../../models/claim_request_model.dart';
import '../../providers/claim_provider.dart';

import 'widgets/image_picker_card.dart';
import 'widgets/image_preview_list.dart';

import '../../providers/location_provider.dart';

import 'widgets/location_map.dart';
import '../../core/localization/app_localizations.dart';

class CreateClaimPage extends StatefulWidget {
  const CreateClaimPage({super.key});

  @override
  State<CreateClaimPage> createState() => _CreateClaimPageState();
}

class _CreateClaimPageState extends State<CreateClaimPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  int? _categoryId;
  int? _communeId;
  double? _latitude;
  double? _longitude;

  final List<File> _images = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = context.read<LocationProvider>();
      await provider.loadCurrentLocation();
      print("Error: ${provider.error}");
      print(provider.latitude);
      print(provider.longitude);

      setState(() {
        _latitude = provider.latitude;
        _longitude = provider.longitude;
      });
    });
  }

  // 🛠️ تم التعديل هنا لتستقبل الدالة الـ context للوصول للترجمة بشكل صحيح
  Future<void> _submit(BuildContext context) async {
    final l = AppLocalizations.of(context); // الآن يمكنك استخدام المتغير l هنا بأمان

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez choisir une localisation."),
        ),
      );
      return;
    }

    if (_categoryId == null || _communeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Veuillez sélectionner une catégorie et une commune.",
          ),
        ),
      );
      return;
    }

    final request = ClaimRequestModel(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      categoryId: _categoryId!,
      communeId: _communeId!,
      latitude: _latitude!,
      longitude: _longitude!,
    );

    final provider = context.read<ClaimProvider>();
    final claim = await provider.createClaim(request);

    if (claim == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar( // 🛑 تم حذف const من هنا لأن المحتوى متغير
          content: Text(
            provider.error ?? l.text("error"),
          ),
        ),
      );
      return;
    }

    // Upload des images
    if (_images.isNotEmpty) {
      final provider = context.read<ClaimProvider>();
      await provider.uploadMultipleMedia(claim.id, _images);
    }


    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar( // 🛑 تم حذف const من هنا بسبب دالة الترجمة
        content: Text(
          l.text("claimCreated"),
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l.text("newClaim"),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text("Hello"),
              ClaimForm(
                titleController: _titleController,
                descriptionController: _descriptionController,
              ),
              const SizedBox(height: 20),
              CategoryDropdown(
                value: _categoryId,
                onChanged: (value) {
                  setState(() {
                    _categoryId = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              CommuneDropdown(
                value: _communeId,
                onChanged: (value) {
                  setState(() {
                    _communeId = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              if (_latitude != null && _longitude != null)
                LocationMap(
                  latitude: _latitude!,
                  longitude: _longitude!,
                  onLocationChanged: (latitude, longitude) {
                    setState(() {
                      _latitude = latitude;
                      _longitude = longitude;
                    });
                  },
                ),
              const SizedBox(height: 20),
              ImagePickerCard(
                images: _images,
                onImageAdded: (file) {
                  setState(() {
                    _images.add(file);
                  });
                },
              ),
              ImagePreviewList(
                images: _images,
                onDelete: (index) {
                  setState(() {
                    _images.removeAt(index);
                  });
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 55,
                child: Consumer<ClaimProvider>(
                  builder: (_, provider, __) {
                    return SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        // 🛠️ تم تمرير الـ context هنا للدالة المُعدّلة لتعمل بشكل سليم
                        onPressed: provider.isLoading
                            ? null
                            : () => _submit(context),
                        child: provider.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Déposer la réclamation"),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}