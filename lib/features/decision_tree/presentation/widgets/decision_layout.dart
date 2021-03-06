import 'package:healthsup/features/decision_tree/domain/entities/node.dart';
import 'package:healthsup/features/decision_tree/presentation/bloc/decision_tree_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthsup/features/patient/presentation/bloc/patient_bloc.dart';

class DecisionLayout extends StatefulWidget {
  final Node node;
  final int idAppointment;

  const DecisionLayout({
    Key key,
    @required this.node,
    @required this.idAppointment,
  }) : super(key: key);

  @override
  _DecisionLayoutState createState() => _DecisionLayoutState();
}

class _DecisionLayoutState extends State<DecisionLayout> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          AppBar(
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            title: Text(
              'Cardiomiopatia Periparto',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
              ),
            ),
            backgroundColor: Colors.grey[300],
            leading: Navigator.canPop(context)
                ? IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 25,
                    ),
                    onPressed: () {
                      BlocProvider.of<PatientBloc>(context)
                          .add(RefreshPatientEvent());
                      Navigator.pop(context);
                    },
                  )
                : null,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/prancheta2.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 4.5,
                    child: Center(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          '${widget.node.decision.title}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 21,
                          ),
                        ),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width / 1.5,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                    height: MediaQuery.of(context).size.height / 2.5,
                  ),
                  Expanded(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 50, right: 20),
                            child: FlatButton(
                              color: widget.node.isInitial
                                  ? Colors.grey
                                  : Colors.blue,
                              child: Text(
                                'Voltar',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () async {
                                if (!widget.node.isInitial) {
                                  BlocProvider.of<DecisionTreeBloc>(context)
                                      .add(
                                    GetPreviousNodeDecisionTreeEvent(
                                      idNode: widget.node.id,
                                      idAppointment: widget.idAppointment,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 50, left: 20),
                            child: FlatButton(
                              color: Colors.blue,
                              child: Text(
                                'Confirmar',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                BlocProvider.of<DecisionTreeBloc>(context).add(
                                  ConfirmDecisionDecisionTreeEvent(
                                    idAppointment: widget.idAppointment,
                                    idDecision: widget.node.decision.id,
                                  ),
                                );
                                BlocProvider.of<PatientBloc>(context)
                                    .add(RefreshPatientEvent());
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
