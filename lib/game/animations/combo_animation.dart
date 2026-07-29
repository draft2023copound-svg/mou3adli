import 'package:flutter/material.dart'; import '../utils/constants.dart'; import '../utils/extensions.dart';

class ComboAnimation extends StatefulWidget {
  final String text; final Color color; final double fontSize; final VoidCallback? onComplete;
  const ComboAnimation({super.key, required this.text, this.color = kWarningColor, this.fontSize = 32.0, this.onComplete});
  factory ComboAnimation.score(int score, {int? combo, VoidCallback? onComplete}) => ComboAnimation(text: combo != null && combo > 1 ? 'COMBO x$combo\n+${score.formatted}' : '+${score.formatted}', color: combo != null && combo > 2 ? kAccentColor : kSuccessColor, fontSize: combo != null && combo > 2 ? 40.0 : 28.0, onComplete: onComplete);
  factory ComboAnimation.perfectClear({VoidCallback? onComplete}) => ComboAnimation(text: 'PERFECT CLEAR!', color: kWarningColor, fontSize: 48.0, onComplete: onComplete);
  @override State<ComboAnimation> createState() => _ComboAnimationState();
}
class _ComboAnimationState extends State<ComboAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller; late Animation<double> _slide, _opacity, _scale;
  @override void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)); _slide = Tween<double>(begin: 0, end: -120).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.7, curve: Curves.easeOut))); _opacity = TweenSequence([TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1), weight: 15), TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1), weight: 50), TweenSequenceItem(tween: Tween<double>(begin: 1, end: 0), weight: 35)]).animate(_controller); _scale = TweenSequence([TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 1.2), weight: 20), TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 1.0), weight: 15), TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.0), weight: 65)]).animate(_controller); _controller.forward().then((_) => widget.onComplete?.call()); }
  @override void dispose() { _controller.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AnimatedBuilder(animation: _controller, builder: (context, child) => Opacity(opacity: _opacity.value, child: Transform.translate(offset: Offset(0, _slide.value), child: Transform.scale(scale: _scale.value, child: Text(widget.text, textAlign: TextAlign.center, style: TextStyle(fontSize: widget.fontSize, fontWeight: FontWeight.w900, color: widget.color, shadows: const [Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(2, 2))]))))));
}