import 'package:flutter/material.dart';

class PieceAppearAnimation extends StatefulWidget {
  final Widget child; final Duration duration; final VoidCallback? onComplete;
  const PieceAppearAnimation({super.key, required this.child, this.duration = const Duration(milliseconds: 250), this.onComplete});
  @override State<PieceAppearAnimation> createState() => _PieceAppearAnimationState();
}
class _PieceAppearAnimationState extends State<PieceAppearAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller; late Animation<double> _scale, _opacity;
  @override void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: widget.duration); _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut); _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)); _controller.forward().then((_) => widget.onComplete?.call()); }
  @override void dispose() { _controller.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AnimatedBuilder(animation: _controller, builder: (context, child) => Opacity(opacity: _opacity.value, child: Transform.scale(scale: _scale.value, child: widget.child)));
}

class PiecePulseAnimation extends StatefulWidget {
  final Widget child; final Duration duration;
  const PiecePulseAnimation({super.key, required this.child, this.duration = const Duration(milliseconds: 500)});
  @override State<PiecePulseAnimation> createState() => _PiecePulseAnimationState();
}
class _PiecePulseAnimationState extends State<PiecePulseAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller; late Animation<double> _scale;
  @override void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: widget.duration)..repeat(reverse: true); _scale = Tween<double>(begin: 1.0, end: 1.08).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)); }
  @override void dispose() { _controller.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AnimatedBuilder(animation: _controller, builder: (context, child) => Transform.scale(scale: _scale.value, child: widget.child), child: widget.child);
}