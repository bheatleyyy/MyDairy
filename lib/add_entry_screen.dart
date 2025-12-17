import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'databasehelper.dart';
import 'diary.dart';

class AddEditDiaryScreen extends StatefulWidget {
  final Diary? diary;
  const AddEditDiaryScreen({super.key, this.diary});

  @override
  State<AddEditDiaryScreen> createState() => _AddEditDiaryScreenState();
}

class _AddEditDiaryScreenState extends State<AddEditDiaryScreen> {
  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();
  File? imageFile;

  @override
  void initState() {
    super.initState();
    // Preserve existing data when editing
    if (widget.diary != null) {
      titleCtrl.text = widget.diary!.title;
      contentCtrl.text = widget.diary!.content;
      if (widget.diary!.imagePath != null) {
        imageFile = File(widget.diary!.imagePath!);
      }
    }
  }

  // Pick image from gallery or take a photo
  void pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }
  
  // Save or update diary entry in db
  void saveDiary() async {
    if (titleCtrl.text.isEmpty || contentCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both title and content.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    final diary = Diary(
      id: widget.diary?.id,
      title: titleCtrl.text,
      content: contentCtrl.text,
      date: DateTime.now().toString().substring(0, 10),
      imagePath: imageFile?.path,
    );

    if (widget.diary == null) {
      await DatabaseHelper.instance.insertDiary(diary);
    } else {
      await DatabaseHelper.instance.updateDiary(diary);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Diary')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: contentCtrl, decoration: const InputDecoration(labelText: 'Content')),
            const SizedBox(height: 10),
            if (imageFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  imageFile!,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.image, size: 80, color: Colors.grey),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo),
                  label: const Text('Gallery'),
                  onPressed: () => pickImage(ImageSource.gallery),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                  onPressed: () => pickImage(ImageSource.camera),
                ),
              ],
            ),
            ElevatedButton(onPressed: saveDiary, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
