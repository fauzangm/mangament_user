part of 'undangan_bloc.dart';

abstract class UndanganState {
  const UndanganState();
}

class UndanganInitial extends UndanganState {}

class UndanganLoading extends UndanganState {}

class UndanganLoaded extends UndanganState {
  final List<Undangan> allUndangans;
  final List<Undangan> visibleUndangans;
  final int pendingCount;
  final int confirmedCount;
  final int declinedCount;
  final int totalCount;
  final String? selectedStatus;

  const UndanganLoaded({
    required this.allUndangans,
    required this.visibleUndangans,
    required this.pendingCount,
    required this.confirmedCount,
    required this.declinedCount,
    required this.totalCount,
    required this.selectedStatus,
  });
}

class UndanganError extends UndanganState {
  final String message;

  const UndanganError(this.message);
}

class UndanganSuccesPost extends UndanganState {
  final bool isSucces;

  const UndanganSuccesPost(this.isSucces);
}
