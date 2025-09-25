import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; // arquivo gerado pelo FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  } catch (e) {
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Erro ao inicializar Firebase: $e'),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Lista de Tarefas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _taskController = TextEditingController();
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      tasks.add({
        'title': _taskController.text,
        'status': 'pendente', // status inicial
        'created_at': FieldValue.serverTimestamp(),
      });
      _taskController.clear();
    }
  }

  void _deleteTask(String id) {
    tasks.doc(id).delete();
  }

  void _toggleStatus(String id, String currentStatus) {
    String newStatus;
    if (currentStatus == 'pendente') {
      newStatus = 'em desenvolvimento';
    } else if (currentStatus == 'em desenvolvimento') {
      newStatus = 'concluída';
    } else {
      newStatus = 'pendente';
    }

    tasks.doc(id).update({'status': newStatus});
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pendente':
        return Colors.red;
      case 'em desenvolvimento':
        return Colors.orange;
      case 'concluída':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      labelText: 'Nova tarefa',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addTask,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: tasks.orderBy('created_at', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final taskDocs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: taskDocs.length,
                  itemBuilder: (context, index) {
                    final doc = taskDocs[index];
                    final title = doc['title'];
                    final status = doc['status'];

                    return ListTile(
                      title: Text(title),
                      subtitle: Text(
                        status,
                        style: TextStyle(color: _statusColor(status)),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.autorenew),
                            tooltip: 'Mudar status',
                            onPressed: () => _toggleStatus(doc.id, status),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            tooltip: 'Excluir tarefa',
                            onPressed: () => _deleteTask(doc.id),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
