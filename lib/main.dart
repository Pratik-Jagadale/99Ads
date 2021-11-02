import 'package:_99ads/providers/cat_provider.dart';
import 'package:_99ads/screens/autentication/withemail_screen.dart';
import 'package:_99ads/screens/autentication/withphone_screen.dart';
import 'package:_99ads/screens/home_screen.dart';
import 'package:_99ads/screens/location_screen.dart';
import 'package:_99ads/screens/login_screen.dart';
import 'package:_99ads/screens/main_screen.dart';
import 'package:_99ads/screens/product_details_screen.dart';
import 'package:_99ads/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'forms/forms_screen.dart';
import 'forms/seller_car_form.dart';
import 'providers/product_provider.dart';
import 'screens/SellItems/product_by_category_screen.dart';
import 'screens/SellItems/seller_category_list.dart';
import 'screens/SellItems/seller_subcat.dart';
import 'screens/category_screen/category_list.dart';
import 'screens/category_screen/subcat_screen.dart';
import 'forms/user_review_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  runApp(MultiProvider(
    providers: [
      Provider(create: (_) => CategoryProvider()),
      Provider(create: (_) => ProductProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.cyan.shade900, //Add new color
          fontFamily: 'arial' //add new font
          ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        PhoneAuthScreen.id: (context) => const PhoneAuthScreen(),
        Location_screen.id: (context) => const Location_screen(),
        HomeScreen.id: (context) => const HomeScreen(),
        EmailAuthScreen.id: (context) => const EmailAuthScreen(),
        CategoryListScreen.id: (context) => const CategoryListScreen(),
        SubCatList.id: (context) => const SubCatList(),
        SellerCategory.id: (context) => const SellerCategory(),
        SellerSubCatList.id: (context) => const SellerSubCatList(),
        SellerCarForm.id: (context) => const SellerCarForm(),
        UserReviewScreen.id: (context) => const UserReviewScreen(),
        MainScreen.id: (context) => const MainScreen(),
        FormsScreen.id: (context) => const FormsScreen(),
        ProductDetailsScreen.id: (context) => const ProductDetailsScreen(),
        ProductByCategory.id: (context) => const ProductByCategory(),
      },
    );
  }
}
