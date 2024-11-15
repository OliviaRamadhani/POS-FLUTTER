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
        late Timer _flashSaleTimer;  // Timer for flash sale countdown
        late Timer _pageTransitionTimer;  // Timer for page transitions
        late GoogleMapController _mapController;
        LatLng _selectedLocation = LatLng(0, 0); // Default location
        final Set<Marker> _markers = {};

        // Remaining time for Flash Sale
        Duration _remainingTime = Duration(hours: 10, minutes: 20, seconds: 00);

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

        // List to store like counts for each product
        List<int> likeCounts = List<int>.filled(18, 0); // Assuming you have 18 products

        @override
        void initState() {
          super.initState();
          
              // Start countdown for Flash Sale (every second)
        _flashSaleTimer = Timer.periodic(Duration(seconds: 1), (timer) {
          if (_remainingTime.inSeconds > 0) {
            setState(() {
              _remainingTime = _remainingTime - Duration(seconds: 1);
            });
          } else {
            _flashSaleTimer.cancel(); // Stop the countdown when time is up
          }
        });

        // Start page transition (every 6 seconds)
        _pageTransitionTimer = Timer.periodic(Duration(seconds: 6), (timer) {
          setState(() {
            if (_currentIndex < discountItems.length - 1) {
              _currentIndex++;
            } else {
              _currentIndex = 0;
            }
          });
            

            _pageController.animateToPage(
              _currentIndex,
              duration: Duration(milliseconds: 2500),
              curve: Curves.easeInOut,
            );
          });
        }

         @override
          void dispose() {
            // Cancel both timers when the widget is disposed
            _flashSaleTimer.cancel();
            _pageTransitionTimer.cancel();
            super.dispose();
          }

        // Format time in HH:mm:ss format
        String _formatTime(Duration duration) {
          String twoDigits(int n) => n.toString().padLeft(2, '0');
          final hours = twoDigits(duration.inHours);
          final minutes = twoDigits(duration.inMinutes.remainder(60));
          final seconds = twoDigits(duration.inSeconds.remainder(60));
          return '$hours:$minutes:$seconds';
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


        // Method to handle toggling likes for a product
        void _toggleLike(int index) {
          setState(() {
            likeCounts[index] = likeCounts[index] == 0 ? 1 : 0;  // Toggle between 0 and 1
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
              // Flash Sale section with countdown timer
              Widget _buildFlashSaleSection() { 
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Flash Sale", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                        Text("Closing in: ${_formatTime(_remainingTime)}", style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 5, 14, 61))),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                );
              }


         Widget _buildFilterRow() {
        final filters = ["All", "Food", "Drink", "Dessert"];  // Modified filters
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
          // List of product details with title, price, image, and category
          final products = [
            {"title": "Coconut Water", "price": "\$5.99", "image": "images/Coconut Water.jpg", "category": "Drink"},
            {"title": "Gaeng Som", "price": "\$12.99", "image": "images/Gaeng Som.jpg", "category": "Food"},
            {"title": "Khanom Jeen Nam Ya", "price": "\$49.99", "image": "images/Khanom Jeen Nam Ya.jpg", "category": "Food"},
            {"title": "Khao", "price": "\$29.99", "image": "images/khao.jpeg", "category": "Food"},
            {"title": "Larb", "price": "\$39.99", "image": "images/Larb.jpg", "category": "Food"},
            {"title": "Lod Chong", "price": "\$7.99", "image": "images/Lod Chong.jpg", "category": "Dessert"},
            {"title": "Mango Sticky Rice", "price": "\$9.99", "image": "images/Mango Sticky Rice.jpg", "category": "Dessert"},
            {"title": "P Aor", "price": "\$11.99", "image": "images/P Aor.jpg", "category": "Food"},
            {"title": "Pad", "price": "\$14.99", "image": "images/pad.jpeg", "category": "Food"},
            {"title": "Pranakorn", "price": "\$16.99", "image": "images/Pranakorn .jpg", "category": "Food"},
            {"title": "Savoey", "price": "\$13.99", "image": "images/Savoey.jpg", "category": "Food"},
            {"title": "Soi", "price": "\$8.99", "image": "images/soi.jpeg", "category": "Food"},
            {"title": "Somtam", "price": "\$7.99", "image": "images/somtam.jpeg", "category": "Food"},
            {"title": "Tako", "price": "\$5.99", "image": "images/Tako.jpg", "category": "Dessert"},
            {"title": "Tamarind Juice", "price": "\$3.99", "image": "images/Tamarind Juice.jpg", "category": "Drink"},
            {"title": "Thai", "price": "\$12.99", "image": "images/thai.jpeg", "category": "Drink"},
            {"title": "Tom Kha Kai", "price": "\$15.99", "image": "images/Tom Kha Kai.jpg", "category": "Food"},
            {"title": "Yam Nua", "price": "\$17.99", "image": "images/Yam Nua.jpg", "category": "Food"},
          ];

          // Filter products based on the selected filter
          List<Map<String, String>> filteredProducts = [];
          if (_selectedFilter == "All") {
            filteredProducts = products; // Show all products if "All" is selected
          } else {
            filteredProducts = products.where((product) => product["category"] == _selectedFilter).toList();
          }

          return GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12, // Increased space between grid items
              mainAxisSpacing: 12, // Increased space between grid items
              childAspectRatio: 0.75,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return _buildProductCard(
                product["title"]!, 
                product["price"]!, 
                product["image"]!, 
                likes: likeCounts[index], 
                onLikeTapped: () => _toggleLike(index)
              );
            },
          );
        }


          Widget _buildProductCard(String title, String price, String imageUrl, {int likes = 0, required VoidCallback onLikeTapped}) {
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
                      Stack(
                        children: [
                          Image.asset(
                            imageUrl,
                            width: double.infinity,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: onLikeTapped,
                              child: Icon(
                                likes == 0 ? Icons.favorite_border : Icons.favorite, // Change icon based on like state
                                color: Colors.red,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Align text and button to opposite sides
                      children: [
                        Row(
                          children: [
                            // Shift like count to the left by adding padding or adjusting alignment
                            Padding(
                              padding: EdgeInsets.only(left: 10 , right: 35), // Adjust this value to fine-tune the position
                              child: Text(
                                '$likes', // Display the number of likes
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Add logic for shopping action here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 5, 14, 61),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Shop Now",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
