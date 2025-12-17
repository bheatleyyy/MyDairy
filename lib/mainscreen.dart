import 'dart:io';
import 'package:flutter/material.dart';
import 'databasehelper.dart';
import 'diary.dart';
import 'add_entry_screen.dart';
import 'detail_edit_screen.dart';

class DiaryListScreen extends StatefulWidget {
  const DiaryListScreen({super.key});

  @override
  State<DiaryListScreen> createState() => _DiaryListScreenState();
}

class _DiaryListScreenState extends State<DiaryListScreen> {
  List<Diary> diaries = [];

  @override
  void initState() {
    super.initState();
    loadDiaries();
  }

  // Load all diary entries from db
  void loadDiaries() async {
    diaries = await DatabaseHelper.instance.getAllDiaries();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'MyDairy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 400,
              height: 1,
              color: Colors.black,
            ),
          ],
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditDiaryScreen()),
          );
          loadDiaries();
        },
      ),
      body: ListView.separated(
      itemCount: diaries.length,
      separatorBuilder: (context, index) => const Divider(
        thickness: 1,
        indent: 16,
        endIndent: 16,
      ),
      itemBuilder: (context, index) {
        final d = diaries[index];
        return ListTile(
            leading: d.imagePath != null
                ? Image.file(File(d.imagePath!), width: 50, fit: BoxFit.cover)
                : const Icon(Icons.book),
            title: Text(d.title),
            subtitle: Text(d.date),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DiaryDetailScreen(diary: d),
                ),
              );
              loadDiaries();
            },
          );
        },
      ),
    );
  }
}
