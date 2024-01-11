import 'package:e_commerce/models/user.dart';
import 'package:e_commerce/provider/theme_provider.dart';
import 'package:e_commerce/provider/user_model_provider.dart';
import 'package:e_commerce/root_screen.dart';
import 'package:e_commerce/screens/loading_screen.dart';
import 'package:e_commerce/screens/orders/order_screen.dart';
import 'package:e_commerce/screens/product/viewed_recently.dart';
import 'package:e_commerce/screens/product/wish_list.dart';
import 'package:e_commerce/screens/regestration/log_in.dart';
import 'package:e_commerce/services/assets_handler.dart';
import 'package:e_commerce/services/methods.dart';
//import 'package:e_commerce/services/methods.dart';
import 'package:e_commerce/widgets/app_title.dart';
import 'package:e_commerce/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  bool isLoading = false;
  UserModel? userModel;
  Future<void> fetchUserInfo() async {
    final userProvider = Provider.of<UserModelProvider>(context);
    try {
      setState(() {
        isLoading = true;
      });
      userModel = await userProvider.getUserData();
    } catch (e) {
      // ignore: use_build_context_synchronously
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: e.toString(),
        fct: () {},
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeProvider = Provider.of<ThemeChanger>(context);
    return FutureBuilder(
        future: fetchUserInfo(),
        builder: (context, snapshot) {
          return LoadingManager(
            isLoading: isLoading,
            child: Scaffold(
              appBar: AppBar(
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    AssetsManager.shoppingCart,
                  ),
                ),
                title: const AppNameTextWidget(fontSize: 20),
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: user != null ? false : true,
                      child: const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: TitlesTextWidget(
                          label: 'Please login to have unlimited access',
                        ),
                      ),
                    ),
                    user == null
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).cardColor,
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        width: 3),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        userModel!.userImage,
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TitlesTextWidget(
                                        label: userModel!.userName),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    SubtitleTextWidget(
                                        label: userModel!.userEmail),
                                  ],
                                )
                              ],
                            ),
                          ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(
                            thickness: 1,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const TitlesTextWidget(
                            label: 'General',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: user == null ? false : true,
                            child: CustomListTile(
                              text: 'All Order',
                              imagePath: AssetsManager.orderSvg,
                              function: () {
                                Navigator.pushNamed(
                                    context, OrdersScreenFree.id);
                              },
                            ),
                          ),
                          Visibility(
                            visible: user == null ? false : true,
                            child: CustomListTile(
                              text: 'Wishlist',
                              imagePath: AssetsManager.wishlistSvg,
                              function: () {
                                Navigator.pushNamed(context, WishlistScreen.id);
                              },
                            ),
                          ),
                          CustomListTile(
                            text: 'Viewed recently',
                            imagePath: AssetsManager.recent,
                            function: () {
                              Navigator.pushNamed(
                                  context, ViewedRecentlyScreen.id);
                            },
                          ),
                          CustomListTile(
                            text: 'Address',
                            imagePath: AssetsManager.address,
                            function: () {
                              print(userModel!.userEmail);
                            },
                          ),
                          const SizedBox(height: 6),
                          const Divider(
                            thickness: 1,
                          ),
                          const SizedBox(height: 6),
                          const TitlesTextWidget(
                            label: 'Settings',
                          ),
                          const SizedBox(height: 10),
                          SwitchListTile(
                            secondary: Image.asset(
                              AssetsManager.theme,
                              height: 34,
                            ),
                            title: Text(themeProvider.isDark
                                ? 'Dark Mode'
                                : 'Light Mode'),
                            value: themeProvider.isDark,
                            onChanged: (value) {
                              themeProvider.setTheme(value);
                            },
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              30.0,
                            ),
                          ),
                        ),
                        icon: Icon(user == null ? Icons.login : Icons.logout),
                        label: Text(user == null ? 'Login' : 'LogOut'),
                        onPressed: () async {
                          if (user == null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          } else {
                            await MyAppFunctions.showErrorOrWarningDialog(
                                context: context,
                                subtitle: 'Are you sure you want to signout',
                                fct: () {
                                  setState(() {
                                    auth.signOut();
                                  });
                                  Navigator.pushReplacementNamed(
                                      context, RootScreen.id);
                                },
                                isError: false);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.imagePath,
    required this.text,
    required this.function,
  });
  final String imagePath, text;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        function();
      },
      title: SubtitleTextWidget(label: text),
      leading: Image.asset(
        imagePath,
        height: 34,
      ),
      trailing: const Icon(IconlyLight.arrowRight2),
    );
  }
}
