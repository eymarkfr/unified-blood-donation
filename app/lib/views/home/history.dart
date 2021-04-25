import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ubd/models/user.dart';
import 'package:ubd/widgets/history_item.dart';

class HistoryView extends StatefulWidget {
  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final UserProfile user = generateRandomUsers(1)[0];

  @override
  Widget build(BuildContext context) {
    final items = user.getRandomHistroyForDemo(10).reversed.toList();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        children: [
          const SizedBox(height: 10,),
          Center(child: Text("My History", style: Theme.of(context).textTheme.headline4)),
          const SizedBox(height: 20,),
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(48, 20, 0, 20),
                  child: Container(
                    width: 3,
                    decoration: BoxDecoration(color: Colors.black38),
                  ),
                ),
                ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return HistoryItem(key: Key(item.date.toIso8601String()), item: item, dateFormat: DateFormat("MMMM d, y"),);
                  }
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
