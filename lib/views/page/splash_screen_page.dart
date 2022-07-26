import 'package:flutter/material.dart';


class SplashScreen extends StatelessWidget {
  final text1 = 'Watch movie\n anywhere, anything';
  final text2 =
      'Morbi bibendum augue sed quam convallis, id posuere diam semper.';
  final textButton = 'Vamso lá';
  final imageUrl =
      'https://www.designerd.com.br/wp-content/uploads/2021/07/cartazes-de-filmes-estrangeiros-recriados-com-atores-brasileiros-por-beto-vieira-6-1434x2048.jpg';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 10),
              child: Column(
                children: [
                  Expanded(
                      flex: 3,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(imageUrl),
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            text1,
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20, bottom: 40),
                            child: Text(
                              text2,
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff6C7086),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width ,
                              height: 61,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12), // <-- Radius
                                  ),
                                ),
                                child: Text(
                                  textButton,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ))
                        ],
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
