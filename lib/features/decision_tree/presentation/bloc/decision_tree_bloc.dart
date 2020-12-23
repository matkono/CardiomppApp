import 'dart:async';

import 'package:HealthSup/core/error/failure.dart';
import 'package:HealthSup/features/decision_tree/domain/entities/answer.dart';
import 'package:HealthSup/features/decision_tree/domain/entities/node.dart';
import 'package:HealthSup/features/decision_tree/domain/usecases/confirm_action.dart';
import 'package:HealthSup/features/decision_tree/domain/usecases/finish_appointment.dart';
import 'package:HealthSup/features/decision_tree/domain/usecases/get_current_node.dart';
import 'package:HealthSup/features/decision_tree/domain/usecases/previous_question.dart';
import 'package:HealthSup/features/decision_tree/domain/usecases/send_answer.dart';
import 'package:HealthSup/features/decision_tree/domain/usecases/start_medical_appointment.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'decision_tree_event.dart';
part 'decision_tree_state.dart';

class DecisionTreeBloc extends Bloc<DecisionTreeEvent, DecisionTreeState> {
  final ConfirmAction confirmAction;
  final FinishAppointment finishAppointment;
  final GetCurrentNode getCurrentNode;
  final PreviousQuestion previousQuestion;
  final SendAnswer sendAnswer;
  final StartMedicalAppointment startMedicalAppointment;

  DecisionTreeBloc({
    @required this.confirmAction,
    @required this.finishAppointment,
    @required this.getCurrentNode,
    @required this.previousQuestion,
    @required this.sendAnswer,
    @required this.startMedicalAppointment,
    initialState,
  }) : super(initialState);

  DecisionTreeState get initialState => DecisionTreeInitial();

  @override
  Stream<DecisionTreeState> mapEventToState(
    DecisionTreeEvent event,
  ) async* {
    if (event is GetCurrentNodeDecisionTreeEvent) {
      yield LoadingDecisionTreeState();

      var failureOrNode =
          await getCurrentNode(ParamsCurrentNode(idAppointment: 1));
      yield failureOrNode.fold(
        (failure) {
          if (failure is ServerFailure)
            return ErrorDecisionTreeState(message: failure.failureMessage);
          else if (failure is NoInternetConnectionFailure)
            return ErrorDecisionTreeState(message: failure.failureMessage);
          else
            return ErrorDecisionTreeState(message: 'Erro desconhecido');
        },
        (node) {
          if (node.nodeType.id == 1) {
            return QuestionDecisionTreeState(node: node);
          } else if (node.nodeType.id == 2) {
            return DecisionDecisionTreeState(node: node);
          } else if (node.nodeType.id == 3)
            return ActionDecisionTreeState(node: node);
          else
            return ErrorDecisionTreeState(message: 'Código inválido');
        },
      );
    } else if (event is GetNextNodeDecisionTreeEvent) {
      yield LoadingDecisionTreeState();

      var failureOrNode = await sendAnswer(ParamsAnswer(answer: event.answer));
      yield failureOrNode.fold(
        (failure) {
          if (failure is ServerFailure)
            return ErrorDecisionTreeState(message: failure.failureMessage);
          else if (failure is NoInternetConnectionFailure)
            return ErrorDecisionTreeState(message: failure.failureMessage);
          else
            return ErrorDecisionTreeState(message: 'Erro desconhecido');
        },
        (node) {
          if (node.nodeType.id == 1) {
            return QuestionDecisionTreeState(node: node);
          } else if (node.nodeType.id == 2) {
            return DecisionDecisionTreeState(node: node);
          } else if (node.nodeType.id == 3)
            return ActionDecisionTreeState(node: node);
          else
            return ErrorDecisionTreeState(message: 'Código inválido');
        },
      );
    } else if (event is ConfirmDecisionDecisionTreeEvent) {
      yield LoadingDecisionTreeState();

      var failureOrNode = await finishAppointment(
          ParamsFinishAppointment(medicalAppointmentId: 1, finished: true));
      yield failureOrNode.fold(
        (failure) {
          if (failure is ServerFailure)
            return ErrorDecisionTreeState(message: failure.failureMessage);
          else if (failure is NoInternetConnectionFailure)
            return ErrorDecisionTreeState(message: failure.failureMessage);
          else
            return ErrorDecisionTreeState(message: 'Erro desconhecido');
        },
        (success) {
          return AppointmentFinished();
        },
      );
    } else if (event is ConfirmActionDecisionTreeEvent) {
      yield LoadingDecisionTreeState();

      var failureOrNode = await confirmAction(
          ParamsConfirmAction(idAppointment: 1, idAction: event.idAction));
      yield failureOrNode.fold(
        (failure) {
          if (failure is ServerFailure)
            return ErrorDecisionTreeState(message: failure.failureMessage);
          else if (failure is NoInternetConnectionFailure)
            return ErrorDecisionTreeState(message: failure.failureMessage);
          else
            return ErrorDecisionTreeState(message: 'Erro desconhecido');
        },
        (node) {
          if (node.nodeType.id == 1) {
            return QuestionDecisionTreeState(node: node);
          } else if (node.nodeType.id == 2) {
            return DecisionDecisionTreeState(node: node);
          } else if (node.nodeType.id == 3)
            return ActionDecisionTreeState(node: node);
          else
            return ErrorDecisionTreeState(message: 'Código inválido');
        },
      );
    } else if (event is GetPreviousNodeDecisionTreeEvent) {
      yield LoadingDecisionTreeState();

      var failureOrNode = await previousQuestion(ParamsPreviousNode(
        idAppointment: 1,
        idCurrentNode: event.idNode,
      ));
      yield failureOrNode.fold(
        (failure) {
          if (failure is ServerFailure)
            return ErrorDecisionTreeState(message: failure.failureMessage);
          else if (failure is NoInternetConnectionFailure)
            return ErrorDecisionTreeState(message: failure.failureMessage);
          else
            return ErrorDecisionTreeState(message: 'Erro desconhecido');
        },
        (node) {
          if (node.nodeType.id == 1) {
            return QuestionDecisionTreeState(node: node);
          } else if (node.nodeType.id == 2) {
            return DecisionDecisionTreeState(node: node);
          } else if (node.nodeType.id == 3)
            return ActionDecisionTreeState(node: node);
          else
            return ErrorDecisionTreeState(message: 'Código inválido');
        },
      );
    }
  }
}
