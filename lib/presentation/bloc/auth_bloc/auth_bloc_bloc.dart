import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trade_loop/presentation/authentication/models/user_model.dart';
import 'package:trade_loop/repositories/auth_services.dart';
import 'package:trade_loop/repositories/user_repository.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBlocBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  final AuthServices _authServices = AuthServices();
  final UserRepository _userRepository = UserRepository();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isCheckingAuth = false;
  AuthBlocBloc() : super(AuthBlocInitial()) {
    //Log In Bloc
    on<LoginButtonPressed>((event, emit) async {
      emit(AuthLoading());
      try {
        _isCheckingAuth = true; // Prevent state handler from intervening
        await _authServices.signIn(event.email, event.password);
        emit(AuthSuccess());
      } catch (e) {
        if (e.toString().contains('banned')) {
          emit(const UserBanned(message: 'Your account has been banned.'));
        } else {
          emit(const AuthFailure(message: 'Login Failed'));
        }
      } finally {
        _isCheckingAuth = false;
      }
    });
    //Sign Up Bloc
    on<SignUpButtonPressed>((event, emit) async {
      emit(AuthLoading());
      try {
        UserCredential userCredential =
            await _authServices.signUp(event.email, event.password);
        final user = UserModel(
          uid: userCredential.user?.uid,
          email: event.email,
          name: event.name,
        );
        await _userRepository.storeUser(user);
        emit(AuthSuccess());
      } on FirebaseAuthException catch (e) {
        emit(AuthFailure(message: e.message ?? 'Sign Up Failed'));
      } catch (e) {
        emit(AuthFailure(message: 'Error storing user data: ${e.toString()}'));
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
        final userCredential = await _authServices.signInWithGoogle();
        if (userCredential != null && userCredential.user != null) {
          final user = UserModel(
            uid: userCredential.user!.uid,
            email: userCredential.user!.email!,
            name: userCredential.user!.displayName!,
          );
          await _userRepository.storeUser(user);
          emit(AuthSuccess());
        } else {
          emit(const AuthFailure(message: 'Google Sign-In failed'));
        }
      } on Exception catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    });
    //Log out bloc
    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authServices.signOut();
        emit(AuthLoggedOut());
      } catch (e) {
        emit(AuthFailure(message: 'Logout Failed: ${e.toString()}'));
      }
    });

    on<CheckAuthStatus>((event, emit) async {
      if (_isCheckingAuth) return;
      emit(AuthLoading());
      try {
        print('check status bloc is called');
        final user = _firebaseAuth.currentUser;
        if (user != null) {
          // Fetch user details from Firestore
          final userDetails = await _userRepository.getUser(user.uid);
          if (userDetails != null) {
            final isBanned = userDetails.isBanned ?? false;
            if (isBanned) {
              // If user is banned, emit UserBanned state
              emit(const UserBanned(message: 'Your account has been banned.'));
              // Optionally log out the user
              await _authServices.signOut();
            } else {
              // User is authenticated and not banned
              emit(AuthSuccess());
            }
          } else {
            // If user details are not found in Firestore, log them out
            await _authServices.signOut();
            emit(AuthLoggedOut());
          }
        } else {
          // If no user is signed in, emit logged out state
          emit(AuthLoggedOut());
        }
      } catch (e) {
        emit(AuthFailure(
            message: 'Failed to check authentication status: ${e.toString()}'));
      }
    });
  }
}
