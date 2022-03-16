import 'package:sqflite/sqflite.dart';

const String idColumn = "idColumn";     //cria uma variavel para o mapa
const String nameColumn = "nameColumn";     //cria uma variavel para o mapa
const String emailColumn = "emailColumn";     //cria uma variavel para o mapa
const String phoneColumn = "phoneColumn";     //cria uma variavel para o mapa
const String imgColumn = "imgColumn";     //cria uma variavel para o mapa

class ContactHelper {

}

class Contact {

  int? id;
  String? name;
  String? email;
  String? phone;
  String? img;

  Contact.fromMap(Map map) {     //construtor de mapa para o contato
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  Map toMap() {     //função que faz o mapa receber o contato
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img,
    };
    if(id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {     //printa as informaçoes do contato
    return"Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }
  
}