import 'package:flutter/material.dart';
import 'package:flutter_app_honey/details_screen.dart';
import 'package:flutter_app_honey/network_handler.dart';

import 'model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _selectedCategory=1;

  Future<List<Product>> setupItemsList() async {
    List result = await  NetworkHandler().fetchAllProducts(_selectedCategory!);
    if(result.isEmpty){
      return [];
    }
     return result.map((e) => Product.fromDb(e)).toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: setupItemsList(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        else {
          List<Product>? _items = snapshot.data;
          return CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: [
              SliverAppBar(
                  backgroundColor: Colors.amber,
                  pinned: true,
                  snap: false,
                  floating: false,
                  expandedHeight: MediaQuery
                      .of(context)
                      .size
                      .height * .3,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: const Text('Honey Boom!'),
                    background: SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * .2,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .25,
                        child: Image.asset('images/splash2.png',)),
                  )
              ),
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.1,
                  color: Colors.amber,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = 0;
                          });
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Best seller', style: TextStyle(fontSize: 18.0,
                                color: (_selectedCategory == 0)
                                    ? Colors.white
                                    : Colors.grey),),
                            const SizedBox(height: 3.0,),
                            Visibility(
                                visible: _selectedCategory == 0,
                                child: Container(
                                  width: 40.0,
                                  height: 2.0,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = 1;
                          });
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Popular', style: TextStyle(fontSize: 18.0,
                                color: (_selectedCategory == 1)
                                    ? Colors.white
                                    : Colors.grey),),
                            const SizedBox(height: 3.0,),
                            Visibility(
                                visible: _selectedCategory == 1,
                                child: Container(
                                  width: 40.0,
                                  height: 2.0,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = 2;
                          });
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Suggested for you', style: TextStyle(
                                fontSize: 18.0,
                                color: (_selectedCategory == 2)
                                    ? Colors.white
                                    : Colors.grey),),
                            const SizedBox(height: 3.0,),
                            Visibility(
                                visible: _selectedCategory == 2,
                                child: Container(
                                  width: 40.0,
                                  height: 2.0,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 12.0,
                ),
                delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    DetailsScreen(product: _items![index],)));
                          },
                          child: Card(
                            child: Column(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        _items![index].imageUrl!,
                                        fit: BoxFit.fill,),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: Text('${_items[index].name}',
                                    style: const TextStyle(fontSize: 18.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: _items!.length
                ),
              ),
            ],
          );
        }
      }
    );
  }
}