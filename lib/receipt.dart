import 'package:flutter/material.dart';
import 'package:flutter_app_honey/network_handler.dart';

import 'model.dart';

class Receipt extends StatefulWidget {
  final Order? order;
  const Receipt({Key? key,required this.order}) : super(key: key);

  @override
  _ReceiptState createState() => _ReceiptState();
}




class _ReceiptState extends State<Receipt> {
  Future<List<Product>> _items() async {
    List<Product> items = [];
    for(int e in widget.order!.itemsIds!){
      Product item = await NetworkHandler().fetchProduct(e);
      items.add(item);
    }
    return items;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 50.0),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 50.0),
            elevation: 10.0,
            shadowColor: Colors.amber,
            child: FutureBuilder<List<Product>>(
              future: _items(),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  List<Product> products = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (context,index){
                              Product item = products[index];
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${item.name}   x${widget.order!.itemsAmounts![index]}'),
                                  Text((widget.order!.itemsAmounts![index]*item.unitPrice!).toStringAsFixed(2)),
                                ],
                              );
                            },
                          ),
                        ),
                        Container(
                          color: Colors.black,
                          height: 2.0,
                          width: double.infinity,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total price:'),
                              Text('${widget.order!.totalPrice}'),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }else{
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
