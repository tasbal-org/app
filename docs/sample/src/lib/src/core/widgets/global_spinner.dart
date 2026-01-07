import 'package:flutter/material.dart';
import 'package:qrino_admin/src/core/theme/app_theme.dart';

class GlobalSpinner extends StatelessWidget {
  final double size;
  final Color? color;

  const GlobalSpinner({
    super.key,
    this.size = 50.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.black45,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? AppTheme.getTheme().primaryColor,
            ),
            strokeWidth: 4.0,
          ),
        ),
      ),
    );
  }
}