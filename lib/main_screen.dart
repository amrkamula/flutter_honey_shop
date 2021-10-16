import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_honey/cart_page.dart';
import 'package:flutter_app_honey/favourites_screen.dart';
import 'package:flutter_app_honey/model.dart';
import 'package:flutter_app_honey/network_handler.dart';
import 'package:flutter_app_honey/profile_page.dart';
import 'package:flutter_app_honey/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'about_page.dart';
import 'home_page.dart';

int? selectedPage;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  setupItemsFirst() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getBool('done fetching') == null) {
      for (int i = 0; i < 12; i++) {
        NetworkHandler().addItem(Product.random());
      }
    }
    sharedPreferences.setBool('done fetching', true);
  }

  @override
  void initState() {
    setupItemsFirst();
    selectedPage = 2;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.white,
        backgroundColor: Colors.grey[300]!,
        buttonBackgroundColor: Colors.amber,
        index: selectedPage!,
        items: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  color: (selectedPage == 0) ? Colors.white : Colors.grey,
                ),
                Text(
                  'Favourites',
                  style: TextStyle(
                      fontSize: 8.0,
                      color: (selectedPage == 0) ? Colors.white : Colors.grey),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on,
                    color: (selectedPage == 1) ? Colors.white : Colors.grey),
                Text(
                  'Contact us',
                  style: TextStyle(
                      fontSize: 8.0,
                      color: (selectedPage == 1) ? Colors.white : Colors.grey),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.home,
                    color: (selectedPage == 2) ? Colors.white : Colors.grey),
                Text(
                  'Home',
                  style: TextStyle(
                      fontSize: 8.0,
                      color: (selectedPage == 2) ? Colors.white : Colors.grey),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person,
                    color: (selectedPage == 3) ? Colors.white : Colors.grey),
                Text(
                  'Profile',
                  style: TextStyle(
                      fontSize: 8.0,
                      color: (selectedPage == 3) ? Colors.white : Colors.grey),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shopping_cart_rounded,
                    color: (selectedPage == 4) ? Colors.white : Colors.grey),
                Text(
                  'Cart',
                  style: TextStyle(
                      fontSize: 8.0,
                      color: (selectedPage == 4) ? Colors.white : Colors.grey),
                )
              ],
            ),
          ),
        ],
        onTap: (index) {
          setState(() {
            selectedPage = index;
          });
        },
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    switch (selectedPage) {
      case 0:
        return isUserIn
            ? const FavScreen()
            : Scaffold(
          backgroundColor: Colors.grey[300],
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Image.asset(
                    'images/beemove.png',
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(height: 20.0,),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('First, you need to ',style: TextStyle(fontSize: 18.0),),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              selectedPage = 3;
                            });
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(color: Colors.amber,fontSize: 18.0),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      case 1:
        return const AboutUsScreen();
      case 2:
        return const HomePage();
      case 3:
        return const ProfilePage();
      case 4:
        return isUserIn
            ? const CartPage()
            : Scaffold(
                backgroundColor: Colors.grey[300],
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Image.asset(
                          'images/beemove.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(height: 20.0,),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('First, you need to ',style: TextStyle(fontSize: 18.0),),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    selectedPage = 3;
                                  });
                                },
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(color: Colors.amber,fontSize: 18.0),
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
    }
  }

  @override
  void dispose() {
    NetworkHandler().closeDatabase();
    // TODO: implement dispose
    super.dispose();
  }

}
