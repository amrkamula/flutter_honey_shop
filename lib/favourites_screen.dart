import 'package:flutter/material.dart';
import 'package:flutter_app_honey/network_handler.dart';
import 'package:flutter_app_honey/strings.dart';

import 'details_screen.dart';
import 'model.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({Key? key}) : super(key: key);

  @override
  _FavScreenState createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  List? fav;

  @override
  void initState() {
    fav = globalUser.favourites;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Favourites')
      ),
      backgroundColor: Colors.grey[300],
      body:(fav!.isEmpty)?  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article,color:Colors.amber,size: MediaQuery.of(context).size.width*0.2,),
            const SizedBox(height: 20.0,),
            const Text('You have no favourite items',style: TextStyle(
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
              child: ListView.builder(
                  itemCount: favItems!.length,
                  itemBuilder: (context, index) {
                    Product product = favItems[index];
                    return GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                DetailsScreen(product: favItems[index],)));
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
                            title: Text('${product.name}'),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.remove_circle, color: Colors.amber,),
                              onPressed: () {
                                setState(() {
                                  globalUser.favourites!.remove(product.id!);
                                  NetworkHandler().updateUser(globalUser);
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
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
    if (fav!.isNotEmpty) {
      List<Product>? favItems = [] ;
      for (int e in fav!) {
        Product item = await NetworkHandler().fetchProduct(e);
        favItems.add(item);
      }
      return favItems;
    }
    return [];
  }
}
