import 'dart:math';

import 'strings.dart';


class User{
  String? userName,eMail,password;
  int? id;
  List<int>? favourites,orders;
  User({
    required this.id,
    required this.userName,
    required this.eMail,
    required this.password,
    required this.favourites,
    required this.orders
});

  User.fromDb(Map<String,dynamic> map){
    id = map[userIdColumn];
    userName = map[userNameColumn];
    password = map[userPasswordColumn];
    eMail = map[userMailColumn];
    favourites = convertToList(map[userFavouritesColumn]);
    orders = convertToList(map[userOrdersColumn]);
  }

  Map<String,dynamic> toJson(){
    return {
      userIdColumn:id,
      userMailColumn:eMail,
      userPasswordColumn:password,
      userNameColumn:userName,
      userFavouritesColumn:favourites.toString(),
      userOrdersColumn:orders.toString()
    };
  }
}

class Product{
  int? id,category;
  String? name,description,imageUrl;
  double? unitPrice;

  Product({
    required this.id,
    required this.category,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.unitPrice,
  });

  Product.random(){
    id = null;
    category = Random().nextInt(3);
    name = 'Bee Honey ${Random().nextInt(7)}';
    description = 'No honey is more sweet';
    imageUrl = 'images/item${Random().nextInt(12)}.png';
    unitPrice = (Random().nextInt(6)+1)*30.0;
  }

  Product.fromDb(Map<String,dynamic> map){
    id = map[productIdColumn];
    category = map[productCategoryColumn];
    name = map[productNameColumn];
    description = map[productDescriptionColumn];
    imageUrl = map[productImageColumn];
    unitPrice = double.parse(map[productPriceColumn]);
  }

  Map<String,dynamic> toJson(){
    return {
      productIdColumn: id,
      productCategoryColumn: category,
      productNameColumn: name,
      productDescriptionColumn: description,
      productImageColumn: imageUrl,
      productPriceColumn: unitPrice.toString(),

    };
  }


}

class Order{
  int? id;
  double? totalPrice;
  List<int>? itemsIds;
  List<int>? itemsAmounts;
  String? phoneNumber;
  String? address;

  Order({
    required this.id,
    required this.totalPrice,
    required this.itemsIds,
    required this.itemsAmounts,
    required this.phoneNumber,
    required this.address
});

  Order.fromDb(Map<String,dynamic> map){
    id = map[orderIdColumn];
    totalPrice = double.parse(map[orderPriceColumn]);
    itemsIds = convertToList(map[orderItemsColumn]);
    itemsAmounts = convertToList(map[orderAmountsColumn]);
    phoneNumber = map[orderPhoneColumn];
    address = map[orderAddressColumn];
  }

  Map<String,dynamic> toJson(){
    return {
      orderIdColumn:id,
      orderPriceColumn:totalPrice.toString(),
      orderItemsColumn:itemsIds.toString(),
      orderAmountsColumn:itemsAmounts.toString(),
      orderPhoneColumn: phoneNumber,
      orderAddressColumn:address,
    };
  }

}

List<int> convertToList(String stringList){
  if(stringList.length == 2){
    return [];
  }
  String withoutBraces = stringList.substring(1).substring(0,stringList.length-2);
  List<String> withoutComma = withoutBraces.split(',');
  return withoutComma.map((e)=>int.parse(e)).toList();
}