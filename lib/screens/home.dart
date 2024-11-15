      import 'package:flutter/material.dart';
      import 'package:google_maps_flutter/google_maps_flutter.dart';
      import 'package:pos2_flutter/screens/inventori/produk/index.dart';
      import 'package:pos2_flutter/screens/signin_screen.dart';
      import 'package:pos2_flutter/widgets/support_widget.dart';
      import 'dart:async'; // Import for Timer

      void main() {
        runApp(MyApp());
      }
      
        class MyApp extends StatelessWidget {
          @override
          Widget build(BuildContext context) {
            return MaterialApp(
              home: Home(),
              debugShowCheckedModeBanner: false,
            );
          }
        }

        class Home extends StatefulWidget {
          @override
          _HomeState createState() => _HomeState();
        }

        class _HomeState extends State<Home> {
          final PageController _pageController = PageController();
          int _currentIndex = 0;
          String _selectedFilter = "All";
          late Timer _timer;

          late GoogleMapController _mapController;
          LatLng _selectedLocation = LatLng(0, 0); // Default location
          final Set<Marker> _markers = {};

          final List<Map<String, String>> discountItems = [
            {
              "title": "Seasonal Discount",
              "discount": "Up to 50% off",
              "imagePath": "images/bgg.png",
            },
            {
              "title": "Limited Time Offer",
              "discount": "Save 30%",
              "imagePath": "images/food.png",
            },
            {
              "title": "Special Promotion",
              "discount": "20% off on desserts",
              "imagePath": "images/drink.png",
            },
          ];

          @override
          void initState() {
            super.initState();

            // Set up the Timer to automatically change the page every 3 seconds
            _timer = Timer.periodic(Duration(seconds: 6), (timer) {
              if (_currentIndex < discountItems.length - 1) {
                _currentIndex++;
              } else {
                _currentIndex = 0;
              }

              // Animate to the next page with a slower transition and a smoother curve
              _pageController.animateToPage(
                _currentIndex,
                duration: Duration(milliseconds: 2500), // Further slow down the transition (1.5 seconds)
                curve: Curves.easeInOut, // More gradual, smooth curve
              );

              setState(() {}); // Rebuild the widget to update the indicator
            });
          }

          @override
          void dispose() {
            _timer.cancel(); // Cancel the timer when the widget is disposed
            super.dispose();
          }

          // Method to update location when user selects on map
          void _onMapTapped(LatLng location) {
            setState(() {
              _selectedLocation = location;
              _markers.clear(); // Clear previous markers
              _markers.add(Marker(
                markerId: MarkerId('selectedLocation'),
                position: _selectedLocation,
                infoWindow: InfoWindow(title: 'Selected Location'),
              ));
            });

            // Close the map dialog after selecting a location
            Navigator.of(context).pop();
          }

          void _onFilterSelected(String filter) {
            setState(() {
              _selectedFilter = filter;
            });
          }


        @override
        Widget build(BuildContext context) {
          return Scaffold(
            backgroundColor: Color(0xFFF8F8F8),
            drawer: Drawer(  // Menambahkan drawer di sini
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 5, 14, 61),                    
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
                        title: Text('Produk'),
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
              backgroundColor: Color.fromARGB(255, 5, 14, 61),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu, color: Color.fromARGB(255, 255, 255, 255)),
                  onPressed: () {
                    Scaffold.of(context).openDrawer(); // Open drawer when menu button is pressed
                  },
                ),
              ),
              actions: [
                // Profile icon and notification icon in the actions section
                IconButton(
                  icon: Icon(Icons.notifications, color: Color.fromARGB(255, 255, 255, 255), size: 24),
                  onPressed: () {
                    // Action for notification icon (if needed)
                  },
                ),
                SizedBox(width: 15),  // Space between icons
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                      // Display the selected location
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Location:", style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 5, 14, 61))),
                    Text(
                      _selectedLocation == LatLng(0, 0)
                          ? "Select a location"
                          : "${_selectedLocation.latitude}, ${_selectedLocation.longitude}",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 5, 14, 61)),
                    ),
                  ],
                ),
                // Location picker button
                IconButton(
                  icon: Icon(Icons.location_on, color: Color.fromARGB(255, 5, 14, 61)),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          height: 400,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _selectedLocation,
                              zoom: 12,
                            ),
                            markers: _markers,
                            onMapCreated: (controller) {
                              _mapController = controller;
                            },
                            onTap: (LatLng location) {
                              _onMapTapped(location);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
                    SizedBox(height: 20),

                    // Search Bar
                    _buildSearchBar(),

                    SizedBox(height: 20), // Add space between search bar and discount slider

                    // Discount Slider with Scroll Indicator
                    _buildDiscountSlider(),

                    SizedBox(height: 20), // Add space between discount banner and other sections

                    // Categories
                    _buildCategoryRow(),

                    SizedBox(height: 20), // Add space between categories and flash sale

                    // Flash Sale Section
                    _buildFlashSaleSection(),

                    SizedBox(height: 20), // Add space between flash sale and filter section

                    // Filters with functionality
                    _buildFilterRow(),

                    // Product Cards in a Grid
                    _buildProductGrid(),
                  ],
                ),
              ),
            ),
          );
        }

        

            Widget _buildSearchBar() {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Color.fromARGB(255, 5, 14, 61)),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

              Widget _buildDiscountSlider() {
              return SizedBox(
                height: 170,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: discountItems.length,
                        itemBuilder: (context, index) {
                          final item = discountItems[index];
                          return _buildDiscountBanner(
                            item["title"],    // No null operator (!) to allow fallback
                            item["discount"], // No null operator (!) to allow fallback
                            item["imagePath"], // No null operator (!) to allow fallback
                          );
                        },
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        discountItems.length,
                        (index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentIndex == index
                                ? Color.fromARGB(255, 5, 14, 61)
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

           Widget _buildCategoryRow() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCategory("🍔", "Food"),
                _buildCategory("🍹", "Drink"),
                _buildCategory("🍰", "Dessert"),
              ],
            );
          }
            Widget _buildFlashSaleSection() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Flash Sale", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                      Text("Closing in: 02 : 12 : 56", style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 5, 14, 61))),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              );
            }


          Widget _buildFilterRow() {
            final filters = ["All", "Newest", "Popular", "Man", "Women"];
            return Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                child: Row(
                  children: filters.map((filter) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12), // Add more space between filters
                      child: GestureDetector(
                        onTap: () => _onFilterSelected(filter),
                        child: _buildFilter(filter, isActive: _selectedFilter == filter),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          }

          Widget _buildProductGrid() {
            // List of product details with title, price, and image
            final products = [
              {"title": "Coconut Water", "price": "\$5.99", "image": "images/Coconut Water.jpg"},
              {"title": "Gaeng Som", "price": "\$12.99", "image": "images/Gaeng Som.jpg"},
              {"title": "Khanom Jeen Nam Ya", "price": "\$49.99", "image": "images/Khanom Jeen Nam Ya.jpg"},
              {"title": "Khao", "price": "\$29.99", "image": "images/khao.jpeg"},
              {"title": "Larb", "price": "\$39.99", "image": "images/Larb.jpg"},
              {"title": "Lod Chong", "price": "\$7.99", "image": "images/Lod Chong.jpg"},
              {"title": "Mango Sticky Rice", "price": "\$9.99", "image": "images/Mango Sticky Rice.jpg"},
              {"title": "P Aor", "price": "\$11.99", "image": "images/P Aor.jpg"},
              {"title": "Pad", "price": "\$14.99", "image": "images/pad.jpeg"},
              {"title": "Pranakorn", "price": "\$16.99", "image": "images/Pranakorn .jpg"},
              {"title": "Savoey", "price": "\$13.99", "image": "images/Savoey.jpg"},
              {"title": "Soi", "price": "\$8.99", "image": "images/soi.jpeg"},
              {"title": "Somtam", "price": "\$7.99", "image": "images/somtam.jpeg"},
              {"title": "Tako", "price": "\$5.99", "image": "images/Tako.jpg"},
              {"title": "Tamarind Juice", "price": "\$3.99", "image": "images/Tamarind Juice.jpg"},
              {"title": "Thai", "price": "\$12.99", "image": "images/thai.jpeg"},
              {"title": "Tom Kha Kai", "price": "\$15.99", "image": "images/Tom Kha Kai.jpg"},
              {"title": "Yam Nua", "price": "\$17.99", "image": "images/Yam Nua.jpg"},
            ];

            return GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12, // Increased space between grid items
                mainAxisSpacing: 12, // Increased space between grid items
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductCard(product["title"]!, product["price"]!, product["image"]!);
              },
            );
          }

          Widget _buildProductCard(String title, String price, String imageUrl) {
            return Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        imageUrl,
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 10),
                      Text(
                        title,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      SizedBox(height: 5),
                      Text(
                        price,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 5, 14, 61)),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 5, 14, 61),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                          "Shop Now",
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.white, // Set the text color
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                    ),
                  ),
                ],
              ),
            );
          }


          Widget _buildDiscountBanner(String? title, String? discount, String? imagePath) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFFF3E7DC),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title ?? "Default Title",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 5, 14, 61),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        discount ?? "Default Discount",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 5, 14, 61),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 5, 14, 61),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Shop Now",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  imagePath ?? "images/default.png",
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          );
        }



            Widget _buildCategory(String icon, String label) {
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      icon,
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color:Color.fromARGB(255, 5, 14, 61))),
                ],
              );
            }

            // Make sure this method is defined in the same class
          Widget _buildFilter(String label, {required bool isActive}) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? Color.fromARGB(255, 5, 14, 61) : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.white :Color.fromARGB(255, 5, 14, 61),
                ),
              ),
            );
          }
          }
