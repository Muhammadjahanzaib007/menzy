// // ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart' as auth;
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../Models/user.dart';
// import '../Services/api-service.dart';
// import '../Services/auth_service.dart';
// import '../Services/code_generator.dart';
// import '../Services/deep_link_service.dart';
// import '../main.dart';
// import '../utils/App-Contants.dart';
//
// class UserRepository  {
//   UserRepository._();
//   static UserRepository? _instance;
//
//   static UserRepository get instance {
//     _instance ??= UserRepository._();
//     return _instance!;
//   }
//
//   ValueNotifier<User> currentUserNotifier = ValueNotifier<User>(User.empty());
//
//   User? get user {
//     return currentUserNotifier.value;
//   }
//
//   listenToCurrentUser(String uid) {
//     final snapshot = FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
//     snapshot.listen((event) {
//       final user = User.fromJson(event.data() as Map<String, dynamic>);
//       currentUserNotifier.value = user;
//       notifyListenersUser();
//     });
//   }
//
//   Future<User?> logIn(String email, String password) async {
//     final authUser = await AuthService.instance?.logIn(email, password);
//     if (authUser != null) {
//       final user = await getUser(authUser.uid);
//       currentUserNotifier.value = user;
//       notifyListenersUser();
//       listenToCurrentUser(user.id);
//       return user;
//     } else {
//       return null;
//     }
//   }
//
//   Future<User?> registerUser(String name, String email, String password,String token, {String referrerCode = ''}) async    {
//     final uid = await AuthService.instance?.signUp(email, password);
//     addUser(name, email, uid??"",token,referrerCode: referrerCode);
//   }
//
//   Future<User?> addUser(String name, String email, String uid,String token, {String referrerCode = ''}) async    {
//     print("adduser code $referrerCode");
//     final referCode = CodeGenerator.generateCode('refer');
//     final referLink = await DeepLinkService.instance?.createReferLink(referCode);
//     await FirebaseFirestore.instance.collection('users').doc(uid).set({
//       'name': name,
//       'email': email,
//       'uid': uid,
//       'token': token,
//       'refer_link': referLink,
//       'refer_code': referCode,
//       "referral_code": referrerCode,
//       'reward': 0,
//     });
//     currentUserNotifier.value = await getUser(uid);
//     listenToCurrentUser(uid);
//     notifyListenersUser();
//
//     if (referrerCode.isNotEmpty) {
//       await rewardUser(uid, referrerCode);
//     }
//   }
//
//   Future<User> getUser(String uid) async {
//     DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
//     debugPrint("user Id ${userSnapshot.data()}");
//     if (userSnapshot.exists) {
//       return User.fromJson(userSnapshot.data() as Map<String, dynamic>);
//     } else {
//       return User.empty();
//     }
//   }
//
//   Future<User> getReferrerUser(String referCode) async {
//     final docSnapshots =
//         await FirebaseFirestore.instance.collection('users').where('refer_code', isEqualTo: referCode).get();
//
//     final userSnapshot = docSnapshots.docs.first;
//
//     if (userSnapshot.exists) {
//       return User.fromJson(userSnapshot.data());
//     } else {
//       return User.empty();
//     }
//   }
//
//   Future<void> rewardUser(String currentUserUID, String referrerCode) async {
//     try {
//       final referer = await getReferrerUser(referrerCode);
//
//       final checkIfUserAlreadyExist = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(referer.id)
//           .collection('referrers')
//           .doc(currentUserUID)
//           .get();
//
//       if (!checkIfUserAlreadyExist.exists) {
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(referer.id)
//             .collection('referrers')
//             .doc(currentUserUID)
//             .set({
//           "uid": currentUserUID,
//           "createdAt": DateTime.now().toUtc().millisecondsSinceEpoch,
//         });
//
//         await FirebaseFirestore.instance.collection('users').doc(referer.id).update({
//           "reward": FieldValue.increment(1),
//         });
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//   }
//
//
//   Future<void> listenToCurrentAuth() async {
//     print("Working");
//     print(UserRepository.instance.user?.email);
//     if (UserRepository.instance.user?.id == "") {
//       var fbUser = auth.FirebaseAuth.instance.currentUser;
//       if (fbUser == null) {
//         try {
//           fbUser = await auth.FirebaseAuth.instance.authStateChanges().first;
//           if (fbUser != null) {
//             currentUserNotifier.value = await getUser(fbUser.uid);
//             notifyListenersUser();
//           }
//         } catch (_) {}
//       }
//       if (fbUser == null) {
//         debugPrint("no  user");
//       } else {
//         final user = await getUser(fbUser.uid);
//         currentUserNotifier.value = user;
//         debugPrint(user.id);
//         listenToCurrentUser(user.id);
//         notifyListenersUser();
//       }
//     }
//   }
//
//   notifyListenersUser() {
//     currentUserNotifier.notifyListeners();
//   }
//
//   logOutUser() async {
//     currentUserNotifier.value = User.empty();
//     notifyListenersUser();
//     await AuthService.instance?.logOut();
//   }
// }
