import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String contactTable = "contactTable";
const String idColumn = "idColumn";     //cria uma variavel para o mapa
const String nameColumn = "nameColumn";     //cria uma variavel para o mapa
const String emailColumn = "emailColumn";     //cria uma variavel para o mapa
const String phoneColumn = "phoneColumn";     //cria uma variavel para o mapa
const String imgColumn = "imgColumn";     //cria uma variavel para o mapa

class ContactHelper {     //cria uma classe

  static final ContactHelper _instance = ContactHelper.internal();     //cria um objeto e chama um construtor interno

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database? _db;     //cria um banco de dados

  Future get db async {
    if(_db != null) {     //inicializa o banco de dados
      return _db;
    } else {
      _db = await initDb();      //obriga a inicializacão do banco de dados
      return _db;
    }
  }

  Future<Database> initDb() async {     //função initDB
    final databasesPath = await getDatabasesPath();     //pega o local que esta o banco de dados
    final path = join(databasesPath, "contactsnew.db");     //pega o arquivo do banco de dados

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {     //abri o banco de dados
      await db.execute(     //codigo nao pode ser modificado
        "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT,"
      "$phoneColumn TEXT, $imgColumn TEXT)"
      );
    });
  }

  Future<Contact> saveContact(Contact contact) async{     //salva as informações no banco de dados
    Database dbContact = await db;     //obtem o banco de dados
    contact.id = await dbContact.insert(contactTable, contact.toMap());     //insere os daos no id
    return contact;
  }

  Future<Contact?> getContact (int id) async {     //obtem os dados
    Database dbContact = await db;     //obtem o banco de dados
    List<Map> maps = await dbContact.query(contactTable,
      columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
      where: "$idColumn = ?",
    whereArgs: [id]);
    if(maps.length > 0) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {     //função para deletar
    Database dbContact = await db;
    return await dbContact.delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {     //função para salvar um contato
    Database dbContact = await db;
    return await dbContact.update(contactTable, contact.toMap(), where: "$idColumn = ?", whereArgs: [contact.id]);
  }

  Future<List> getAllContacts() async {     //função para obter os contatos
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $contactTable");     //seleciona todos os elementos da tabela
    List<Contact> listContact = [];
    for(Map m in listMap) {
      listContact.add(Contact.fromMap(m));     //transforma cada mapa em uma lista e adiciona na lista de contatos
    }
    return listContact;
  }

  Future<int?> getNumber() async {     //função para obter o numero de contatos
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) $contactTable"));     //obtem a contagem e retorn a quantidade de elementos na tabela
  }

  Future close() async {     //função para fechar o banco de dados
    Database dbContact = await db;
    dbContact.close();
  }

}

class Contact {

  int? id;
  String? name;
  String? email;
  String? phone;
  String? img;

  Contact();

  Contact.fromMap(Map map) {     //construtor de mapa para o contato
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  Map toMap() {     //função que faz o mapa receber o contato
    var map = <String, dynamic>{
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