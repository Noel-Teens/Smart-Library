import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management_app/core/constants/app_constants.dart';
import 'package:library_management_app/core/theme/app_theme.dart';
import 'package:library_management_app/routing/app_router.dart';

/// The root application widget.
///
/// Wraps the widget tree in [ProviderScope] and configures
/// [MaterialApp.router] with GoRouter and the design token themes.
class SmartLibraryApp extends ConsumerWidget {
  const SmartLibraryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
