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

  Database _db;     //cria um banco de dados

  Future<Database> get db async {
    if(_db != null) {     //inicializa o banco de dados
      return _db;
    } else {
      _db = await initDb();      //obriga a inicializacão do banco de dados
      return _db;
    }
  }

  Future<Database> initDb() async {     //função initDB
    final databasesPath = await getDatabasesPath();     //pega o local que esta o banco de dados
    final path = join(databasesPath, "contacts.db");     //pega o arquivo do banco de dados

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {     //abri o banco de dados
      await db.execute(     //codigo nao pode ser modificado
        "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT"
      "$phoneColumn TEXT, $imgColumn TEXT)"
      );
    });
  }

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