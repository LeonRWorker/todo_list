import 'package:flutter/material.dart';

void main() {
  runApp(const ToDoList());
}

class ToDoList extends StatefulWidget {
  const ToDoList({Key? key}) : super(key: key);

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  List<Map<String, dynamic>> originalTasks = [];
  List<Map<String, dynamic>> tasks = [];
  TextEditingController createController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateTasks();
  }

  void _updateTasks() {
    setState(() {
      tasks = List.from(originalTasks);
      _separateTasks('todo');
    });
  }

  void _reloadList(String status) {
    if (status == 'todo') {
      _separateTasks('todo');
    } else if (status == 'inprogress') {
      _separateTasks('inprogress');
    } else if (status == 'done') {
      _separateTasks('done');
    } else if (status == 'archived') {
      _separateTasks('archived');
    }
  }

  void _updateTaskStatus(int index, String newStatus, String actualStatus) {
    setState(() {
      tasks[index]['status'] = newStatus;
      originalTasks[index]['status'] = newStatus;
    });
    _reloadList(actualStatus);
  }

  void _separateTasks(String status) {
    setState(() {
      tasks = originalTasks.where((task) => task['status'] == status).toList();
    });
  }

  void _createTask(String text) {
    setState(() {
      originalTasks.add(
          {'id': originalTasks.length + 1, 'name': text, 'status': 'todo'});
      tasks.add(
          {'id': originalTasks.length + 1, 'name': text, 'status': 'todo'});
    });
    _updateTasks();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TO-DO List',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TO-DO List'),
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF4B5A7A),
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 50,
              constraints: const BoxConstraints(maxWidth: 500),
              alignment: Alignment.center,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _insertTask(context),
                  const SizedBox(height: 20),
                  _todoNavigation(context),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _buildTasksList(),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF4B5A7A),
          onPressed: () {
            _separateTasks('archived');
          },
          child: const Icon(Icons.archive_outlined),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _insertTask(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 60,
      child: TextField(
        onEditingComplete: () => {_createTask(createController.text)},
        controller: createController,
        style: const TextStyle(
          fontFamily: 'Poppins',
          color: Color(0xFFFFFFFF),
          fontWeight: FontWeight.w400,
        ),
        decoration: const InputDecoration(
            hintText: 'Cadastrar tarefa...',
            hintStyle: TextStyle(color: Color(0xFFFFFFFF)),
            prefixIcon: Icon(
              Icons.search,
              color: Color(0xFFFFFFFF),
            ),
            border: OutlineInputBorder(),
            labelStyle: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 15,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                width: 1,
                color: Color(0xFF4B5A7A),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                width: 1,
                color: Color(0xFF4B5A7A),
              ),
            ),
            filled: true,
            fillColor: Color(0xFF4B5A7A)),
      ),
    );
  }

  Widget _todoNavigation(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 60,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _elevatedButton('A Fazer', Icons.checklist_outlined, 'todo'),
              _elevatedButton('Em Andamento', Icons.timelapse, 'inprogress'),
              _elevatedButton('Feito', Icons.check, 'done'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _elevatedButton(String label, IconData icon, String status) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(20),
        backgroundColor: const Color(0xFF4B5A7A),
      ),
      icon: Icon(icon, color: const Color(0xFFFFFFFF), size: 20.0),
      label: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 15,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: () => _separateTasks(status),
    );
  }

  Widget _buildTasksList() {
    return tasks.isEmpty
        ? _notFoundTaskMessage()
        : ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (BuildContext context, int index) {
              return _task(context, tasks[index], index);
            },
          );
  }

  Widget _task(BuildContext context, Map<String, dynamic> task, int index) {
    return Column(
      children: [
        GestureDetector(
          onDoubleTap: () {
            String newStatus;
            String actualStatus = task['status'];
            if (task['status'] == 'todo') {
              newStatus = 'inprogress';
            } else if (task['status'] == 'inprogress') {
              newStatus = 'done';
            } else if (task['status'] == 'done') {
              newStatus = 'archived';
            } else {
              newStatus = 'done';
            }
            _updateTaskStatus(index, newStatus, actualStatus);
          },
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              child: Dismissible(
                key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
                background: _dismissibleBackground(context, task),
                direction: DismissDirection.startToEnd,
                child: Container(
                  width: MediaQuery.of(context).size.width * 1 - 60,
                  padding: const EdgeInsets.all(15),
                  color: const Color(0xFF4B5A7A),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        task['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                onDismissed: (direction) {
                  if (task['status'] == 'todo') {
                    tasks.removeWhere(
                        (selectedTask) => selectedTask['id'] == task['id']);
                    originalTasks.removeWhere(
                        (selectedTask) => selectedTask['id'] == task['id']);
                    _reloadList('todo');
                  } else if (task['status'] == 'inprogress') {
                    _updateTaskStatus(index, 'todo', 'inprogress');
                  } else if (task['status'] == 'done') {
                    _updateTaskStatus(index, 'inprogress', 'done');
                  } else if (task['status'] == 'archived') {
                    tasks.removeWhere(
                        (selectedTask) => selectedTask['id'] == task['id']);
                    originalTasks.removeWhere(
                        (selectedTask) => selectedTask['id'] == task['id']);
                    _reloadList('archived');
                  }
                },
              )),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _notFoundTaskMessage() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/empty.jpg",
              width: MediaQuery.of(context).size.width * 0.8,
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

  Widget _dismissibleBackground(
      BuildContext context, Map<String, dynamic> task) {
    return Container(
      color: Color(
        task['status'] == 'inprogress'
            ? 0xFFEE9A00
            : task['status'] == 'done'
                ? 0xFFF2CB6C
                : 0xFFE04343,
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            task['status'] == 'inprogress'
                ? const Row(
                    children: [
                      Icon(
                        Icons.assignment_turned_in,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Por em: "A Fazer"',
                        style: TextStyle(
                          color: Color(0xFFF7F7F7),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  )
                : task['status'] == 'done'
                    ? const Row(
                        children: [
                          Icon(
                            Icons.timelapse,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Por em: "Em Andamento"',
                            style: TextStyle(
                              color: Color(0xFFF7F7F7),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )
                    : const Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Remover',
                            style: TextStyle(
                              color: Color(0xFFF7F7F7),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
          ],
        ),
      ),
    );
  }
}
