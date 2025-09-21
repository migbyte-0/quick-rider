import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class GradientContainer extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const GradientContainer({
    super.key,
    required this.child,
    this.borderRadius = 0.0,
    this.padding = const EdgeInsets.all(0.0),
    this.margin = const EdgeInsets.all(0.0),
  });

  @override
  State<GradientContainer> createState() => _GradientContainerState();
}

class _GradientContainerState extends State<GradientContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // fast animation
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Animate forward, then reverse once, then stop
    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Color> _animatedColors(double value) {
    return [
      Color.lerp(AppColors.secondary, AppColors.primary, value)!,
      Color.lerp(AppColors.secondary, AppColors.primary, value)!,
      Color.lerp(AppColors.primary, AppColors.secondary, value)!,
      Color.lerp(AppColors.primary, AppColors.secondary, value)!,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: double.infinity,
          width: double.infinity,
          margin: widget.margin,
          padding: widget.padding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: _animatedColors(_animation.value),
              stops: const [0.0, 0.1, 0.7, 1.0],
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: widget.child,
        );
      },
    );
  }
}
