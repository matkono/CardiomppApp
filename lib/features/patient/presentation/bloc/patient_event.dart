part of 'patient_bloc.dart';

abstract class PatientEvent extends Equatable {
  const PatientEvent();

  @override
  List<Object> get props => [];
}

class GetCepInfoEvent extends PatientEvent {
  final String cep;

  GetCepInfoEvent({
    @required this.cep,
  });
}
