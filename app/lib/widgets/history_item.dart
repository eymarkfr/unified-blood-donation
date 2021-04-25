import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ubd/models/user.dart';

class HistoryItem extends StatelessWidget {
  final DonationHistoryItem item;
  final DateFormat dateFormat;

  const HistoryItem({Key? key, required this.item, required this.dateFormat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: (){/*TODO*/},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(item.bloodBank.imageUrl ?? ""),
              radius: 40,
            ),
            SizedBox(width: 15,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.bloodBank.name, style: theme.textTheme.headline5, maxLines: 5,),
                  const SizedBox(height: 4,),
                  Text(dateFormat.format(item.date), style: theme.textTheme.subtitle2,)
                ],
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(Icons.chevron_right_sharp)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
