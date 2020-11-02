import "package:cloud_firestore/cloud_firestore.dart";

class Bags {
  String brandName;
  String colour;
  String material;
  String price;

  DocumentReference documentReference;

  Bags({this.brandName, this.colour, this.material, this.price});

  Bags.fromMap(Map<String, dynamic> map, {this.documentReference}) {
    brandName = map["brandName"];
    colour = map["colour"];
    material = map["material"];
    price = map["price"];
  }

  Bags.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, documentReference: snapshot.reference);

  toJson() {
    return {
      'brandName': brandName,
      'colour': colour,
      'material': material,
      'price': price
    };
  }
}
