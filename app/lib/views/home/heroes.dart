import 'package:flutter/material.dart';
import 'package:ubd/models/user.dart';
import 'package:ubd/widgets/hero_card.dart';

class HeroesView extends StatefulWidget {
  @override
  _HeroesViewState createState() => _HeroesViewState();
}

class _HeroesViewState extends State<HeroesView> {

  String teamName = "Florida Blood Donors";
  List<UserProfile> _heroes = generateRandomUsers(6);

  Widget _getHeader(int livesSaved, int unitsDonated) {
    final theme = Theme.of(context);
    final headerStyle = theme.textTheme.subtitle2?.copyWith(color: theme.primaryColor);
    final contentStyle = theme.textTheme.headline3?.copyWith(fontWeight: FontWeight.bold);
    const verticalSpacer = SizedBox(height: 10,);
    return Container(
      height: 0.30 * MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(color: Color(0x280394AB), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/images/dummy_team.png"),
                SizedBox(width: 15,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("MY TEAM", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                      SizedBox(height: 10),
                      Text(teamName, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold), maxLines: 3,)
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20,),
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      Text("Lives saved", style: headerStyle,),
                      verticalSpacer,
                      Text(livesSaved.toString(), style: contentStyle),
                    ],
                  ),
                ),
              ),
              Container(width: 2.0, height: 40, decoration: BoxDecoration(color: Colors.black12),),
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      Text("Total units donated", style: headerStyle,),
                      verticalSpacer,
                      Text(unitsDonated.toString(), style: contentStyle),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }

  Widget _getListEntry(BuildContext context, int index, int totalUnits) {
    if(index == 0) {
      return _getHeader((totalUnits*0.612).toInt(), totalUnits);
    }
    if(index == 1) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: Text("Team heroes", style: Theme.of(context).textTheme.headline3?.copyWith(fontWeight: FontWeight.bold),),
      );
    }
    final hero = _heroes[index-2];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
      child: HeroCard(key: Key(hero.userId), hero: hero),
    );
  }

  @override
  Widget build(BuildContext context) {
    _heroes.sort((a,b)=>-(a.unitsDonated?.compareTo(b.unitsDonated ?? 0) ?? 0));
    int totalUnits = 0;
    for(var hero in _heroes) {
      totalUnits += hero.unitsDonated ?? 0;
    }
    return Container(
      child: ListView.builder(
        itemCount: _heroes.length + 2,
          itemBuilder: (context, index) => _getListEntry(context, index, totalUnits),
      )
    );
  }
}
