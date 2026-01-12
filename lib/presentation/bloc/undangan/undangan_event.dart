part of 'undangan_bloc.dart';

abstract class UndanganEvent {
  const UndanganEvent();
}

class LoadUndangan extends UndanganEvent {}

class UpdateUndanganStatus extends UndanganEvent {
  final String id;
  final String status;

  const UpdateUndanganStatus({required this.id, required this.status});
}
