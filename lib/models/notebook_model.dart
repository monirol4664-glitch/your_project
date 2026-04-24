import 'package:flutter/material.dart';

class CodeCell {
  String id;
  String code;
  String output;
  bool isRunning;
  
  CodeCell({
    required this.id,
    this.code = '',
    this.output = '',
    this.isRunning = false,
  });
}

class NotebookModel extends ChangeNotifier {
  List<CodeCell> cells = [];
  int _nextId = 1;
  
  NotebookModel() {
    _initPython();
    addCell();
  }
  
  Future<void> _initPython() async {
    // Python will be initialized when first cell runs
    // This is handled by the Python service at runtime
    print('IDE Ready - Python will load on first execution');
  }
  
  void addCell({String? afterId}) {
    final cell = CodeCell(id: 'cell_${_nextId++}');
    
    if (afterId != null) {
      final index = cells.indexWhere((c) => c.id == afterId);
      cells.insert(index + 1, cell);
    } else {
      cells.add(cell);
    }
    notifyListeners();
  }
  
  void deleteCell(String id) {
    if (cells.length > 1) {
      cells.removeWhere((c) => c.id == id);
      notifyListeners();
    }
  }
  
  void updateCode(String id, String newCode) {
    final cell = cells.firstWhere((c) => c.id == id);
    cell.code = newCode;
    notifyListeners();
  }
  
  void updateOutput(String id, String output) {
    final cell = cells.firstWhere((c) => c.id == id);
    cell.output = output;
    cell.isRunning = false;
    notifyListeners();
  }
  
  void setRunning(String id, bool running) {
    final cell = cells.firstWhere((c) => c.id == id);
    cell.isRunning = running;
    notifyListeners();
  }
  
  void clearAllOutputs() {
    for (var cell in cells) {
      cell.output = '';
    }
    notifyListeners();
  }
  
  void runAllCells() {
    for (var cell in cells) {
      if (cell.code.trim().isNotEmpty) {
        // Trigger execution (handled by UI)
      }
    }
  }
}
