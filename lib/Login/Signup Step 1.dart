import 'package:flutter/material.dart';
import 'package:pharmacy_app/Login/Signup%20Step%202.dart';
import 'package:pharmacy_app/Login/Widgets.dart';

class SignupStep1 extends StatefulWidget {
  const SignupStep1({super.key});

  @override
  State<SignupStep1> createState() => _SignupStep1State();
}

class _SignupStep1State extends State<SignupStep1> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(step: 1, totalSteps: 3, percent: 0.33),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Create your account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Enter your personal information to begin with the marketplace.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              const CustomLabel(text: "Full Name"),
              const CustomTextField(
                  hintText: "Johnathan Doe", prefixIcon: Icons.person_outline),
              const SizedBox(height: 20),

              const CustomLabel(text: "Work Email"),
              const CustomTextField(
                  hintText: "john@pharmacy.com",
                  prefixIcon: Icons.alternate_email),
              const SizedBox(height: 20),

              const CustomLabel(text: "Phone Number"),
              const CustomTextField(
                  hintText: "+1 (555) 000-0000",
                  prefixIcon: Icons.phone_android),
              const SizedBox(height: 20),

              const CustomLabel(text: "Password"),
              CustomTextField(
                hintText: "Min. 8 characters",
                prefixIcon: Icons.lock_outline,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),

              // Password Strength Indicator
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child:
                          Container(height: 4, color: const Color(0xFF1DE9B6))),
                  const SizedBox(width: 5),
                  Expanded(
                      child: Container(height: 4, color: Colors.grey[300])),
                  const SizedBox(width: 5),
                  Expanded(
                      child: Container(height: 4, color: Colors.grey[300])),
                  const SizedBox(width: 10),
                  const Text("Strong",
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),

              const SizedBox(height: 40),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: RichText(
                    text: const TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                            text: "Log in",
                            style: TextStyle(
                                color: Color(0xFF1DE9B6),
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                text: "Next Step",
                icon: Icons.arrow_forward,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SignupStep2()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
