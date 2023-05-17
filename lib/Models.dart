


import 'package:cloud_firestore/cloud_firestore.dart';




class Model {
  final String message;
  String id;
  Model(this.message , this.id);

  factory Model.fromJson(jsonData) {
    return Model(jsonData['message'] , jsonData['id']);
  }
}



// class Model {
//   final String message;
//
//   Model(this.message);
//
//   factory Model.fromJson(DocumentSnapshot<Object?> doc) {
//     final data = doc.data() as Map<String, dynamic>?;
//     final message = data?['message'] as String? ?? '';
//     return Model(message);
//   }
// }



