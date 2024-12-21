import 'package:dio/dio.dart';
import 'package:easypark/data/network/failure.dart';


enum DataSource{
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTHORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECEIVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  DEFAULT
}

class ResponseCode{
      static const int  SUCCESS = 200;
      static const int NO_CONTENT = 201;
      static const int BAD_REQUEST = 400;
      static const int FORBIDDEN = 403;
      static const int UNAUTHORISED = 401;
      static const int NOT_FOUND = 404;
      static const int INTERNAL_SERVER_ERROR = 500;
      static const int DEFAULT = 0;

      //local status code
      static const int UNKNOWN = -1;
      static const int CONNECT_TIMEOUT = -2;
      static const int CANCEL = -3;
      static const int RECEIVE_TIMEOUT = -4;
      static const int SEND_TIMEOUT = -5;
      static const int CACHE_ERROR = -6;
      static const int NO_INTERNET_CONNECTION  = -7;
}

extension DataSourceExtension on DataSource{

  Failure getFailure() {
    switch (this) {
      case DataSource.BAD_REQUEST:
      return Failure(ResponseCode.BAD_REQUEST, ResponseCodeMessage.BAD_REQUEST);
      case DataSource.FORBIDDEN:
        return Failure(ResponseCode.FORBIDDEN, ResponseCodeMessage.FORBIDDEN);
      case DataSource.UNAUTHORISED:
        return Failure(ResponseCode.UNAUTHORISED, ResponseCodeMessage.UNAUTHORISED);
      case DataSource.NOT_FOUND:
        return Failure(ResponseCode.NOT_FOUND, ResponseCodeMessage.NOT_FOUND);
      case DataSource.INTERNAL_SERVER_ERROR:
        return Failure(ResponseCode.INTERNAL_SERVER_ERROR, ResponseCodeMessage.INTERNAL_SERVER_ERROR);
      case DataSource.CONNECT_TIMEOUT:
        return Failure(ResponseCode.CONNECT_TIMEOUT, ResponseCodeMessage.CONNECT_TIMEOUT);
      case DataSource.CANCEL:
        return Failure(ResponseCode.CANCEL, ResponseCodeMessage.CANCEL);
      case DataSource.RECEIVE_TIMEOUT:
        return Failure(ResponseCode.RECEIVE_TIMEOUT, ResponseCodeMessage.RECEIVE_TIMEOUT);
      case DataSource.SEND_TIMEOUT:
        return Failure(ResponseCode.SEND_TIMEOUT, ResponseCodeMessage.SEND_TIMEOUT);
      case DataSource.CACHE_ERROR:
        return Failure(ResponseCode.CACHE_ERROR, ResponseCodeMessage.CACHE_ERROR);
      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(ResponseCode.NO_INTERNET_CONNECTION, ResponseCodeMessage.NO_INTERNET_CONNECTION);
      case DataSource.DEFAULT:
        return Failure(ResponseCode.UNKNOWN, ResponseCodeMessage.UNKNOWN);
        default:
          return Failure(ResponseCode.UNKNOWN, ResponseCodeMessage.UNKNOWN);

    }
  }




}


class ErrorHandler implements Exception{
  late Failure failure;

  ErrorHandler.handle(dynamic error){
    if(error is DioError){
    }else{
      failure = DataSource.DEFAULT.getFailure();
    }
  }


}

class ResponseCodeMessage{
  static const String  SUCCESS = "Success";
  static const String NO_CONTENT = "Success With No Content";
  static const String BAD_REQUEST = "Bad request, try again later";
  static const String FORBIDDEN = "Forbidden request, try again later";
  static const String UNAUTHORISED = "Unauthorised User, try again later";
  static const String NOT_FOUND = "Url Not Found, try again later";
  static const String INTERNAL_SERVER_ERROR = "Server Errorr";
  static const String DEFAULT = "Something wrong happened";

  //local status code
  static const String UNKNOWN = "Something wrong happened";
  static const String CONNECT_TIMEOUT = "Timeout. Try again later";
  static const String CANCEL = "Request was cancelled, try again later";
  static const String RECEIVE_TIMEOUT = "Timeout. Try again later";
  static const String SEND_TIMEOUT ="Timeout. Try again later";
  static const String CACHE_ERROR = "Cache Error. Try again later";
  static const String NO_INTERNET_CONNECTION  = "Check your connectivity";
}

class AppInternalStatus{
  static const int SUCCESS = 200;
  static const int FAILURE = 1;

}