import 'package:cloud_firestore/cloud_firestore.dart';

class InternshipService {
  final FirebaseFirestore _firestore= FirebaseFirestore.instance;

  Future<Map<String,dynamic>?> getdetails(String name)async{
     try{
        final snapshot= await _firestore.collection('Oppurtunities').where('name',isEqualTo: name).limit(1).get();
        if(snapshot.docs.isNotEmpty){
          return snapshot.docs.first.data();
        }
       
        else{
          throw Exception("Event Not Found");
        }
        
     }catch(e){
        throw Exception(e.toString());
     }
  }
}