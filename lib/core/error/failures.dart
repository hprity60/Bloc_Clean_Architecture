// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class ServerFailure extends Failure {
  final String message;
  ServerFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

class HttpFailure extends Failure {
  final String message;
  HttpFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

class SocketFailure extends Failure {
  final String message;
  SocketFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

class LocalFailure extends Failure {
  final String message;
  LocalFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}