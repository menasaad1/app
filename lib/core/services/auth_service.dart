import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;
  bool get isSignedIn => currentUser != null;
  String? get userId => currentUser?.uid;
  String? get userEmail => currentUser?.email;
  String? get userName => currentUser?.displayName;
  String? get userPhotoUrl => currentUser?.photoURL;

  // Initialize auth service
  Future<void> initialize() async {
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _saveUserSession(user);
      } else {
        _clearUserSession();
      }
    });
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      await _saveUserSession(credential.user!);
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('فشل في تسجيل الدخول: $e');
    }
  }

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name
      await credential.user?.updateDisplayName(displayName);
      await credential.user?.reload();
      
      await _saveUserSession(credential.user!);
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('فشل في إنشاء الحساب: $e');
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      await _saveUserSession(userCredential.user!);
      return userCredential;
    } catch (e) {
      throw Exception('فشل في تسجيل الدخول مع Google: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      await _clearUserSession();
    } catch (e) {
      throw Exception('فشل في تسجيل الخروج: $e');
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('فشل في إرسال رابط إعادة تعيين كلمة المرور: $e');
    }
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      await currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('فشل في تحديث كلمة المرور: $e');
    }
  }

  // Update display name
  Future<void> updateDisplayName(String displayName) async {
    try {
      await currentUser?.updateDisplayName(displayName);
      await currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('فشل في تحديث الاسم: $e');
    }
  }

  // Update email
  Future<void> updateEmail(String newEmail) async {
    try {
      await currentUser?.updateEmail(newEmail);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('فشل في تحديث البريد الإلكتروني: $e');
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    try {
      await currentUser?.delete();
      await _clearUserSession();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('فشل في حذف الحساب: $e');
    }
  }

  // Re-authenticate user
  Future<void> reauthenticate(String password) async {
    try {
      final credential = EmailAuthProvider.credential(
        email: currentUser!.email!,
        password: password,
      );
      await currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('فشل في إعادة المصادقة: $e');
    }
  }

  // Check if user is verified
  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      await currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('فشل في إرسال رابط التحقق: $e');
    }
  }

  // Get user profile
  Map<String, dynamic> getUserProfile() {
    if (currentUser == null) return {};
    
    return {
      'uid': currentUser!.uid,
      'email': currentUser!.email,
      'displayName': currentUser!.displayName,
      'photoURL': currentUser!.photoURL,
      'emailVerified': currentUser!.emailVerified,
      'creationTime': currentUser!.metadata.creationTime?.toIso8601String(),
      'lastSignInTime': currentUser!.metadata.lastSignInTime?.toIso8601String(),
    };
  }

  // Save user session
  Future<void> _saveUserSession(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', user.uid);
      await prefs.setString('user_email', user.email ?? '');
      await prefs.setString('user_name', user.displayName ?? '');
      await prefs.setString('user_photo', user.photoURL ?? '');
      await prefs.setBool('is_signed_in', true);
    } catch (e) {
      // Handle error silently
    }
  }

  // Clear user session
  Future<void> _clearUserSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');
      await prefs.remove('user_email');
      await prefs.remove('user_name');
      await prefs.remove('user_photo');
      await prefs.setBool('is_signed_in', false);
    } catch (e) {
      // Handle error silently
    }
  }

  // Handle auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'المستخدم غير موجود';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';
      case 'user-disabled':
        return 'تم تعطيل هذا الحساب';
      case 'too-many-requests':
        return 'تم تجاوز عدد المحاولات المسموح';
      case 'operation-not-allowed':
        return 'هذه العملية غير مسموحة';
      case 'requires-recent-login':
        return 'يجب تسجيل الدخول مرة أخرى';
      case 'invalid-credential':
        return 'بيانات الاعتماد غير صحيحة';
      case 'account-exists-with-different-credential':
        return 'يوجد حساب آخر بنفس البريد الإلكتروني';
      case 'credential-already-in-use':
        return 'بيانات الاعتماد مستخدمة بالفعل';
      case 'invalid-verification-code':
        return 'رمز التحقق غير صحيح';
      case 'invalid-verification-id':
        return 'معرف التحقق غير صحيح';
      case 'network-request-failed':
        return 'فشل في الاتصال بالشبكة';
      case 'timeout':
        return 'انتهت مهلة الاتصال';
      default:
        return 'حدث خطأ غير متوقع: ${e.message}';
    }
  }

  // Check if user has admin privileges
  Future<bool> isAdmin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('is_admin') ?? false;
    } catch (e) {
      return false;
    }
  }

  // Set admin privileges
  Future<void> setAdmin(bool isAdmin) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_admin', isAdmin);
    } catch (e) {
      // Handle error silently
    }
  }

  // Get user role
  Future<String> getUserRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('user_role') ?? 'user';
    } catch (e) {
      return 'user';
    }
  }

  // Set user role
  Future<void> setUserRole(String role) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_role', role);
    } catch (e) {
      // Handle error silently
    }
  }

  // Check if user can perform action
  Future<bool> canPerformAction(String action) async {
    try {
      final role = await getUserRole();
      final isAdminUser = await isAdmin();
      
      switch (action) {
        case 'add_bishop':
        case 'edit_bishop':
        case 'delete_bishop':
          return isAdminUser || role == 'editor';
        case 'view_reports':
        case 'export_data':
          return isAdminUser || role == 'viewer' || role == 'editor';
        case 'manage_users':
        case 'system_settings':
          return isAdminUser;
        default:
          return true;
      }
    } catch (e) {
      return false;
    }
  }

  // Get user permissions
  Future<List<String>> getUserPermissions() async {
    try {
      final role = await getUserRole();
      final isAdminUser = await isAdmin();
      
      if (isAdminUser) {
        return [
          'add_bishop',
          'edit_bishop',
          'delete_bishop',
          'view_reports',
          'export_data',
          'manage_users',
          'system_settings',
        ];
      }
      
      switch (role) {
        case 'editor':
          return [
            'add_bishop',
            'edit_bishop',
            'delete_bishop',
            'view_reports',
            'export_data',
          ];
        case 'viewer':
          return [
            'view_reports',
            'export_data',
          ];
        default:
          return [];
      }
    } catch (e) {
      return [];
    }
  }
}
