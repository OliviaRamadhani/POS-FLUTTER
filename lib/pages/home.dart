import 'package:flutter/material.dart';
import 'package:pos2_flutter/widget/support_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
List categories=[
  "images/Larb.jpg",
  "images/Savoey.jpg",
  "images/Coconut Water.jpg",
  "images/Gaeng Som.jpg",
  "images/Khanom Jeen Nam Ya.jpg",
  "images/khao.jpeg",
  "images/Lod Chong.jpg",
  "images/Mango Sticky Rice.jpg",
  "images/P Aor.jpg",
  "images/pad.jpeg",
  "images/Pranakorn .jpg",
  "images/soi.jpeg",
  "images/somtam.jpeg",
  "images/Tako.jpg",
  "images/Tamarind Juice.jpg",
  "images/thai.jpeg",
  "images/Tom Kha Kai.jpg",
  "images/Yam Nua.jpg"

];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome In\nSiam Spice Co.", 
                  style: AppWidget.boldTextFeildStyle(),
                    ),
                    Text("Good Morning Everyone", 
                    style: AppWidget.LightTextFieldStyle(),
            ),
              ],
            ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20), 
                  child: Image.asset("images/siam1.png", height: 60, width: 60, fit: BoxFit.cover,)),
          ],
        ),
          SizedBox(height: 30.0,),
            Container(

              decoration: BoxDecoration(color: Colors.white, borderRadius:BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width,
              child: TextField(
                decoration: InputDecoration(border: InputBorder.none, hintText: "Search Products", hintStyle: AppWidget.LightTextFieldStyle(), prefixIcon: Icon(Icons.search, color: Colors.black,)),
              ),),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Categories", 
                  style: AppWidget.semiboldTextFieldStyle(),
                  ),
                  Text("See All For Dish & Drink", 
                  style: TextStyle(color: Color(0xFFfd6f3e), fontSize: 18.0, fontWeight: FontWeight.bold)
                  ),

                ],
              ),
      SizedBox(height: 20.0,),
      Row(
        children: [
            Container(
              height: 130,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: Color(0xFFFD6F3E) ,
           borderRadius: BorderRadius.circular(10)
        ),
        child: Center(child: Text("All" , 
        style: TextStyle(
          color: const Color.fromARGB(255, 255, 255, 255) , 
          fontSize: 20.0, 
          fontWeight: FontWeight.bold),))
        
        ),
          Expanded(
            child: Container(
              height: 130,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: categories.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index){
                  return CategoryTile(image: categories[index]);
                }),
            
            ),
          ),
        ],
      ),
      SizedBox(height: 20.0,),
      Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("All Products", 
                  style: AppWidget.semiboldTextFieldStyle(),
                  ),
                  Text("See All For Dish & Drink", 
                  style: TextStyle(color: Color(0xFFfd6f3e), fontSize: 18.0, fontWeight: FontWeight.bold)
                  ),

                ],
              ),

      SizedBox(height: 20.0,),
        Container(
          height: 240,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Column(children: [
                  Image.asset("images/khao.jpeg", height: 150, width: 150, fit: BoxFit.cover,),
                  Text("Khao Pad", style: AppWidget.semiboldTextFieldStyle(),),
                  SizedBox(height: 18.0,),
                  Row(
                    
                    children: [
                    Text("\$100", style: TextStyle(color: Color(0xFFfd6f3e), fontSize: 22.0, fontWeight: FontWeight.bold),),
                    SizedBox(width: 40.0,),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(color: Color(0xFFfd6f3e),borderRadius: BorderRadius.circular(7)),
                      child: Icon(Icons.add, color: Colors.white,))
                  ],)
                ],),
              ),
              
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Column(children: [
                  Image.asset("images/khao.jpeg", height: 150, width: 150, fit: BoxFit.cover,),
                  Text("Khao Pad", style: AppWidget.semiboldTextFieldStyle(),),
                  SizedBox(height: 18.0,),
                  Row(
                    
                    children: [
                    Text("\$100", style: TextStyle(color: Color(0xFFfd6f3e), fontSize: 22.0, fontWeight: FontWeight.bold),),
                    SizedBox(width: 40.0,),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(color: Color(0xFFfd6f3e),borderRadius: BorderRadius.circular(7)),
                      child: Icon(Icons.add, color: Colors.white,))
                  ],)
                ],),
              )
              
            ],
          ),
        )
      ], 
      ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  String image;
  CategoryTile({required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(right: 20.0),
      decoration: BoxDecoration(
        color: Colors.white , borderRadius: BorderRadius.circular(10)
      ),
      height: 90,
      width: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
      Image.asset(image, height: 50, width: 50, fit: BoxFit.cover,),

      Icon(Icons.arrow_forward)
      ],),
    );
  }
}