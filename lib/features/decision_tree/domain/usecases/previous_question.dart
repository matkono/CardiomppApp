import 'package:HealthSup/core/error/failure.dart';
import 'package:HealthSup/core/usecase/usecase.dart';
import 'package:HealthSup/features/decision_tree/domain/entities/node.dart';
import 'package:HealthSup/features/decision_tree/domain/repositories/decision_tree_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class PreviousQuestion extends UseCase<Node, ParamsQuestion> {
  final DecisionTreeRepository treeRepository;

  PreviousQuestion(
    this.treeRepository,
  );

  @override
  Future<Either<Failure, Node>> call(ParamsQuestion params) async {
    return await treeRepository.previousQuestion(
        params.idAppointment, params.idCurrentNode);
  }
}

class ParamsQuestion extends Equatable {
  final int idAppointment;
  final int idCurrentNode;

  ParamsQuestion({
    @required this.idAppointment,
    @required this.idCurrentNode,
  });

  @override
  List<Object> get props => [idAppointment, idCurrentNode];
}
