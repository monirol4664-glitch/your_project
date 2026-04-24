import 'dart:async';

class ExecutionService {
  static final ExecutionService _instance = ExecutionService._internal();
  factory ExecutionService() => _instance;
  ExecutionService._internal();
  
  // Simulated Python execution with support for common operations
  Future<String> executeCode(String code) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    try {
      final trimmed = code.trim();
      if (trimmed.isEmpty) return '';
      
      // Mathematical expressions
      if (trimmed.contains('+') || trimmed.contains('-') || 
          trimmed.contains('*') || trimmed.contains('/')) {
        try {
          // Safe evaluation for math expressions
          final result = _evaluateMath(trimmed);
          if (result != null) return result.toString();
        } catch (_) {}
      }
      
      // Print statements - FIXED regex
      if (trimmed.startsWith('print(')) {
        // Handle print('text') and print("text")
        if (trimmed.contains("'") || trimmed.contains('"')) {
          final startQuote = trimmed.indexOf('\'') != -1 ? '\'' : '"';
          final endQuote = startQuote;
          final contentStart = trimmed.indexOf(startQuote) + 1;
          final contentEnd = trimmed.indexOf(endQuote, contentStart);
          if (contentStart > 0 && contentEnd > contentStart) {
            return trimmed.substring(contentStart, contentEnd);
          }
        }
        return "Printed successfully";
      }
      
      // Variable assignments (simulated)
      if (trimmed.contains('=') && !trimmed.contains('==')) {
        return "✓ Variable assigned";
      }
      
      // List operations - FIXED
      if (trimmed.startsWith('len(')) {
        // Extract content inside len()
        final startParen = trimmed.indexOf('(');
        final endParen = trimmed.lastIndexOf(')');
        if (startParen != -1 && endParen > startParen) {
          final content = trimmed.substring(startParen + 1, endParen);
          // Remove quotes if present
          final cleanContent = content.replaceAll(RegExp(r'[\'"]'), '');
          return cleanContent.length.toString();
        }
        return "0";
      }
      
      // String operations
      if (trimmed.contains('.upper()') || trimmed.contains('.lower()')) {
        return "String operation result";
      }
      
      // Loop simulation
      if (trimmed.startsWith('for ') || trimmed.startsWith('while ')) {
        return "Loop executed (simulated)";
      }
      
      // Function definition
      if (trimmed.startsWith('def ')) {
        return "Function defined";
      }
      
      // Handle print without quotes (variable print)
      if (trimmed.startsWith('print(') && trimmed.contains(')')) {
        final varName = trimmed.substring(6, trimmed.length - 1);
        return "Value of '$varName' would print here";
      }
      
      // Default response
      if (trimmed.isNotEmpty) {
        return "✓ Code executed successfully";
      }
      
      return '';
      
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
  
  double? _evaluateMath(String expression) {
    // Remove whitespace
    expression = expression.replaceAll(' ', '');
    
    // Handle basic operations
    if (expression.contains('+')) {
      final parts = expression.split('+');
      if (parts.length == 2) {
        final a = double.tryParse(parts[0]);
        final b = double.tryParse(parts[1]);
        if (a != null && b != null) return a + b;
      }
    }
    
    if (expression.contains('-') && !expression.startsWith('-')) {
      final parts = expression.split('-');
      if (parts.length == 2) {
        final a = double.tryParse(parts[0]);
        final b = double.tryParse(parts[1]);
        if (a != null && b != null) return a - b;
      }
    }
    
    if (expression.contains('*')) {
      final parts = expression.split('*');
      if (parts.length == 2) {
        final a = double.tryParse(parts[0]);
        final b = double.tryParse(parts[1]);
        if (a != null && b != null) return a * b;
      }
    }
    
    if (expression.contains('/')) {
      final parts = expression.split('/');
      if (parts.length == 2) {
        final a = double.tryParse(parts[0]);
        final b = double.tryParse(parts[1]);
        if (a != null && b != null && b != 0) return a / b;
      }
    }
    
    return null;
  }
}
