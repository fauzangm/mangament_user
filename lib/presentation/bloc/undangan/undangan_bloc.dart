import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangament_acara/data/models/undanga_beranda.dart';
import 'package:mangament_acara/domain/repositories/undangan_repository.dart';
import '../../models/undangan.dart';

part 'undangan_event.dart';
part 'undangan_state.dart';

class UndanganBloc extends Bloc<UndanganEvent, UndanganState> {
  final UndanganRepository undanganRepository;

  UndanganBloc({required this.undanganRepository}) : super(UndanganInitial()) {
    on<LoadUndangan>(_onLoadUndangan);
    on<FilterUndangan>(_onFilterUndangan);
    on<UpdateUndanganStatus>(_onUpdateUndanganStatus);
    on<KonfirmasiUndangan>(_onKonfirmasiUndangan);
    on<CheckinUndangan>(_onCheckinUndangan);
    on<PresensiUndangan>(_onPresensiUndangan);
  }

  List<Undangan> _mapGroup(List<AcaraModel>? items, String status) {
    final safeItems = items ?? const <AcaraModel>[];
    return safeItems.map((a) {
      final id =
          a.id?.toString() ??
          a.nama ??
          DateTime.now().millisecondsSinceEpoch.toString();
      return Undangan(
        id: id,
        title: a.nama ?? '-',
        organization: '',
        date: a.tglMulai ?? '-',
        location: a.lokasi ?? '-',
        status: status,
        description: a.deskripsi,
      );
    }).toList();
  }

  List<Undangan> _mapBerandaToAll(UndanganBerandaResponse response) {
    final acara = response.data?.acara;
    final all = <Undangan>[];
    all.addAll(_mapGroup(acara?.belumKonfirmasi, 'pending'));
    all.addAll(_mapGroup(acara?.hadir, 'confirmed'));
    all.addAll(_mapGroup(acara?.tidakHadir, 'declined'));
    all.addAll(_mapGroup(acara?.selesai, 'confirmed'));
    return all;
  }

  ({int pending, int confirmed, int declined, int total}) _resolveCounts(
    UndanganBerandaResponse response,
    List<Undangan> all,
  ) {
    final statistik = response.data?.statistik;
    final pending =
        statistik?.belumKonfirmasi ??
        all.where((u) => u.status == 'pending').length;
    final confirmed =
        statistik?.hadir ?? all.where((u) => u.status == 'confirmed').length;
    final declined =
        statistik?.tidakHadir ??
        all.where((u) => u.status == 'declined').length;
    final total = pending + confirmed + declined;
    return (
      pending: pending,
      confirmed: confirmed,
      declined: declined,
      total: total,
    );
  }

  Future<void> _onLoadUndangan(
    LoadUndangan event,
    Emitter<UndanganState> emit,
  ) async {
    emit(UndanganLoading());

    try {
      final response = await undanganRepository.undanganBeranda();
      final all = _mapBerandaToAll(response);
      final counts = _resolveCounts(response, all);

      emit(
        UndanganLoaded(
          allUndangans: all,
          visibleUndangans: all,
          pendingCount: counts.pending,
          confirmedCount: counts.confirmed,
          declinedCount: counts.declined,
          totalCount: counts.total,
          selectedStatus: null,
        ),
      );
    } catch (e) {
      emit(UndanganError('Failed to load undangans: $e'));
    }
  }

