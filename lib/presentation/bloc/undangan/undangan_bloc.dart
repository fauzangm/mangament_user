import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/undangan.dart';

part 'undangan_event.dart';
part 'undangan_state.dart';

class UndanganBloc extends Bloc<UndanganEvent, UndanganState> {
  UndanganBloc() : super(UndanganInitial()) {
    on<LoadUndangan>(_onLoadUndangan);
    on<UpdateUndanganStatus>(_onUpdateUndanganStatus);
  }

  Future<void> _onLoadUndangan(LoadUndangan event, Emitter<UndanganState> emit) async {
    emit(UndanganLoading());
    
    // Simulate API call with dummy data
    await Future.delayed(const Duration(seconds: 1));
    
    try {
      final dummyUndangans = [
        Undangan(
          id: '1',
          title: 'Digital Transformation Forum',
          organization: 'Ministry of Communication and IT',
          date: 'Monday, February 3, 2026',
          location: 'Innovation Hub Jakarta',
          status: 'pending',
        ),
        Undangan(
          id: '2',
          title: 'National Policy Summit 2026',
          organization: 'Ministry of National Development',
          date: 'Friday, January 24, 2026',
          location: 'Grand Convention Center',
          status: 'confirmed',
        ),
        Undangan(
          id: '3',
          title: 'Tech Innovation Workshop',
          organization: 'Ministry of Research and Technology',
          date: 'Wednesday, January 15, 2026',
          location: 'Tech Center Bandung',
          status: 'confirmed',
        ),
      ];
      
      emit(UndanganLoaded(dummyUndangans));
    } catch (e) {
      emit(UndanganError('Failed to load undangans: $e'));
    }
  }

  Future<void> _onUpdateUndanganStatus(
    UpdateUndanganStatus event,
    Emitter<UndanganState> emit,
  ) async {
    if (state is UndanganLoaded) {
      final currentState = state as UndanganLoaded;
      final updatedUndangans = currentState.undangans.map((undangan) {
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

      emit(UndanganLoaded(updatedUndangans));
    }
  }
}
