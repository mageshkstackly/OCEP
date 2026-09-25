import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_theme.dart';
import 'stackly_logo.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;
  final bool reverse;

  const AuthLayout({super.key, required this.child, this.reverse = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, bounds) {
            if (bounds.maxWidth < 760) {
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: AppTheme.darkNavy,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                    child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: _brand()),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 30),
                      child: Center(
                        child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 440), child: child),
                      ),
                    ),
                  ),
                ],
              );
            }
            final left = Expanded(flex: 46, child: _brandPanel());
            final right = Expanded(
              flex: 54,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 38),
                  child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 360), child: child),
                ),
              ),
            );
            return Row(children: reverse ? [right, left] : [left, right]);
          },
        ),
      ),
    );
  }

  Widget _brandPanel() => Container(
        color: AppTheme.darkNavy,
        padding: const EdgeInsets.fromLTRB(40, 28, 40, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _brand(),
            const Spacer(),
            const Text('CLOUD PLATFORM  ·  HRMS  ·  CRM  ·  ERP  ·  FINANCE  ·  AI',
                style: TextStyle(color: AppTheme.teal, fontSize: 9, letterSpacing: 1.1, fontFamily: 'monospace')),
            const SizedBox(height: 14),
            RichText(
              text: TextSpan(
                style: GoogleFonts.inter(color: Colors.white, height: 1.12, fontSize: 30, fontWeight: FontWeight.w600, letterSpacing: -1.1),
                children: const [
                  TextSpan(text: 'Every operation.\n'),
                  TextSpan(text: 'One sign-in.', style: TextStyle(color: AppTheme.gold)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text('HR, sales, procurement, finance and your AI copilot — running on one identity, one policy, one audit trail.',
                style: GoogleFonts.inter(color: Colors.white.withValues(alpha: .68), fontSize: 12, height: 1.65)),
            const SizedBox(height: 24),
            const Expanded(flex: 3, child: _OrbitGraphic()),
            const Spacer(),
            Divider(color: Colors.white.withValues(alpha: .12)),
            const SizedBox(height: 12),
            const Wrap(spacing: 22, runSpacing: 8, children: [
              _FooterTag(Icons.shield_outlined, 'SOC 2 Type II'),
              _FooterTag(Icons.lock_outline, 'ISO 27001'),
              _FooterTag(Icons.timelapse_outlined, '99.95% uptime SLA'),
            ]),
          ],
        ),
      );

  Widget _brand() => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const StacklyLogo(iconSize: 24),
          Container(height: 18, width: 1, margin: const EdgeInsets.symmetric(horizontal: 12), color: Colors.white.withValues(alpha: .28)),
          Container(
            width: 27,
            height: 27,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              gradient: const LinearGradient(colors: [AppTheme.gold, AppTheme.teal], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            alignment: Alignment.center,
            child: Text('1E', style: GoogleFonts.inter(color: AppTheme.darkNavy, fontSize: 10, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 7),
          Text('One Enterprise', style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      );
}

class _FooterTag extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FooterTag(this.icon, this.label);

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 11, color: Colors.white.withValues(alpha: .58)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Color(0xFF929AB8), fontSize: 9, fontFamily: 'monospace')),
      ]);
}

class _OrbitGraphic extends StatelessWidget {
  const _OrbitGraphic();

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _OrbitPainter(),
        child: const Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF282C60),
              border: Border.fromBorderSide(BorderSide(color: AppTheme.gold, width: .5)),
            ),
            child: SizedBox(width: 34, height: 34, child: Center(child: Text('AI', style: TextStyle(color: Colors.white70, fontSize: 8)))),
          ),
        ),
      );
}

class _OrbitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final points = [
      Offset(size.width * .14, size.height * .18),
      Offset(size.width * .86, size.height * .18),
      Offset(size.width * .14, size.height * .5),
      Offset(size.width * .86, size.height * .5),
      Offset(size.width * .14, size.height * .82),
      Offset(size.width * .86, size.height * .82),
    ];
    final solid = Paint()..color = AppTheme.teal.withValues(alpha: .62)..style = PaintingStyle.stroke..strokeWidth = .65;
    final dotted = Paint()..color = const Color(0xFF525887)..style = PaintingStyle.stroke..strokeWidth = .65;
    final dot = Paint()..color = const Color(0xFF343A77);
    for (var i = 0; i < points.length; i++) {
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..quadraticBezierTo((center.dx + points[i].dx) / 2, points[i].dy, points[i].dx, points[i].dy);
      canvas.drawPath(path, i < 3 ? solid : dotted);
      canvas.drawCircle(points[i], 3, dot);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
