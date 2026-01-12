part of 'undangan_bloc.dart';

abstract class UndanganState {
  const UndanganState();
}

class UndanganInitial extends UndanganState {}

class UndanganLoading extends UndanganState {}

class UndanganLoaded extends UndanganState {
  final List<Undangan> undangans;

  const UndanganLoaded(this.undangans);
}

class UndanganError extends UndanganState {
  final String message;

  const UndanganError(this.message);
}
