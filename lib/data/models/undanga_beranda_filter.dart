import 'package:mangament_acara/data/models/undanga_beranda.dart';

class UndanganFilterResponse {
  List<AcaraModel>? data;
  int? currentPage;
  int? from;
  bool? hasMorePages;
  int? perPage;
  bool? success;
  int? to;

  UndanganFilterResponse(
      {this.data,
      this.currentPage,
      this.from,
      this.hasMorePages,
      this.perPage,
      this.success,
      this.to});

  UndanganFilterResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AcaraModel>[];
      json['data'].forEach((v) {
        data!.add(new AcaraModel.fromJson(v));
      });
    }
    currentPage = json['current_page'];
    from = json['from'];
    hasMorePages = json['has_more_pages'];
    perPage = json['per_page'];
    success = json['success'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['current_page'] = this.currentPage;
    data['from'] = this.from;
    data['has_more_pages'] = this.hasMorePages;
    data['per_page'] = this.perPage;
    data['success'] = this.success;
    data['to'] = this.to;
    return data;
  }
}