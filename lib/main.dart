import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/cell.dart';
import 'services/python_service.dart';
import 'widgets/toolbar.dart';
import 'widgets/cell_widget.dart';

void main() {
  runApp(const JupyterMobileApp());
}

class JupyterMobileApp extends StatelessWidget {
  const JupyterMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotebookModel()),
        ChangeNotifierProvider(create: (_) => PythonService()),
      ],
      child: MaterialApp(
        title: 'Jupyter Mobile',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.blue[900],
          scaffoldBackgroundColor: const Color(0xFF1e1e1e),
        ),
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          ToolbarWidget(),
          Expanded(child: NotebookView()),
        ],
      ),
    );
  }
}

class NotebookView extends StatelessWidget {
  const NotebookView({super.key});

  @override
  Widget build(BuildContext context) {
    final notebook = Provider.of<NotebookModel>(context);
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notebook.cells.length,
      itemBuilder: (context, index) {
        return CellWidget(
          cell: notebook.cells[index],
          index: index,
          onRun: () => notebook.executeCell(index),
          onDelete: () => notebook.deleteCell(index),
          onUpdate: (code) => notebook.updateCell(index, code),
        );
      },
    );
  }
}
