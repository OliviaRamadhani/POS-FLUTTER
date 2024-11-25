  import 'package:flutter/material.dart';

  void main() {
    runApp(MyApp());
  }

  class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RecipeDetailScreen(),
      );
    }
  }

  class RecipeDetailScreen extends StatefulWidget {
    @override
    _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
  }

  class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
    bool _isExpanded = false; // To track whether the description is expanded

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  // Top Image
                  Image.asset(
                    'images/Gaeng Som.jpg', // Replace with your image
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                  // AppBar Actions
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Back Button with Bold Background Color
                          Container(
                            padding: EdgeInsets.all(8), // Padding around the icon
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(30), // Rounded corners for the background
                            ),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 0, 0, 0)),
                            ),
                          ),
                          Row(
                            children: [
                              // Favorite Button with Bold Background Color
                              Container(
                                padding: EdgeInsets.all(8), // Padding around the icon
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 255, 255, 255), // Darker and more solid background
                                  borderRadius: BorderRadius.circular(30), // Rounded corners for the background
                                ),
                                child: Icon(Icons.favorite_border, color: const Color.fromARGB(255, 0, 0, 0)),
                              ),
                              SizedBox(width: 16),
                              // Share Button with Bold Background Color
                              Container(
                                padding: EdgeInsets.all(8), // Padding around the icon
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 255, 255, 255), // Darker and more solid background
                                  borderRadius: BorderRadius.circular(30), // Rounded corners for the background
                                ),
                                child: Icon(Icons.share, color: const Color.fromARGB(255, 0, 0, 0)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Image Carousel
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5, // Replace with the number of images
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'images/P Aor.jpg', // Replace with your image
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              // Recipe Details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Gaeng Som Tam',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange),
                            Text(
                              '4.9',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Recipe by section
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Recipe by Dianne Russell', // Replace with the chef's name
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    // Chef Info
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('images/140.jpg'), // Replace with chef's image
                          radius: 20,
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dianne Russell',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Chef'),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.phone, color: Colors.orange),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.message, color: Colors.orange),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Description with curved edges and "See All" button
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20), // Curved corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gaeng Som Tam, or Spicy Green Curry with Papaya Salad, is a harmonious blend of green curry paste, sour tamarind, sweet palm sugar, and the essential fish sauce, creating a perfect balance of tangy and spicy flavors. The addition of shredded green papaya gives the dish a fresh crunch that contrasts beautifully with the rich, aromatic curry broth , It is usually served with steamed rice or sticky rice, making it the ideal meal for those who love bold flavors with a touch of sweetness. Gaeng Som Tam is not only delicious but also packed with nutrients from the fresh papaya, making it a healthy and satisfying dish.',
                            style: TextStyle(fontSize: 16),
                            maxLines: _isExpanded ? null : 3, // If expanded, show full text
                            overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis, // Show full text if expanded
                          ),
                          SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isExpanded = !_isExpanded; // Toggle the expanded state
                              });
                            },
                            child: Text(
                              _isExpanded ? 'See Less' : 'See All',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0), // Optional: Add vertical padding for spacing
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center the entire row
      children: [
        // Timer Column
        Expanded(  // Use Expanded to take all available space
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12), // Reduced padding for less space
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1), // Light orange background for the icon
                  borderRadius: BorderRadius.circular(16), // Rounded corners
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Ensure the row only takes as much space as needed
                  children: [
                    Icon(
                      Icons.timer,
                      color: Colors.orange,
                      size: 60, // Reduced icon size to make room
                    ),
                    SizedBox(width: 8), // Space between icon and text
                    Column( // Wrap the texts in a Column to stack them
                      crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                      children: [
                        Text(
                          'Time of All',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '45 min',
                          style: TextStyle(
                            fontSize: 18, // Slightly larger text size
                            fontWeight: FontWeight.bold,
                            color: Colors.orange, // Matching the icon color for consistency
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4), // Space between the icon and text
            ],
          ),
        ),
        SizedBox(width: 16), // Reduced space between the two columns

        // Cuisine Type Column
       Expanded(
  // Use Expanded to take all available space
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        padding: EdgeInsets.all(12), // Reduced padding for less space
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1), // Light orange background
          borderRadius: BorderRadius.circular(16), // Rounded corners
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
          children: [
            Text(
              'Best Food Of All', // Placeholder text if needed
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
            Text(
              'Good to cook when it rains',
              style: TextStyle(
                fontSize: 18, // Slightly larger text size
                fontWeight: FontWeight.bold,
                color: Colors.orange, // Consistent orange color
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 4), // Space between elements
    ],
  ),
),

      ],
    ),
  ),



          SizedBox(height: 16),
      // Ingredients
      Text(
        'Ingredients',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 8),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Papaya or other vegetables
          Row(
            children: [
              Icon(Icons.local_florist, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Green papaya, shredded (or use vegetables like carrots or green beans as alternatives).',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Curry paste
          Row(
            children: [
              Icon(Icons.local_dining, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Dried chilies, shallots, garlic, shrimp paste.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Protein (optional)
          Row(
            children: [
              Icon(Icons.set_meal, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Fish (commonly snakehead fish or mackerel), prawns (optional).',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Seasonings
          Row(
            children: [
              Icon(Icons.kitchen, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Tamarind paste or juice (for the sour flavor), palm sugar (for a slight sweetness), fish sauce (for saltiness).',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Other vegetables (optional)
          Row(
            children: [
              Icon(Icons.eco, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Bamboo shoots, green beans, or water mimosa, depending on regional styles.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Water or stock
          Row(
            children: [
              Icon(Icons.opacity, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Used as the base to simmer the curry.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
      SizedBox(height: 16),

                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
