      import 'package:flutter/material.dart';
      import 'package:google_maps_flutter/google_maps_flutter.dart';
      import 'package:pos2_flutter/screens/inventori/produk/index.dart';
      import 'package:pos2_flutter/screens/signin_screen.dart';
      import 'package:pos2_flutter/widgets/support_widget.dart';
      import 'dart:async'; // Import for Timer
      import 'package:pos2_flutter/screens/recipes.dart';

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
        int? selectedIndex;
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
            "title": "Discount of Today",
            "discount": "Discount Up To 30%",
            "imagePath": "images/thailand.png",
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

        
           Widget _buildSearchBar() {
  return TextField(
    decoration: InputDecoration(
      hintText: 'Search Any Recipe...',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: const Color.fromARGB(255, 255, 255, 255),
      prefixIcon: Icon(Icons.search, color: Colors.black), // Menambahkan ikon di dalam TextField
    ),
  );
}


        @override
          Widget build(BuildContext context) {
            return Scaffold(
              backgroundColor: Color(0xFFF8F8F8),
              drawer: _buildDrawer(context),
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(200),
                child: _buildCustomAppBar(context),
              ),

     body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              // Discount Slider with Scroll Indicator
                    _buildSectionTitle('Discount & Flash Sale'),  

                    _buildDiscountSlider(),

                    SizedBox(height: 20), // Add space between discount banner and other sections
                    _buildFlashSaleSection(),

                    SizedBox(height: 20), // Add space between categories and flash sale

                    // Flash Sale Section

                    _buildSectionTitle('Categories'),

              _buildCategoryList(context),

            

              _buildSectionTitle('Popular Recipes'),

              SizedBox(height: 20),

              _buildPopularRecipe(context),

              SizedBox(height: 20),

              _buildSectionTitle('Top Chefs'),

              SizedBox(height: 20),

              _buildChefList(),

              SizedBox(height: 20),

               _buildGoNow(),

               SizedBox(height: 20),

                _buildThailand(),

                SizedBox(height: 20),

              _buildGoFood(),
              SizedBox(height: 20),

               _buildGoFoods(),
               SizedBox(height: 20),

               

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 5, 14, 61),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    "images/siam1.png",
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Siam Spice Co.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Home'),
            leading: Icon(Icons.house_outlined),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
          ExpansionTile(
            title: Text('Inventori'),
            leading: Icon(Icons.inventory_2_outlined),
            children: [
              ListTile(
                title: Text('Produk'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => InventoryPage()),
                  );
                },
              ),
            ],
          ),
          ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.settings_outlined),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
        ],
      ),
    );
  }


  Widget _buildCustomAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 5, 14, 61),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          children: [
            SizedBox(height: 50),
            _buildSearchBar(),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Location:",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    Text(
                      "Select a location",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.location_on, color: Colors.white),
                  onPressed: () {
                    // Tambahkan aksi untuk memilih lokasi
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  
Widget _buildCategoryList(BuildContext context) {
  final categories = [
    {'name': 'Side Dish', 'image': 'images/Mango Sticky Rice.jpg'},
    {'name': 'Drink', 'image': 'images/Coconut Water.jpg'},
    {'name': 'Food', 'image': 'images/khao.jpeg'},
  ];

  return Column(
    children: [
      SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index; // Mengubah index yang dipilih
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40), // Melengkungkan sudut
                      child: Container(
                        width: 150, // Lebar gambar
                        height: 70, // Tinggi gambar
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(categories[index]['image']!),
                            fit: BoxFit.cover, // Gambar tetap full
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.4), // Menambahkan lapisan hitam transparan
                              BlendMode.darken, // Menggunakan mode untuk membuat gambar lebih gelap
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.6), // Bayangan hitam
                              blurRadius: 8.0, // Ukuran blur bayangan
                              offset: Offset(2.0, 2.0), // Posisi bayangan
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center, // Menyusun teks di tengah
                          children: [
                            // Teks kategori berada di atas gambar
                            Text(
                              categories[index]['name']!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: selectedIndex == index ? Colors.white : const Color.fromARGB(176, 255, 248, 56),
                                shadows: [
                                  Shadow(
                                    blurRadius: 8.0, // Jarak bayangan
                                    color: Colors.black.withOpacity(0.6), // Bayangan hitam
                                    offset: Offset(2.0, 2.0), // Posisi bayangan
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}



  Widget _buildPopularRecipe(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10),
    ),
    child: GestureDetector(
      onTap: () {
        // Navigate to RecipeDetailScreen when tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecipeDetailScreen()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'images/Gaeng Som.jpg',
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Text(
            'Gaeng Som Tam',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 5),
          Text(
            '35 min · Easy · by Arlene McCoy',
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Navigate to RecipeDetailScreen when pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecipeDetailScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            child: Text('View Recipe'),
          ),
        ],
      ),
    ),
  );
}



Widget _buildChefList() {
  final chefs = [
    {'name': 'Chef Chada', 'image': 'images/100.jpg', 'rating': 4.5},
    {'name': 'Chef Anong', 'image': 'images/110.jpg', 'rating': 4.0},
    {'name': 'Chef Jai', 'image': 'images/120.jpg', 'rating': 4.8},
    {'name': 'Chef Arnold.', 'image': 'images/140.jpg', 'rating': 3.9},
    {'name': 'Chef Viera', 'image': 'images/150.jpg', 'rating': 3.5},
  ];

  return SizedBox(
    height: 200, // Increase height to make space for the name
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: chefs.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar chef dengan overlay gelap
              ClipRRect(
                borderRadius: BorderRadius.circular(60), // Perfect circle for the image
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(chefs[index]['image'] as String), // Cast to String
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.4), // Menambahkan lapisan hitam transparan
                        BlendMode.darken, // Menggunakan mode untuk membuat gambar lebih gelap
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8), // Add space between the image and the name
              // Nama chef yang ditempatkan di bawah gambar
              Text(
                chefs[index]['name'] as String, // Cast to String
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              // Rating dan ikon bintang di bawah nama
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    chefs[index]['rating'].toString(),
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
                            item["title"],
                            item["discount"],
                            item["imagePath"],
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


        

        Widget _buildDiscountBanner(String? title, String? discount, String? imagePath) {
          bool isFullImage = (title == null || title.isEmpty) && (discount == null || discount.isEmpty);

          return Stack(
            children: [
              // Full image display
              Positioned.fill(
                child: Image.asset(
                  imagePath ?? "images/default.png",
                  fit: BoxFit.cover,
                ),
              ),
              // Position title and discount text in the bottom-left corner
              if (!isFullImage)
                Positioned(
                  bottom: 70,  // Positioned above the "Shop Now" button
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? "Default Title",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        discount ?? "Default Discount",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                        ),
                      ),
                    ],
                  ),
                ),
              // Positioned "Shop Now" button in the bottom-right corner
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
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        }

      Widget _buildGoFood() {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15), // More rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'images/thailand.png', // Ganti dengan path gambar Anda
                    height: 150, // Larger image for better visibility
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 15), // Adjusted space between image and title

                // Title/Heading with shadow for better visibility
                Text(
                  'Delicious Thailand Deals!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                    shadows: [
                      Shadow(
                        blurRadius: 5,
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                // Description
                Text(
                  'Explore exciting discounts and popular menus near you. Order now and enjoy!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF555555),
                  ),
                ),
                SizedBox(height: 20),

                // Button with icon and improved design
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle button press (e.g., navigate to another page)
                  },
                  icon: Icon(Icons.food_bank, color: Colors.white), // Added food icon
                  label: Text(
                    'Order Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    iconColor: Color(0xFFFF4500), // Vibrant orange background
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Rounded button
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      Widget _buildGoNow() {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15), // More rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'images/thailand.png', // Ganti dengan path gambar Anda
                    height: 150, // Larger image for better visibility
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 15), // Adjusted space between image and title

                // Title/Heading with shadow for better visibility
                Text(
                  'Delicious Thailand Deals!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                    shadows: [
                      Shadow(
                        blurRadius: 5,
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                // Description
                Text(
                  'Explore exciting discounts and popular menus near you. Order now and enjoy!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF555555),
                  ),
                ),
                SizedBox(height: 20),

                // Button with icon and improved design
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle button press (e.g., navigate to another page)
                  },
                  icon: Icon(Icons.food_bank, color: Colors.white), // Added food icon
                  label: Text(
                    'Order Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    iconColor: Color(0xFFFF4500), // Vibrant orange background
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Rounded button
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      Widget _buildThailand() {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15), // More rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'images/thailand.png', // Ganti dengan path gambar Anda
                    height: 150, // Larger image for better visibility
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 15), // Adjusted space between image and title

                // Title/Heading with shadow for better visibility
                Text(
                  'Delicious Thailand Deals!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                    shadows: [
                      Shadow(
                        blurRadius: 5,
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                // Description
                Text(
                  'Explore exciting discounts and popular menus near you. Order now and enjoy!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF555555),
                  ),
                ),
                SizedBox(height: 20),

                // Button with icon and improved design
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle button press (e.g., navigate to another page)
                  },
                  icon: Icon(Icons.food_bank, color: Colors.white), // Added food icon
                  label: Text(
                    'Order Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    iconColor: Color(0xFFFF4500), // Vibrant orange background
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Rounded button
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      Widget _buildGoFoods() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15), // More rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'images/thailand.png', // Ganti dengan path gambar Anda
                height: 150, // Larger image for better visibility
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 15), // Adjusted space between image and title

            // Title/Heading with shadow for better visibility
            Text(
              'Delicious Thailand Deals!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
                shadows: [
                  Shadow(
                    blurRadius: 5,
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            // Description
            Text(
              'Explore exciting discounts and popular menus near you. Order now and enjoy!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF555555),
              ),
            ),
            SizedBox(height: 20),

            // Button with icon and improved design
            ElevatedButton.icon(
              onPressed: () {
                // Handle button press (e.g., navigate to another page)
              },
              icon: Icon(Icons.food_bank, color: Colors.white), // Added food icon
              label: Text(
                'Order Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                iconColor: Color(0xFFFF4500), // Vibrant orange background
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded button
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }





        //     Widget _buildCategory(String icon, String label) {
        //       return Column(
        //         children: [
        //           Container(
        //             padding: EdgeInsets.all(10),
        //             decoration: BoxDecoration(
        //               color: Color(0xFFF8F8F8),
        //               borderRadius: BorderRadius.circular(50),
        //               boxShadow: [
        //                 BoxShadow(
        //                   color: Colors.black.withOpacity(0.1),
        //                   blurRadius: 8,
        //                   offset: Offset(0, 2),
        //                 ),
        //               ],
        //             ),
        //             child: Text(
        //               icon,
        //               style: TextStyle(fontSize: 24),
        //             ),
        //           ),
        //           SizedBox(height: 5),
        //           Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color:Color.fromARGB(255, 5, 14, 61))),
        //         ],
        //       );
        //     }

        //     // Make sure this method is defined in the same class
        //   Widget _buildFilter(String label, {required bool isActive}) {
        //     return Container(
        //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        //       decoration: BoxDecoration(
        //         color: isActive ? Color.fromARGB(255, 5, 14, 61) : Colors.transparent,
        //         borderRadius: BorderRadius.circular(30),
        //       ),
        //       child: Text(
        //         label,
        //         style: TextStyle(
        //           fontSize: 14,
        //           fontWeight: FontWeight.bold,
        //           color: isActive ? Colors.white :Color.fromARGB(255, 5, 14, 61),
        //         ),
        //       ),
        //     );
        //   }
          
         }