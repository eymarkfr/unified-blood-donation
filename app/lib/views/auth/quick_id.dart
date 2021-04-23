import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QuickIdView extends StatefulWidget {
  @override
  _QuickIdViewState createState() => _QuickIdViewState();
}

class _QuickIdViewState extends State<QuickIdView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final containerSize = MediaQuery.of(context).size.width - 20;
    final qrSize = containerSize * 0.65;
    final imageSize = (containerSize - 0.5*qrSize) * 0.4;
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
                      Stack(
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
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(1000),
                                                child: Image.asset(
                                                  "assets/images/emily.png",
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Text("Emily Jones, 24", style: theme.textTheme.headline4?.copyWith(color: Colors.white),),
                                            SizedBox(height: 5,),
                                            Text("#ID390123", style: theme.textTheme.subtitle2?.copyWith(color: Colors.white),),
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
                                      data: "TODO",
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
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                    onPressed: (){
                      // TODO Cancel
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
