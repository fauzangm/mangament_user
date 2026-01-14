import 'package:mangament_acara/data/models/undanga_beranda.dart';
import 'package:mangament_acara/data/models/undanga_beranda_filter.dart';
import 'package:mangament_acara/data/models/undangan_detail.dart';

abstract class UndanganRepository {
  Future<UndanganBerandaResponse> undanganBeranda();
  Future<UndanganFilterResponse> filterUndanganBeranda(String status);
  Future<UndanganDetailResponse> undanganDetail(int id);
  Future<bool> konfirmasiUndangan(int id, String status, String alasan);
  Future<bool> checkin(int id,String kode);
  Future<bool> presensi(int id, String tanggal, String sesi, String token);
}