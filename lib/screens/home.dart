import 'package:flutter/material.dart';
import 'package:pos2_flutter/screens/inventori/produk/index.dart';
import 'package:pos2_flutter/widgets/support_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List categories = [
    "images/drink.png",
    "images/food.png",
    "images/dessert.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      drawer: Drawer(  // Menambahkan drawer di sini
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset("images/siam1.png", height: 80, width: 80, fit: BoxFit.cover),
                  ),
                  SizedBox(height: 10),
                  Text("Siam Spice Co.", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            ListTile(
              title: Text('Home'),
              leading: Icon(Icons.house_outlined),
              onTap: () {
                // Aksi saat menu Home dipilih
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()), 
                );
              },
            ),
             ExpansionTile(
              title: Text('Inventori'),
              leading: Icon(Icons.inventory_2_outlined),
              children: <Widget>[
                ListTile(
                  title: Text('       Produk'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => InventoryPage()), // Ganti dengan halaman produk
                    );
                  },
                ),
              ], 
             ),
            ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings_outlined),
              onTap: () {
                // Aksi saat menu Settings dipilih
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()), 
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xfff2f2f2),
        leading: 
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Membuka drawer saat tombol di AppBar ditekan
              },
            ),
          ),
      ),
      body: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
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
                height: 50.0,
              ),
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
                      Text(
                        "Good Morning Everyone",
                        style: AppWidget.LightTextFieldStyle(),
                      ),
                    ],
                  ),
                  Text("See All For Dish & Drink", 
                  style: TextStyle(color: Color.fromRGBO(18, 51, 82, 1), fontSize: 18.0, fontWeight: FontWeight.bold)
                  ),
                ],
              ),
      SizedBox(height: 20.0,),
      Row(
        children: [
            Container(
              height: 130,
        padding: EdgeInsets.all(30),
        margin: EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: Color.fromRGBO(18, 51, 82, 1),
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
                  Text(
                    "Categories",
                    style: AppWidget.semiboldTextFieldStyle(),
                  ),
                  const Text(
                    "See All For Dish & Drink",
                    style: TextStyle(
                      color: Color(0xFFfd6f3e),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  // All Category Button
                  Container(
                    height: 130,
                    padding: const EdgeInsets.all(30),
                    margin: const EdgeInsets.only(right: 20.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFD6F3E),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "All",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // List of Category Icons
                  Expanded(
                    child: SizedBox(
                      height: 130,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: categories.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return CategoryTile(image: categories[index]);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              // Product Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "All Products",
                    style: AppWidget.semiboldTextFieldStyle(),
                  ),
                  const Text(
                    "See All For Dish & Drink",
                    style: TextStyle(
                      color: Color(0xFFfd6f3e),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              
              // Product List
              SizedBox(
                height: 240,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildProductCard("images/khao.jpeg", "Khao Pad", "\$100"),
                    _buildProductCard("images/Yam Nua.jpg", "Yam Nua", "\$50"),
                    _buildProductCard("images/Yam Nua.jpg", "Yam Nua", "\$50"),
                  ],
                ),
              ),
              const SizedBox(height: 20), // Tambahkan padding di akhir halaman
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(String image, String name, String price) {
    return Container(
      margin: const EdgeInsets.only(right: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Image.asset(
            image,
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          ),
          Text(
            name,
            style: AppWidget.semiboldTextFieldStyle(),
          ),
          const SizedBox(height: 18.0),
          Row(
            children: [
              Text(
                price,
                style: const TextStyle(
                  color: Color(0xFFfd6f3e),
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 40.0),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFFfd6f3e),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
      );
  }
}

class CategoryTile extends StatelessWidget {
  final String image;
  const CategoryTile({required this.image, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Event klik kategori
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 90,
        width: 90,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              image,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
