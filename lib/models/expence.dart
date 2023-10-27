import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

enum Category { food, travel, leisure, work }

const CategoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

class Expence {
  Expence(
      {required this.title,
      required this.amount,
      required this.date,
      required this.category})
      : id = uuid.v4();
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get FormatedDate {
    return formatter.format(date);
  }
}

class ExpenceBucket {
  const ExpenceBucket({required this.category, required this.expences});

  ExpenceBucket.forCategory(List<Expence> allExpences, this.category)
      : expences = allExpences
            .where((expence) => expence.category == category)
            .toList();

  final Category category;
  final List<Expence> expences;

  double get totalExpences {
    double sum = 0;
    for (var expence in expences) {
      sum += expence.amount;
    }

    return sum;
  }
}
