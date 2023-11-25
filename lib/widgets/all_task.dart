import 'package:flutter/material.dart';

class ToDoTasksList extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;

  const ToDoTasksList({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ToDoTasksListScreen(tasks: tasks);
  }
}

class ToDoTasksListScreen extends StatefulWidget {
  final List<Map<String, dynamic>> tasks;

  const ToDoTasksListScreen({Key? key, required this.tasks}) : super(key: key);

  @override
  State<ToDoTasksListScreen> createState() => _ToDoTasksListScreenState();
}

class _ToDoTasksListScreenState extends State<ToDoTasksListScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.tasks.isEmpty
        ? notFoundTaskMessage(context)
        : ListView.builder(
            itemCount: widget.tasks.length,
            itemBuilder: (BuildContext context, int index) {
              return Task(context, widget.tasks[index]);
            },
          );
  }

  Widget Task(BuildContext context, Map<String, dynamic> task) {
    return ListTile(
      title: Text(task['name']),
      // Outras informações ou ações relacionadas à tarefa podem ser adicionadas aqui
    );
  }

  Widget notFoundTaskMessage(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(30),
        alignment: Alignment.center,
        child: Column(
          children: [
            Image.asset(
              "assets/empty.jpg",
              width: 413,
              height: 457,
            ),
            const Text(
              'Não foram encontradas tarefas para o status informado!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
