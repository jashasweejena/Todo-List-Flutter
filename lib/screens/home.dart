import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notesfreecodecamp/models/database.dart';
import 'package:notesfreecodecamp/services/auth.dart';
import 'package:notesfreecodecamp/widgets/todo_card.dart';

class Home extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const Home({Key key, @required this.auth, @required this.firestore})
      : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _todoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => Auth(auth: widget.auth).signOut(),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          const Text(
            'Add Todo Here:',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          Card(
            margin: const EdgeInsets.all(20.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _todoController,
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (_todoController.text != null) {
                          setState(() {
                            Database(firestore: widget.firestore).addTodo(
                                uid: widget.auth.currentUser.uid,
                                content: _todoController.text);
                            _todoController.clear();
                          });
                        }
                      })
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          const Text(
            'Your Todos',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: StreamBuilder(
              stream: Database(firestore: widget.firestore)
                  .streamTodos(uid: widget.auth.currentUser.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data.isEmpty) {
                    return const Center(
                      child: const Text("You don't have any unfinished Todos"),
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (_, index) {
                      return TodoCard(
                          todo: snapshot.data[index],
                          firestore: widget.firestore,
                          uid: widget.auth.currentUser.uid);
                    },
                    itemCount: snapshot.data.length,
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
