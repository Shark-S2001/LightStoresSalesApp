import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> initializeDb() async {
  Future<Database> db = openDatabase(
    join(await getDatabasesPath(), "orders.db"),onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE order_items(product_code INTEGER,product_name TEXT,qty DOUBLE,unit_price DOUBLE,product_vat DOUBLE,amount DOUBLE)"
      );
  },version: 1);
      return db;
}

Future<void> insertItemsToDb(productCode,productName,qty,unitPrice,productVat,amount) async {
  Database db = await initializeDb();
  await db.transaction((txn){
    return txn.rawInsert("INSERT INTO order_items(product_code,product_name,qty,unit_price,product_vat,amount)VALUES($productCode,'$productName',$qty,$unitPrice,$productVat,$amount)");
  });
}

Future<List> RetrieveItemsFromDb() async {
  Database db = await initializeDb();
  return db.rawQuery("SELECT product_code,product_name,qty,unit_price,ROUND(product_vat,2)AS product_vat,ROUND(amount,2)AS amount FROM order_items");
}

Future<List> RetrieveTotalsFromDb() async {
  Database db = await initializeDb();
  return db.rawQuery("SELECT ROUND(SUM(amount),2) AS orderTotal FROM order_items");
}