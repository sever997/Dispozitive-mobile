import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'backend/firebase/firebase_config.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/nav/nav.dart';

import 'features/auth/auth_controller.dart';
import 'features/auth/auth_page.dart';
import 'home/home_page.dart';
import 'home/main_page.dart';
import 'home/add_resource_page.dart';
import 'resources/edit_resource_page.dart';
import 'resources/bookmarks_page.dart';
import 'backend/firebase_messaging_service.dart';
import 'features/auth/signup_page.dart';
import 'features/stress_relief/stress_relief_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await initFirebase();
  await FlutterFlowTheme.initialize();

  // push notifications
  //final FirebaseMessagingService messagingService = FirebaseMessagingService();
  //await messagingService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier.instance;
    _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => HomePage(),
        ),
        GoRoute(
          path: '/auth',
          builder: (context, state) => AuthPage(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => SignUpPage(),
        ),
        GoRoute(
          path: '/main',
          builder: (context, state) => MainPage(),
        ),
      ],
    );
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Student Resource Hub',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => HomePage(),
          ),
          GoRoute(
            path: '/auth',
            builder: (context, state) => AuthPage(),
          ),
          GoRoute(
            path: '/signup',
            builder: (context, state) => SignUpPage(),
          ),
          GoRoute(
            path: '/main',
            builder: (context, state) => MainPage(),
          ),
          GoRoute(
            path: '/add-resource',
            builder: (context, state) => AddResourcePage(),
          ),
          GoRoute(
            path: '/edit-resource',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>;
              return EditResourcePage(
                resourceId: extra['id'],
                initialTitle: extra['title'],
                initialDescription: extra['description'],
              );
            },
          ),
          GoRoute(
            path: '/bookmarks',
            builder: (context, state) => BookmarksPage(),
          ),
          GoRoute(
            path: '/stress-relief',
            builder: (context, state) => StressReliefPage(),
          ),
        ],
      ),
    );
  }
}
