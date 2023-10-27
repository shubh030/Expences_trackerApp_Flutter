import 'package:flutter/material.dart';
import 'package:expence_tracker/models/expence.dart';

class Expenceitem extends StatelessWidget {
  const Expenceitem(this.expence,{super.key});
   
  final Expence expence;
  @override
  Widget build(BuildContext context) {
    return Card(child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(expence.title,style:Theme.of(context).textTheme.titleLarge,),
          const SizedBox(height: 4,),
          Row(
            children: [
              Text('\₹${expence.amount.toStringAsFixed(2)}'),
             const Spacer(),
              Row(children: [
                Icon(CategoryIcons[expence.category]),
               const  SizedBox(width: 8,),
                Text(expence.FormatedDate),
              ],)
            ],
          ),
        ],
      ),
    ),);
  }
}