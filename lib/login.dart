import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketeasy/pages/busadmin/b_home.dart';
import 'package:ticketeasy/pages/manager/m_home.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'signup.dart'; // Assuming SignUpPage is in a file named signup.dart

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CollectionReference managers = FirebaseFirestore.instance.collection('managers');
  CollectionReference admins = FirebaseFirestore.instance.collection('admins');

  String? _errorMessage;
  bool isEmployee = false;

  @override
  void initState() {
    super.initState();
    _checkIfUserIsLoggedIn();
  }

Future<void> _checkIfUserIsLoggedIn() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    // User is signed in via Firebase Authentication
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String userType = prefs.getString('userType') ?? '';

    if (isLoggedIn) {
      if (userType == 'admin') {
        // Admin is signed in, navigate to 'homeadmin'
        Navigator.of(context).pushNamedAndRemoveUntil('homeadmin', (route) => false);
      } else if (userType == 'manager') {
        // Manager is signed in, navigate to 'homemanager'
        Navigator.of(context).pushNamedAndRemoveUntil('homemanager', (route) => false);
      } else {
        // Normal user is signed in, navigate to 'homepage'
        Navigator.of(context).pushNamedAndRemoveUntil('homepage', (route) => false);
      }
    }
  }
}

 Future<void> signInWithGoogle() async {
  try {
    final googleSignIn = GoogleSignIn();

    // Sign out before attempting to sign in
    await googleSignIn.signOut();

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      return; // The user canceled the sign-in
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = userCredential.user;

    if (user != null) {
      // Save email and username to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': user.email,
        'username': user.displayName,
      });
    }

    // Navigate to the next screen
    Navigator.of(context).pushNamedAndRemoveUntil('homepage', (route) => false);
  } catch (e) {
    setState(() {
      _errorMessage = 'Google sign-in failed. Please try again.';
    });
    print('Google sign-in error: $e');
  }
}

 Future<void> signInEmployee(String id, String password) async {
  try {
    QuerySnapshot managerSnapshot = await FirebaseFirestore.instance.collection('managers')
        .where('id', isEqualTo: id)
        .where('password', isEqualTo: password)
        .get();

    QuerySnapshot adminSnapshot = await FirebaseFirestore.instance.collection('admins')
        .where('id', isEqualTo: id)
        .where('password', isEqualTo: password)
        .get();

    if (managerSnapshot.docs.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userID', id);
      await prefs.setString('userName', managerSnapshot.docs.first['id']); // Save the actual name

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (adminSnapshot.docs.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userID', id);
      await prefs.setString('userName', adminSnapshot.docs.first['id']); // Save the actual name

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ScanPage()),
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid ID or Password';
      });
    }
  } catch (e) {
    setState(() {
      _errorMessage = 'Login failed. Please check your credentials.';
    });
    print('Employee sign-in error: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'images/logo.png',
              width: 53,
              height: 50,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Welcome! ",
                    style: TextStyle(
                      fontSize: 28,
                      color: Color.fromARGB(255, 92, 92, 124),
                      fontWeight: FontWeight.w800,
                      fontFamily: "Inter",
                    ),
                  ),
                  Text(
                    "Login now.",
                    style: TextStyle(
                      fontSize: 22,
                      color: Color.fromARGB(255, 92, 92, 124),
                      fontWeight: FontWeight.w600,
                      fontFamily: "Inter",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              ToggleSwitch(
                changeOnTap: true,
                minWidth: 90.0,
                cornerRadius: 10.0,
                activeBgColors: [
                  [Color.fromARGB(255, 230, 123, 0)],
                  [Color.fromARGB(255, 230, 123, 0)],
                ],
                customWidths: [180.0, 180.0],
                activeFgColor: Colors.white,
                inactiveBgColor: Color(0xFFEDEEEF),
                inactiveFgColor: Color(0xFF59597C),
                initialLabelIndex: isEmployee ? 1 : 0,
                totalSwitches: 2,
                labels: ['User', 'Employee'],
                radiusStyle: true,
                onToggle: (index) {
                  setState(() {
                    isEmployee = index == 1;
                  });
                },
              ),
              SizedBox(height: 40),
              Text(
                isEmployee ? '  ID number' : '  Email address',
                style: TextStyle(
                  color: Color(0xFF59597C),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Inter",
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Color(0xFFFD8DADC),
                  ),
                ),
                child: TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return isEmployee ? 'Please enter your ID number' : 'Please enter your email';
                    }
                    if (!isEmployee && (!value.contains('@') || !value.contains('.'))) {
                      return 'Invalid email format';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorText: _errorMessage,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                '  Password',
                style: TextStyle(
                  color: Color(0xFF59597C),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Inter",
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Color(0xFFFD8DADC),
                  ),
                ),
                child: TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  fixedSize: Size(50, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _errorMessage = null;
                  });
                  if (_formKey.currentState!.validate()) {
                    try {
                      if (isEmployee) {
                        await signInEmployee(emailController.text, passwordController.text);
                      } else {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        Navigator.of(context).pushReplacementNamed('homepage');
                      }
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        switch (e.code) {
                          case 'user-not-found':
                            _errorMessage = 'No user found for that email.';
                            break;
                          case 'wrong-password':
                            _errorMessage = 'Wrong password provided.';
                            break;
                          case 'invalid-email':
                            _errorMessage = 'Invalid email format.';
                            break;
                          default:
                            _errorMessage = 'Login failed. Please check your credentials.';
                            break;
                        }
                      });
                    } catch (e) {
                      setState(() {
                        _errorMessage = 'Login failed. Please try again.';
                      });
                      print('General sign-in error: $e');
                    }
                  }
                },
                child: const Text(
                  'Log in',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 40),
              if (!isEmployee) ...[
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        color: Color.fromARGB(255, 218, 218, 218),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Or Login With',
                        style: TextStyle(
                          color: Color.fromARGB(255, 148, 148, 148),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Color.fromARGB(255, 218, 218, 218),
                        thickness: 2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: InkWell(
                    onTap: () {
                      signInWithGoogle();
                    },
                    child: Image.asset(
                      'images/google.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpPage()),
                        );
                      },
                      child: const Text('Sign up'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
