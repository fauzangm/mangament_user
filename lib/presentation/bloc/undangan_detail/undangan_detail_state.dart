import 'package:mangament_acara/data/models/undangan_detail.dart';

abstract class UndanganDetailState {
  const UndanganDetailState();
}

class UndanganDetailInitial extends UndanganDetailState {
  const UndanganDetailInitial();
}

class UndanganDetailLoading extends UndanganDetailState {
  const UndanganDetailLoading();
}

class UndanganDetailLoaded extends UndanganDetailState {
  final UndanganDetailResponse response;
  const UndanganDetailLoaded(this.response);
}

class UndanganConfirmLoading extends UndanganDetailState {
  const UndanganConfirmLoading();
}

class UndanganConfirmSuccess extends UndanganDetailState {
  final String message;
  const UndanganConfirmSuccess(this.message);
}

class UndanganDetailError extends UndanganDetailState {
  final String message;
  const UndanganDetailError(this.message);
}
