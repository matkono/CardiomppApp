import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthsup/features/decision_tree/presentation/bloc/decision_tree_bloc.dart';
import 'package:healthsup/features/decision_tree/presentation/pages/medical_appointment.dart';
import 'package:healthsup/features/disease/domain/entities/diseases.dart';
import 'package:healthsup/features/disease/presentation/bloc/disease_bloc.dart';
import 'package:healthsup/features/patient/domain/entities/patient.dart';

class ListDisease extends StatefulWidget {
  final Patient patient;
  final List<Diseases> diseasesList;
  final int totalRows;

  const ListDisease({
    Key key,
    @required this.diseasesList,
    @required this.totalRows,
    @required this.patient,
  }) : super(key: key);

  @override
  _ListDiseaseState createState() => _ListDiseaseState();
}

class _ListDiseaseState extends State<ListDisease> {
  int radioButton;
  ScrollController _scrollController = new ScrollController();

  Widget _radioInfiniteScroll(
    BuildContext context,
  ) {
    return ListView.builder(
      itemCount: widget.diseasesList.length + 1,
      controller: _scrollController,
      itemBuilder: (BuildContext context, int index) {
        if (index == widget.diseasesList.length) {
          if (index != widget.totalRows) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text(''),
            );
          }
        }
        return Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 5),
          child: FlatButton(
            color: Colors.blue[300],
            onPressed: () {
              BlocProvider.of<DecisionTreeBloc>(context).add(
                StartDecisionTreeEvent(
                  patientId: widget.patient.id,
                  diseaseId: widget.diseasesList[index].id,
                ),
              );
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MedicalAppointmentPage()));
            },
            child: Text(
              '${widget.diseasesList[index].id} - ${widget.diseasesList[index].name}',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        );
      },
    );
  }

  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchTen();
      }
    });
  }

  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void fetchTen() {
    BlocProvider.of<DiseaseBloc>(context).add(GetNextDiseaseListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            'Nova Consulta',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
            ),
          ),
          backgroundColor: Colors.grey[300],
        ),
        Expanded(
          child: Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.black,
                    margin: EdgeInsets.only(top: 40),
                    height: MediaQuery.of(context).size.height / 5.5,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/HealthSup-logo-sem-nome-homepage.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Text(
                      'Selecione uma doença',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: _radioInfiniteScroll(
                      context,
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.black,
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
