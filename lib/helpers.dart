import 'dart:convert';
import 'dart:io';
import 'package:arcjoga_frontend/pages/auth/login.dart';
import 'package:arcjoga_frontend/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:arcjoga_frontend/config.dart';
import 'package:http_parser/http_parser.dart';
import 'package:arcjoga_frontend/models/loader.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class CustomResponse {
  final int statusCode;
  final dynamic data;

  CustomResponse({
    required this.statusCode,
    this.data,
  });
}

class Helpers {
  static const _storage = FlutterSecureStorage();

  static Future<CustomResponse> sendFileRequest(
    BuildContext context,
    String endpoint, {
    required File file,
    String method = 'POST',
    Map<String, String>? headers,
    Map<String, dynamic>? fields,
    bool requireToken = false,
  }) async {
    var uri = Uri.parse('${Config.apiUrl}/$endpoint');
    var request = http.MultipartRequest(method, uri);

    var multipartFile = await http.MultipartFile.fromPath(
      'file',
      file.path,
      contentType: MediaType(
        'image',
        'jpeg',
      ),
    );

    request.files.add(multipartFile);
    fields?.forEach((key, value) {
      request.fields[key] = value;
    });

    if (requireToken) {
      String? bearerToken = await _storage.read(key: 'token');
      if (bearerToken == null) {
        Flushbar(
          message:
              "A felhasználói azonosítás sikertelen volt! Kérjük jelentkezzen be!",
          duration: const Duration(seconds: 3),
          flushbarPosition: FlushbarPosition.TOP,
        ).show(context);
      }
      request.headers['Authorization'] = 'Bearer $bearerToken';
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return CustomResponse(
          statusCode: response.statusCode,
          data: json.decode(response.body),
        );
      } else {
        Flushbar(
          message:
              "A kérés sikertelen volt: ${response.statusCode}", //  ${response.body}
          duration: const Duration(seconds: 3),
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: Colors.red.shade400,
        ).show(context);

        return CustomResponse(
          statusCode: response.statusCode,
          data: response.body,
        );
      }
    } catch (e, stackTrace) {
      // Handle exceptions...
      if (Config.isLiveMode) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
        );
      }
      Flushbar(
        message: "Váratlan szerver hiba történt...", // $e
        duration: const Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: Colors.red.shade400,
      ).show(context);
      throw Exception();
    }
  }

  static Future<dynamic> sendRequest(
    BuildContext context,
    String endpoint, {
    String method = 'GET',
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? fields,
    bool requireToken = false,
  }) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      // _hideLoader(context);
      Flushbar(
        message: "Nincs internet kapcsolat...",
        duration: const Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: Colors.red.shade400,
      ).show(context);

      throw Exception("No internet connection");
    }

    var loaderModel = Provider.of<LoaderModel>(
      context,
      listen: false,
    );

    // _showLoader(context);

    if (requireToken) {
      var isLoggedIn =
          await Provider.of<UserProvider>(context).isUserLoggedIn();
      String? bearerToken = await _storage.read(key: 'token');
      if (bearerToken == null && !isLoggedIn) {
        Flushbar(
          message: "A bejelentkezése lejárt, kérjük lépjen be újra fiókjába!",
          duration: const Duration(seconds: 3),
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: Colors.red.shade400,
        ).show(context).then(
              (_) => Navigator.pushNamedAndRemoveUntil(
                context,
                Login.routeName,
                (Route<dynamic> route) => false,
              ),
            );

        // Immediately exit the function if the user is not logged in.
        return Future.error("User not logged in");
      }
      headers ??= {};
      headers['Authorization'] = 'Bearer $bearerToken';
    }

    try {
      loaderModel.show();
      http.Response response = await _makeHttpRequest(
        endpoint,
        method,
        headers,
        body,
      );

      if (response.statusCode == 200) {
        // print("RESPONSE: ${response.body}");
        loaderModel.hide();

        return CustomResponse(
          statusCode: response.statusCode,
          data: json.decode(response.body),
        );
      } else if (response.statusCode == 401) {
        // _hideLoader(context);

        loaderModel.hide();

        Flushbar(
          //: ${response.statusCode} ${response.body}
          message: "A felhasználói azonosítás sikertelen volt!",
          duration: const Duration(seconds: 3),
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: Colors.red.shade400,
        ).show(context);

        return CustomResponse(
          statusCode: response.statusCode,
          data: json.decode(response.body)['message'],
        );
      } else {
        // _hideLoader(context);
        loaderModel.hide();
        Flushbar(
          message:
              "Szerver hiba történt...: ${response.statusCode}", //${response.body}
          duration: const Duration(seconds: 3),
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: Colors.red.shade400,
        ).show(context);

        return CustomResponse(
          statusCode: response.statusCode,
          data: json.decode(response.body)['message'],
        );
      }
    } catch (e, stackTrace) {
      if (Config.isLiveMode) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
        );
      }

      loaderModel.hide();

      Flushbar(
        message: "Váratlan szerver hiba történt...: $e", //: $e
        duration: const Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: Colors.red.shade400,
      ).show(context);

      return CustomResponse(
        statusCode: 500,
        data: {
          'message': '$e',
        },
      );
    }
  }

  static Future<http.Response> _makeHttpRequest(
    String endpoint,
    String method,
    Map<String, String>? headers,
    dynamic body,
  ) async {
    String url = '${Config.apiUrl}/$endpoint';
    headers ??= {};
    headers['Content-Type'] = 'application/json';

    switch (method.toUpperCase()) {
      case 'POST':
        return await http.post(
          Uri.parse(url),
          headers: headers,
          body: json.encode(body),
        );
      case 'GET':
      default:
        return await http.get(
          Uri.parse(url),
          headers: headers,
        );
    }
  }
}
