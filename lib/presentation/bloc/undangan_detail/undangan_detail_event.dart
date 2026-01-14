abstract class UndanganDetailEvent {
  const UndanganDetailEvent();
}

class LoadUndanganDetail extends UndanganDetailEvent {
  final int id;
  const LoadUndanganDetail(this.id);
}

class ConfirmUndangan extends UndanganDetailEvent {
  final int id;
  final bool isAccept; // true = accept, false = decline

  const ConfirmUndangan({
    required this.id,
    required this.isAccept,
  });
}
