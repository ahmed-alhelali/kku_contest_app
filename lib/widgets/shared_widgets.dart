import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/utilities/utilities.dart';

class Widgets {



  static Widget getContainerWithOnOnTap(ThemeProvider themeProvider, bool isLightTheme, Icon icon, String keyMap,
      TextDirection textDirection, BuildContext context,
      {Function onTap}) {
    return Padding(
      padding: textDirection == TextDirection.ltr
          ? EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.60,
            )
          : EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.60,
            ),
      child: InkWell(
        child: Align(
          alignment: AlignmentDirectional.topStart,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isLightTheme? AppTheme.lightTheme.scaffoldBackgroundColor : AppTheme.darkTheme.scaffoldBackgroundColor,
              borderRadius: textDirection == TextDirection.ltr
                  ? BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                    ),
            ),
            width: 150,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  icon,
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    MyLocalization.of(context).getTranslatedValue(keyMap),
                    style: textDirection == TextDirection.ltr
                        ? Utilities.getUbuntuTextStyleWithSize(13, color: themeProvider.themeColor(isLightTheme).textColor)
                        : Utilities.getTajwalTextStyleWithSize(13, color: themeProvider.themeColor(isLightTheme).textColor),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  static showWarringDialog(
      ThemeProvider themeProvider,bool isLightTheme,
    String keyTitle,
    String keyContent,
    BuildContext context,
    String yetText,
    String noText,
    Function functionOfYesButton,
    Function functionOfNoButton,
    TextDirection textDirection,
  ) {
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: isLightTheme? AppTheme.lightTheme.scaffoldBackgroundColor : AppTheme.darkTheme.scaffoldBackgroundColor,
      title: Text(
        MyLocalization.of(context).getTranslatedValue(keyTitle),
        style: textDirection == TextDirection.ltr
            ? Utilities.getUbuntuTextStyleWithSize(20, color: themeProvider.themeColor(isLightTheme).textColor)
            : Utilities.getTajwalTextStyleWithSize(20, color: themeProvider.themeColor(isLightTheme).textColor),
      ),
      content: Text(
        MyLocalization.of(context).getTranslatedValue(keyContent),
        style: textDirection == TextDirection.ltr
            ? Utilities.getUbuntuTextStyleWithSize(14, color: themeProvider.themeColor(isLightTheme).textColor)
            : Utilities.getTajwalTextStyleWithSize(14, color: themeProvider.themeColor(isLightTheme).textColor),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            elevation: 0,
            backgroundColor: HexColor("#5C704D"),
          ),
          child: Text(
            MyLocalization.of(context).getTranslatedValue(noText),
            style: textDirection == TextDirection.ltr
                ? Utilities.getUbuntuTextStyleWithSize(12)
                : Utilities.getTajwalTextStyleWithSize(12),
          ),
          onPressed: functionOfNoButton,
        ),
        TextButton(
          style: TextButton.styleFrom(
            elevation: 0,
            backgroundColor: HexColor("#A74552"),
          ),
          child: Text(
            MyLocalization.of(context).getTranslatedValue(yetText),
            style: textDirection == TextDirection.ltr
                ? Utilities.getUbuntuTextStyleWithSize(12)
                : Utilities.getTajwalTextStyleWithSize(12),
          ),
          onPressed: functionOfYesButton,
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (context) => alertDialog,
    );
  }

  static Widget getCoursesInDrawer(ThemeProvider themeProvider,bool isLightTheme,TextDirection textDirection) {
    CollectionReference courses =
        FirebaseFirestore.instance.collection("Courses");

    return StreamBuilder<QuerySnapshot>(
      stream: courses.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  MyLocalization.of(context)
                      .getTranslatedValue("error_connection"),
                  style: textDirection == TextDirection.ltr
                      ? Utilities.getUbuntuTextStyleWithSize(14, color: themeProvider.themeColor(isLightTheme).textColor)
                      : Utilities.getTajwalTextStyleWithSize(14, color: themeProvider.themeColor(isLightTheme).textColor),
                )
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          );
        }

        if (snapshot.data.size == 0) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  MyLocalization.of(context).getTranslatedValue("no_courses"),
                  style: textDirection == TextDirection.ltr
                      ? Utilities.getUbuntuTextStyleWithSize(14, color: themeProvider.themeColor(isLightTheme).textColor)
                      : Utilities.getTajwalTextStyleWithSize(14, color: themeProvider.themeColor(isLightTheme).textColor),
                )
              ],
            ),
          );
        }

        return ListView(
          padding: textDirection == TextDirection.ltr
              ? EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.5)
              : EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.5),
          children: snapshot.data.docs.map(
            (DocumentSnapshot document) {
              final currentCourse = document.data().values;
              // print(currentCourse);
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      currentCourse.first,
                      style: textDirection == TextDirection.ltr
                          ? Utilities.getUbuntuTextStyleWithSize(12, color: themeProvider.themeColor(isLightTheme).textColor)
                          : Utilities.getTajwalTextStyleWithSize(12, color: themeProvider.themeColor(isLightTheme).textColor),
                    ),
                  ),
                  SizedBox(
                    height: 0.5,
                    child: Container(color: Colors.grey),
                  ),
                ],
              );
            },
          ).toList(),
        );
      },
    );
  }
}
