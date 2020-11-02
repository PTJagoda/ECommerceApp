import 'package:flutter/material.dart';

import 'package:ecommerce_app/Models/Bags.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Loging_Screen.dart';

class EStoreDemo extends StatefulWidget {
  static const routeName = '/store';
  EStoreDemo() : super();

  final String appTitle = "EStore DB";

  @override
  _EStoreDemoState createState() => _EStoreDemoState();
}

class _EStoreDemoState extends State<EStoreDemo> {
  TextEditingController brandNameController = TextEditingController();
  TextEditingController colourController = TextEditingController();
  TextEditingController materialController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  bool isEditing = false;
  bool textFieldVisibility = false;

  String firestoreCollectionName = "Bags";

  Bags currentBag;

  getAllBags() {
    return Firestore.instance.collection(firestoreCollectionName).snapshots();
  }

  addBag() async {
    Bags bag = Bags(
        brandName: brandNameController.text,
        colour: colourController.text,
        material: materialController.text,
        price: priceController.text);

    try {
      Firestore.instance.runTransaction((Transaction transaction) async {
        await Firestore.instance
            .collection(firestoreCollectionName)
            .document()
            .setData(bag.toJson());
      });
    } catch (e) {
      print(e.toString());
    }
  }

  updateBag(Bags bags, String brandName, String colour, String material,
      String price) {
    try {
      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(bags.documentReference, {
          'brandName': brandName,
          'colour': colour,
          'material': material,
          'price': price
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  updateIfEditing() {
    if (isEditing) {
      updateBag(currentBag, brandNameController.text, colourController.text,
          materialController.text, priceController.text);

      setState(() {
        isEditing = false;
      });
    }
  }

  deleteBag(Bags bags) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await transaction.delete(bags.documentReference);
    });
  }

  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getAllBags(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.hasData) {
          print('Documents -> ${snapshot.data.documents.length}');
          return buildList(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => listItemBuild(context, data)).toList(),
    );
  }

  Widget listItemBuild(BuildContext context, DocumentSnapshot data) {
    final bag = Bags.fromSnapshot(data);

    return Padding(
      key: ValueKey(bag.brandName),
      padding: EdgeInsets.symmetric(vertical: 19, horizontal: 1),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.yellow[200],
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(4),
        ),
        child: SingleChildScrollView(
          child: ListTile(
            title: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.shopping_bag,
                      color: Colors.blue,
                    ),
                    Text(bag.brandName),
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.color_lens,
                      color: Colors.blue,
                    ),
                    Text(bag.colour),
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.crop_square,
                      color: Colors.blue,
                    ),
                    Text(bag.material),
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.money,
                      color: Colors.blue,
                    ),
                    Text(bag.price),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                deleteBag(bag);
              },
            ),
            onTap: () {
              setUpdateUI(bag);
            },
          ),
        ),
      ),
    );
  }

  setUpdateUI(Bags bag) {
    brandNameController.text = bag.brandName;
    colourController.text = bag.colour;
    materialController.text = bag.material;
    priceController.text = bag.price;

    setState(() {
      textFieldVisibility = true;
      isEditing = true;
      currentBag = bag;
    });
  }

  button() {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        color: Colors.blue,
        child: Text(isEditing ? "UPDATE" : "ADD"),
        onPressed: () {
          if (isEditing == true) {
            updateIfEditing();
          } else {
            addBag();
          }

          setState(() {
            textFieldVisibility = false;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(widget.appTitle),
        actions: <Widget>[
          FlatButton(
            child: Row(
              children: <Widget>[Text('LogOut'), Icon(Icons.person)],
            ),
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(Loging_Screen.routeName);
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                textFieldVisibility = !textFieldVisibility;
              });
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.lightGreenAccent,
          Colors.yellow,
        ])),
        padding: EdgeInsets.all(19),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            textFieldVisibility
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          TextFormField(
                            controller: brandNameController,
                            decoration: InputDecoration(
                                labelText: "Brand Name",
                                hintText: "Enter Brand Name"),
                          ),
                          TextFormField(
                            controller: colourController,
                            decoration: InputDecoration(
                                labelText: "Colour", hintText: "Enter Colour"),
                          ),
                          TextFormField(
                            controller: materialController,
                            decoration: InputDecoration(
                                labelText: "Material",
                                hintText: "Enter Material"),
                          ),
                          TextFormField(
                            controller: priceController,
                            decoration: InputDecoration(
                                labelText: "Price", hintText: "Enter Price"),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      button()
                    ],
                  )
                : Container(),
            SizedBox(
              height: 20,
            ),
            Text(
              "BAGS",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            SizedBox(
              height: 20,
            ),
            Flexible(
              child: buildBody(context),
            )
          ],
        ),
      ),
    );
  }
}
