import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_path_gate_admin_portal/pages/MainAppWrapper.dart';
import 'package:golden_path_gate_admin_portal/pages/auth/login_page.dart';
import 'package:golden_path_gate_admin_portal/pages/customers/create_customer.dart';
import 'package:golden_path_gate_admin_portal/pages/customers/customer_list.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_details/shipment_details.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_list/shipment_list.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'constants.dart';
import 'firebase_options.dart';
import 'pages/create_shipment/create_shipment.dart';


final GlobalKey<NavigatorState> _rootNavigatorKey =
GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
GlobalKey<NavigatorState>(debugLabel: 'shell');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print(FirebaseAuth.instance.currentUser);
  //print(FirebaseAuth.instance.currentUser);
  runApp(
      ChangeNotifierProvider.value(
          value: AuthState(),
          child: MyApp()
      )
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
      // '/login' :
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
                path: '/shipments-list',
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
              path: '/customers-list',
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
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Golden Path Gate',
      theme: ThemeData(
        fontFamily: 'Cairo',
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          surface: AppColors.background,
        ),
        scaffoldBackgroundColor: Colors.white,//Colors.black,
        // canvasColor: Colors.white12,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      ),
      //home: MainAppWrapper(),
      // home: const ShipmentFormPage()
    );
  }
}
