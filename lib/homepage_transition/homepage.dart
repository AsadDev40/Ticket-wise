import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:ticket_wise/Pages/login.dart';
import 'package:ticket_wise/Pages/signup.dart';
import 'package:ticket_wise/screens/home_screen.dart';
import 'package:ticket_wise/utils/utils.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  bool hide = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 30.0).animate(_scaleController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: const HomeScreen()));
            }
          });
  }

  Widget _buildOutlinedButton(
      {required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: FadeInUp(
        duration: const Duration(milliseconds: 1500),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/splash2.jpg'),
                fit: BoxFit.cover)),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
            Colors.black.withOpacity(.9),
            Colors.black.withOpacity(.4),
          ])),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    child: const Text(
                      "Ticket Voice Your Event Manager",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    )),
                const SizedBox(
                  height: 20,
                ),
                FadeInUp(
                    duration: const Duration(milliseconds: 1300),
                    child: const Text(
                      "Let’s start with our journey to unforgettable events..",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                const SizedBox(
                  height: 100,
                ),
                _buildOutlinedButton(
                  text: "Login",
                  onTap: () {
                    setState(() {
                      hide = true;
                    });
                    Utils.navigateTo(context, const LoginPage());
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildOutlinedButton(
                  text: "Create Account",
                  onTap: () {
                    Utils.navigateTo(context, const SignupPage());
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
