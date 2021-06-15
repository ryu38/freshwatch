import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {

  const DashboardCard({ 
    Key? key,
    required this.content,
    this.backgroundColor
  }) :
    super(key: key);

  final Widget content;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xff000000).withOpacity(.05),
            blurRadius: 30,
          )
        ]
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: content,
        ),
      ),
    );
  }
}