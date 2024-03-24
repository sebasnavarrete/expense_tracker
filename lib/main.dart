import 'package:expense_tracker/screens/auth_screen.dart';
import 'package:expense_tracker/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// Color matri: #221060
var kColorScheme = ColorScheme.fromSeed(
  primary: const Color.fromARGB(210, 34, 16, 96),
  seedColor: const Color.fromARGB(210, 34, 16, 96),
  background: const Color.fromARGB(255, 44, 182, 156),
  onPrimary: const Color.fromARGB(255, 239, 238, 110),
  secondary: const Color.fromARGB(255, 125, 20, 101),
  onSecondary: const Color.fromARGB(255, 244, 173, 78),
  inversePrimary: const Color.fromARGB(255, 190, 55, 93),
  onPrimaryContainer: const Color.fromARGB(255, 229, 111, 79),
  tertiary: const Color.fromARGB(255, 215, 7, 7),
  // Expense color
  onTertiary: const Color.fromARGB(255, 86, 143, 7), // Income color
);

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://91578946b9e340cdc1c0e6d0b42d8070@o4504690512494592.ingest.us.sentry.io/4506965774958592';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      ProviderScope(
        child: MaterialApp(
          theme: ThemeData().copyWith(
            primaryColor: kColorScheme.primary,
            colorScheme: kColorScheme,
            appBarTheme: const AppBarTheme().copyWith(
              backgroundColor: kColorScheme.primary,
              foregroundColor: kColorScheme.primaryContainer,
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            cardTheme: const CardTheme().copyWith(
              color: kColorScheme.primary,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorScheme.primaryContainer,
              ),
            ),
            textTheme: GoogleFonts.ibmPlexSansTextTheme(),
            dropdownMenuTheme: ThemeData().dropdownMenuTheme.copyWith(
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
            snackBarTheme: const SnackBarThemeData().copyWith(
              elevation: 20,
              contentTextStyle: const TextStyle(
                fontSize: 14,
              ),
            ),
            floatingActionButtonTheme:
                const FloatingActionButtonThemeData().copyWith(
              backgroundColor: kColorScheme.primary,
              foregroundColor: Colors.white,
            ),
          ),
          themeMode: ThemeMode.light,
          home: const TabsScreen(),
          //home: const AuthScreen(),
        ),
      ),
    ),
  );
}
