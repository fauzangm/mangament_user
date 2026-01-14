import 'dart:convert';

import 'package:mangament_acara/core/constants/contans.dart';
import 'package:mangament_acara/core/exception.dart';
import 'package:mangament_acara/core/sessionMangaer.dart';
import 'package:mangament_acara/data/models/undanga_beranda.dart';
import 'package:mangament_acara/data/models/undanga_beranda_filter.dart';
import 'package:mangament_acara/data/models/undangan_detail.dart';
import 'package:mangament_acara/domain/repositories/undangan_repository.dart';
import 'package:http/http.dart' as http;

class UndanganRepositoryImpl implements UndanganRepository {
  final http.Client client;

  UndanganRepositoryImpl(this.client);
  @override
  Future<UndanganBerandaResponse> undanganBeranda() async {
    final isToken = await getIsToken();
    print(isToken);
    final response = await client.get(
      Uri.parse("${Constans.baseUrl}personal/acara"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $isToken',
      },
    );
    try {
      if (response.statusCode < 300) {
        print(response.body);
        return UndanganBerandaResponse.fromJson(json.decode(response.body));
      } else {
        print(response.body);
        print(response.statusCode);
        throw ServerException();
      }
    } catch (e) {
      throw '$e';
    }
  }

  @override
  Future<bool> checkin(int id, String kode) async {
    final isToken = await getIsToken();
    print(isToken);
    final response = await client.post(
      Uri.parse("${Constans.baseUrl}personal/acara/$id/checkin"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $isToken',
      },
      body: jsonEncode({
        'token': kode
      }),
    );
    try {
      if (response.statusCode < 300) {
        print(response.body);
        return true;
      } else {
        print(response.body);
        print(response.statusCode);
        throw ServerException();
      }
    } catch (e) {
      throw '$e';
    }
  }

  @override
  Future<UndanganFilterResponse> filterUndanganBeranda(String status) async {
    final isToken = await getIsToken();
    print(isToken);
    final response = await client.get(
      Uri.parse("${Constans.baseUrl}personal/acara/$status"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $isToken',
      },
    );
    try {
      if (response.statusCode < 300) {
        print(response.body);
        return UndanganFilterResponse.fromJson(json.decode(response.body));
      } else {
        print(response.body);
        print(response.statusCode);
        throw ServerException();
      }
    } catch (e) {
      throw '$e';
    }
  }

  @override
  Future<bool> konfirmasiUndangan(int id, String status, String alasan) async {
    final isToken = await getIsToken();
    print(isToken);
    final response = await client.post(
      Uri.parse("${Constans.baseUrl}personal/acara/$id/konfirmasi"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $isToken',
      },
      body: jsonEncode({
        'status': status,
        'alasan': alasan
      }),
    );
    try {
      if (response.statusCode < 300) {
        print(response.body);
        return true;
      } else {
        print(response.body);
        print(response.statusCode);
        throw ServerException();
      }
    } catch (e) {
      throw '$e';
    }
  }

  @override
  Future<UndanganDetailResponse> undanganDetail(int id) async {
    final isToken = await getIsToken();
    print(isToken);
    final response = await client.get(
      Uri.parse("${Constans.baseUrl}personal/acara/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $isToken',
      },
    );
    try {
      if (response.statusCode < 300) {
        print(response.body);
        return UndanganDetailResponse.fromJson(json.decode(response.body));
      } else {
        print(response.body);
        print(response.statusCode);
        throw ServerException();
      }
    } catch (e) {
      throw '$e';
    }
  }
  
  @override
  Future<bool> presensi(int id, String tanggal, String sesi, String token) async {
    final isToken = await getIsToken();
    print(isToken);
    final response = await client.post(
      Uri.parse("${Constans.baseUrl}personal/acara/$id/presensi"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $isToken',
      },
      body: jsonEncode({
        'tanggal': tanggal,
        'sesi': sesi,
        'token': token
      }),
    );
    try {
      if (response.statusCode < 300) {
        print(response.body);
        return true;
      } else {
        print(response.body);
        print(response.statusCode);
        throw ServerException();
      }
    } catch (e) {
      throw '$e';
    }
  }
}
