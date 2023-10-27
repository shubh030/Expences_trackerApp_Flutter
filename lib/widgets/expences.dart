import 'package:expence_tracker/widgets/expences_list/expences_list.dart';
import 'package:expence_tracker/widgets/new_expence.dart';
import 'package:flutter/material.dart';
import 'package:expence_tracker/models/expence.dart';
import 'package:expence_tracker/widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expence> _registeredExpences = [
    Expence(
        title: 'Flutter Cource',
        amount: 499,
        date: DateTime.now(),
        category: Category.work),
    Expence(
        title: 'Cinema',
        amount: 200,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void _openAddExpenceOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpence(OnAddExpence: _addExpence),
    );
  }

  void _addExpence(Expence expence) {
    setState(() {
      _registeredExpences.add(expence);
    });
  }

  void _removeExpence(Expence expence) {
    final expenceIndex =_registeredExpences.indexOf(expence);
    setState(() {
      _registeredExpences.remove(expence);
    });
    ScaffoldMessenger.of(context).clearSnackBars(); 
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expence Deleted'),
        action: SnackBarAction(label: 'Undo', onPressed: () {
          setState(() {
            _registeredExpences.insert(expenceIndex, expence);
          });
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // final height = MediaQuery.of(context).size.height;

    Widget mainContent = const Center(
      child: Text('No Expence Found . Start Adding Some!'),
    );
    if (_registeredExpences.isNotEmpty) {
      mainContent = ExpencesList(
          expences: _registeredExpences, onRemoveExpence: _removeExpence);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Expence Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenceOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width <600 ? Column(
        children: [
          Chart(expenses: _registeredExpences  ),
          
          Expanded(
            child: mainContent,
          ),
        ],
      ) : Row(children: [
          Expanded(child: Chart(expenses: _registeredExpences  )),
          
          Expanded(
            child: mainContent, 
          ),
        ], )
    );
  }
}
