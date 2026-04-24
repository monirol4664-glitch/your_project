import 'dart:async';

class PythonService {
  static final PythonService _instance = PythonService._internal();
  factory PythonService() => _instance;
  PythonService._internal();
  
  Future<String> executeCode(String code) async {
    // Simulate Python execution
    await Future.delayed(const Duration(milliseconds: 100));
    
    try {
      if (code.trim().isEmpty) {
        return '';
      }
      
      // Simple simulation for demo
      if (code.contains('print')) {
        final match = RegExp(r'print\([\'"](.+)[\'"]\)').firstMatch(code);
        if (match != null) {
          return match.group(1) ?? '';
        }
      }
      
      if (code.contains('1 + 1')) {
        return '2';
      }
      
      if (code.contains('len(')) {
        final match = RegExp(r'len\([\'"](.+)[\'"]\)').firstMatch(code);
        if (match != null) {
          return match.group(1)?.length.toString() ?? '';
        }
      }
      
      return 'Executed successfully';
      
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
                                     }
