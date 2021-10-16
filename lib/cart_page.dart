import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_honey/network_handler.dart';
import 'package:flutter_app_honey/strings.dart';

import 'model.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<int>? items = globalOrder.itemsIds;
  List<int>? amounts = globalOrder.itemsAmounts;
  GlobalKey<FormState>? _key;
  TextEditingController? _phoneNumberController;
  TextEditingController? _addressController;

  @override
  void dispose() {
    _phoneNumberController!.dispose();
    _addressController!.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    _phoneNumberController = TextEditingController();
    _addressController = TextEditingController();
    _key = GlobalKey<FormState>();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Text('Cart')
      ),
      backgroundColor: Colors.grey[300],
      body:(globalOrder.itemsIds!.isEmpty)? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.remove_shopping_cart_outlined,color:Colors.amber,size: MediaQuery.of(context).size.width*0.2,),
            const SizedBox(height: 20.0,),
            const Text('You have no items in cart',style: TextStyle(
              color: Colors.amber,
              fontSize: 20.0,
            ),)
          ],
        ),
      ):FutureBuilder<List<Product>>(
          future: _setUpItems(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              List<Product>? favItems = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: favItems!.length,
                          itemBuilder: (context, index) {
                            Product product = favItems[index];
                            return Card(
                              child: ListTile(
                                leading: SizedBox(
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.1,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.1,
                                  child: Image.asset(
                                    product.imageUrl!, fit: BoxFit.fill,),
                                ),
                                title: Text('${product.name}',style: const TextStyle(fontSize: 20.0),),
                                subtitle: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('number of units : ',style: TextStyle(fontSize: 16.0),),
                                    Text('${amounts![index]}',style: TextStyle(color: Colors.grey[500],fontWeight: FontWeight.bold,fontSize: 18.0),)
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle, color: Colors.amber,),
                                  onPressed: () {
                                    int index = globalOrder.itemsIds!.indexOf(product.id!);
                                    setState(() {
                                      globalOrder.itemsAmounts!.removeAt(index);
                                      globalOrder.itemsIds!.remove(product.id!);
                                    });
                                  },
                                ),
                              ),
                            );
                          }),
                    ),
                    Container(
                      height: 3.0,
                      width: double.infinity,
                      color: Colors.amber,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: (){
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Fill in the fields to confirm order',style:TextStyle(color: Colors.amber),),
                                    content: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 12.0),
                                        child: Form(
                                          key: _key,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0, top: 20.0,left: 8.0,bottom: 8.0),
                                                child: TextFormField(
                                                  controller: _phoneNumberController,
                                                  keyboardType: TextInputType.number,
                                                  validator: (val) {
                                                    if (val!.isEmpty) {
                                                      return 'This field can not be empty';
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Colors.amber),
                                                      borderRadius:
                                                      BorderRadius.circular(25.7),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(20.0),
                                                    ),
                                                    hintText: 'phone number',
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0, left: 8.0, bottom: 8.0),
                                                child: TextFormField(
                                                  controller: _addressController,
                                                  keyboardType:
                                                  TextInputType.streetAddress,
                                                  validator: (val) {
                                                    if (val!.isEmpty) {
                                                      return 'This field can not be empty';
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                      focusedBorder:
                                                      OutlineInputBorder(
                                                        borderSide: const BorderSide(
                                                            color: Colors.amber),
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            25.7),
                                                      ),
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                      ),
                                                      hintText: 'address',
                                                      focusColor: Colors.amber),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Submit',style: TextStyle(color: Colors.amber),),
                                        onPressed: () async {
                                          if(_key!.currentState!.validate()){
                                            globalOrder.phoneNumber = _phoneNumberController!.text;
                                            globalOrder.address = _addressController!.text;
                                            int id = await NetworkHandler().addOrder(globalOrder);
                                            setState(() {
                                              globalUser.orders!.add(id);
                                              globalOrder = Order(id: null,
                                                  totalPrice: 0.0,
                                                  itemsIds: [],
                                                  itemsAmounts: [],
                                                  phoneNumber: '',
                                                  address: ''
                                              );
                                            });
                                            await NetworkHandler().updateUser(globalUser);
                                            SnackBar snackBar = const SnackBar(content:Text('Order submitted successfully'),backgroundColor: Colors.amber,);
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('cancel',style: TextStyle(color: Colors.grey),),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Card(
                              elevation: 10.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 12.0),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: const Center(child: Text('Submit order',style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),)),
                              ),
                            ),
                          ),
                        ),),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              const Text('Total price: ',style: TextStyle(fontSize: 14.0),),
                              Text('${globalOrder.totalPrice!.toStringAsFixed(2)} \$',style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18.0),),
                            ],
                          ),
                        )
                      ],
                    ),

                  ],
                ),
              );
            }
            else{
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                  strokeWidth: 3.0,
                ),
              );
            }
          }
      ),
    );
  }

  Future<List<Product>> _setUpItems() async {
    if (items!.isNotEmpty) {
      List<Product>? favItems = [] ;
      for (int e in items!) {
        Product item = await NetworkHandler().fetchProduct(e);
        favItems.add(item);
      }
      return favItems;
    }
    return [];
  }



}
