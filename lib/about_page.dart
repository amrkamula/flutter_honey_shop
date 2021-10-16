import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber,
        title: const Text('Contact us'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: const Icon(Icons.phone,color: Colors.amber,),
                            onPressed: (){
                              launch("tel://+201019334494");
                            },
                          ),
                        ),
                        elevation: 10.0,
                      ),
                      Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: const Icon(Icons.email,color: Colors.amber,),
                              onPressed: (){
                                launch("mailto:kula6372@gmail.com?subject=News&body=New%20plugin");
                              },
                            ),
                          ),
                        elevation: 10.0,
                      ),
                      Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: const Icon(Icons.language,color: Colors.amber,),
                              onPressed: (){
                                launch("https://www.linkedin.com/in/kam-ula-05776321b/");
                              },
                            ),
                          ),
                        elevation: 10.0,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(MediaQuery.of(context).size.width*0.3))
                    ),
                    child: Image.asset('images/splash1.jpg',fit: BoxFit.fill,),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.amber,
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('+100 YEARS OF EXPERIENCE',style: TextStyle(color: Colors.white,fontSize: 20.0),),
                ),
              ),
            ),
          ),
          Container(height: MediaQuery.of(context).size.height*0.05,)
        ],
      ),
    );
  }
}
