import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:menzy/Utils/App-Colors.dart';
import 'package:menzy/Utils/App-TextStyle.dart';
import 'package:menzy/View/Auth/login.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => Login()),
    );
  }

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/images/clock.png',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Column(
      children: [
        SizedBox(height: 30,),
        Image.asset('assets/images/logo.png', width: 75),
        Text("Menzy",style: AppTextStyle.mediumWhite20,),
        SizedBox(height: 20,),
        Expanded(child: Image.asset('assets/images/$assetName',fit: BoxFit.contain,)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 17.0,color: Colors.white);
    const subtitlestyle = TextStyle(fontSize: 17.0,color: Colors.white60);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700,color: Colors.white),
      bodyTextStyle: bodyStyle,
      imageFlex: 11,
      bodyFlex: 5,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: AppColors.background,
      imagePadding: EdgeInsets.zero,
      bodyAlignment: Alignment.center,
      imageAlignment: Alignment.topCenter,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: AppColors.background,
      isTopSafeArea: true,
      // globalFooter: SizedBox(
      //   width: double.infinity,
      //   height: 60,
      //   child: ElevatedButton(
      //     child: const Text(
      //       'Let\'s go right away!',
      //       style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      //     ),
      //     onPressed: () => _onIntroEnd(context),
      //   ),
      // ),
      pages: [
        PageViewModel(
          title: "Welcome to Menzy",
          bodyWidget:
          Column(
            children: [
              Text("We believe that everyone should be able to stay fit and healthy using deep tech AI technologies easily. ",style: bodyStyle,textAlign: TextAlign.center,),
              SizedBox(height: 10,),
              Text("Move to Earn easy, with Menzy",style: subtitlestyle,),
            ],
          ),
          image: _buildImage('intro1.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Making Fitness Fun!",
          bodyWidget:
          Column(
            children: [
              Text("Packed with fun and excited challenges designed specially for you!",style: bodyStyle,textAlign: TextAlign.center,),
              SizedBox(height: 10,),
              Text("Say NO to repetitive fitness workouts!",style: subtitlestyle,),
            ],
          ),
          image: _buildImage('intro2.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Let’s GO!",
          bodyWidget:
          Column(
            children: [
              Text("Our user friendly Menzy App allows you to earn while you get fit in a few simple steps. Sign in to learn more!",style: bodyStyle,textAlign: TextAlign.center,),
              SizedBox(height: 10,),
              Text("Start earning as you move!",style: subtitlestyle,),
            ],
          ),
          decoration: pageDecoration,
          image: _buildImage('intro3.png'),
          // reverse: true,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      // controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}