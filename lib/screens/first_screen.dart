import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/models/offering_wrapper.dart';
import 'package:rinlin/components/app_colors.dart';
import 'package:rinlin/components/custom_button.dart';
import 'package:rinlin/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:rinlin/components/base_screen.dart';
import 'package:rinlin/components/custom_container.dart';
import 'package:rinlin/purchase/purchase_api.dart';
import 'package:rinlin/screens/services/auth_service.dart';
import 'package:rinlin/state/user_state.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    getStorage();
    super.initState();
    getoffer();
  }

  getoffer() async {
    List<Offering> offerlist = await PurchaseApi.fetchOffersByIds(Coins.allIds);
    for (Offering product in offerlist) {
      print("Product ID: ${product.identifier}");
      print("Price: ${product.availablePackages.first.storeProduct.title}");
      print(
          "Title: ${product.availablePackages.first.storeProduct.description}");
    }
  }

  Future<void> getStorage() async {
    const storage = FlutterSecureStorage();
    // await storage.delete(key: 'accessToken');
    // await storage.delete(key: 'refreshToken');
    String? accessToken = await storage.read(key: 'accessToken');
    String? gender = await storage.read(key: 'gender');
    final result =
        await Provider.of<UserState>(context, listen: false).getIsRegistered();
    if (accessToken != null && gender != null && result == true) {
      if (int.parse(gender) == 1) {
        Navigator.pushNamed(context, "/malemypage");
      } else {
        Navigator.pushNamed(context, "/femalemypage");
      }
    }
  }

  // Utility function to generate a random nonce
  static String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  // Utility function to create SHA256 hash of a string
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> appleLogin(String clientid) async {
    try {
      String clientID = clientid;
      const String redirectURL =
          'https://valley-amplified-fright.glitch.me/callbacks/sign_in_with_apple';

      // Generate a raw nonce
      final rawNonce = generateNonce();
      // Create a SHA256 nonce for security
      final nonce = sha256ofString(rawNonce);

      // Sign in with Apple
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: Platform.isIOS ? nonce : null,
        webAuthenticationOptions: Platform.isIOS
            ? null
            : WebAuthenticationOptions(
                clientId: clientID,
                redirectUri: Uri.parse(redirectURL),
              ),
      );

      // Create Apple credential for Firebase Authentication
      final AuthCredential appleAuthCredential =
          OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: Platform.isIOS ? rawNonce : null,
        accessToken: Platform.isIOS ? null : appleCredential.authorizationCode,
      );

      // Sign in to Firebase with Apple credential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(appleAuthCredential);

      if (userCredential.user != null) {
      } else {
        // Handle case where user is null after sign in
        debugPrint("ERROR: User is null after sign in.");
      }
    } catch (e) {
      // Catch any errors that occur during sign-in process and print them
      debugPrint("ERROR: ${e.toString()}");
    }

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    print(credential);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: BaseScreen(
          child: Stack(
        children: [
          Center(
            child: CustomContainer(
              decoration: BoxDecoration(color: AppColors.primaryWhite),
              child: Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      height: 130,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage("assets/images/first_title.png"),
                              fit: BoxFit.cover)),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(top: 50),
                      decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: AssetImage("assets/images/logo.png"),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: CustomContainer(
              width: 375,
              height: 812,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 45),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (Platform.isAndroid)
                      CustomButton(
                          title: "Googleでサインイン",
                          width: 316,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: AppColors.primaryBlack,
                          // borderColor: AppColors.primaryBlue,
                          titleColor: AppColors.primaryWhite,
                          onTap: () async {
                            final googleAuthResult =
                                await AuthService().signInWithGoogle();

                            if (googleAuthResult != null &&
                                googleAuthResult["email"] != "") {
                              final isLogin = await Provider.of<UserState>(
                                      context,
                                      listen: false)
                                  .loginWithGoogle(
                                      googleAuthResult["displayName"],
                                      googleAuthResult["email"]);
                              if (isLogin) {
                                Navigator.pushNamed(context, "/loginhome");
                              } else {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (_) => Center(
                                            // Aligns the container to center
                                            child: Container(
                                          // A simplified version of dialog.
                                          width: 300,
                                          height: 150,
                                          padding:
                                              const EdgeInsets.only(top: 35),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: AppColors.primaryWhite),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Googleログインに失敗しました。",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color:
                                                        AppColors.primaryBlack,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 15,
                                                    letterSpacing: -1,
                                                    decoration:
                                                        TextDecoration.none),
                                              ),
                                              const SizedBox(
                                                height: 24,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Container(
                                                  width: 343,
                                                  height: 42,
                                                  margin: const EdgeInsets.only(
                                                      top: 5),
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          top: BorderSide(
                                                              color: AppColors
                                                                  .secondaryGray
                                                                  .withOpacity(
                                                                      0.5)))),
                                                  child: MaterialButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Center(
                                                      child: CustomText(
                                                          text: "OK",
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          lineHeight: 1,
                                                          letterSpacing: -1,
                                                          color: AppColors
                                                              .alertBlue),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )));
                              }
                            }
                          }),
                    if (Platform.isIOS)
                      CustomButton(
                          title: "Appleでサインイン",
                          width: 316,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: AppColors.primaryBlack,
                          // borderColor: AppColors.primaryBlue,
                          titleColor: AppColors.primaryWhite,
                          onTap: () async {
                            await appleLogin("");
                          }),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                        title: "LINEでログイン",
                        width: 316,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: AppColors.primaryGreen,
                        titleColor: AppColors.primaryWhite,
                        onTap: () async {
                          try {
                            final result = await LineSDK.instance.login();
                            if (result != null) {
                              final isLogin = await Provider.of<UserState>(
                                      context,
                                      listen: false)
                                  .loginWithLine(result.userProfile!.userId,
                                      result.userProfile!.displayName);
                              if (isLogin) {
                                Navigator.pushNamed(context, "/loginhome");
                              } else {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (_) => Center(
                                            // Aligns the container to center
                                            child: Container(
                                          // A simplified version of dialog.
                                          width: 300,
                                          height: 150,
                                          padding:
                                              const EdgeInsets.only(top: 35),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: AppColors.primaryWhite),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "LINEログインに失敗しました。",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color:
                                                        AppColors.primaryBlack,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 15,
                                                    letterSpacing: -1,
                                                    decoration:
                                                        TextDecoration.none),
                                              ),
                                              const SizedBox(
                                                height: 24,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Container(
                                                  width: 343,
                                                  height: 42,
                                                  margin: const EdgeInsets.only(
                                                      top: 5),
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          top: BorderSide(
                                                              color: AppColors
                                                                  .secondaryGray
                                                                  .withOpacity(
                                                                      0.5)))),
                                                  child: MaterialButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Center(
                                                      child: CustomText(
                                                          text: "OK",
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          lineHeight: 1,
                                                          letterSpacing: -1,
                                                          color: AppColors
                                                              .alertBlue),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )));
                              }
                            }
                          } on PlatformException catch (e) {
                            print("erororor${e.message.toString()}");
                          }
                        }),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // CustomButton(
                    //   title: "Facebookでログイン",
                    //   width: 316,
                    //   fontSize: 15,
                    //   fontWeight: FontWeight.normal,
                    //   color: AppColors.primaryBlue,
                    //   titleColor: AppColors.primaryWhite,
                    //   onTap: (){
                    //     Navigator.pushNamed(context, "/malemypage");
                    //   }
                    // ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                        title: "電話番号でサインイン",
                        width: 316,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: AppColors.darkGray,
                        titleColor: AppColors.primaryWhite,
                        onTap: () {
                          Navigator.pushNamed(context, "/phone");
                        }),
                    const SizedBox(
                      height: 46,
                    ),
                    CustomText(
                        text: "登録・ログインにお困りの方へ",
                        fontSize: 11,
                        fontWeight: FontWeight.normal,
                        lineHeight: 1,
                        letterSpacing: 1,
                        color: AppColors.primaryBlack),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
