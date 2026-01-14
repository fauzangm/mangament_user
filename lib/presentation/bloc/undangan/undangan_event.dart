part of 'undangan_bloc.dart';

abstract class UndanganEvent {
  const UndanganEvent();
}

class LoadUndangan extends UndanganEvent {}

class FilterUndangan extends UndanganEvent {
  final String? status;

  const FilterUndangan({this.status});
}

class UpdateUndanganStatus extends UndanganEvent {
  final String id;
  final String status;

  const UpdateUndanganStatus({required this.id, required this.status});
}

class KonfirmasiUndangan extends UndanganEvent {
  final int id;
  final String status;
  final String alasan;

  const KonfirmasiUndangan({required this.id, required this.status, required this.alasan});
}

class CheckinUndangan extends UndanganEvent {
  final int id;
  final String kode;

  const CheckinUndangan({required this.id, required this.kode});
}

class PresensiUndangan extends UndanganEvent {
  final int id;
  final String tanggal;
  final String sesi;
  final String token;

  const PresensiUndangan({
    required this.id,
    required this.tanggal,
    required this.sesi,
    required this.token,
  });
}
