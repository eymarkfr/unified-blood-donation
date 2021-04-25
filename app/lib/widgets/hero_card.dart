import 'package:flutter/material.dart';
import 'package:ubd/models/user.dart';

class HeroCard extends StatelessWidget {

  final User hero;

  const HeroCard({Key? key, required this.hero}) : super(key: key);

  Widget _topRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 7, 10, 8),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(hero.imageUrl), minRadius: 25,),
          const SizedBox(width: 20,),
          Text("${hero.firstName} ${hero.lastName}, ${hero.getAge()}", style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.w600),)
        ],
      ),
    );
  }

  Widget _bottomRow(BuildContext context) {
    final theme = Theme.of(context);
    final headerStyle = theme.textTheme.subtitle2?.copyWith(color: theme.primaryColor, fontSize: 13);
    final contentStyle = theme.textTheme.headline4?.copyWith(fontWeight: FontWeight.bold);
    const verticalSpacer = SizedBox(height: 5,);
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Column(
              children: [
                Text("Blood type", style: headerStyle,),
                verticalSpacer,
                Text(hero.bloodGroup, style: contentStyle),
              ],
            ),
          ),
        ),
        Container(width: 2.0, height: 40, decoration: BoxDecoration(color: Colors.black12),),
        Expanded(
          child: Center(
            child: Column(
              children: [
                Text("Units donated", style: headerStyle,),
                verticalSpacer,
                Text(hero.unitsDonated?.toString() ?? "0" , style: contentStyle),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _topRow(context),
            const SizedBox(height: 15,),
            _bottomRow(context)
          ],
        ),
      ),
    );
  }
}
