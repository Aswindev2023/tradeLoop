import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/firebase_options.dart';
import 'package:trade_loop/presentation/authentication/screens/banned_page.dart';
import 'package:trade_loop/presentation/authentication/screens/login_screen.dart';
import 'package:trade_loop/presentation/authentication/widgets/auth_state_handler.dart';
import 'package:trade_loop/presentation/bloc/auth_bloc/auth_bloc_bloc.dart';
import 'package:trade_loop/presentation/bloc/account_deletion_bloc/account_deletion_bloc.dart';
import 'package:trade_loop/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:trade_loop/presentation/bloc/category_selection_cubit/category_selection_cubit.dart';
import 'package:trade_loop/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:trade_loop/presentation/bloc/image_cubit/image_slider_cubit.dart';
import 'package:trade_loop/presentation/bloc/location_cubit/location_cubit.dart';
import 'package:trade_loop/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:trade_loop/presentation/bloc/message_bloc/message_bloc.dart';
import 'package:trade_loop/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:trade_loop/presentation/bloc/product_details_bloc/product_details_bloc.dart';
import 'package:trade_loop/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:trade_loop/presentation/bloc/recently_viewed_bloc/recently_viewed_bloc.dart';
import 'package:trade_loop/presentation/bloc/report_bloc/report_bloc.dart';
import 'package:trade_loop/presentation/bloc/boolean_cubit/bool_cubit.dart';
import 'package:trade_loop/presentation/bloc/seller_profile_bloc/seller_profile_bloc.dart';
import 'package:trade_loop/presentation/bloc/wishlist_bloc/wish_list_bloc.dart';
import 'package:trade_loop/presentation/home/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBlocBloc>(
          create: (BuildContext context) => AuthBlocBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(),
        ),
        BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc(),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
        ),
        BlocProvider<ProductDetailsBloc>(
          create: (context) => ProductDetailsBloc(),
        ),
        BlocProvider<RecentlyViewedBloc>(
          create: (context) => RecentlyViewedBloc(),
        ),
        BlocProvider<WishListBloc>(
          create: (context) => WishListBloc(),
        ),
        BlocProvider<SellerProfileBloc>(
          create: (context) => SellerProfileBloc(),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(),
        ),
        BlocProvider<MessageBloc>(
          create: (context) => MessageBloc(),
        ),
        BlocProvider<AccountDeletionBloc>(
          create: (context) => AccountDeletionBloc(),
        ),
        BlocProvider<ReportBloc>(
          create: (context) => ReportBloc(),
        ),
        BlocProvider<BoolCubit>(
          create: (context) => BoolCubit(),
        ),
        BlocProvider<ImageSliderCubit>(
          create: (context) => ImageSliderCubit(),
        ),
        BlocProvider<LocationCubit>(
          create: (context) => LocationCubit(),
        ),
        BlocProvider<CategorySelectionCubit>(
          create: (context) => CategorySelectionCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TradeLoop',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: appThemecol),
          useMaterial3: true,
        ),
        home: const AuthStateHandler(
          homePage: HomePage(),
          loginPage: LogIn(),
          bannedPage: BannedPage(),
        ),
      ),
    );
  }
}
