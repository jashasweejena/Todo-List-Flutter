import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notesfreecodecamp/models/database.dart';
import 'package:notesfreecodecamp/models/todo.dart';

class TodoCard extends StatefulWidget {
  final TodoModel todo;
  final FirebaseFirestore firestore;
  final String uid;

  const TodoCard(
      {Key key,
      @required this.todo,
      @required this.firestore,
      @required this.uid})
      : super(key: key);

  @override
  _TodoCardState createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Text(
              widget.todo.content,
              style:
                  const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            Checkbox(
                value: widget.todo.done,
                onChanged: (newValue) {
                  setState(() {});
                  Database(firestore: widget.firestore).updateTodo(
                    uid: widget.uid,
                    todoId: widget.todo.todoId,
                  );
                })
          ],
        ),
      ),
    );
  }
}
