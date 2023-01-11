import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:menzy/Controllers/auth-controller.dart';
import 'package:menzy/utils/App-Contants.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widget/app_button.dart';
import '../../utils/App-Colors.dart';
import '../../utils/App-TextStyle.dart';
import '../metaverse/metaverse.dart';

class OtpVerification extends StatefulWidget {
  final String email;
  const OtpVerification({Key? key, required this.email}) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class _OtpVerificationState extends State<OtpVerification> {
  GoogleSignInAccount? _currentUser;
  String _contactText = '';

  TextEditingController otpC = TextEditingController();

  bool showPass = true;
  bool showConfirmPass = true;
  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact(_currentUser!);
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = 'People API gave a ${response.statusCode} '
            'response. Check logs for details.';
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = 'I see you know $namedContact!';
      } else {
        _contactText = 'No contacts to display.';
      }
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final Map<String, dynamic>? name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 75,
                  ),
                ),
              ),
              Container(
                width: Get.width,
                height: 620,
                padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OTP Verification',
                      style: AppTextStyle.boldWhite34,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "An authorization code hase been\nsend to your email address",
                        style: AppTextStyle.mediumWhite14,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: Get.width,
                      child: PinCodeTextField(
                        maxLength: 4,
                        hideCharacter: false,
                        pinBoxColor: AppColors.white,
                        pinBoxRadius: 10,
                        defaultBorderColor: AppColors.white,
                        pinTextStyle: AppTextStyle.boldPrimary18,
                        hasTextBorderColor: AppColors.primary,
                        pinBoxHeight: 60,
                        pinBoxWidth: 53,
                        controller: otpC,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'I don’t recieve code ',
                          style: AppTextStyle.regularWhite12,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await EasyLoading.show();

                            var res = await AuthController().resendOTP(
                                context: context, email: widget.email);

                            EasyLoading.dismiss();
                          },
                          child: Text(
                            'Resend Code',
                            style: AppTextStyle.boldPrimary12,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 165,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppButton(
                              text: 'VERIFY NOW',
                              textColor: Colors.white,
                              borderSideColor: AppColors.lightPrimary,
                              overlayColor: AppColors.whiteSplash,
                              textStyle: AppTextStyle.boldWhite18,
                              height: 60,
                              onPressed: () async {
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                var userId = sharedPreferences
                                    .getInt(AppConstants.USER_ID);

                                await EasyLoading.show();

                                var res = await AuthController().verifyOTP(
                                    context: context,
                                    userId: int.parse(userId.toString()),
                                    otp: otpC.text);

                                EasyLoading.dismiss();
                                if (res != null) {
                                  sharedPreferences.setString(
                                      AppConstants.USER_NAME,
                                      res['result']['user_name']);
                                  sharedPreferences.setInt(AppConstants.USER_ID,
                                      res['result']['user_id']);
                                  sharedPreferences.setString(
                                      AppConstants.ACCESS_TOKEN,
                                      res['result']['token']);

                                  Get.offAll(() => MetaverseScreen());
                                }
                              }),
                          SizedBox(
                            height: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
