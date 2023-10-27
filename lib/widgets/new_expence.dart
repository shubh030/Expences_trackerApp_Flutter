import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expence_tracker/models/expence.dart';

class NewExpence extends StatefulWidget {
  const NewExpence({super.key, required this.OnAddExpence});
  final void Function(Expence expence) OnAddExpence;

  @override
  State<NewExpence> createState() => _NewExpenceState();
}

class _NewExpenceState extends State<NewExpence> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentdatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenceData() {
    final enteredAmount = double.tryParse(_amountController
        .text); // tryparse ('Helow')=> null ,tryparse('1.2')=>1.2
    final amaountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    ;

    if (_titleController.text.trim().isEmpty ||
        amaountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ivalid Input'),
          content: const Text(
              'Plese Make Sure a vaild Amount Title a,Amount , Date and  category was Entered.'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okey'),),
          ],
        ),
      );
      return;
    }
    widget.OnAddExpence(Expence(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory),);
        Navigator.pop(context); 
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyBoardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder:(ctx, constraints){
      // final width =constraints.maxWidth;

      return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.fromLTRB(16,16,16,keyBoardSpace + 16),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      maxLength: 10,
                      decoration: const InputDecoration(
                        label: Text('Amount'),
                        prefixText: '₹',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'No Date Selected'
                            : formatter.format(_selectedDate!),
                      ),
                      IconButton(
                          onPressed: _presentdatePicker,
                          icon: const Icon(
                            Icons.calendar_month,
                          ),),
                    ],
                  ),),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  DropdownButton(
                      value: _selectedCategory,
                      items: Category.values
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(
                                 category.name.toUpperCase(),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedCategory = value;
                        });
                      }),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancle'),
                  ),
                  ElevatedButton(
                    onPressed: _submitExpenceData,
                    child: const Text('Save Expence '),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );

    });
 
  }
}
