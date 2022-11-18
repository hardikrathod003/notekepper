import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../helper/firestore_helper.dart';
import '../helper/firestore_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextStyle mystyle = TextStyle(color: Colors.white);
  final GlobalKey<FormState> insertkey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  String? title;
  String? note;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Note Kepper"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: validatorandinsert,
        label: Text("Create A Note"),
        icon: Icon(Icons.note_add),
      ),
      body: StreamBuilder(
        stream: CloudFirestoreHelper.cloudFirestoreHelper.selectrecord(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
          if (snapShot.hasError) {
            return Center(
              child: Text("ERROR : ${snapShot.error}"),
            );
          } else if (snapShot.hasData) {
            QuerySnapshot? data = snapShot.data;
            List<QueryDocumentSnapshot> documents = data!.docs;

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, i) {
                return Card(
                  elevation: 5,
                  shadowColor: Colors.orange,
                  child: ListTile(
                      isThreeLine: true,
                      leading: Text("${i + 1}"),
                      title: Text("${documents[i]['title']}"),
                      subtitle: Text("${documents[i]['note']}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Update Records"),
                                  content: Form(
                                    key: updateKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          validator: (val) {
                                            (val!.isEmpty)
                                                ? "Enter title First..."
                                                : null;
                                          },
                                          onSaved: (val) {
                                            title = val;
                                          },
                                          controller: titleController,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: "Enter title Here....",
                                              labelText: "title"),
                                        ),
                                        const SizedBox(height: 10),
                                        TextFormField(
                                          maxLines: 5,
                                          validator: (val) {
                                            (val!.isEmpty)
                                                ? "Enter note First..."
                                                : null;
                                          },
                                          onSaved: (val) {
                                            note = val;
                                          },
                                          controller: noteController,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: "Enter note Here....",
                                              labelText: "note"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      child: const Text("Update"),
                                      onPressed: () {
                                        if (updateKey.currentState!
                                            .validate()) {
                                          updateKey.currentState!.save();

                                          Map<String, dynamic> data = {
                                            'title': title,
                                            'note': note,
                                          };
                                          CloudFirestoreHelper
                                              .cloudFirestoreHelper
                                              .updateRecords(
                                                  id: documents[i].id,
                                                  data: data);
                                        }
                                        titleController.clear();

                                        noteController.clear();

                                        title = "";
                                        note = "";
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    OutlinedButton(
                                      child: const Text("Cancel"),
                                      onPressed: () {
                                        titleController.clear();
                                        noteController.clear();

                                        title = null;

                                        note = null;

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              await CloudFirestoreHelper.cloudFirestoreHelper
                                  .deleterecord(id: "${documents[i].id}");
                            },
                          ),
                        ],
                      )),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  validatorandinsert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text("Enter note details here"),
        ),
        content: Form(
          key: insertkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                validator: (val) {
                  (val!.isEmpty) ? "Enter title" : null;
                },
                controller: titleController,
                onSaved: (val) {
                  title = val;
                },
                decoration: const InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "title",
                  hintText: "Enter title Here...",
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                validator: (val) {
                  (val!.isEmpty) ? "Enter note" : null;
                },
                controller: noteController,
                onSaved: (val) {
                  note = val;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "note",
                  hintText: "Enter note Here...",
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            child: const Text("Submit"),
            onPressed: () async {
              if (insertkey.currentState!.validate()) {
                insertkey.currentState!.save();

                Map<String, dynamic> data = {
                  'title': title,
                  'note': note,
                };

                await CloudFirestoreHelper.cloudFirestoreHelper
                    .insertrecord(data: data);

                Navigator.of(context).pop();
                titleController.clear();
                noteController.clear();
                setState(() {
                  title = null;
                  note = null;
                });
              }
            },
          ),
          ElevatedButton(
              onPressed: () {
                titleController.clear();
                noteController.clear();
                setState(() {
                  title = null;
                  note = null;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Cancel")),
        ],
      ),
    );
  }
}
