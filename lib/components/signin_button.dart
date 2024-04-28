import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {

  final Function()? onTap;

  const SignInButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(left: 28, right: 28),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
          ),
        child: const Center(
          child: Text(
            "Bejelentkezés",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}