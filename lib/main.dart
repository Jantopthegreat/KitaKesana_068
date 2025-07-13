import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitakesana/presentation/auth/login/bloc/login_bloc.dart';
import 'package:kitakesana/presentation/auth/register/bloc/register_bloc.dart';
import 'package:kitakesana/data/repositories/auth_repository.dart';
import 'package:kitakesana/data/repositories/place_repository.dart';
import 'package:kitakesana/presentation/auth/login_screen.dart';
import 'package:kitakesana/presentation/places/bloc/place_bloc.dart';
import 'package:kitakesana/services/place_service.dart';

void main() {
  runApp(const KitaKesanaApp());
}

class KitaKesanaApp extends StatelessWidget {
  const KitaKesanaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (_) => LoginBloc(AuthRepository())),
        BlocProvider<RegisterBloc>(
          create: (_) => RegisterBloc(authRepository: AuthRepository()),
        ),
        BlocProvider<PlaceBloc>(
          create: (_) =>
              PlaceBloc(placeService: PlaceService(PlaceRepository())),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KitaKesana!',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
        home: const LoginScreen(),
      ),
    );
  }
}
