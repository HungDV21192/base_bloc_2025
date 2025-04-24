import 'package:flutter/material.dart';

//Todo: Tạo hiệu ứng thu gọn Leen hoặc xuống
class ExpandedWidget extends StatefulWidget {
  final Widget child;
  final bool expand;
  final Axis axis;
  final int duration;

  const ExpandedWidget(
      {super.key,
      this.expand = false,
      required this.child,
      this.axis = Axis.vertical,
      this.duration = 300});

  @override
  // ignore: library_private_types_in_public_api
  _ExpandedWidgetState createState() => _ExpandedWidgetState();
}

class _ExpandedWidgetState extends State<ExpandedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.duration));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.ease,
    );
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        axisAlignment: 1.0,
        axis: widget.axis,
        sizeFactor: animation,
        child: widget.child);
  }
}
