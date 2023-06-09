import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plancation/modules/another.dart';
import 'package:plancation/pages/home_diary/home_diary.dart';
import 'package:plancation/pages/home_my/home_my.dart';
import 'package:plancation/pages/home_todo/home_todo.dart';
import 'home_ai/home_ai.dart';
import 'home_calendar/home_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _widgetIndex = 0;

  @override
  Widget build(BuildContext context) {
    DateTime? backPressedTime;

    Future<bool> onWillPop() async {
      DateTime currentTime = DateTime.now();
      bool backButton = backPressedTime == null ||
          currentTime.difference(backPressedTime!) > const Duration(seconds: 3);

      if (backButton) {
        backPressedTime = currentTime;
        infoSnackBar(context, "한번 더 뒤로가기를 누르면 종료됩니다.");
        return false;
      }
      return true;
      SystemNavigator.pop(); 
    }

    return Scaffold(
        body: WillPopScope(
          onWillPop: onWillPop,
          child: IndexedStack(
            index: _widgetIndex,
            children: const [
              HomeCalendarComponent(),
              HomeTodoPage(),
              HomeAIPage(),
              HomeDiaryPage(),
              HomeMyComponent(),
            ],
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 200),
          items: [
            Icon(Icons.calendar_month,
                color: Theme.of(context).colorScheme.background),
            Icon(Icons.checklist,
                color: Theme.of(context).colorScheme.background),
            Icon(Icons.laptop, color: Theme.of(context).colorScheme.background),
            Icon(Icons.assignment,
                color: Theme.of(context).colorScheme.background),
            Icon(Icons.account_circle,
                color: Theme.of(context).colorScheme.background),
          ],
          height: 64,
          color: Theme.of(context).colorScheme.secondary,
          backgroundColor: Theme.of(context).colorScheme.background,
          onTap: (index) {
            setState(() {
              _widgetIndex = index;
            });
          },
        ));
  }
}
