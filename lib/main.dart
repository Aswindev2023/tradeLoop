import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/presentation/authentication/widgets/auth_state_handler.dart';
import 'package:trade_loop/presentation/bloc/account_deletion_bloc/account_delete_bloc.dart';
import 'package:trade_loop/presentation/bloc/auth_bloc/auth_bloc_bloc.dart';
import 'package:trade_loop/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:trade_loop/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:trade_loop/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:trade_loop/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:trade_loop/repositories/auth_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final AuthServices authServices = AuthServices();
  runApp(MyApp(authServices: authServices));
}

class MyApp extends StatelessWidget {
  final AuthServices authServices;
  const MyApp({super.key, required this.authServices});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBlocBloc>(
          create: (BuildContext context) => AuthBlocBloc(authServices),
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
        BlocProvider<AccountDeleteBloc>(
          create: (context) => AccountDeleteBloc(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 30, 0, 255)),
          useMaterial3: true,
        ),
        home: const AuthStateHandler(),
      ),
    );
  }
}
