import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phoneotp/forms/forms_screen.dart';
import 'package:phoneotp/forms/seller_car_form.dart';
import 'package:phoneotp/forms/user_review_screen.dart';
import 'package:phoneotp/provider/cat_provider.dart';
import 'package:phoneotp/screens/categories/category_list.dart';
import 'package:phoneotp/screens/categories/subcat_screen.dart';
import 'package:phoneotp/screens/location_screen.dart';
import 'package:phoneotp/screens/login_screen.dart';
import 'package:phoneotp/screens/main_screen.dart';
import 'package:phoneotp/screens/phone_auth_screen.dart';
import 'package:phoneotp/screens/sellitems/seller_category_list.dart';
import 'package:phoneotp/screens/sellitems/seller_subcat.dart';
import 'package:phoneotp/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  runApp(MultiProvider(
    providers: [Provider(create: (_) => CategoryProvider())],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.cyan.shade900,
        fontFamily: 'Lato',
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        PhoneAuthScreen.id: (context) => PhoneAuthScreen(),
        LocationScreen.id: (context) => LocationScreen(
              popScreen: MainScreen.id,
            ),
        MainScreen.id: (context) => MainScreen(),
        CategoryListScreen.id: (context) => CategoryListScreen(),
        SubCatList.id: (context) => SubCatList(),
        SellerSubCatList.id: (context) => SellerSubCatList(),
        SellerCategory.id: (context) => SellerCategory(),
        SellerCarForm.id: (context) => SellerCarForm(),
        UserReviewScreen.id: (context) => UserReviewScreen(),
        FormScreen.id: (context) => FormScreen(),
      },
    );
  }
}

// FutureBuilder(
//       future: Future.delayed(const Duration(seconds: 10)),
//       builder: (context, AsyncSnapshot snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const MaterialApp(
//             debugShowCheckedModeBanner: false,
//             home: SplashScreen(),
//           );
//         } else {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             theme: ThemeData(
//               primaryColor: Colors.cyan.shade900,
//               fontFamily: 'Lato',
//             ),
//             home: LoginScreen(),
//             routes: {
//               LoginScreen.id: (context) => LoginScreen(),
//               PhoneAuthScreen.id: (context) => PhoneAuthScreen(),
//               LocationScreen.id: (context) => LocationScreen(),
//             },
//           );
//         }
//       },
//     );

