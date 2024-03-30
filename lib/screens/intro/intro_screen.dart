//stl,
// stf
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:management_app/screens/authen_page/authen_page.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 13.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.only(top: 130),
      bodyAlignment: Alignment.center,
    );

    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      key: introKey,
      allowImplicitScrolling: true,
      // autoScrollDuration: 3000,
      // infiniteAutoScroll: true,
      globalHeader: Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: FractionallySizedBox(
                widthFactor: 0.5, // Điều chỉnh tỷ lệ rộng của ảnh
                child: _buildImageHeader('logocloudgo.png', 100),
              ),
            ),
          ),
        ),
      ),

      pages: [
        PageViewModel(
          title: "",
          bodyWidget: Column(children: [
            _buildImage('intro3.png'),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "Fractional shares",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
            const Text(
              "Instead of having to buy an entire share, invest any amount you want.",
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          ]),
          // body:
          //     "Instead of having to buy an entire share, invest any amount you want.",
          // image: _buildImage('intro1.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "",
          bodyWidget: Column(children: [
            _buildImage('intro2.png'),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "Fractional shares",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
            const Text(
              "Instead of having to buy an entire share, invest any amount you want.",
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          ]),
          // body:
          //     "Instead of having to buy an entire share, invest any amount you want.",
          // image: _buildImage('intro1.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "",
          bodyWidget: Column(children: [
            _buildImage('intro1.png'),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "Fractional shares",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
            const Text(
              "Instead of having to buy an entire share, invest any amount you want.",
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          ]),
          // body:
          //     "Instead of having to buy an entire share, invest any amount you want.",
          // image: _buildImage('intro1.png'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => goHomepage(context),
      onSkip: () => goHomepage(context),
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      skip: const Text(
        'Bỏ qua',
        style: TextStyle(color: Colors.black),
      ),
      next: const Icon(Icons.arrow_forward, color: Colors.black),
      done: const Text(
        'Bắt đầu',
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
      ),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.black,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset(
      'lib/assets/images/intro/$assetName',
      width: width,
    );
  }

  Widget _buildImageHeader(String assetName, [double width = 350]) {
    return Image.asset(
      'lib/assets/images/intro/$assetName',
      width: width,
    );
  }

  void goHomepage(context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
      return const AuthenPage();
    }), (Route<dynamic> route) => false);
    //Navigate to home page and remove the intro screen history
    //so that "Back" button wont work.
  }
}
