import 'package:flutter/material.dart';

class CodeCell {
  final String id;
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
  List<CodeCell> _cells = [];
  int _nextId = 1;
  
  List<CodeCell> get cells => _cells;
  
  NotebookModel() {
    _addInitialCell();
  }
  
  void _addInitialCell() {
    _cells.add(CodeCell(id: 'cell_${_nextId++}'));
    notifyListeners();
  }
  
  void addCell({String? afterId}) {
    final cell = CodeCell(id: 'cell_${_nextId++}');
    
    if (afterId != null) {
      final index = _cells.indexWhere((c) => c.id == afterId);
      _cells.insert(index + 1, cell);
    } else {
      _cells.add(cell);
    }
    notifyListeners();
  }
  
  void deleteCell(String id) {
    if (_cells.length > 1) {
      _cells.removeWhere((c) => c.id == id);
      notifyListeners();
    }
  }
  
  void updateCode(String id, String newCode) {
    final cell = _cells.firstWhere((c) => c.id == id);
    cell.code = newCode;
    notifyListeners();
  }
  
  void updateOutput(String id, String output) {
    final cell = _cells.firstWhere((c) => c.id == id);
    cell.output = output;
    cell.isRunning = false;
    notifyListeners();
  }
  
  void setRunning(String id, bool running) {
    final cell = _cells.firstWhere((c) => c.id == id);
    cell.isRunning = running;
    notifyListeners();
  }
  
  void clearAllOutputs() {
    for (var cell in _cells) {
      cell.output = '';
    }
    notifyListeners();
  }
  
  void reorderCells(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final cell = _cells.removeAt(oldIndex);
    _cells.insert(newIndex, cell);
    notifyListeners();
  }
}
