import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_path_gate_admin_portal/app_theme.dart';
import 'package:golden_path_gate_admin_portal/pages/MainAppWrapper.dart';
import 'package:golden_path_gate_admin_portal/pages/auth/login_page.dart';
import 'package:golden_path_gate_admin_portal/pages/customers/create_customer.dart';
import 'package:golden_path_gate_admin_portal/pages/customers/customer_list.dart';
import 'package:golden_path_gate_admin_portal/pages/settings/settings_page.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_details/shipment_details.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_list/shipment_list.dart';
import 'package:golden_path_gate_admin_portal/pages/users/users_list.dart';
import 'package:golden_path_gate_admin_portal/services/app_config_service.dart';
import 'package:golden_path_gate_admin_portal/services/app_info_service.dart';
import 'package:golden_path_gate_admin_portal/services/local_storage_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'localization/AppLocal.dart';
import 'pages/create_shipment/create_shipment.dart';
import 'pages/users/create_user/create_user_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


final GlobalKey<NavigatorState> _rootNavigatorKey =
GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
GlobalKey<NavigatorState>(debugLabel: 'shell');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  LocalStorageService.instance.init();
  AppInfoService();
  runApp(
      MyApp()
      // ChangeNotifierProvider.value(
      //     value: AuthState(),
      //     child:
      // )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final GoRouter
  late GoRouter _router;

  @override
  void initState() {
    _router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      // refreshListenable: Provider.of<AuthState>(context),
      initialLocation:
      // FirebaseAuth.instance.currentUser == null ?
      // '/login' ,
      '/create-shipment',
     /* redirect: (context, state) {
        final auth = Provider.of<AuthState>(context, listen: false);
        final loggedIn = auth.isLoggedIn;

        print("state.topRoute");
        print(state.topRoute);
        print(state.name);
        print(state.path);
        final loggingIn = state.topRoute!.name == '/login';

        if (!loggedIn) return loggingIn ? null : '/login';
        if (loggedIn && loggingIn) return '/create-shipment';

        return null;
      },*/
      routes: [
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return MainAppWrapper(
                path: state.fullPath??"", child: child
            );
          },
          routes: [
            GoRoute(
              path: '/create-shipment',
              builder: (context, state) {
                return const ShipmentFormPage();
              },
            ),
            GoRoute(
                path: '/shipment-list',
                builder: (context, state) {
                  return const ShipmentList();
                },
                routes: [
                  GoRoute(
                    path: 'details/:id',
                    builder: (context, state) {
                      String detailId = state.pathParameters['id']??"";
                      return ShipmentDetails(id: detailId,);
                    },
                  )
                ]
            ),
            GoRoute(
              path: '/settings',
              builder: (context,state){
                return const SettingsPage();
              }
            ),
            GoRoute(
              path: '/customer-list',
              builder: (context, state) {
                return const CustomerList();
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'create',
                  //parentNavigatorKey: _rootNavigatorKey,
                  builder: (BuildContext context, GoRouterState state) {
                    return const CreateCustomerFormPage();
                  },
                ),
                GoRoute(
                  path: 'details/:id',
                  //parentNavigatorKey: _rootNavigatorKey,
                  builder: (BuildContext context, GoRouterState state) {
                    String? id = state.pathParameters['id'];
                    return  CreateCustomerFormPage(
                      id: id,
                    );
                  },
                ),

              ],
            ),
            GoRoute(
              path: '/user-list',
              builder: (context, state) {
                return const UserList();
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'create',
                  //parentNavigatorKey: _rootNavigatorKey,
                  builder: (BuildContext context, GoRouterState state) {
                    return const CreateUserPage();
                  },
                ),
              ],
            )
          ],
        ),
        // GoRoute(
        //     path: '/test',
        //     builder: (context,state){
        //       return ProcessTimelineWidget();
        //     }
        // ),
        GoRoute(
            path: '/login',
            builder: (context,state){
              return LoginPage();
            }
        )
      ],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppConfigService>.value(
      value: AppConfigService(),
      child: Consumer<AppConfigService>(
        builder: (context, state, child) {
          return MaterialApp.router(
            routerConfig: _router,
            title: 'Golden Path Gate',
            theme: state.brightness == Brightness.light ? lightThemeDate : darkThemeDate,
            localizationsDelegates: [
              const AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
            ],
            supportedLocales: Lang.values.map((e) => Locale(e)).toList(),
            locale: Locale(
              'ar'
              //LocalStorageService.instance.languageCode,
            ),
          );
        }
      ),
    );
  }
}
