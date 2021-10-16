import 'dart:async';
import 'dart:io';
import 'package:flutter_app_honey/strings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'model.dart';

class NetworkHandler{
  NetworkHandler._();

  static final NetworkHandler _instance = NetworkHandler._();

  factory NetworkHandler(){
    return _instance;
  }

  Database? _database;

  Future<Database> get db async {
    if(_database != null){
      return _database!;
    }

    return _init();
  }

  Future<Database> _init() async {
    Directory directory =  await getApplicationDocumentsDirectory();
    String path = join(directory.path,'database.db');
    return openDatabase(path,version: 2,onCreate: _onCreate);
  }



   _onCreate(Database db, int version) async {
    await db.execute(''
        'CREATE TABLE $usersTable('
        '$userIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$userMailColumn TEXT,'
        '$userPasswordColumn TEXT,'
        '$userNameColumn TEXT,'
        '$userFavouritesColumn TEXT,'
        '$userOrdersColumn TEXT'
        ')');
    await db.execute(''
        'CREATE TABLE $productsTable('
        '$productIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$productCategoryColumn INTEGER,'
        '$productNameColumn TEXT,'
        '$productDescriptionColumn TEXT,'
        '$productImageColumn TEXT,'
        '$productPriceColumn TEXT'
        ')');
    await db.execute(''
        'CREATE TABLE $ordersTable('
        '$orderIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$orderPriceColumn TEXT,'
        '$orderItemsColumn TEXT,'
        '$orderAmountsColumn TEXT,'
        '$orderPhoneColumn TEXT,'
        '$orderAddressColumn TEXT'
        ')');
  }

  //for users: add,fetch one,update,delete
  Future addUser(User user) async {
    var _db = await db;
    await _db.insert(usersTable, user.toJson(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User> fetchOneUser(String userName) async {
    var _db = await db;
    List res = await _db.query(usersTable,where: '$userNameColumn = ?',whereArgs: [userName]);
    if(res.isEmpty){
      return User(
        id: null,
        eMail: '',
        password: '',
        userName: '',
        orders: [],
        favourites: [],
      );
    }
    return User.fromDb(res.first);
  }

  Future updateUser(User newUser) async {
    var _db = await db;
     await _db.update(usersTable, newUser.toJson(),where: '$userIdColumn = ?',whereArgs: [newUser.id],conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future deleteUser(int id) async {
    var _db = await db;
    await _db.delete(usersTable,where: '$userIdColumn = ?',whereArgs: [id]);
  }

  //for items: add,fetch all
  Future addItem(Product product) async {
    var _db = await db;
    await _db.insert(productsTable, product.toJson(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Product> fetchProduct(int id) async {
    var _db = await db;
    List res = await _db.query(productsTable,where: '$productIdColumn = ?',whereArgs: [id]);
    return Product.fromDb(res.first);
  }

  Future<List> fetchAllProducts(int category) async {
    var _db = await db;
    List res = await _db.query(productsTable,where: '$productCategoryColumn = ?',whereArgs: [category]);
    return res ;
  }



  // for orders: add,fetch all,update,delete

  Future<int> addOrder(Order order) async {
    var _db = await db;
    return await _db.insert(ordersTable, order.toJson(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Order>> fetchAllOrders() async {
    var _db = await db;
    List res = await _db.query(ordersTable);
    return res.map((e) => Order.fromDb(e)).toList();
  }

  Future<Order> fetchOrder(int id) async {
    var _db = await db;
    var res = await _db.query(ordersTable,where: '$orderIdColumn = ?',whereArgs: [id],);
    return Order.fromDb(res.first);
  }

  Future deleteOrder(int id) async {
    var _db = await db;
    await _db.delete(ordersTable,where: '$orderIdColumn = ?',whereArgs: [id]);
  }

  Future closeDatabase() async {
    var _db = await db;
    await _db.close();
  }

}