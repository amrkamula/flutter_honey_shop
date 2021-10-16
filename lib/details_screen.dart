import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_honey/network_handler.dart';
import 'package:flutter_app_honey/strings.dart';

import 'model.dart';

// ignore: must_be_immutable
class DetailsScreen extends StatefulWidget {
  Product product;
  DetailsScreen({Key? key, required this.product}) : super(key: key);
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int _numberOfItems = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.3,
            width: double.infinity,
            color: Colors.amber,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height*0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.4,
                    width: MediaQuery.of(context).size.width*0.6,
                    child: Image.asset(widget.product.imageUrl!,fit: BoxFit.fill,),
                  ),
                ],
              ),
            Expanded(child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20.0),
                      child: Text('${widget.product.name}',style: const TextStyle(color: Colors.black,fontSize: 30.0,fontWeight: FontWeight.bold),),
                    ),

                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text('${widget.product.description}',style: const TextStyle(color: Colors.grey,fontSize: 20.0),),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: GestureDetector(
                            onTap: (){
                              if(_numberOfItems > 1){
                                setState(() {
                                  _numberOfItems--;
                                });
                              }
                            },
                            child: Container(
                              height: 30.0,
                              width: 30.0,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.amber),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: const Icon(Icons.remove,color: Colors.amber,),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('$_numberOfItems',style: const TextStyle(fontSize: 20.0),)
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                _numberOfItems++;
                              });
                            },
                            child: Container(
                              height: 30.0,
                              width: 30.0,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.amber),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: const Icon(Icons.add,color: Colors.amber,),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
                      child: Row(
                        children: [
                          const Text('Total price: ',style: TextStyle(fontSize: 18.0),),
                          Text('${(widget.product.unitPrice!*_numberOfItems).toStringAsFixed(2)} \$',style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.0),),
                        ],
                      ),
                    )
                  ],
                ),
                Expanded(child: Row(
                  children: [
                    Expanded(child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20.0),
                      child: GestureDetector(
                        onTap: (){
                          if(globalUser.userName == ""){
                            SnackBar snackBar = const SnackBar(content: Text('you need to sign in first'),backgroundColor: Colors.amber,);
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }else {
                              setState(() {
                                globalOrder.itemsIds!.add(widget.product.id!);
                                globalOrder.itemsAmounts!.add(_numberOfItems);
                                globalOrder.totalPrice = globalOrder.totalPrice! + widget.product.unitPrice!*_numberOfItems;
                              });
                              SnackBar snackBar = const SnackBar(content: Text('Product added to cart'),backgroundColor: Colors.amber,);
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.amber,width: 3.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 20.0),
                                child: Icon(Icons.add_shopping_cart,color: Colors.amber,),
                              ),
                              Expanded(child: Text('Add to cart',style: TextStyle(color: Colors.amber,fontSize: 18.0),))
                            ],
                          ),
                        ),
                      ),
                    ),),
                   Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GestureDetector(
                        onTap: (){
                          if(globalUser.userName == ""){
                            SnackBar snackBar = const SnackBar(content: Text('you need to sign in first'),backgroundColor: Colors.amber,);
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }else {
                            if(globalUser.favourites!.contains(widget.product.id)){
                              setState(() {
                                globalUser.favourites!.remove(widget.product.id!);
                                NetworkHandler().updateUser(globalUser);
                              });
                            }else{
                            setState(() {
                              globalUser.favourites!.add(widget.product.id!);
                              NetworkHandler().updateUser(globalUser);
                            });
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(Icons.star_border,size: 30.0,color: (globalUser.favourites!.contains(widget.product.id))?Colors.white:Colors.amber,),
                          decoration: BoxDecoration(
                              color: (globalUser.favourites!.contains(widget.product.id))?Colors.amber:Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.amber,
                                  width: 3.0
                              )
                          ),
                        ),
                      ),
                    ),

                  ],
                )),
              ],
            )),
            ],
          )
        ],
      ),
    );
  }
}
