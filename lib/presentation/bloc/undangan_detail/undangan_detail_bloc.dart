import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangament_acara/data/models/undangan_detail.dart';
import 'package:mangament_acara/domain/repositories/undangan_repository.dart';
import 'package:mangament_acara/presentation/bloc/undangan_detail/undangan_detail_event.dart';
import 'package:mangament_acara/presentation/bloc/undangan_detail/undangan_detail_state.dart';

class UndanganDetailBloc
    extends Bloc<UndanganDetailEvent, UndanganDetailState> {
  final UndanganRepository undanganRepository;

  UndanganDetailBloc({required this.undanganRepository})
      : super(const UndanganDetailInitial()) {
    on<LoadUndanganDetail>(_onLoad);
    on<ConfirmUndangan>(_onConfirm);
  }

  Future<void> _onLoad(
    LoadUndanganDetail event,
    Emitter<UndanganDetailState> emit,
  ) async {
    emit(const UndanganDetailLoading());
    try {
      final response = await undanganRepository.undanganDetail(event.id);
      emit(UndanganDetailLoaded(response));
    } catch (e) {
      emit(UndanganDetailError('Failed to load detail: $e'));
    }
  }

  Future<void> _onConfirm(
    ConfirmUndangan event,
    Emitter<UndanganDetailState> emit,
  ) async {
    emit(const UndanganConfirmLoading());
    try {
      await undanganRepository.konfirmasiUndangan(
        event.id,
        event.isAccept ? 'hadir' : 'tidak-hadir',
        event.isAccept ? '' : "Tidak Hadir",
      );

      emit(
        UndanganConfirmSuccess(
          event.isAccept
              ? 'Undangan berhasil diterima'
              : 'Undangan ditolak',
        ),
      );

      // reload detail setelah konfirmasi
      add(LoadUndanganDetail(event.id));
    } catch (e) {
      emit(UndanganDetailError('Gagal konfirmasi undangan: $e'));
    }
  }
}

