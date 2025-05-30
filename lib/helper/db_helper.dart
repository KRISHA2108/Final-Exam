import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart';
import '../model/product_model.dart';
import 'package:path/path.dart';

class SQLHelper {
  static String _databaseName = "auctionDB.db";
  static int _databaseVersion = 1;
  static String table = 'products';
  static String columnId = 'id';
  static String columnName = 'name';
  static String columnCategory = 'category';
  static String columnPrice = 'price';

  SQLHelper._();
  static final SQLHelper instance = SQLHelper._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnCategory TEXT NOT NULL,
        $columnPrice REAL NOT NULL
      )
    ''');
  }

  // CRUD Operations
  // 1. Create (Insert)
  Future<int> insertProduct(Product product) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {
      columnId: product.id,
      columnName: product.name,
      columnCategory: product.category,
      columnPrice: product.price
    };
    return await db.insert(table, row);
  }

  // 2. Read (Fetch All)
  Future<List<Map<String, dynamic>>> fetchAllProducts() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // 3. Read (Fetch by ID)
  Future<Map<String, dynamic>?> fetchProductById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  // 4. Update
  Future<int> updateProduct(int id, Product product) async {
    Database db = await instance.database;
    String sql =
        "UPDATE $table SET $columnName = ?, $columnCategory = ?, $columnPrice = ? WHERE $columnId = ?";
    List args = [product.name, product.category, product.price, id];
    return await db.rawUpdate(sql, args);
  }

  Future<List<Product>> fetchData() async {
    Database db = await instance.database;
    String query = "SELECT * FROM $table";
    var allData = await db.rawQuery(query);
    return allData.map((e) => Product.fromMap(e)).toList();
  }

  Future<int?> deleteData(int iD) async {
    Database db = await instance.database;
    String query = "DELETE FROM $table WHERE $columnId = $iD";
    return await db.rawDelete(query);
  }
}
