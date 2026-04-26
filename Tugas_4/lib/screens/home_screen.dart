import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  void _submitTodo() {
    context.read<TodoProvider>().addTodo(_controller.text);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'My Tasks',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Input Field Area
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _submitTodo(),
                    decoration: InputDecoration(
                      hintText: 'Tambahkan tugas baru...',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.task_alt,
                        color: Colors.deepPurple,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FloatingActionButton(
                  onPressed: _submitTodo,
                  elevation: 2,
                  child: const Icon(Icons.add_rounded, size: 32),
                ),
              ],
            ),
          ),

          // Bonus Challenge: Filter Tabs
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<FilterState>(
                segments: const [
                  ButtonSegment(value: FilterState.all, label: Text('All')),
                  ButtonSegment(
                    value: FilterState.active,
                    label: Text('Active'),
                  ),
                  ButtonSegment(value: FilterState.done, label: Text('Done')),
                ],
                selected: {provider.filter},
                onSelectionChanged: (Set<FilterState> newSelection) {
                  context.read<TodoProvider>().setFilter(newSelection.first);
                },
                style: SegmentedButton.styleFrom(
                  backgroundColor: Colors.white,
                  selectedForegroundColor: Colors.white,
                  selectedBackgroundColor: Colors.deepPurple,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Todo List
          Expanded(
            child: provider.todos.isEmpty
                ? Center(
                    child: Text(
                      'Belum ada tugas di kategori ini ✨',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: provider.todos.length,
                    itemBuilder: (context, index) {
                      return TodoTile(todo: provider.todos[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
