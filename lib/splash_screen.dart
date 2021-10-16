import 'package:flutter/material.dart';
import 'package:flutter_app_honey/main_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  int _currentPage = 0;
  final List<String> _images = [
    'images/splash4.png',
    'images/splash2.png',
    'images/splash3.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(child: PageView(
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index){
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: _images.map((e) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(e,fit: BoxFit.fill,),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('We serve you the most tasty , HONEY',style: TextStyle(fontSize: 20.0, color: Colors.grey,decoration: TextDecoration.none),),
                      ),
                    ],
                  )).toList(),
                )),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: _images.map((e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CircleAvatar(radius: 10.0,backgroundColor: (_currentPage == _images.indexOf(e))?Colors.amber:Colors.grey,),
                  )).toList(),
                ),
              )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MainScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('Start',style: TextStyle(fontSize: 20.0, color: Colors.white,decoration: TextDecoration.none)),
                            SizedBox(width: 10.0,),
                            Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,)
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
    );
  }
}
