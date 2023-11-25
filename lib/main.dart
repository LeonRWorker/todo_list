import 'package:flutter/material.dart';
import 'package:todolist/widgets/all_task.dart';

void main() {
  runApp(const ToDoList());
}

class ToDoList extends StatelessWidget {
  const ToDoList({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'TO-DO List',
      debugShowCheckedModeBanner: false,
      home: ToDoListPage(),
    );
  }
}

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({Key? key}) : super(key: key);

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  List<Map<String, dynamic>> originalTasks = [
    {"name": "Trabalho da faculdade", "status": "inprogress"}
  ];
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      tasks = List.from(originalTasks);
    });
  }

  void separateTasks(String status) {
    setState(() {
      tasks = originalTasks.where((task) => task['status'] == status).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: topBarScreen(context),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF4B5A7A),
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          constraints: const BoxConstraints(maxWidth: 500),
          alignment: Alignment.center,
          child: Column(
            children: [
              const SizedBox(height: 10),
              todoNavigation(context),
              const SizedBox(height: 10),
              Expanded(child: ToDoTasksList(tasks: tasks)),
            ],
          ),
        ),
      ),
    );
  }

  Widget topBarScreen(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'TO-DO List',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget todoNavigation(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: const Color(0xFF4B5A7A),
                    ),
                    icon: const Icon(
                      Icons.checklist_outlined,
                      color: Color(0xFFFFFFFF),
                      size: 20.0,
                    ),
                    label: const Text(
                      'A Fazer',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => separateTasks('todo'),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: const Color(0xFF4B5A7A),
                    ),
                    icon: const Icon(
                      Icons.timelapse,
                      color: Color(0xFFFFFFFF),
                      size: 20.0,
                    ),
                    label: const Text(
                      'Em Andamento',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => separateTasks('inprogress'),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: const Color(0xFF4B5A7A),
                    ),
                    icon: const Icon(
                      Icons.check,
                      color: Color(0xFFFFFFFF),
                      size: 20.0,
                    ),
                    label: const Text(
                      'Feito',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => separateTasks('done'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
