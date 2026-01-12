class UndanganDetailResponse {
  UndanganDetailData? data;

  UndanganDetailResponse({this.data});

  UndanganDetailResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? UndanganDetailData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (data != null) {
      json['data'] = data!.toJson();
    }
    return json;
  }
}

class UndanganDetailData {
  String? nama;
  String? deskripsi;
  String? tglMulai;
  String? tglSelesai;
  String? lokasi;
  String? status;
  bool? checkIn;
  bool? presensiMulai;
  bool? presensiAkhir;
  List<DokumenModel>? dokumen;
  String? ketentuan;
  Map<String, List<AgendaModel>>? agenda;
  PartisipanModel? partisipan;

  UndanganDetailData({
    this.nama,
    this.deskripsi,
    this.tglMulai,
    this.tglSelesai,
    this.lokasi,
    this.status,
    this.checkIn,
    this.presensiMulai,
    this.presensiAkhir,
    this.dokumen,
    this.ketentuan,
    this.agenda,
    this.partisipan,
  });

  UndanganDetailData.fromJson(Map<String, dynamic> json) {
    nama = json['nama'];
    deskripsi = json['deskripsi'];
    tglMulai = json['tgl_mulai'];
    tglSelesai = json['tgl_selesai'];
    lokasi = json['lokasi'];
    status = json['status'];
    checkIn = json['check_in'];
    presensiMulai = json['presensi_mulai'];
    presensiAkhir = json['presensi_akhir'];
    ketentuan = json['ketentuan'];

    if (json['dokumen'] != null) {
      dokumen = <DokumenModel>[];
      json['dokumen'].forEach((v) {
        dokumen!.add(DokumenModel.fromJson(v));
      });
    }

    if (json['agenda'] != null) {
      agenda = {};
      json['agenda'].forEach((key, value) {
        agenda![key] = <AgendaModel>[];
        value.forEach((v) {
          agenda![key]!.add(AgendaModel.fromJson(v));
        });
      });
    }

    partisipan = json['partisipan'] != null
        ? PartisipanModel.fromJson(json['partisipan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['nama'] = nama;
    json['deskripsi'] = deskripsi;
    json['tgl_mulai'] = tglMulai;
    json['tgl_selesai'] = tglSelesai;
    json['lokasi'] = lokasi;
    json['status'] = status;
    json['check_in'] = checkIn;
    json['presensi_mulai'] = presensiMulai;
    json['presensi_akhir'] = presensiAkhir;
    json['ketentuan'] = ketentuan;

    if (dokumen != null) {
      json['dokumen'] = dokumen!.map((v) => v.toJson()).toList();
    }

    if (agenda != null) {
      final Map<String, dynamic> agendaJson = {};
      agenda!.forEach((key, value) {
        agendaJson[key] = value.map((v) => v.toJson()).toList();
      });
      json['agenda'] = agendaJson;
    }

    if (partisipan != null) {
      json['partisipan'] = partisipan!.toJson();
    }

    return json;
  }
}

class DokumenModel {
  String? nama;
  String? ketentuan;
  String? format;
  int? min;
  int? max;
  bool? isWajib;

  DokumenModel({
    this.nama,
    this.ketentuan,
    this.format,
    this.min,
    this.max,
    this.isWajib,
  });

  DokumenModel.fromJson(Map<String, dynamic> json) {
    nama = json['nama'];
    ketentuan = json['ketentuan'];
    format = json['format'];
    min = json['min'];
    max = json['max'];
    isWajib = json['is_wajib'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['nama'] = nama;
    json['ketentuan'] = ketentuan;
    json['format'] = format;
    json['min'] = min;
    json['max'] = max;
    json['is_wajib'] = isWajib;
    return json;
  }
}

class AgendaModel {
  int? id;
  String? tanggal;
  String? jamMulai;
  String? jamSelesai;
  String? kegiatan;
  String? keterangan;
  int? narasumberId;
  NarasumberModel? narasumber;

  AgendaModel({
    this.id,
    this.tanggal,
    this.jamMulai,
    this.jamSelesai,
    this.kegiatan,
    this.keterangan,
    this.narasumberId,
    this.narasumber,
  });

  AgendaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tanggal = json['tanggal'];
    jamMulai = json['jam_mulai'];
    jamSelesai = json['jam_selesai'];
    kegiatan = json['kegiatan'];
    keterangan = json['keterangan'];
    narasumberId = json['narasumber_id'];
    narasumber = json['narasumber'] != null
        ? NarasumberModel.fromJson(json['narasumber'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['id'] = id;
    json['tanggal'] = tanggal;
    json['jam_mulai'] = jamMulai;
    json['jam_selesai'] = jamSelesai;
    json['kegiatan'] = kegiatan;
    json['keterangan'] = keterangan;
    json['narasumber_id'] = narasumberId;
    if (narasumber != null) {
      json['narasumber'] = narasumber!.toJson();
    }
    return json;
  }
}
class NarasumberModel {
  int? id;
  String? nama;

  NarasumberModel({this.id, this.nama});

  NarasumberModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['id'] = id;
    json['nama'] = nama;
    return json;
  }
}
class PartisipanModel {
  int? id;
  String? peran;
  String? konfirmasi;
  String? wktKonfirmasi;
  List<DokumenPartisipanModel>? dokumen;

  PartisipanModel({
    this.id,
    this.peran,
    this.konfirmasi,
    this.wktKonfirmasi,
    this.dokumen,
  });

  PartisipanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    peran = json['peran'];
    konfirmasi = json['konfirmasi'];
    wktKonfirmasi = json['wkt_konfirmasi'];

    if (json['dokumen'] != null) {
      dokumen = <DokumenPartisipanModel>[];
      json['dokumen'].forEach((v) {
        dokumen!.add(DokumenPartisipanModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['id'] = id;
    json['peran'] = peran;
    json['konfirmasi'] = konfirmasi;
    json['wkt_konfirmasi'] = wktKonfirmasi;
    if (dokumen != null) {
      json['dokumen'] = dokumen!.map((v) => v.toJson()).toList();
    }
    return json;
  }
}

class DokumenPartisipanModel {
  String? nama;
  String? file;
  String? fileUrl;

  DokumenPartisipanModel({this.nama, this.file, this.fileUrl});

  DokumenPartisipanModel.fromJson(Map<String, dynamic> json) {
    nama = json['nama'];
    file = json['file'];
    fileUrl = json['file_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['nama'] = nama;
    json['file'] = file;
    json['file_url'] = fileUrl;
    return json;
  }
}
