import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart' as flutter_provider;

import '../../app_theme.dart';
import '../../providers/auth_flow_provider.dart';
import '../../providers/user_provider.dart';
import '../../routes/routes.dart';
import '../../widgets/auth_layout.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final workspaceController = TextEditingController(text: 'acmecorp');
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();
  bool hidePassword = true;

  @override
  void dispose() {
    workspaceController.dispose();
    emailController.dispose();
    passwordController.dispose();
    otpController.dispose();
    super.dispose();
  }

  void _requestOtp(AuthFlowProvider flow) {
    final email = emailController.text.trim();
    final password = passwordController.text;
    const testEmail = 'user@gmail.com';
    const testPassword = '123456';
    final registered = ref.read(userProvider.notifier).validateLogin(email, password);
    flow.requestOtp(
      email: email,
      password: password,
      credentialsValid: (email == testEmail && password == testPassword) || registered,
    );
  }

  void _verifyOtp(AuthFlowProvider flow) {
    if (flow.verifyOtp(otpController.text)) {
      ref.read(userProvider.notifier).login(emailController.text.trim());
      context.go(AppRoutes.admin);
    }
  }

  @override
  Widget build(BuildContext context) {
    final flow = flutter_provider.Provider.of<AuthFlowProvider>(context);
    return AuthLayout(
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('STEP ${flow.otpRequested ? '2' : '1'} OF 3 · ${flow.otpRequested ? 'VERIFY' : 'IDENTIFY'}',
                style: const TextStyle(fontSize: 9, color: AppTheme.muted, letterSpacing: 1.1, fontFamily: 'monospace')),
            const SizedBox(height: 8),
            Text('Sign in', style: GoogleFonts.inter(fontSize: 22, height: 1.2, fontWeight: FontWeight.w600, color: AppTheme.ink, letterSpacing: -.5)),
            const SizedBox(height: 5),
            Text('Enter your workspace and work email to continue.',
                style: GoogleFonts.inter(color: AppTheme.muted, fontSize: 11.5)),
            const SizedBox(height: 25),
            _label('Workspace'),
            const SizedBox(height: 5),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: workspaceController,
                  decoration: const InputDecoration(hintText: 'yourcompany', contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
                  style: const TextStyle(fontSize: 12),
                  enabled: !flow.otpRequested,
                ),
              ),
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: const Color(0xFFF3F4F6), border: Border.all(color: AppTheme.border), borderRadius: const BorderRadius.horizontal(right: Radius.circular(7))),
                child: const Text('.oneenterprise.io', style: TextStyle(color: AppTheme.muted, fontSize: 10, fontFamily: 'monospace')),
              ),
            ]),
            const SizedBox(height: 4),
            RichText(text: TextSpan(style: GoogleFonts.inter(color: AppTheme.muted, fontSize: 9), children: const [
              TextSpan(text: "Don't know your workspace? "),
              TextSpan(text: 'Find it here', style: TextStyle(color: AppTheme.darkNavy, fontWeight: FontWeight.w600)),
            ])),
            const SizedBox(height: 16),
            _label('Work email'),
            const SizedBox(height: 5),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.username, AutofillHints.email],
              enabled: !flow.otpRequested,
              decoration: const InputDecoration(hintText: 'you@company.com'),
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 15),
            _label('Password'),
            const SizedBox(height: 5),
            TextField(
              controller: passwordController,
              obscureText: hidePassword,
              autofillHints: const [AutofillHints.password],
              enabled: !flow.otpRequested,
              onSubmitted: (_) => flow.otpRequested ? _verifyOtp(flow) : _requestOtp(flow),
              decoration: InputDecoration(
                hintText: 'Enter your password',
                suffixIcon: IconButton(
                  onPressed: () => setState(() => hidePassword = !hidePassword),
                  icon: Icon(hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 17, color: AppTheme.muted),
                ),
              ),
              style: const TextStyle(fontSize: 12),
            ),
            if (flow.otpRequested) ...[
              const SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _label('Verification code'),
                TextButton(
                  onPressed: () { flow.backToCredentials(); otpController.clear(); },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: const Text('Change credentials', style: TextStyle(fontSize: 9)),
                ),
              ]),
              const SizedBox(height: 5),
              TextField(
                controller: otpController,
                autofocus: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onSubmitted: (_) => _verifyOtp(flow),
                decoration: const InputDecoration(hintText: 'Enter 6-digit code', counterText: '', prefixIcon: Icon(Icons.dialpad_outlined, size: 17)),
                style: const TextStyle(fontSize: 13, letterSpacing: 3),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFFF4F5F8), borderRadius: BorderRadius.circular(6)),
                child: Text('Demo code: ${flow.verificationCode}  ·  Email delivery is not configured',
                    style: const TextStyle(fontSize: 9, color: AppTheme.muted)),
              ),
            ],
            if (flow.errorMessage.isNotEmpty) ...[
              const SizedBox(height: 9),
              Text(flow.errorMessage, style: const TextStyle(color: Color(0xFFB54747), fontSize: 10)),
            ],
            const SizedBox(height: 11),
            SizedBox(
              width: double.infinity,
              height: 43,
              child: ElevatedButton(
                onPressed: () => flow.otpRequested ? _verifyOtp(flow) : _requestOtp(flow),
                child: Text(flow.otpRequested ? 'Verify and sign in' : 'Continue', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
              ),
            ),
            if (!flow.otpRequested) ...[
              const SizedBox(height: 14),
              Row(children: [
                const Expanded(child: Divider(color: Color(0xFFE8EAF0))),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text('or continue with', style: GoogleFonts.inter(color: AppTheme.muted, fontSize: 9))),
                const Expanded(child: Divider(color: Color(0xFFE8EAF0))),
              ]),
              const SizedBox(height: 10),
              _ssoButton('Google', const Text('G', style: TextStyle(color: Color(0xFF4285F4), fontSize: 13, fontWeight: FontWeight.w700)), _loginWithGoogle),
              const SizedBox(height: 5),
              _ssoButton('Microsoft', const Text('▦', style: TextStyle(color: Color(0xFF0078D4), fontSize: 15, fontWeight: FontWeight.w700)), _loginWithGoogle),
              const SizedBox(height: 5),
              _ssoButton('Company SSO (SAML)', const Icon(Icons.person_outline, size: 14), _loginWithGoogle),
              const SizedBox(height: 14),
              const Divider(color: Color(0xFFE8EAF0)),
              const SizedBox(height: 9),
              Center(
                child: Wrap(alignment: WrapAlignment.center, children: [
                  Text('New to One Enterprise? ', style: GoogleFonts.inter(fontSize: 9, color: AppTheme.muted)),
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.register),
                    child: const Text('Talk to sales', style: TextStyle(fontSize: 9, color: AppTheme.darkNavy, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 11),
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.forgotPassword),
                    child: const Text('Forgot password?', style: TextStyle(fontSize: 9, color: AppTheme.darkNavy, fontWeight: FontWeight.w600)),
                  ),
                ]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _label(String value) => Text(value, style: GoogleFonts.inter(color: AppTheme.ink, fontSize: 10, fontWeight: FontWeight.w600));

  Widget _ssoButton(String label, Widget icon, VoidCallback onPressed) => SizedBox(
        width: double.infinity,
        height: 34,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: icon,
          label: Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.ink, fontWeight: FontWeight.w400)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppTheme.border),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          ),
        ),
      );

  void _loginWithGoogle() {
    ref.read(userProvider.notifier).login('googleuser@gmail.com');
    context.go(AppRoutes.admin);
  }
}
