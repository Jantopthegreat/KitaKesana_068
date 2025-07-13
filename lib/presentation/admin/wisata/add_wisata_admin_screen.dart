import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitakesana/data/models/request/admin/place/post_place_admin_request_model.dart';
import 'package:kitakesana/presentation/admin/bloc/place/admin_place_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final addressController = TextEditingController();
  final latController = TextEditingController();
  final longController = TextEditingController();

  String? selectedKabupaten;
  int? selectedCategory;
  File? selectedImage;

  final List<String> kabupatenList = [
    'Sleman',
    'Bantul',
    'Gunungkidul',
    'Kulon Progo',
    'Kota Yogyakarta',
  ];

  final Map<String, int> categoryMap = {
    'Wisata': 1,
    'Wisata Budaya': 2,
    'Wisata Kuliner': 3,
  };

  Future<void> _pickImage({required ImageSource source}) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = path.basename(picked.path);
      final File savedImage = await File(
        picked.path,
      ).copy('${appDir.path}/$fileName');

      setState(() => selectedImage = savedImage);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate() ||
        selectedImage == null ||
        selectedCategory == null ||
        selectedKabupaten == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua data dan foto')),
      );
      return;
    }

    final request = PostPlaceAdminRequestModel(
      name: nameController.text,
      description: descController.text,
      address: addressController.text,
      categoryId: selectedCategory!,
      kabupaten: selectedKabupaten!,
      latitude: double.tryParse(latController.text) ?? 0.0,
      longitude: double.tryParse(longController.text) ?? 0.0,
      photo: selectedImage,
    );

    context.read<AdminPlaceBloc>().add(CreateAdminPlaceEvent(request));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminPlaceBloc, AdminPlaceState>(
      listener: (context, state) {
        if (state is AdminPlaceSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is AdminPlaceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan: ${state.message}')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tambah Tempat Wisata'),
          backgroundColor: Colors.deepPurple,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama Tempat'),
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Deskripsi'),
                  maxLines: 3,
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Alamat'),
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: selectedKabupaten,
                  hint: const Text('Pilih Kabupaten'),
                  items: kabupatenList
                      .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedKabupaten = v),
                  validator: (v) => v == null ? 'Wajib dipilih' : null,
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<int>(
                  value: selectedCategory,
                  hint: const Text('Pilih Kategori'),
                  items: categoryMap.entries.map((entry) {
                    return DropdownMenuItem<int>(
                      value: entry.value,
                      child: Text(entry.key),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => selectedCategory = v),
                  validator: (v) => v == null ? 'Wajib dipilih' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: latController,
                  decoration: const InputDecoration(labelText: 'Latitude'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: longController,
                  decoration: const InputDecoration(labelText: 'Longitude'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),

                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return SafeArea(
                          child: Wrap(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.camera_alt),
                                title: const Text('Ambil dari Kamera'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickImage(source: ImageSource.camera);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo_library),
                                title: const Text('Ambil dari Galeri'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickImage(source: ImageSource.gallery);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[100],
                    ),
                    child: selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : const Center(child: Text('Pilih Foto')),
                  ),
                ),

                const SizedBox(height: 20),

                BlocBuilder<AdminPlaceBloc, AdminPlaceState>(
                  builder: (context, state) {
                    final isLoading = state is AdminPlaceLoading;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Simpan'),
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
