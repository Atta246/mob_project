import 'package:flutter/material.dart';

class Setting_page extends StatelessWidget {
  const Setting_page({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,

        children: [
          SizedBox(
            height: screenHeight * 0.37,
            child: AppBar(
              backgroundColor: Colors.lightBlue,
              toolbarHeight: screenHeight * 0.3,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(60),
                ),
              ),
              flexibleSpace: Padding(
                padding: EdgeInsets.only(left: 20, top: 56),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Hi, Ahmed',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: screenHeight * 0.2 - 50,
            left: screenwidth * 0.05,
            width: screenwidth * 0.9,

            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    alignment: Alignment.center,
                    height: screenHeight * 0.42,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Center(
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 70,
                                backgroundImage: NetworkImage(
                                  'https://png.pngtree.com/png-clipart/20190520/original/pngtree-business-male-icon-vector-png-image_4187852.jpg',
                                ),
                              ),
                              SizedBox(height: 25),
                              Text(
                                'Ahmed',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'EMAIL',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Ahmed@gmail.com',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        SizedBox(height: 10),

                        Text(
                          'PHONE NUMBER',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '0000000000',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                   Column(
    
    children: [
          SizedBox(height: 16),
          Container(
  width: double.infinity,
  
  decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            
      ),
  child: TextButton(
    onPressed: () {
      print('object');
    },
    child: Padding(
      padding: EdgeInsets.all(3),
      
      child: Text(
        'LOG OUT',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
      )
    ,SizedBox(height: 20),
             Container(
  width: double.infinity,
  
  decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            
      ),
  child: TextButton(
    onPressed: () {
      print('object');
    },
    child: Padding(
      padding: EdgeInsets.all(3),
      
      child: Text(
        'LOG OUT',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
      )
    , SizedBox(height: 20),
            Container(
                        width: double.infinity,

                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton(
                          onPressed: () {
                            print('object');
                          },
                          child: Padding(
                            padding: EdgeInsets.all(3),

                            child: Text(
                              'LOG OUT',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
