
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:major/auth.dart';
import 'package:major/emailverify.dart';
import 'Utils.dart';
import 'firebase_options.dart';
// @dart=2.9
Future<void>_firebaseMessagingBackgroundHandler(RemoteMessage)async{
  print("Handling a background messaging");
}
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}
final navigatorKey=GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      navigatorKey: navigatorKey,
      scaffoldMessengerKey:Utils.messengerKey,
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  @override
  Widget build(BuildContext context) {

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child:SpinKitDancingSquare(
                  size: 50,
                  itemBuilder: (context,index){
                    final colors=[Colors.orange,Colors.cyanAccent];
                    final color=colors[index%colors.length];
                    return DecoratedBox(decoration:BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                        shape: BoxShape.rectangle,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 2,
                              offset: Offset(5, 5),
                              color: Colors.redAccent
                          )
                        ]
                    ));
                  }
              ));
            }
            else if(snapshot.hasError){
              return Center(child: Text("Something Went Wrong"),);
            }
         else if(snapshot.hasData){
              return Verifyemail();
            }else{
              return AuthPage(islogin: true,);}
          },
        )
    );
  }
}
