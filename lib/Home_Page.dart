import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_interview_assignment/Widgets/loading.dart';
import 'package:flutter_interview_assignment/Widgets/navigator.dart';
import 'package:flutter_interview_assignment/login.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ////////////////////////////////////////

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  String weight = '';

  ////////////////////////////////////////
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addWeigth(
            context,
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(
          'Flutter Interview',
          style: TextStyle(color: Colors.black87),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                showLoading(context);
                auth
                    .signOut()
                    .then((value) => navigatorRemove(context, LoginPage()));
              },
              icon: Icon(
                Icons.logout,
                color: Colors.black87,
              ))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(user!.uid)
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (snapshot.data.docs.length == 0)
            return Center(
              child: Text('No Data Yet'),
            );
          return ListView.separated(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return weightTile(snapshot.data.docs[index], index);
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          );
        },
      ),
    );
  }

  weightTile(DocumentSnapshot snapshot, int index) {
    return Card(
      child: ExpansionTile(
        leading: Text('${index + 1} )'),
        title: Text('Weigth:  ${snapshot['weight']} KG'),
        subtitle: Row(
          children: [Spacer(), Text('${snapshot['time'].toString()}')],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [delete(snapshot), update(snapshot)],
            ),
          )
        ],
      ),
    );
  }

  //////////////// Delete Button //////////////////

  delete(DocumentSnapshot snapshot) {
    return SizedBox(
      width: 140,
      // ignore: deprecated_member_use
      child: RaisedButton.icon(
        color: Colors.red,
        onPressed: () {
          showLoading(context);
          firestore
              .collection(user!.uid)
              .doc(snapshot.id)
              .delete()
              .then((value) => Navigator.pop(context));
        },
        icon: Icon(
          Icons.delete,
          color: Colors.grey[200],
        ),
        label: Text("Delete", style: TextStyle(color: Colors.grey[200])),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  //////////////// Update Button //////////////////

  update(DocumentSnapshot snapshot) {
    return SizedBox(
      width: 140,
      // ignore: deprecated_member_use
      child: RaisedButton.icon(
        color: Colors.blue,
        onPressed: () {
          updateWeigth(context, snapshot);
        },
        icon: Icon(
          Icons.update,
          color: Colors.grey[200],
        ),
        label: Text("Update", style: TextStyle(color: Colors.grey[200])),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  //////////////// Add Weight Dialog //////////////////

  addWeigth(BuildContext context) async {
    return await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            elevation: 10,
            children: [
              CupertinoFormSection(
                  header: Text(
                    "Weight",
                    style: TextStyle(fontSize: 18),
                  ),
                  children: [
                    CupertinoFormRow(
                      child: CupertinoTextFormFieldRow(
                        keyboardType: TextInputType.number,
                        placeholder: "Enter weight",
                        onFieldSubmitted: (value) {
                          weight = value;
                        },
                        onChanged: (value) {
                          weight = value;
                        },
                        onSaved: (value) {
                          weight = value.toString();
                        },
                      ),
                    ),
                  ]),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        if (weight != '') {
                          addNew(value: weight);
                        }
                      },
                      child: Text('ADD'))
                ],
              )
            ],
          );
        });
  }

  //////////////// Add Weight Fucntion //////////////////

  addNew({required String value}) {
    Navigator.pop(context);
    firestore.collection(user!.uid).add({
      'weight': weight,
      'time': DateFormat("dd-MM-yyyy h:mm:ss a").format(DateTime.now())
    }).then((value) {
      weight = '';
    });
  }

  //////////////// Update Weight Dialog //////////////////

  updateWeigth(BuildContext context, DocumentSnapshot snapshot) async {
    return await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            elevation: 10,
            children: [
              CupertinoFormSection(
                  header: Text(
                    "Weight",
                    style: TextStyle(fontSize: 18),
                  ),
                  children: [
                    CupertinoFormRow(
                      child: CupertinoTextFormFieldRow(
                        initialValue: snapshot['weight'],
                        keyboardType: TextInputType.number,
                        placeholder: "Enter weight",
                        onFieldSubmitted: (value) {
                          weight = value;
                        },
                        onChanged: (value) {
                          weight = value;
                        },
                        onSaved: (value) {
                          weight = value.toString();
                        },
                      ),
                    ),
                  ]),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        updateOld(snapshot);
                      },
                      child: Text('Update'))
                ],
              )
            ],
          );
        });
  }

//////////////// Update Weight Function //////////////////
  ///
  updateOld(DocumentSnapshot snapshot) {
    Navigator.pop(context);
    showLoading(context);
    firestore
        .collection(user!.uid)
        .doc(snapshot.id)
        .update({'weight': weight}).then((value) {
      Navigator.pop(context);
      weight = '';
    });
  }
}
