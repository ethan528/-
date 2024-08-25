import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:reading_buddy/model/Book.dart';
import 'package:reading_buddy/screen/login.dart';
import 'package:reading_buddy/service/adHelper.dart';
import 'package:reading_buddy/service/databaseSvc.dart';
import 'package:reading_buddy/widget/MyBannerAdWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
    prepareBookList();
  }

  // TODO: Add _interstitialAd
  InterstitialAd? _interstitialAd;

  // TODO: Implement _loadInterstitialAd()
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {},
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
  }

  Future<void> naverLogout() async {
    try {
      await FlutterNaverLogin.logOutAndDeleteToken().then((value) {
        print('logout successful');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Login(),
        ));
      });
    } catch (error) {}
  }

  Future<void> logout() async {
    bool logoutSuccessful = false;

    try {
      await UserApi.instance.logout();
      await naverLogout();
      logoutSuccessful = true;
      print('로그아웃 성공, SDK에서 토큰 삭제');
    } catch (error) {
      print('로그아웃 실패, SDK에서 토큰 삭제 $error');
    }

    try {
      FirebaseAuth.instance.signOut();
      logoutSuccessful = true;
    } catch (error) {
      print('Firebase 로그아웃 실패: $error');
    }

    if (logoutSuccessful) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Login(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              MyBannerAdWidget(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 120,
                  ),
                  IconButton(
                    onPressed: () => logout(),
                    icon: const Icon(
                      Icons.logout,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_interstitialAd != null) {
                        _interstitialAd?.show();
                      }
                    },
                    icon: const Icon(Icons.tv_rounded),
                  )
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                alignment: Alignment.center,
                child: _buildBookList(context, books),
              )
            ],
          ),
        ),
      ),
    );
  }

  void updateUIWithBooks(List<Book> newBooks) {
    if (mounted) {
      setState(() {
        books = newBooks;
      });
    }
  }

  void prepareBookList() {
    DatabaseSvc().readDB(updateUIWithBooks);

    // for (int i = 0; i < 5; i++) {
    //   var name = 'Book $i';
    //   var imgUrl = 'https://picsum.photos/id/10$i/200/200';
    //   var book = Book(name: name, imgUrl: imgUrl);
    //
    //   books.add(book);
    // }
  }

  _buildBookList(BuildContext context, List<Book> books) {
    return CarouselSlider.builder(
        itemCount: books.length,
        itemBuilder: (context, index, realIndex) {
          return buildBookCard(books[index]);
        },
        options: CarouselOptions(
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          initialPage: 2,
          viewportFraction: 0.35,
          enlargeStrategy: CenterPageEnlargeStrategy.scale,
          autoPlay: false,
        ));
  }

  buildBookCard(Book book) {
    return Container(
      margin: const EdgeInsets.all(1.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(1.0)),
        child: Stack(
          children: [
            Image.network(
              book.imgUrl,
              fit: BoxFit.contain,
              width: 140.0,
            )
          ],
        ),
      ),
    );
  }
}
