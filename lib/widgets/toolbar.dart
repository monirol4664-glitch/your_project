import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cell.dart';

class ToolbarWidget extends StatelessWidget {
  const ToolbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final notebook = Provider.of<NotebookModel>(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2d2d2d),
        border: Border(
          bottom: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () => notebook.addCell(),
              tooltip: 'Add Cell',
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () {
                for (int i = 0; i < notebook.cells.length; i++) {
                  notebook.executeCell(i);
                }
              },
              icon: const Icon(Icons.play_arrow, size: 18),
              label: const Text('Run All'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.cleaning_services, color: Colors.white),
              onPressed: () => notebook.clearAllOutputs(),
              tooltip: 'Clear Outputs',
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Reset Notebook'),
                    content: const Text('This will delete all cells. Continue?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          notebook.resetAll();
                          Navigator.pop(ctx);
                        },
                        child: const Text('Reset', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              tooltip: 'Reset All',
            ),
          ],
        ),
      ),
    );
  }
}
