import 'package:flutter/material.dart';

class WelcomeButton extends StatefulWidget {
  const WelcomeButton(
      {super.key, this.buttonText, this.onTap, this.color, this.textColor});
  final String? buttonText;
  final Widget? onTap;
  final Color? color;
  final Color? textColor;

  @override
  _WelcomeButtonState createState() => _WelcomeButtonState();
}

class _WelcomeButtonState extends State<WelcomeButton>
    with SingleTickerProviderStateMixin {
  // Animation controller for the button slide-in effect
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  // Initial scale factor (normal size)
  double _scaleFactor = 1.0;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 4000), // Set the duration of the slide-in
    );

    // Define the slide animation
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1), // Start from below the screen
      end: Offset.zero, // End at the center
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut, // Smooth easing curve for the slide
    ));

    // Start the slide animation when the widget is first created
    _animationController.forward();
  }

  @override
  void dispose() {
    // Dispose of the animation controller when the widget is destroyed
    _animationController.dispose();
    super.dispose();
  }

  // Function to handle the tap and scale animation
  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scaleFactor = 0.95; // Scale down when pressed
    });
  }

  // Function to handle when the tap ends (restore the scale)
  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scaleFactor = 1.0; // Restore to original size
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown, // Detect when the tap starts
      onTapUp: _onTapUp, // Detect when the tap ends
      onTapCancel: () {
        setState(() {
          _scaleFactor = 1.0; // Reset if tap is canceled
        });
      },
      onTap: () {
        // Smooth page transition with custom animation
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              // Fade transition for the new page
              return FadeTransition(
                opacity: animation,
                child: widget.onTap!,
              );
            },
            transitionDuration: const Duration(
                milliseconds: 500), // Set the transition duration
            reverseTransitionDuration: const Duration(
                milliseconds: 500), // Reverse transition duration
          ),
        );
      },
      child: SlideTransition(
        position: _slideAnimation, // Apply the slide animation
        child: AnimatedScale(
          scale: _scaleFactor, // Apply the scaling effect
          duration:
              const Duration(milliseconds: 100), // Duration of the animation
          curve: Curves.easeInOut, // Smooth easing curve
          child: Container(
            padding: const EdgeInsets.all(28.0),
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(0),
              ),
            ),
            child: Text(
              widget.buttonText!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: widget.textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
