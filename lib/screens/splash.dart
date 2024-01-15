import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:works_book_user_app/common/style.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Image.asset(
                    kLogoImageUrl,
                    width: 80,
                  ),
                  const Text(
                    'オシゴト予定帳',
                    style: TextStyle(
                      color: kBaseColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  const Text(
                    '- スタッフ用 -',
                    style: TextStyle(
                      color: kGreyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
              const SpinKitFadingCircle(color: kBaseColor),
            ],
          ),
        ),
      ),
    );
  }
}
