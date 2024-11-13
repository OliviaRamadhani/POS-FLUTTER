import 'package:flutter/material.dart';
import 'package:pos2_flutter/widget/support_widget.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfef5f1),
      body: Container(
        padding: EdgeInsets.only(top: 50.0 , left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Stack(
          children: [ GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(left:20.0),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(30)),
              child: Icon(Icons.arrow_back_ios_new_outlined)),
          ),
          Center(
            child: Image.asset("images/Coconut Water.jpg", 
            height: 300,))
          ] ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only( left: 20.0, right: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
            ),
            width: MediaQuery.of(context).size.width , child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Coconut Water", style: AppWidget.boldTextFeildStyle(),),
                    Text("\$100", 
                      style: TextStyle(
                        color: Color(0xFFfd6f3e), 
                        fontSize: 23.0, 
                        fontWeight: FontWeight.bold))
                  ],
                ),
                SizedBox(height: 20.0,),
                Text("Details", style: AppWidget.semiboldTextFieldStyle(),),
                SizedBox(height: 10.0,),
                Text("Coconut water is the clear liquid found inside young coconuts, known for its refreshing taste and health benefits. This natural drink is low in calories and fat-free, making it a popular choice for healthy hydration. Rich in electrolytes like potassium, sodium, and magnesium, coconut water is excellent for rehydrating after physical activity. Additionally, it contains antioxidants that help combat free radicals and support the immune system."),
                SizedBox(height: 90.0,),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                   color:  Color(0xFFfd6f3e), borderRadius: BorderRadius.circular(10)
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Center(child: Text("Buy Now", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),)),
                )
              ],
            ),),
        ) 
      ],
        ),
          ),
    );
  }
}