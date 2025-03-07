
import 'package:flutter/material.dart';

class LockItem extends StatelessWidget{
   final String iconName;
   final String title;
   final int value;
   final void Function()? onTap;

   const LockItem({super.key,required this.iconName,required this.title,required this.value,this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
          children: [
            const SizedBox(height: 5),
            Image.asset(
              'assets/images/$iconName',
              width: 50,
              height: 50,
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 5),
            Text(title),
            Transform.scale(
              scale: 0.5,
              child: Switch(
                value: false,
                onChanged: (value) {
                },
              ),
            )
          ],
      ),
    );
  }


}