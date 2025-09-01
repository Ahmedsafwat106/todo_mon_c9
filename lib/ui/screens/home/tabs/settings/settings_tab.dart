import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/list_provider.dart';
import '../../../../../services/backup_service.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ListProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: () async {
              final file = await BackupService.exportTodos();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("✅ Backup saved at: ${file.path}")),
              );
            },
            icon: const Icon(Icons.upload_file),
            label: const Text("Export Tasks"),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              try {
                final result = await FilePicker.platform.pickFiles();
                if (result != null && result.files.single.path != null) {
                  final file = File(result.files.single.path!);

                  // ✅ جرب اقرأ الملف الأول
                  final content = await file.readAsString();
                  jsonDecode(content); // لو مش JSON هيرمي Exception

                  // 🟢 استدعاء الاستيراد
                  final importedTasks = await BackupService.importTodos(file);

                  // 🟢 خلي الـ provider يضيف التاسكات + يحدث اللستة
                  await provider.importTasks(importedTasks);
                  await provider.getTodosFromLocal();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("✅ Tasks imported successfully!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("❌ Import failed: الملف غير صالح"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            icon: const Icon(Icons.download),
            label: const Text("Import Tasks"),
          ),
        ],
      ),
    );
  }
}
