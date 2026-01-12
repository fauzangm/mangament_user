class UndanganBerandaResponse {
  Data? data;

  UndanganBerandaResponse({this.data});

  UndanganBerandaResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Statistik? statistik;
  Acara? acara;

  Data({this.statistik, this.acara});

  Data.fromJson(Map<String, dynamic> json) {
    statistik = json['statistik'] != null
        ? new Statistik.fromJson(json['statistik'])
        : null;
    acara = json['acara'] != null ? new Acara.fromJson(json['acara']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.statistik != null) {
      data['statistik'] = this.statistik!.toJson();
    }
    if (this.acara != null) {
      data['acara'] = this.acara!.toJson();
    }
    return data;
  }
}

class Statistik {
  int? belumKonfirmasi;
  int? hadir;
  int? tidakHadir;
  int? selesai;

  Statistik({this.belumKonfirmasi, this.hadir, this.tidakHadir, this.selesai});

  Statistik.fromJson(Map<String, dynamic> json) {
    belumKonfirmasi = json['belum_konfirmasi'];
    hadir = json['hadir'];
    tidakHadir = json['tidak_hadir'];
    selesai = json['selesai'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['belum_konfirmasi'] = this.belumKonfirmasi;
    data['hadir'] = this.hadir;
    data['tidak_hadir'] = this.tidakHadir;
    data['selesai'] = this.selesai;
    return data;
  }
}

class Acara {
  List<AcaraModel>? belumKonfirmasi;
  List<AcaraModel>? hadir;
  List<AcaraModel>? tidakHadir;
  List<AcaraModel>? selesai;

  Acara({this.belumKonfirmasi, this.hadir, this.tidakHadir, this.selesai});

  Acara.fromJson(Map<String, dynamic> json) {
    if (json['belum_konfirmasi'] != null) {
      belumKonfirmasi = <AcaraModel>[];
      json['belum_konfirmasi'].forEach((v) {
        belumKonfirmasi!.add(new AcaraModel.fromJson(v));
      });
    }
    if (json['hadir'] != null) {
      hadir = <AcaraModel>[];
      json['hadir'].forEach((v) {
        hadir!.add(new AcaraModel.fromJson(v));
      });
    }
    if (json['tidak_hadir'] != null) {
      tidakHadir = <AcaraModel>[];
      json['tidak_hadir'].forEach((v) {
        tidakHadir!.add(new AcaraModel.fromJson(v));
      });
    }
    if (json['selesai'] != null) {
      selesai = <AcaraModel>[];
      json['selesai'].forEach((v) {
        selesai!.add(new AcaraModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.belumKonfirmasi != null) {
      data['belum_konfirmasi'] =
          this.belumKonfirmasi!.map((v) => v.toJson()).toList();
    }
    if (this.hadir != null) {
      data['hadir'] = this.hadir!.map((v) => v.toJson()).toList();
    }
    if (this.tidakHadir != null) {
      data['tidak_hadir'] = this.tidakHadir!.map((v) => v.toJson()).toList();
    }
    if (this.selesai != null) {
      data['selesai'] = this.selesai!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AcaraModel {
  String? nama;
  String? deskripsi;
  String? tglMulai;
  String? tglSelesai;
  String? lokasi;

  AcaraModel(
      {this.nama, this.deskripsi, this.tglMulai, this.tglSelesai, this.lokasi});

  AcaraModel.fromJson(Map<String, dynamic> json) {
    nama = json['nama'];
    deskripsi = json['deskripsi'];
    tglMulai = json['tgl_mulai'];
    tglSelesai = json['tgl_selesai'];
    lokasi = json['lokasi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nama'] = this.nama;
    data['deskripsi'] = this.deskripsi;
    data['tgl_mulai'] = this.tglMulai;
    data['tgl_selesai'] = this.tglSelesai;
    data['lokasi'] = this.lokasi;
    return data;
  }
}
