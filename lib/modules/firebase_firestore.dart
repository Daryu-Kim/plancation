import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:plancation/modules/firebase_login.dart';
import 'package:plancation/modules/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreManage {
  Future<bool> createUser(String uid, String name, BuildContext context) async {
    try {
      final credential =
          await FirebaseFirestore.instance.collection("Users").doc(uid).set({
        'userID': uid,
        'userName': name,
        'userImagePath': AuthManage().getUser()!.photoURL
      });
      final calendar = await FirebaseFirestore.instance
          .collection("Calendars")
          .doc(uid)
          .set({
        'calenderID': uid,
        'calendarTitle': "개인",
        'calendarUsers': [uid],
        'calendarAuthorID': uid,
      });
    } on FirebaseException catch (e) {
      Logger().e(e);
      return false;
    }
    return true;
  }

  Future<bool> updateUserImage(String? path) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(AuthManage().getUser()?.uid.toString())
          .update({'userImagePath': path});
      return true;
    } catch (e) {
      Logger().e(e);
      return false;
    }
  }

  Future<bool> updateUserName(String name) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(AuthManage().getUser()?.uid.toString())
          .update({'userName': name});
      return true;
    } catch (e) {
      Logger().e(e);
      return false;
    }
  }

  Future<List?> getCalendarUsers(String calendarID) async {
    try {
      await FirebaseFirestore.instance
          .collection('Calendars')
          .doc(calendarID)
          .get()
          .then((value) {
        List<String> resultData = value.get('calendarUsers') as List<String>;
        Logger().e(resultData);
        return resultData;
      });
    } catch (e) {
      Logger().e(e);
      return null;
    }
    return null;
  }

  Future<dynamic> getDiaryAuthorName(String authorID) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(authorID)
          .get()
          .then((value) {
        return value.get('userName');
      });
    } catch (e) {
      Logger().e(e);
      return;
    }
  }

  Future<String> createDiary(String title, String content) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String calendarID = "";

      if (prefs.getString("selectedCalendarID") != null) {
        calendarID = prefs.getString("selectedCalendarID")!;
      } else {
        calendarID = AuthManage().getUser()!.uid;
      }

      final credential = await FirebaseFirestore.instance
          .collection("Calendars")
          .doc(calendarID)
          .collection("Posts")
          .add({
        'postTime': Timestamp.fromDate(DateTime.now()),
        'postTitle': title,
        'postContent': content,
        'postAuthorID': AuthManage().getUser()!.uid
      });
      await FirebaseFirestore.instance
          .collection("Calendars")
          .doc(calendarID)
          .collection("Posts")
          .doc(credential.id)
          .update({'postID': credential.id});
      return credential.id;
    } catch (e) {
      Logger().e(e);
      return "";
    }
  }

// fromDate ( date :  Date ) : Timestamp

  Future<String> modifyDiary(String id, String title, String content) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String calendarID = "";

      if (prefs.getString("selectedCalendarID") != null) {
        calendarID = prefs.getString("selectedCalendarID")!;
      } else {
        calendarID = AuthManage().getUser()!.uid;
      }

      await FirebaseFirestore.instance
          .collection("Calendars")
          .doc(calendarID)
          .collection("Posts")
          .doc(id)
          .update({
        'postTitle': title,
        'postContent': content,
      });
      return id;
    } catch (e) {
      Logger().e(e);
      return "";
    }
  }

  Future<bool> deleteDiary(String postID, String? postImagePath) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String calendarID = "";

      if (prefs.getString("selectedCalendarID") != null) {
        calendarID = prefs.getString("selectedCalendarID")!;
      } else {
        calendarID = AuthManage().getUser()!.uid;
      }

      if (postImagePath != null) {
        await StorageManage().deleteDiaryImage(calendarID, postID);
      }
      final credential = await FirebaseFirestore.instance
          .collection("Calendars")
          .doc(calendarID)
          .collection("Posts")
          .doc(postID)
          .delete();
      return true;
    } catch (e) {
      Logger().e(e);
      return false;
    }
  }

  Future<bool> updateDiaryImage(String id, String? path) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String calendarID = "";

      if (prefs.getString("selectedCalendarID") != null) {
        calendarID = prefs.getString("selectedCalendarID")!;
      } else {
        calendarID = AuthManage().getUser()!.uid;
      }

      await FirebaseFirestore.instance
          .collection("Calendars")
          .doc(calendarID)
          .collection("Posts")
          .doc(id)
          .update({'postImagePath': path});
      return true;
    } catch (e) {
      Logger().e(e);
      return false;
    }
  }

  Future<dynamic> getDiaryItems() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String calendarID = "";
      List<Map> resultDiaryItem;

      if (prefs.getString("selectedCalendarID") != null) {
        calendarID = prefs.getString("selectedCalendarID")!;
      } else {
        calendarID = AuthManage().getUser()!.uid;
      }
      await FirebaseFirestore.instance
          .collection("Calendars")
          .doc(calendarID)
          .collection("Posts")
          .get()
          .then((querySnapshot) async {
        resultDiaryItem = querySnapshot.docs.map((doc) => doc.data()).toList();
        return resultDiaryItem;
      });
    } on FirebaseException catch (e) {
      Logger().e(e);
    }
  }

//할 일 추가
  Future<bool> createTodo(DateTime startTime, DateTime endTime,
      String todoTitle, String selectUsers, Map alert) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String calendarID = "";

      if (prefs.getString("selectedCalendarID") != null) {
        calendarID = prefs.getString("selectedCalendarID")!;
      } else {
        calendarID = AuthManage().getUser()!.uid;
      }

      final credential = await FirebaseFirestore.instance
          .collection("Calendars")
          .doc(calendarID)
          .collection("Events")
          .add({
        'eventSTime': Timestamp.fromDate(startTime), //시작날짜와 시간
        'eventETime': Timestamp.fromDate(endTime), //종료날짜와 시간
        'eventTitle': todoTitle, //할 일 제목
        'eventUsers': [selectUsers], //할 일 이벤트 참여자 고유 uid를 담아야돼요
        'eventAlerts': alert, // 알림
        'eventAuthorID': AuthManage().getUser()!.uid, //이벤트 제작자 고유 ID
        'eventTodo': true, //true 면 할 일, false 면 일정
        'eventCheckedUsers': [], // 할 일 체크 초기설정 [] 빈 배열 - 완료되면 완료된 사람의 Uid 담기
      });
      await FirebaseFirestore.instance
          .collection("Calendars")
          .doc(calendarID)
          .collection("Events")
          .doc(credential.id)
          .update(
              {'eventID': credential.id}); //eventID 랜덤으로 들어갔던 것도 업데이트로 필드에 추가하기

      return true;
    } catch (e) {
      Logger().e(e);
      return false;
    }
  }
}

// //할 일 만든 작자 가져오기
// Future<dynamic> getTodoAuthorName(String authorID) async {
//   try {
//     await FirebaseFirestore.instance
//         .collection('Users')
//         .doc(authorID)
//         .get()
//         .then((value) {
//       return value.get('userName');
//     });
//   } catch (e) {
//     Logger().e(e);
//     return;
//   }
// }
