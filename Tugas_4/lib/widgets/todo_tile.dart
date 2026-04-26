import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;

  const TodoTile({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Transform.scale(
          scale: 1.2,
          child: Checkbox(
            value: todo.isDone,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            onChanged: (_) => context.read<TodoProvider>().toggleDone(todo.id),
          ),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: todo.isDone ? FontWeight.normal : FontWeight.w500,
            color: todo.isDone ? Colors.grey : Colors.black87,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: Colors.redAccent,
          ),
          onPressed: () => context.read<TodoProvider>().removeTodo(todo.id),
        ),
      ),
    );
  }
}
