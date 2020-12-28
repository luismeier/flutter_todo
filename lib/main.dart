// Import MaterialApp and other widgets which we can use to quickly create a material app
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Code written in Dart starts exectuting from the main function. runApp is part of
// Flutter, and requires the component which will be our app's container. In Flutter,
// every component is known as a "widget".
void main() => runApp(new TodoApp());

// Every component in Flutter is a widget, even the whole app itself
class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Todo List',
      home: new TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  List<String> _todoItems = [];

  // This will be called everytime the add button is pressed
  void _addTodoItem(String task) {
    // Only add the task if string is not empty
    if (task.length > 0) {
      setState(() => _todoItems.add(task));
    }
  }

  /// Removes item from list at index
  void _removeTodoItem(int index) {
    setState(() => _todoItems.removeAt(index));
  }

  /// Show an alert dialog asking the user to confirm
  void _promptRemoveTodoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text('Mark "${_todoItems[index]}" as done?'),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: new Text('Cancel')),
                new FlatButton(
                    onPressed: () {
                      _removeTodoItem(index);
                      Navigator.of(context).pop();
                    },
                    child: new Text('Mark as Done'))
              ]);
        });
  }

  /// Build the list of TodoItems
  Widget _buildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        // itemBuilder will be automatically be called as many times as it takes for the
        // list to fill up its available space, which is most likely more than the
        // number of todo items we have. So, we need to check the index is OK.
        if (index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index], index);
        }
      },
    );
  }

// Build a single todo item
  Widget _buildTodoItem(String todoText, int index) {
    return new ListTile(
        title: new Text(todoText),
        onLongPress: () => _promptRemoveTodoItem(index));
  }

  @override
  Widget build(BuildContext context) {
    return buildScaffold();
  }

  Scaffold buildScaffold() {
    return new Scaffold(
    appBar: new AppBar(title: new Text('Todo List')),
    body: _buildTodoList(),
    floatingActionButton: new FloatingActionButton(
        onPressed: _pushAddTodoScreen,
        tooltip: 'Add Task',
        child: new Icon(Icons.add)),
  );
  }

  void _pushAddTodoScreen() {
    // Push this page onto the nav stack
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
          appBar: new AppBar(
            title: new Text("Add a Task"),
          ),
          body: new TextField(
            autofocus: true,
            onSubmitted: (val) {
              _addTodoItem(val);
              Navigator.pop(context); // Closes the add todo screen
            },
            decoration: new InputDecoration(
                hintText: 'Enter a ToDo...',
                contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }
}
