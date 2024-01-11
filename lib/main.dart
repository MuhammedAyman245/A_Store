import 'package:e_commerce/const/theme_style.dart';
import 'package:e_commerce/provider/cart.dart';
import 'package:e_commerce/provider/products.dart';
import 'package:e_commerce/provider/theme_provider.dart';
import 'package:e_commerce/provider/user_model_provider.dart';
import 'package:e_commerce/provider/viewed_product.dart';
import 'package:e_commerce/provider/wish_list.dart';
import 'package:e_commerce/screens/product/product_details.dart';
import 'package:e_commerce/screens/product/viewed_recently.dart';
import 'package:e_commerce/screens/product/wish_list.dart';
import 'package:e_commerce/screens/regestration/forget_pass.dart';
import 'package:e_commerce/screens/regestration/log_in.dart';
import 'package:e_commerce/screens/regestration/register.dart';
import 'package:e_commerce/screens/search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce/root_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ));
          } else if (snapshot.hasError) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: Center(
                    child: SelectableText(snapshot.toString()),
                  ),
                ));
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return ThemeChanger();
              }),
              ChangeNotifierProvider(create: (_) {
                return ProductProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return CartProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return WishListProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return ViewdRecentlyProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return UserModelProvider();
              }),
            ],
            child: Consumer<ThemeChanger>(
                builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'ShopSmart EN',
                theme: Styles.themeData(
                    isDarkTheme: themeProvider.themeState, context: context),
                home: const RootScreen(),
                routes: {
                  RootScreen.id: (context) => const RootScreen(),
                  ProductDetailsScreen.id: (context) =>
                      const ProductDetailsScreen(),
                  WishlistScreen.id: (context) => const WishlistScreen(),
                  ViewedRecentlyScreen.id: (context) =>
                      const ViewedRecentlyScreen(),
                  RegisterScreen.id: (context) => const RegisterScreen(),
                  LoginScreen.id: (context) => const LoginScreen(),
                  ForgotPasswordScreen.id: (context) =>
                      const ForgotPasswordScreen(),
                  SearchScreen.id: (context) => const SearchScreen(),
                },
              );
            }),
          );
        });
  }
}
