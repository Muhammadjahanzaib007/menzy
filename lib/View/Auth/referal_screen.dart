// import 'dart:io';
//
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_share_me/flutter_share_me.dart' as share;
// import 'package:get/get.dart';
// import 'package:menzy/View/metaverse/metaverse.dart';
// import 'package:menzy/Widget/app_button.dart';
// import 'package:menzy/Widget/app_text_field.dart';
// import 'package:menzy/Widget/social_icon_button.dart';
// import 'package:menzy/utils/App-Colors.dart';
// import 'package:menzy/utils/App-TextStyle.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:slider_button/slider_button.dart';
// import 'package:social_share_plugin/social_share_plugin.dart';
//
// class ReferalScreen extends StatefulWidget {
//   ReferalScreen({Key? key, this.showSlider}) : super(key: key);
//   final bool? showSlider;
//
//   @override
//   State<ReferalScreen> createState() => _ReferalScreenState();
// }
//
// class _ReferalScreenState extends State<ReferalScreen> {
//   bool viewSlider = true;
//   TextEditingController linkController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   final dynamicLinkParams = DynamicLinkParameters(
//     link: Uri.parse("https://menzy.io/"),
//     uriPrefix: "https://menzyapp.page.link",
//     androidParameters: const AndroidParameters(packageName: "com.menzy.io"),
//     iosParameters: const IOSParameters(bundleId: "com.menzy.io"),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//                SizedBox(
//                 height: 30,
//                 child: Align(alignment: Alignment.centerLeft,child: TextButton(onPressed: (){
//                   Get.back();
//                 }, child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Icon(Icons.arrow_back_ios,color: Colors.white,size: 20,),
//                     Text("back",style: AppTextStyle.boldWhite14,)
//                   ],
//                 ))),
//               ),
//               Align(
//                 alignment: Alignment.center,
//                 child: Container(
//                   margin: EdgeInsets.symmetric(vertical: 30),
//                   child: Image.asset(
//                     'assets/images/logo.png',
//                     width: 75,
//                   ),
//                 ),
//               ),
//               Text(
//                 ' MOVE TO EARN, EASY WITH',
//                 textAlign: TextAlign.center,
//                 style: AppTextStyle.boldPrimary14,
//               ),
//               Text(
//                 'MENZY',
//                 textAlign: TextAlign.center,
//                 style: AppTextStyle.boldWhite53,
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 'Share & Earn Stamina to Unlock',
//                 textAlign: TextAlign.center,
//                 style: AppTextStyle.boldWhite14,
//               ),
//               SizedBox(
//                 height: 5,
//               ),
//               Text(
//                 'Reach at 100% stamina by sharing\nMenzy with your friends',
//                 textAlign: TextAlign.center,
//                 style: AppTextStyle.regularWhite12,
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//               SizedBox(
//                 width: Get.width - 130,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     SocialIconButton(
//                       image: 'assets/images/telegram.png',
//                       onTap: () async {
//                         // final dynamicLink = await FirebaseDynamicLinks.instance.buildLink( dynamicLinkParams);
//                         // print(dynamicLink);
//
//                         String? response =
//                             await share.FlutterShareMe().shareToTelegram(
//                           msg: "Hey guys! check out this amazing app\n menzy.io",
//                         );
//                         print(response);
//                         if (response?.startsWith("false") ?? false) {
//                           Get.snackbar("Warning", response!.split(":").last,
//                               colorText: Colors.white);
//                         }
//                       },
//                     ),
//                     SocialIconButton(
//                       image: 'assets/images/twitter.png',
//                       onTap: () async {
//                         var response =  await SocialSharePlugin.shareToTwitterLink(text: 'Hey guys! check out this amazing app', url: 'https://menzy.io',);
//                         }
//                     ),
//                     SocialIconButton(
//                       image: 'assets/images/instagram.png',
//                       onTap: () async {
//                         final byteData =
//                             await rootBundle.load('assets/images/instapost.png');
//                         final file = File(
//                             '${(await getTemporaryDirectory()).path}/instapost.png');
//                         await file.writeAsBytes(byteData.buffer.asUint8List(
//                             byteData.offsetInBytes, byteData.lengthInBytes));
//                         String? response = await share.FlutterShareMe()
//                             .shareToInstagram(filePath: file.path);
//                         print("share   $response");
//                         if (response?.startsWith("false") ?? false) {
//                           Get.snackbar("Warning", response!.split(":").last,
//                               colorText: Colors.white);
//                         }
//                       },
//                     ),
//                     SocialIconButton(
//                       image: 'assets/images/facebook.png',
//                       onTap: () async {
//                         var response =  await SocialSharePlugin.shareToFeedFacebookLink(quote: 'Hey guys! check out this amazing app', url: 'https://menzy.io',);
//                        print(response);
//                       },
//                     ),
//                     SocialIconButton(
//                       image: 'assets/images/shareicon.png',
//                       onTap: () {
//                         share.FlutterShareMe().shareToSystem(
//                             msg: "Hey guys! check out this amazing app\n menzy.io");
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//               Text(
//                 'Drop link to add points:',
//                 textAlign: TextAlign.center,
//                 style: AppTextStyle.boldWhite14,
//               ),
//               Container(
//                 height: 56,
//                 width: Get.width,
//                 margin:
//                     const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
//                 decoration: BoxDecoration(
//                     color: Colors.transparent,
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: Colors.white, width: 2)),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: AppTextField(
//                         contentPadding:
//                             EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//                         borderRadius: 6,
//                         showBorder: false,
//                         bgColor: Colors.transparent,
//                         hint: 'Drop your link...',
//                         hintStyle: AppTextStyle.mediumLightGrey14,
//                         textStyle: AppTextStyle.boldWhite12,
//                         keyboardType: TextInputType.emailAddress,
//                         controller: linkController,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () async {
//                         ClipboardData? data =
//                             await Clipboard.getData('text/plain');
//                         setState(() {
//                           linkController.text = data?.text ?? '';
//                         });
//                       },
//                       child: Container(
//                         padding: EdgeInsets.all(15),
//                         child: Text(
//                           'Paste',
//                           style: AppTextStyle.mediumWhite16,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Padding(
//               //   padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
//               //   child: AppTextField(
//               //     hint: 'Link',
//               //     hintStyle: AppTextStyle.mediumLightGrey14,
//               //     textStyle: AppTextStyle.boldWhite12,
//               //   ),
//               // ),
//               AppButton(
//                 margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
//                 text: 'Send',
//                 height: 55,
//                 onPressed: () {
//                   if(linkController.text.isNotEmpty) {
//                     unityWidgetController?.postMessage('GameManager',
//                         'OnLinkShared', "1");
//                   }else{
//                     Get.snackbar("Warning", "Paste a link",colorText: Colors.white);
//                   }
//                   // Get.to(Login());
//                 },
//                 textColor: AppColors.white,
//                 overlayColor: AppColors.primarySplash,
//                 textStyle: AppTextStyle.boldWhite18,
//                 borderSideColor: AppColors.lightPrimary,
//               ),
//               Container(
//                 height: 56,
//                 width: Get.width,
//                 margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: Colors.transparent,
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: Colors.white, width: 2),
//                 ),
//                 child: Text(
//                   'Already have code',
//                   style: AppTextStyle.boldWhite16,
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Visibility(
//                 visible: widget.showSlider ?? true,
//                 child: SliderButton(
//                   action: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => MetaverseScreen()));
//                     setState(() {
//                       viewSlider = false;
//                     });
//                     print("working");
//                   },
//
//                   ///Put label over here
//                   label: Text("Swipe to Enter Trial Version",
//                       style: AppTextStyle.boldWhite14),
//
//                   icon: Image.asset(
//                     'assets/images/logo.png',
//                     width: 42,
//                   ),
//
//                   //Adjust effects such as shimmer and flag vibration here
//                   shimmer: true,
//                   vibrationFlag: true,
//
//                   ///Change All the color and size from here.
//                   width: Get.width * 0.8,
//                   height: 65,
//                   radius: 50,
//                   buttonColor: Colors.transparent,
//                   backgroundColor: AppColors.primary,
//                   highlightedColor: Colors.white,
//                   baseColor: Colors.white12,
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> linkshare ()async{
//     print("twitter successss");
//   }
//
// }
