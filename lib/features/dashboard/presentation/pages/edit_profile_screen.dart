import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ink_scratch/features/auth/presentation/view_model/auth_viewmodel_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  XFile? _image;
  Uint8List? _imageBytes; // For web preview
  final picker = ImagePicker();
  final TextEditingController _bioController = TextEditingController();

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Read bytes for web preview
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _image = pickedFile;
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _updateProfile() async {
    final authViewModel = ref.read(authViewModelProvider.notifier);

    await authViewModel.updateProfile(
      bio: _bioController.text.isNotEmpty ? _bioController.text : null,
      profilePicturePath: _image?.path,
    );

    if (!mounted) return;

    final state = ref.read(authViewModelProvider);
    if (state.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey[300],
                backgroundImage: _imageBytes != null
                    ? MemoryImage(_imageBytes!) // Use MemoryImage for web
                    : null,
                child: _imageBytes == null
                    ? const Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(
                labelText: 'Bio',
                hintText: 'Tell us about yourself (max 160 characters)',
                border: OutlineInputBorder(),
              ),
              maxLength: 160,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: authState.isLoading ? null : _updateProfile,
              child: authState.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
