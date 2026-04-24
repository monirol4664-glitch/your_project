import 'package:flutter/foundation.dart';

class Cell {
  String id;
  String code;
  String output;
  bool isRunning;
  DateTime createdAt;

  Cell({
    required this.id,
    required this.code,
    this.output = '',
    this.isRunning = false,
    required this.createdAt,
  });

  Cell copyWith({
    String? id,
    String? code,
    String? output,
    bool? isRunning,
    DateTime? createdAt,
  }) {
    return Cell(
      id: id ?? this.id,
      code: code ?? this.code,
      output: output ?? this.output,
      isRunning: isRunning ?? this.isRunning,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class NotebookModel extends ChangeNotifier {
  List<Cell> _cells = [];
  
  List<Cell> get cells => _cells;
  
  NotebookModel() {
    _init();
  }
  
  void _init() {
    _cells.add(Cell(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      code: '''# Welcome to Jupyter Mobile!
# Write Python code and tap Run

print("Hello from Flutter!")

# Try:
# 2 + 2
# [x*2 for x in range(10)]

import numpy as np
arr = np.array([1, 2, 3, 4, 5])
print(f"Sum: {arr.sum()}")
''',
      output: '// Tap Run to execute',
      createdAt: DateTime.now(),
    ));
  }
  
  void addCell({String? code}) {
    _cells.add(Cell(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      code: code ?? '# New cell\nprint("Hello!")',
      output: '// Ready',
      createdAt: DateTime.now(),
    ));
    notifyListeners();
  }
  
  void deleteCell(int index) {
    _cells.removeAt(index);
    notifyListeners();
  }
  
  void updateCell(int index, String code) {
    _cells[index] = _cells[index].copyWith(code: code);
    notifyListeners();
  }
  
  void updateOutput(int index, String output) {
    _cells[index] = _cells[index].copyWith(output: output, isRunning: false);
    notifyListeners();
  }
  
  void setRunning(int index, bool running) {
    _cells[index] = _cells[index].copyWith(isRunning: running);
    notifyListeners();
  }
  
  Future<void> executeCell(int index) async {
    setRunning(index, true);
    updateOutput(index, 'Running...');
    
    // Execution handled by PythonService
    notifyListeners();
  }
  
  void clearAllOutputs() {
    for (int i = 0; i < _cells.length; i++) {
      _cells[i] = _cells[i].copyWith(output: '// Output cleared', isRunning: false);
    }
    notifyListeners();
  }
  
  void resetAll() {
    _cells.clear();
    _init();
    notifyListeners();
  }
}
