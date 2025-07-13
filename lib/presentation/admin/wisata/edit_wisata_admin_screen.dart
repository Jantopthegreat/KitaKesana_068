import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitakesana/data/models/request/admin/place/post_place_admin_request_model.dart';
import 'package:kitakesana/data/models/response/place/place_detail_response_model.dart';
import 'package:kitakesana/data/repositories/place_repository.dart';
import 'package:kitakesana/presentation/admin/bloc/place/admin_place_bloc.dart';

class EditPlaceScreen extends StatefulWidget {
  final int placeId;
  const EditPlaceScreen({super.key, required this.placeId});

  @override
  State<EditPlaceScreen> createState() => _EditPlaceScreenState();
}

class _EditPlaceScreenState extends State<EditPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repository = PlaceRepository();

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final addressController = TextEditingController();
  final latController = TextEditingController();
  final longController = TextEditingController();

  String? selectedCategory;
  String? selectedKabupaten;
  File? selectedImage;

  final List<String> kabupatenList = [
    'Sleman',
    'Bantul',
    'Gunungkidul',
    'Kulon Progo',
    'Kota Yogyakarta',
  ];

  final List<String> categoryList = [
    'Wisata',
    'Wisata Budaya',
    'Wisata Kuliner',
  ];

  late Future<PlaceDetailResponse> _futureDetail;

  @override
  void initState() {
    super.initState();
    _futureDetail = _repository.getPlaceDetail(widget.placeId);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => selectedImage = File(picked.path));
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate() ||
        selectedCategory == null ||
        selectedKabupaten == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lengkapi semua data')));
      return;
    }

    final request = PostPlaceAdminRequestModel(
      name: nameController.text,
      description: descController.text,
      address: addressController.text,
      categoryId: _getCategoryId(selectedCategory!),
      kabupaten: selectedKabupaten!,
      latitude: double.tryParse(latController.text) ?? 0.0,
      longitude: double.tryParse(longController.text) ?? 0.0,
      photo: selectedImage,
    );

    // Gunakan BLoC
    context.read<AdminPlaceBloc>().add(
      UpdateAdminPlaceEvent(widget.placeId, request),
    );
  }

  int _getCategoryId(String name) {
    switch (name) {
      case 'Wisata':
        return 1;
      case 'Wisata Budaya':
        return 2;
      case 'Wisata Kuliner':
        return 3;
      default:
        return 1;
    }
  }

  String _getCategoryName(int id) {
    switch (id) {
      case 1:
        return 'Wisata';
      case 2:
        return 'Wisata Budaya';
      case 3:
        return 'Wisata Kuliner';
      default:
        return 'Wisata';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminPlaceBloc, AdminPlaceState>(
      listener: (context, state) {
        if (state is AdminPlaceSuccess) {
          Navigator.pop(context); // Kembali
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is AdminPlaceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memperbarui: ${state.message}')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Tempat Wisata'),
          backgroundColor: Colors.orange,
        ),
        body: FutureBuilder<PlaceDetailResponse>(
          future: _futureDetail,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.hasError) {
              return const Center(child: Text('Gagal memuat data'));
            }

            final place = snapshot.data!;
            nameController.text = place.name;
            descController.text = place.description;
            addressController.text = place.address;
            latController.text = place.latitude.toString();
            longController.text = place.longitude.toString();
            selectedKabupaten ??= place.kabupaten;
            selectedCategory ??= _getCategoryName(place.categoryId);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Tempat',
                      ),
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
                      items: kabupatenList
                          .map(
                            (k) => DropdownMenuItem(value: k, child: Text(k)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => selectedKabupaten = v),
                      validator: (v) => v == null ? 'Wajib dipilih' : null,
                      decoration: const InputDecoration(labelText: 'Kabupaten'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      items: categoryList
                          .map(
                            (k) => DropdownMenuItem(value: k, child: Text(k)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => selectedCategory = v),
                      validator: (v) => v == null ? 'Wajib dipilih' : null,
                      decoration: const InputDecoration(labelText: 'Kategori'),
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
                      onTap: _pickImage,
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
                            : const Center(
                                child: Text('Pilih Foto (opsional)'),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: BlocBuilder<AdminPlaceBloc, AdminPlaceState>(
                        builder: (context, state) {
                          final isLoading = state is AdminPlaceLoading;
                          return ElevatedButton.icon(
                            icon: const Icon(Icons.save),
                            label: const Text('Perbarui'),
                            onPressed: isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
