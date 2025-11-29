import 'package:flutter/material.dart';
import 'package:new_3c/profile/widgets/profile_background.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        ProfileBackground(),
        Positioned(
          top: size.height * .1,
          right: 10,
          left: 10,
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFFF6A25C),
                radius: 60,
                backgroundImage: NetworkImage(
                  "https://picsum.photos/200",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Mazen 1234",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF6A25C),
                ),
              ),
              Text(
                "Software Engineer",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[300],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                "I'm laskjdflas dflaskdjf las dkflaskj dfla;sdj flaskdjf laskdf as;dlkfas;ldk fasl;dkf jasld fkjasl;dfk j",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[400],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("FOLLOW"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF6A25C),
                        foregroundColor: Colors.white),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: Text("MESSAGE"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFFF6A25C),
                      side: BorderSide(
                        color: Color(0xFFF6A25C),
                        width: 2,
                      ),
                    ),
                  ),
                ],
              ),

              //todo mazen will do this
              Container(
                height: 40,
                width: 1,
                color: Colors.black,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Works",
                    style: TextStyle(
                      color: Color(0xFFF6A25C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "view all",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      //image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "https://picsum.photos/200",
                          width: 150,
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                      ),

                      //words
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Nature",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "66 Photos",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[300],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  separatorBuilder: (context, index) => SizedBox(
                    width: 10,
                  ),
                  itemCount: 12,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
