// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'routes/routes.dart';
// import 'providers/user_provider.dart';
// import 'app_theme.dart';

// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (_) => UserProvider(),
//       child: const GTInStockApp(),
//     ),
//   );
// }

// class GTInStockApp extends StatelessWidget {
//   const GTInStockApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       title: 'Once Enterprise Cloud Platform',
//       theme: AppTheme.theme,
//       routerConfig: AppRoutes.router,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide ChangeNotifierProvider;
import 'package:provider/provider.dart';

import 'routes/routes.dart';
import 'app_theme.dart';
import 'providers/auth_flow_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthFlowProvider()),
      ],
      child: const ProviderScope(child: GTInStockApp()),
    ),
  );
}

class GTInStockApp extends ConsumerWidget {
  const GTInStockApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'One Enterprise Cloud Platform',
      theme: AppTheme.theme,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