  Future<void> _onFilterUndangan(
    FilterUndangan event,
    Emitter<UndanganState> emit,
  ) async {
    if (state is! UndanganLoaded) return;
    final current = state as UndanganLoaded;

    final status = event.status;
    if (status == null) {
      emit(
        UndanganLoaded(
          allUndangans: current.allUndangans,
          visibleUndangans: current.allUndangans,
          pendingCount: current.pendingCount,
          confirmedCount: current.confirmedCount,
          declinedCount: current.declinedCount,
          totalCount: current.totalCount,
          selectedStatus: null,
        ),
      );
      return;
    }

    emit(UndanganLoading());

    try {
      final apiStatus = switch (status) {
        'pending' => 'belum_konfirmasi',
        'confirmed' => 'hadir',
        'declined' => 'tidak_hadir',
        _ => status,
      };

      final response = await undanganRepository.filterUndanganBeranda(
        apiStatus,
      );
      final list = (response.data ?? const <AcaraModel>[])
          .map(
            (a) => Undangan(
              id:
                  a.id?.toString() ??
                  a.nama ??
                  DateTime.now().millisecondsSinceEpoch.toString(),
              title: a.nama ?? '-',
              organization: '',
              date: a.tglMulai ?? '-',
              location: a.lokasi ?? '-',
              status: status,
              description: a.deskripsi,
            ),
          )
          .toList();

      emit(
        UndanganLoaded(
          allUndangans: current.allUndangans,
          visibleUndangans: list,
          pendingCount: current.pendingCount,
          confirmedCount: current.confirmedCount,
          declinedCount: current.declinedCount,
          totalCount: current.totalCount,
          selectedStatus: status,
        ),
      );
    } catch (e) {
      emit(UndanganError('Failed to filter undangans: $e'));
    }
  }

  Future<void> _onUpdateUndanganStatus(
    UpdateUndanganStatus event,
    Emitter<UndanganState> emit,
  ) async {
    if (state is! UndanganLoaded) return;
    final currentState = state as UndanganLoaded;

    final updatedAll = currentState.allUndangans.map((undangan) {
      if (undangan.id == event.id) {
        return Undangan(
          id: undangan.id,
          title: undangan.title,
          organization: undangan.organization,
          date: undangan.date,
          location: undangan.location,
          status: event.status,
          description: undangan.description,
        );
      }
      return undangan;
    }).toList();

    final selected = currentState.selectedStatus;
    final visible = selected == null
        ? updatedAll
        : updatedAll.where((u) => u.status.toLowerCase() == selected).toList();

    emit(
      UndanganLoaded(
        allUndangans: updatedAll,
        visibleUndangans: visible,
        pendingCount: currentState.pendingCount,
        confirmedCount: currentState.confirmedCount,
        declinedCount: currentState.declinedCount,
        totalCount: currentState.totalCount,
        selectedStatus: selected,
      ),
    );
  }

  Future<void> _onKonfirmasiUndangan(
  KonfirmasiUndangan event,
  Emitter<UndanganState> emit,
) async {
  emit(UndanganLoading());

  try {
    final result = await undanganRepository.konfirmasiUndangan(
      event.id,
      event.status,
      event.alasan,
    );

    emit(UndanganSuccesPost(result));

    // Optional: update status di list
    if (result) {
      add(UpdateUndanganStatus(
        id: event.id.toString(),
        status: event.status == 'hadir' ? 'confirmed' : 'declined',
      ));
    }
  } catch (e) {
    emit(UndanganError('Gagal konfirmasi undangan: $e'));
  }
}

  Future<void> _onCheckinUndangan(
  CheckinUndangan event,
  Emitter<UndanganState> emit,
) async {
  emit(UndanganLoading());

  try {
    final result = await undanganRepository.checkin(
      event.id,
      event.kode,
    );

    emit(UndanganSuccesPost(result));
  } catch (e) {
    emit(UndanganError('Gagal check-in undangan: $e'));
  }
}

  Future<void> _onPresensiUndangan(
  PresensiUndangan event,
  Emitter<UndanganState> emit,
) async {
  emit(UndanganLoading());

  try {
    final result = await undanganRepository.presensi(
      event.id,
      event.tanggal,
      event.sesi,
      event.token,
    );

    emit(UndanganSuccesPost(result));
  } catch (e) {
    emit(UndanganError('Gagal presensi undangan: $e'));
  }
}

}
