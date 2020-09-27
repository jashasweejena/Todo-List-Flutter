import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String todoId;
  String content;
  bool done;

  TodoModel({this.todoId, this.content, this.done});

  TodoModel.fromDocumentSnapshot({DocumentSnapshot snapshot}) {
    todoId = snapshot.id;
    content = snapshot.data()['content'] as String;
    done = snapshot.data()['done'] as bool;
  }
}
