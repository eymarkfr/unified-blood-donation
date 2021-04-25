import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ubd/models/user.dart';
import 'package:ubd/widgets/safe_image.dart';

class QuickIdView extends StatefulWidget {
  @override
  _QuickIdViewState createState() => _QuickIdViewState();
}

class _QuickIdViewState extends State<QuickIdView> {

  Widget _getId(UserProfile user, double containerSize, double qrSize, ThemeData theme) {
    return Stack(
      children: [
        Center(
          child: Container(
              height: containerSize,
              width: containerSize,
              decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(10)),
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: containerSize - 0.5*qrSize,
                  child: Container(
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                            child: CircleAvatar(backgroundImage: getSafeImageProvider("assets/images/emily.png", user.imageUrl), radius:70,),
                          ),
                        ),
                        Column(
                          children: [
                            Text("${user.firstName} ${user.lastName}, ${user.getAge()}", style: theme.textTheme.headline4?.copyWith(color: Colors.white),),
                            SizedBox(height: 5,),
                            Text("#ID${user.userId}", style: theme.textTheme.subtitle2?.copyWith(color: Colors.white),),
                            SizedBox(height: 25,)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
          ),
        ),
        Column(
          children: [
            SizedBox(height: containerSize - 0.5*qrSize,),
            Center(
              child: Container(
                height: qrSize,
                width: qrSize,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/qr_background.png"),
                          fit: BoxFit.fill
                      )
                  ),
                  child: QrImage(
                    data: user.userId,
                    foregroundColor: theme.primaryColor,
                    backgroundColor: Colors.white,
                    gapless: false,
                    padding: EdgeInsets.all(0),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final containerSize = MediaQuery.of(context).size.width - 20;
    final qrSize = containerSize * 0.65;
    //final user = getUserDocument()
    return Scaffold(
      backgroundColor: Color(0xff676B73),
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: containerSize*0.5,
                        child: Text(
                          "Scan your QuickID for a faster registration process",
                          style: theme.textTheme.subtitle2?.copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 30,),
                      FutureBuilder(
                        future: getUserProfile(),
                          builder: (context, AsyncSnapshot<UserProfile?> profile) {
                              if(profile.hasData) {
                                return _getId(profile.data!, containerSize, qrSize, theme);
                              }
                              return Container();
                          }
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xfff4f4f4),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cancel_outlined, color: Colors.black,),
                        SizedBox(width: 8,),
                        Text("Close", style: TextStyle(color: Colors.black, fontSize: 14),)
                      ],
                    )
                ),
              ),
              SizedBox(height: 40,)
            ],
          )
        ),
      ),
    );
  }
}
