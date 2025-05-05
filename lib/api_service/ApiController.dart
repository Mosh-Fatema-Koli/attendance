import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../common_controller/MiscController.dart';

class API {

  final Dio _dio = Dio();
  final miscontroller=MiscController();

  API() {
    _dio.options.baseUrl = "http://attendance.mrshakil.com/api";
    _dio.interceptors.add(PrettyDioLogger());
  }

  Dio get sendRequest => _dio;

  Future<Response> apiCore({required String address, required String method, String? token, dynamic jsonData,}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      //headers['Authorization'] = 'Bearer $token';
      headers['Authorization'] = 'Token $token';
    }

    _dio.options.headers = headers;
    _dio.options.method = method;

    try {
      return await _dio.request(address, data: jsonData);
    } catch (e) {
      rethrow;
    }
  }

  /// **Login API**
  login({String? endpoint, required String username, required String password,}) async {
    final String httpAddress = '/login/';
    var loginRequest = {
      "username": username,
      "password": password,
    };

    var jsonRequest = json.encode(loginRequest);
    print(jsonRequest);

    var loginResponse = {
      "Success": false,
      "Message": "Login failed, please try again",
      "Packet": {},
    };
    var message = '';

    try {
      var apiResponse = await apiCore(address: httpAddress, method: 'POST', jsonData: jsonRequest,);
        print(apiResponse.statusCode );
      if (apiResponse.statusCode == 200) {
        Map response = apiResponse.data;
        if (response.isNotEmpty) {
          message = 'Login Successful';
          loginResponse['Success'] = true;
          loginResponse['Message'] = "Login Successfully";
          loginResponse['Packet'] = response["user"];
          return json.encode(loginResponse);
        } else {
          loginResponse['Success'] = false;
          loginResponse['Message'] = message;
          loginResponse['Packet'] = '';
          return json.encode(loginResponse);
        }
      }
      else {
        loginResponse['Success'] = false;
        if (apiResponse.statusCode == 400) {
          message = 'Bad Request';
        } else if (apiResponse.statusCode == 401) {
          message = 'Unauthorized';
        } else if (apiResponse.statusCode == 403) {
          message = 'Forbidden';
        } else if (apiResponse.statusCode == 404) {
          message = 'Not Found';
        } else if (apiResponse.statusCode == 500) {
          message = 'Internal Server Error';
        } else if (apiResponse.statusCode == 504) {
          message = 'Gateway Timeout';
        } else {
          message = 'Unauthorized';
        }
        loginResponse['Message'] = message;
        loginResponse['Packet'] = '';
        return json.encode(loginResponse);
      }
    } on SocketException {
      return json.encode(loginResponse);
    }  on DioException {
      return json.encode(loginResponse);
    } catch (ex) {
      loginResponse['Success'] = false;
      loginResponse['Message'] = 'API request failed : $ex';
      loginResponse['Packet'] = '';
      return json.encode(loginResponse);
    }
  }

  /// **Fetch List Data (GET Request)**
  fetchListData({required String endpoint, String? token,}) async {
    var fetchResponse = {
      "Success": false,
      "Message": "",
      "PacketList": [],
    };

    try {
      Response? apiResponse = await apiCore(address: endpoint, method: 'GET', token: token);

      if (apiResponse.statusCode == 200) {
        var response = apiResponse.data;
        bool success = true;
        fetchResponse['Success'] = success;
          var packetList = response;
          if (packetList.isNotEmpty) {
            fetchResponse['Message'] = 'Data fetched successfully';
            fetchResponse['PacketList'] = packetList;
        }
        return json.encode(fetchResponse);
      } else {
        fetchResponse['Success'] = false;
        fetchResponse['Message'] = _getHttpErrorMessage(apiResponse?.statusCode);
        return json.encode(fetchResponse);
      }
    } on SocketException {
      fetchResponse['Success'] = false;
      fetchResponse['Message'] = 'No internet connection';
    } on DioException {
      fetchResponse['Success'] = false;
      fetchResponse['Message'] = 'Request failed';
    } catch (ex) {
      fetchResponse['Success'] = false;
      fetchResponse['Message'] = 'API request failed: $ex';
    }
    return json.encode(fetchResponse);
  }

  /// **Fetch Data (GET Request)**
  fetchData({required String endpoint, String? token,}) async {
    var fetchResponse = {
      "Success": false,
      "Message": "",
      "Packet": {},
    };
    try {
      Response? apiResponse = await apiCore(address: endpoint, method: 'GET', token: token);

      if (apiResponse.statusCode == 200) {
        var response = apiResponse.data;

        bool success = true;
        fetchResponse['Success'] = success;
        var packetList = response;
        if (packetList.isNotEmpty) {
          fetchResponse['Message'] = 'Data fetched successfully';
          fetchResponse['PacketList'] = packetList;
        }
        return json.encode(fetchResponse);

      } else {
        fetchResponse['Success'] = false;
        fetchResponse['Message'] = _getHttpErrorMessage(apiResponse.statusCode);
        return json.encode(fetchResponse);
      }
    } on SocketException {
      fetchResponse['Success'] = false;
      fetchResponse['Message'] = 'No internet connection';
    } on DioException {
      fetchResponse['Success'] = false;
      fetchResponse['Message'] = 'Request failed';
    } catch (ex) {
      fetchResponse['Success'] = false;
      fetchResponse['Message'] = 'API request failed: $ex';
    }
    return json.encode(fetchResponse);
  }

  /// **Post Data (POST Request)**
  postData({
    required String endpoint,
    required dynamic data, // 🔥 Accepts both Map<String, dynamic> and FormData
    String? token,
  }) async {
    var fetchResponse = {
      "Success": false,
      "Message": "",
      "Packet": {},
    };

    try {
      // ✅ Pass `data` directly, it can now handle FormData or JSON
      Response apiResponse = await apiCore(
        address: endpoint,
        method: 'POST',
        token: token,
        jsonData: data, // 🔥 data can be either Map<String, dynamic> or FormData
      );

      if (apiResponse.statusCode == 200 ||apiResponse.statusCode == 201) {
        var response = apiResponse.data;
        fetchResponse['Success'] = true;
        fetchResponse['Message'] = 'Request added successfully';
        fetchResponse['Packet'] = response;
      } else {
        fetchResponse['Success'] = false;
        fetchResponse['Message'] = _getHttpErrorMessage(apiResponse.statusCode);
      }
    } on SocketException {
      fetchResponse['Success'] = false;
      fetchResponse['Message'] = 'No internet connection';
    } on DioException catch (e) {
      fetchResponse['Success'] = false;
      fetchResponse['Message'] = 'Request failed: ${e.message}';
    } catch (ex) {
      fetchResponse['Success'] = false;
      fetchResponse['Message'] = 'API request failed: $ex';
    }

    return json.encode(fetchResponse);
  }

  /// **Update Data (PUT Request)**
  updateData({required String endpoint, required dynamic data, String? token,}) async {

    var fetchResponse = {
      "Success": false,
      "Message": "",
      "Packet": {},
    };

    try {
      Response? apiResponse = await apiCore(
        address: endpoint,
        method: 'PUT',
        token: token,
        jsonData: data,
      );

      if (apiResponse.statusCode == 200 ||apiResponse.statusCode == 201) {
        var response = apiResponse.data;
        fetchResponse['Success'] = true;
        fetchResponse['Message'] = 'Request added successfully';
        fetchResponse['Packet'] = response;
      } else {
        fetchResponse['Success'] = false;
        fetchResponse['Message'] = _getHttpErrorMessage(apiResponse.statusCode);
      }
    }  on SocketException {
     fetchResponse['Success'] = false;
      fetchResponse['Message'] = 'No internet connection';
    } on DioException catch (e) {
    fetchResponse['Success'] = false;
    fetchResponse['Message'] = 'Request failed: ${e.message}';
    } catch (ex) {
    fetchResponse['Success'] = false;
    fetchResponse['Message'] = 'API request failed: $ex';
    }

return json.encode(fetchResponse);
}


