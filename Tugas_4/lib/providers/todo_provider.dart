import 'package:flutter/material.dart';
import '../models/todo.dart';

enum FilterState { all, active, done }

class TodoProvider extends ChangeNotifier {
  final List<Todo> _todos = [];
  FilterState _filter = FilterState.all;

  // Getter yang langsung memfilter data berdasarkan tab yang aktif
  List<Todo> get todos {
    switch (_filter) {
      case FilterState.active:
        return _todos.where((todo) => !todo.isDone).toList();
      case FilterState.done:
        return _todos.where((todo) => todo.isDone).toList();
      case FilterState.all:
      default:
        return _todos;
    }
  }

  FilterState get filter => _filter;

  void setFilter(FilterState filter) {
    _filter = filter;
    notifyListeners();
  }

  void addTodo(String title) {
    if (title.trim().isEmpty) return;

    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch, // Generate ID unik
      title: title,
    );
    _todos.insert(0, newTodo); // Tambah ke urutan teratas
    notifyListeners();
  }

  void toggleDone(int id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].isDone = !_todos[index].isDone;
      notifyListeners();
    }
  }

  void removeTodo(int id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }
}
