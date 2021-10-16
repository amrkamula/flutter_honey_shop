import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_honey/network_handler.dart';
import 'package:flutter_app_honey/receipt.dart';
import 'package:flutter_app_honey/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _signIn = true;
  TextEditingController? _userNameController;
  TextEditingController? _eMailController;
  TextEditingController? _passwordController;
  TextEditingController? _confirmPasswordController;

  bool _remember = false;

  Future<List<Order>> _setUpOrderList() async {
    List<Order> orders = [];
    if(globalUser.orders!.isNotEmpty){
      for(int e in globalUser.orders!){
        Order order = await NetworkHandler().fetchOrder(e);
        orders.add(order);
      }
    }
    return orders;
  }

  @override
  void initState() {
    _userNameController = TextEditingController();
    _eMailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _checkRemember();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isUserIn
        ? Scaffold(
            backgroundColor: Colors.grey[300],
            appBar: AppBar(
              backgroundColor: Colors.amber,
              title: const Text('My profile'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout,color: Colors.white,),
                  onPressed: () async {
                    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                    sharedPreferences.remove('username');
                    setState(() {
                      isUserIn = false;
                      globalUser = User(
                        id: null,
                        eMail: '',
                        password: '',
                        userName: '',
                        orders: [],
                        favourites: [],
                      );
                    });
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Personal information',style: TextStyle(color: Colors.black,fontSize: 20.0,fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 0.0,
                      child: ListTile(
                        title: const Text('username',style: TextStyle(fontSize: 18.0),),
                        subtitle: Text(globalUser.userName!),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 0.0,
                      child: ListTile(
                        title: const Text('e-mail address',style: TextStyle(fontSize: 18.0),),
                        subtitle: Text(globalUser.eMail!),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 20.0),
                    child: Text('My orders',style: TextStyle(color: Colors.black,fontSize: 20.0,fontWeight: FontWeight.bold),),
                  ),
                  FutureBuilder<List<Order>>(
                    future: _setUpOrderList(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        List<Order> orders = snapshot.data!;
                        return SizedBox(
                          height: MediaQuery.of(context).size.height*.4,
                          child: ListView.builder(
                            itemCount: orders.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context,index){
                              Order order = orders[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 10.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text('${index+1}',style: const TextStyle(fontSize: 18.0,color: Colors.amber,fontWeight: FontWeight.bold),),
                                        const SizedBox(height: 20.0,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.phone,size: 20.0,),
                                                  const SizedBox(width: 20.0,),
                                                  Text('${order.phoneNumber}',style: const TextStyle(fontSize: 16.0),),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  const Icon(Icons.location_on,size: 20.0,),
                                                  const SizedBox(width: 20.0,),
                                                  Text('${order.address}',style: const TextStyle(fontSize: 16.0),),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  const Icon(Icons.monetization_on_outlined,size: 20.0,),
                                                  const SizedBox(width: 20.0,),
                                                  Text('${order.totalPrice}',style: const TextStyle(fontSize: 16.0),),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        TextButton(onPressed: (){
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context)=> Receipt(order: order,))
                                          );
                                        }, child: const Text('View Receipt',style: TextStyle(color: Colors.amber,fontSize: 18.0),))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }else{
                       return Container();
                      }
                    }
                  ),

                ],
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.grey[300],
            body: Stack(
              children: [
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.5,
                      decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50.0),
                              topRight: Radius.circular(50.0),
                              bottomRight: Radius.circular(50.0))),
                    )
                  ],
                ),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Image.asset(
                            'images/splash2.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const Text(
                        'Honey Boom!',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 12.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _signIn = false;
                                              });
                                            },
                                            child: Text(
                                              'Sign up',
                                              style: TextStyle(
                                                color: _signIn
                                                    ? Colors.grey
                                                    : Colors.amber,
                                                fontSize: _signIn ? 18.0 : 24.0,
                                              ),
                                            )),
                                        Visibility(
                                            visible: !_signIn,
                                            child: Container(
                                              width: 40.0,
                                              height: 2.0,
                                              color: Colors.amber,
                                            )),
                                      ],
                                    ),
                                    const Text(
                                      'or',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 18.0),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _signIn = true;
                                              });
                                            },
                                            child: Text(
                                              'Sign In',
                                              style: TextStyle(
                                                color: !_signIn
                                                    ? Colors.grey
                                                    : Colors.amber,
                                                fontSize:
                                                    !_signIn ? 18.0 : 24.0,
                                              ),
                                            )),
                                        Visibility(
                                            visible: _signIn,
                                            child: Container(
                                              width: 40.0,
                                              height: 2.0,
                                              color: Colors.amber,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
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
                                          controller: _userNameController,
                                          keyboardType: TextInputType.name,
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
                                            hintText: 'username',
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: !_signIn,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8.0, left: 8.0, bottom: 8.0),
                                          child: TextFormField(
                                            controller: _eMailController,
                                            keyboardType:
                                                TextInputType.emailAddress,
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
                                                hintText: 'e-mail',
                                                focusColor: Colors.amber),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8.0, left: 8.0, bottom: 8.0),
                                        child: TextFormField(
                                          controller: _passwordController,
                                          obscureText: true,
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
                                              hintText: 'password',
                                              focusColor: Colors.amber),
                                        ),
                                      ),
                                      Visibility(
                                        visible: !_signIn,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8.0,
                                              left: 8.0,
                                              bottom: 8.0),
                                          child: TextFormField(
                                            controller:
                                                _confirmPasswordController,
                                            obscureText: true,
                                            validator: (val) {
                                              if (val!.isEmpty) {
                                                return 'This field can not be empty';
                                              }
                                              if (val !=
                                                  _passwordController!.text) {
                                                return 'Password does not match';
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
                                                hintText: 'confirm password',
                                                focusColor: Colors.amber),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, left: 8.0, bottom: 20.0),
                                child: Visibility(
                                    visible: _signIn,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Checkbox(
                                                fillColor: MaterialStateColor
                                                    .resolveWith((states) =>
                                                        Colors.amber),
                                                value: _remember,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _remember = value!;
                                                  });
                                                }),
                                            const Text('Remember me')
                                          ],
                                        )
                                      ],
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            if (_key.currentState!.validate()) {
                              if (_signIn) {
                                if (_remember) {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  sharedPreferences.setString(
                                      'username', _userNameController!.text);
                                  sharedPreferences.setString(
                                      'password', _passwordController!.text);
                                }
                                _signInUser(
                                    userName: _userNameController!.text,
                                    password: _passwordController!.text);
                              } else {
                                _signUp();
                              }
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                _signIn ? 'Sign In' : 'Sign up',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 24.0),
                              )),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  void _signUp() async {
    User user = User(
      id: null,
      eMail: _eMailController!.text,
      password: _passwordController!.text,
      userName: _userNameController!.text,
      favourites: [],
      orders: [],
    );
    NetworkHandler().addUser(user);
    setState(() {
      isUserIn = true;
      globalUser = user;
    });
  }

  void _signInUser({required String userName, required String password}) async {
    User user = await NetworkHandler().fetchOneUser(userName);
    if (user.userName == '') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Username does not exist'),
        backgroundColor: Colors.amber,
      ));
    } else if (user.password != password) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Password does not match'),
        backgroundColor: Colors.amber,
      ));
    } else {
      setState(() {
        isUserIn = true;
        globalUser = user;
      });
    }
  }

  void _checkRemember() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('username') != null) {
      _signInUser(
          userName: sharedPreferences.getString('username')!,
          password: sharedPreferences.getString('password')!);
    }
  }

}
