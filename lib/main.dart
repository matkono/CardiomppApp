import 'package:healthsup/features/decision_tree/presentation/bloc/decision_tree_bloc.dart';
import 'package:healthsup/features/decision_tree/presentation/pages/medical_appointment.dart';
import 'package:healthsup/features/disease/presentation/bloc/disease_bloc.dart';
import 'package:healthsup/features/login/presentation/bloc/login_bloc.dart';
import 'package:healthsup/features/login/presentation/pages/login.dart';
import 'package:healthsup/features/patient/presentation/bloc/patient_bloc.dart';
import 'package:healthsup/features/patient/presentation/overlays/pages/overlay.dart';
import 'package:healthsup/features/patient/presentation/overlays/pages/overlay_patient_details.dart';
import 'package:healthsup/features/patient/presentation/pages/patient_homepage.dart';
import 'package:healthsup/features/patient/presentation/widgets/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthsup/features/registration/presentation/bloc/registration_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'features/tutorial/presentation/pages/base_page.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PatientBloc>(
          create: (context) => di.sl<PatientBloc>(),
        ),
        BlocProvider<LoginBloc>(
          create: (context) => di.sl<LoginBloc>(),
        ),
        BlocProvider<DecisionTreeBloc>(
          create: (context) => di.sl<DecisionTreeBloc>(),
        ),
        BlocProvider<DiseaseBloc>(
          create: (context) => di.sl<DiseaseBloc>(),
        ),
        BlocProvider<RegistrationBloc>(
          create: (context) => di.sl<RegistrationBloc>(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(canvasColor: Colors.white),
        builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget),
          maxWidth: 1200,
          minWidth: 450,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ],
          background: Container(
            color: Color(0xFFF5F5F5),
          ),
        ),
        home: BasePage(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/login': (context) => LoginPage(),
          '/home': (context) => PatientHomePage(),
          '/medicalAppointment': (context) => MedicalAppointmentPage(),
          '/overlayPatientHomePage': (context) => OverlayHomePage(),
          '/overlayPatientDetails': (context) => OverlayPatientDetails(),
          '/patientDetails': (context) => PatientDetails(),
        },
      ),
    );
  }
}
