import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trade_loop/features/authentication/repositories/auth_services.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBlocBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  final AuthServices _authServices;
  AuthBlocBloc(this._authServices) : super(AuthBlocInitial()) {
    //Log In Bloc
    on<LoginButtonPressed>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authServices.signIn(event.email, event.password);
        emit(AuthSuccess());
      } on FirebaseAuthException catch (e) {
        emit(AuthFailure(message: e.message ?? 'Login Failed'));
      }
    });
    //Sign Up Bloc
    on<SignUpButtonPressed>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authServices.signUp(event.email, event.password);
        emit(AuthSuccess());
      } on FirebaseAuthException catch (e) {
        emit(AuthFailure(message: e.message ?? 'Sign Up Failed'));
      }
    });
    //Password Reset Bloc
    on<ForgotPasswordEvent>((event, emit) async {
      emit((AuthLoading()));
      try {
        await _authServices.resetPassword(event.email);
        emit(PasswordResetSuccess());
      } on FirebaseAuthException catch (e) {
        emit(PasswordResetFailure(
            message: e.message ?? 'Password Reset Failed'));
      }
    });
    //Google Signin Bloc
    on<GoogleSignInButtonPressed>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authServices.signInWithGoogle();
        if (user != null) {
          emit(AuthSuccess());
        } else {
          emit(const AuthFailure(message: 'Google Sign-In failed'));
        }
      } on Exception catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    });
  }
}
