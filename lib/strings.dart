import 'model.dart';

String usersTable = 'users';
String userIdColumn = 'id';
String userNameColumn = 'user_name';
String userMailColumn = 'e_mail';
String userPasswordColumn = 'password';
String userFavouritesColumn = 'favourites';
String userOrdersColumn = 'orders';



String productsTable = 'products';
String productIdColumn = 'id';
String productCategoryColumn = 'category';
String productNameColumn = 'name';
String productDescriptionColumn = 'description';
String productImageColumn = 'image';
String productPriceColumn = 'price';


String ordersTable = 'orders';
String orderIdColumn = 'id';
String orderPriceColumn = 'price';
String orderItemsColumn = 'items';
String orderAmountsColumn = 'amounts';
String orderPhoneColumn = 'phone_number';
String orderAddressColumn = 'address';

bool isUserIn = false;
User globalUser = User(
  id: null,
  eMail: '',
  password: '',
  userName: '',
  orders: [],
  favourites: [],
);
Order globalOrder = Order(id: null,
    totalPrice: 0.0,
    itemsIds: [],
    itemsAmounts: [],
    phoneNumber: '',
    address: ''
);