/// **Delete Data (DELETE Request)**
  deleteData({required String endpoint, String? token,}) async {

    var fetchResponse = {
      "Success": false,
      "Message": "",
      "Packet": {},
    };

    try {
      Response? apiResponse = await apiCore(
        address: endpoint,
        method: 'DELETE',
        token: token,
      );

      if (apiResponse.statusCode == 200 ||apiResponse.statusCode == 201) {
        var response = apiResponse.data;
        fetchResponse['Success'] = true;
        fetchResponse['Message'] = 'Request added successfully';
        fetchResponse['Packet'] = response;
      } else {
        fetchResponse['Success'] = false;
        fetchResponse['Message'] = _getHttpErrorMessage(apiResponse.statusCode);
      }
    }  on SocketException {
      fetchResponse['Success'] = false;
      fetchResponse['Message'] = 'No internet connection';
    } on DioException catch (e) {
      fetchResponse['Success'] = false;
      fetchResponse['Message'] = 'Request failed: ${e.message}';
    } catch (ex) {
      fetchResponse['Success'] = false;
      fetchResponse['Message'] = 'API request failed: $ex';
    }

    return json.encode(fetchResponse);
  }

  logout({required String endpoint, String? token,}) async {
    var fetchResponse = {
      "Success": false,
      "Message": "",
      "Packet": {},
    };
    try {
      Response? apiResponse = await apiCore(address: endpoint, method: 'GET', token: token);

      if (apiResponse.statusCode == 200) {
        Map<String, dynamic> response = apiResponse.data;
        bool success = true;
        fetchResponse['Success'] = success;
        if (success) {
          return json.encode(fetchResponse);
        }
      } else {
        fetchResponse['Success'] = false;
        fetchResponse['Message'] = _getHttpErrorMessage(apiResponse.statusCode);
        return json.encode(fetchResponse);
      }
    } on SocketException {
      fetchResponse['Success'] = false;
      fetchResponse['Message'] = 'No internet connection';
    } on DioException {
      fetchResponse['Success'] = false;
      fetchResponse['Message'] = 'Request failed';
    } catch (ex) {
      fetchResponse['Success'] = false;
      fetchResponse['Message'] = 'API request failed: $ex';
    }
    return json.encode(fetchResponse);
  }


  /// **Error Handling**
  // Map<String, dynamic> _handleErrorResponse(Response? response) {
  //   String message = "Something went wrong";
  //   if (response != null) {
  //     switch (response.statusCode) {
  //       case 400:
  //         message = 'Bad Request';
  //         break;
  //       case 401:
  //         message = 'Unauthorized';
  //         break;
  //       case 403:
  //         message = 'Forbidden';
  //         break;
  //       case 404:
  //         message = 'Not Found';
  //         break;
  //       case 500:
  //         message = 'Internal Server Error';
  //         break;
  //       case 504:
  //         message = 'Gateway Timeout';
  //         break;
  //       default:
  //         message = 'Unknown Error: ${response.statusCode}';
  //     }
  //   }
  //   return {"Success": false, "Message": message, "Packet": {}};
  // }

  /// **Helper Method for HTTP Error Messages**
  String _getHttpErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400: return 'Bad Request';
      case 401: return 'Unauthorized';
      case 403: return 'Forbidden';
      case 404: return 'Not Found';
      case 500: return 'Internal Server Error';
      case 504: return 'Gateway Timeout';
      default: return 'Unknown Error';
    }
  }

}


