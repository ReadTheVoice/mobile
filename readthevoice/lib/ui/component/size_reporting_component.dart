import 'package:flutter/material.dart';

// class SizeReportingWidget extends StatefulWidget {
class SizeReportingComponent extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onSizeChange;

  const SizeReportingComponent({
    super.key,
    required this.child,
    required this.onSizeChange,
  });

  @override
  _SizeReportingComponentState createState() => _SizeReportingComponentState();
}

class _SizeReportingComponentState extends State<SizeReportingComponent> {
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
    return widget.child;
  }

  void _notifySize() {
    if (!mounted) {
      return;
    }
    final Size size = context.size!;
    if (_oldSize != size) {
      _oldSize = size;
      widget.onSizeChange(size);
    }
  }
}
