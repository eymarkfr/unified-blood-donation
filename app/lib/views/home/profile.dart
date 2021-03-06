import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ubd/models/user.dart';
import 'package:ubd/utils.dart';
import 'package:ubd/views/auth/sign_up.dart';
import 'package:ubd/views/quick_id.dart';
import 'package:image/image.dart' as ImageLibrary;
import 'package:ubd/widgets/basic_user_profile.dart';
import 'package:ubd/widgets/medical_user_profile.dart';

class ProfileView extends StatefulWidget {

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with SingleTickerProviderStateMixin {
  final _imageSize = 120.0;
  final _imagePicker = ImagePicker();
  List<dynamic> _appointments = [];
  TabController? _tabController;

  void _handleProfileImageEdit() async {
    final pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);
    if(pickedFile == null) return;
    final file = File(pickedFile.path);
    var image = ImageLibrary.decodeImage(file.readAsBytesSync());
    var thumbnail = ImageLibrary.copyResize(image!, width: 350);
    var storageRef = FirebaseStorage.instance
      .ref()
      .child("images")
      .child("${FirebaseAuth.instance.currentUser!.uid}.jpg");
    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});
    var uploadTask = storageRef.putData(Uint8List.fromList(ImageLibrary.encodeJpg(thumbnail, quality: 70)), metadata);
    var result = await uploadTask;
    getUserDocument()?.update({"imageUrl": await result.ref.getDownloadURL()});
  }

  Widget _getHeaderRow(UserProfile userProfile) {
    return Container(
      height: _imageSize*1.05,
      child: Row(
        children: [
          Expanded(child: InkWell(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SingUpPage()));
            },
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Icon(Icons.logout),
              ),
            ),
          )),
          Expanded(child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    child: Text(userProfile.initials(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                    foregroundImage: userProfile.imageUrl == null ? null : NetworkImage(userProfile.imageUrl!),
                    radius: _imageSize*0.5,
                  ),
                  Container(
                    height: _imageSize,
                    width: _imageSize,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        onPressed: _handleProfileImageEdit,
                        backgroundColor: Colors.white,
                        mini: true,
                        child: Icon(Icons.edit_outlined, color: Colors.black,),
                      )
                    ),
                  )
                ],
              )
            ],
          )),
          Expanded(child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Icon(Icons.settings_outlined),
            ),
          ))
        ],
      ),
    );
  }
  Widget _getInfoRow(String bloodType, int? unitsDonated) {
    final theme = Theme.of(context);
    final headerStyle = theme.textTheme.subtitle2?.copyWith(color: theme.primaryColor);
    final contentStyle = theme.textTheme.headline3?.copyWith(fontWeight: FontWeight.bold);
    const verticalSpacer = SizedBox(height: 10,);
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Column(
              children: [
                Text("Blood type", style: headerStyle,),
                verticalSpacer,
                Text(bloodType, style: contentStyle),
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
                Text(unitsDonated?.toString() ?? "10" , style: contentStyle),
              ],
            ),
          ),
        )
      ],
    );
  }
  Widget _getXPRow(int xp) {
    final level = getLevelFromXP(xp);
    final progress = getLevelProgress(xp);
    final xpUntilNext = getXPUntilNextLevel(xp);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      height: 60,
      child: Row(
        children: [
          getLevelIcon(level, 50, 50),
          const SizedBox(width: 30,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(text: TextSpan(
                  children: [
                    TextSpan(text: "Level $level    ", style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                    TextSpan(text: "$xp XP", style: Theme.of(context).textTheme.subtitle2)
                  ],
                )),
                SizedBox(height: 5,),
                LinearProgressIndicator(value: progress, backgroundColor: Colors.black12, valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),),
                SizedBox(height: 5,),
                Text("Next level $xpUntilNext XP", style: Theme.of(context).textTheme.subtitle2,),
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget _getQuickIDRow(UserProfile user) {
    final theme = Theme.of(context);
    final imageUrl = user.imageUrl;
    final age = user.getAge();
    final name = "${user.firstName} ${user.lastName}";
    const containerHeight = 90.0;
    const buttonHeight = 40.0;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Stack(
        children: [
          Container(
            height: containerHeight,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(color: theme.accentColor, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(child: Text(user.initials()), foregroundImage: imageUrl == null ? null : NetworkImage(imageUrl), radius: 0.25*containerHeight,),
                    SizedBox(width: 15,),
                    Text("$name, $age", style: theme.textTheme.headline4,)
                  ],
                )
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                const SizedBox(height: containerHeight - 0.5*buttonHeight,),
                Center(
                  child: SizedBox(
                    height: buttonHeight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>QuickIdView()));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.qr_code),
                          const SizedBox(width: 5,),
                          Text("See my QuickID", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        ],
                      )
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void openBasicUserProfile(UserProfile user) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return BasicUserProfile(
            user: user,
          );
        },
        isDismissible: true,
        backgroundColor: Colors.transparent);
  }

  void openMedicalUserProfile(UserProfile user) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return MedicalUserProfile(
            user: user,
          );
        },
        isDismissible: true,
        backgroundColor: Colors.transparent);
  }

  Widget _getProfileTab(UserProfile user) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.headline4?.copyWith(fontSize: 18);
    final textStyle = theme.textTheme.subtitle2;
    return Column(
      children: [
        InkWell(
          onTap: (){
            openBasicUserProfile(user);
          },
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 5,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(flex: 1, child: Image.asset("assets/icons/basic_item.png", fit: BoxFit.contain,)),
                SizedBox(width: 15,),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Basic", style: titleStyle),
                      const SizedBox(height: 10,),
                      Text("${user.firstName} ${user.lastName}", style: textStyle),
                      const SizedBox(height: 3,),
                      Text(DateFormat.yMMMd().format(user.birthday), style: textStyle)
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
                )
              ],
            ),
          ),
        ),
        InkWell(
          onTap: (){
            openMedicalUserProfile(user);
          },
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 5,
            child: Row(
              children: [
                Expanded(flex:1, child: Image.asset("assets/icons/personal_item.png")),
                SizedBox(width: 15,),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Personal", style: titleStyle),
                      const SizedBox(height: 10,),
                      Text("Height - ${user.heightFormatted()}", style: textStyle),
                      const SizedBox(height: 3,),
                      Text("Weight - ${user.weightFormatted()}", style: textStyle),
                      const SizedBox(height: 3,),
                      Text("BMI - ${user.bmiFormatted()}", style: textStyle)
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
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _getLeaderboardTab() {
    final builder = (Map<String, dynamic> appointment){
      final date = DateTime.parse(appointment['date'] as String);
      final bb = appointment['bloodBank'] as Map<String, dynamic>;
        return Container(
          child: Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(bb['imageUrl'] ?? ""),
                    radius: 40,
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat("E, d. MMMM y - hh:mm").format(date), style: Theme.of(context).textTheme.headline5,),
                        const SizedBox(height: 5,),
                        Text(bb['name'])
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
    };

    _appointments.sort((a, b){
      final dateA = a['date'] as String;
      final dateB = b['date'] as String;

      return dateA.compareTo(dateB);
    });
    return Column(
      children: _appointments.map((e)=>builder(e as Map<String, dynamic>)).toList(),
    );
  }

  Widget _getTabs(UserProfile user) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: "Profile"),
                  Tab(text: "Appointments",)
                ],
                indicatorColor: theme.primaryColor,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black38,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: [
                _getProfileTab(user),
                _getLeaderboardTab()
              ][_tabController?.index ?? 0]
            )
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: SingleChildScrollView(
        child: StreamBuilder(
          stream: getUserDocument()!.snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              final doc = snapshot.data as DocumentSnapshot;
              final user = UserProfile.fromJson(doc.data()!);
              return Column(
                children: [
                  const SizedBox(height: 10,),
                  _getHeaderRow(user),
                  const SizedBox(height: 20,),
                  _getInfoRow(user.bloodGroup, user.unitsDonated ?? 0),
                  const SizedBox(height: 20,),
                  _getXPRow(1200),
                  const SizedBox(height: 30,),
                  _getQuickIDRow(user),
                  const SizedBox(height: 30,),
                  _getTabs(user)
                ],
              );
            } else {
              return Container(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  _handleTabSelection() {
    if (_tabController?.indexIsChanging ?? false) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController?.addListener(_handleTabSelection);
    final docRef = getUserDocument();
    docRef?.get()
      .then((value) {
        setState(() {
          _appointments = value.data()!['appointments'] ?? [];
        });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
