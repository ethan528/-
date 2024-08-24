import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:reading_buddy/main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Reading Buddy',
              style: GoogleFonts.getFont('Fuggles', fontSize: 40),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => signInWithGoogle(),
                    child: Card(
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      elevation: 2,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'images/google.png',
                              height: 30,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Sign In With Google',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 17),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  getKakaoLoginButton(),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                      onTap: () => signInAnonymously(),
                      child: const Text(
                        'Without Sign In',
                        style: TextStyle(color: Colors.grey, fontSize: 17),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getKakaoLoginButton() {
    return InkWell(
      onTap: () => signInWithKakao(),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        elevation: 2,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/kakao.png',
                // height: 30,
              ),
              // const SizedBox(
              //   width: 10,
              // ),
              // const Text(
              //   'Sign In With Kakao',
              //   style:
              //   TextStyle(color: Colors.grey, fontSize: 17),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signInAnonymously() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      print("userCredential $userCredential");
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const MyApp(),
      ));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
  }

  void navigateToMainPage() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const MyApp(),
    ));
  }

  Future<void> signInWithKakao() async {
    // 카카오 로그인 구현 예제

// 카카오톡 실행 가능 여부 확인
// 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk().then((value) {
          print('value from kakao $value');
          navigateToMainPage();
        });
        print('카카오톡으로 로그인 성공');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount().then((value) {
            print('value from kakao $value');
            navigateToMainPage();
          });
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        var provider = OAuthProvider('oidc.readingbuddy');
        var credential = provider.credential(
          idToken: token.idToken,
          accessToken: token.accessToken,
        );
        FirebaseAuth.instance.signInWithCredential(credential);
        navigateToMainPage();

        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  void signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      print(value.user?.uid);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const MyApp(),
      ));
    }).onError((error, stackTrace) {
      print('error $error');
    });
  }
}
