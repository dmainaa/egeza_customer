import 'dart:ffi';

class User{
  int id;
  String name;
  String phone;
  String email;
  String status;
  String profile_url;

  User(this.id, this.name, this.phone, this.email, this.status,
      this.profile_url);
  
  factory User.fromJson(Map<String, dynamic> map){
    return User(map["id"], map["name"] ?? "", map["phone"] ?? "", map["email"] ?? "", map["status"] ?? "", map["profile_photo_url"] ?? "");
  }
}

class ParkingSpot{
  int id;
  String name;
  double latitude;
  double longitude;
  String ratePerMinute;
  String distance;
  int availableSpaces;
  String? qrCode;
  bool? hasActiveSessions;



  ParkingSpot(this.id, this.name, this.latitude, this.longitude, this.ratePerMinute,
      this.distance, this.availableSpaces);

  factory ParkingSpot.fromJson(Map<String, dynamic> map){
    return ParkingSpot(map["id"], map["name"] ?? "", double.parse(map["latitude"] ?? "0.0"), double.parse(map["longitude"] ?? "0.0"), map["rate_per_minute"] ?? "", map["distance"] ?? "", map["available_spaces"] ?? 0);
  }

  void setHasAtiveSessions(bool hasActive){
    this.hasActiveSessions = hasActive;
  }

  void setQRCode(String qrCode){
    this.qrCode = qrCode;
  }
}

class Vehicle{
  int id;
  String title;
  int type;

  String icon;
  String lastParked;


  Vehicle(this.id, this.title, this.type, this.icon, this.lastParked,);

  factory Vehicle.fromJson(Map<String, dynamic> map){
    return Vehicle(map["id"] ?? 0, map["title"] ?? "", map["type"] ?? 0, map["icon"] ?? "", map["last_parked"] ?? "");
  }
}

class Card{


}

class ParkingHistory{
  int id;
  String title;
  double latitude;
  double longitude;
  String date;
  String startTime;
  String endTime;

  String status;
  String icon;
  String bill;

  String receipt_url;


  ParkingHistory(this.id, this.title, this.latitude, this.longitude, this.date, this.bill, this.startTime, this.endTime, this.status, this.icon, this.receipt_url);

  factory ParkingHistory.fromJson(Map<String, dynamic> map){
    return ParkingHistory(map["id"] ?? "", map["title"] ?? "", double.parse(map["coordinates"]["latitude"] ?? "0.0"), double.parse(map["coordinates"]["longitude"] ?? "0.0"), map["date"] ?? "", map["bill"] ?? "", map["start_time"] ?? "", map["end_time"] ?? "", map["status"] ?? "", map["icon"] ?? "",  map["receipt"] ?? "");
  }
}

class MyAccount{

  String balance;
  String currency;
  String paybill;
  String account;
  List<Card> cards = [];


  MyAccount(this.balance, this.currency, this.paybill, this.account);

  factory MyAccount.fromJson(Map<String, dynamic> map){
   return MyAccount(map["balance"] ?? "", map["currency"] ?? "", map["details"]["paybill"] ?? "", map["details"]["account"] ?? "");
  }

  setCards(List<Card> cards){
    this.cards = cards;
  }
}

class Transaction{

  String title;
  String date;
  String amount;
  String type;
  String currency;


  Transaction(this.title, this.date, this.amount, this.type, this.currency);

  factory Transaction.fromJson(Map<String, dynamic> map){
    return Transaction(map["title"] ?? "", map["date"] ?? "", map["amount"]?? "", map["type"] ?? "", map["currency"] ?? "");
  }

}

class Promotion{

  String title;
  String expiry;
  String amount;



  Promotion(this.title, this.expiry, this.amount);

  factory Promotion.fromJson(Map<String, dynamic> map){
    return Promotion(map["title"] ?? "", map["expiry"] ?? "", map["amount"] ?? "");
  }

}


class Session{
  int id;
  String title, start, rate_per_minute, base_pay, gross,icon;
  int  minutes_spent;
  String currency;
  String status;
  String billStatus;
  String exitMinutes;

  Session(this.id, this.title, this.start, this.rate_per_minute, this.base_pay,
      this.gross, this.icon, this.minutes_spent, this.currency, this.status, this.billStatus, this.exitMinutes);

  factory Session.fromJson(Map<String, dynamic> map){
    return Session(map["id"] ?? "", map["title"] ?? "", map["start"] ?? "", map["bill"]["rate_per_minute"] ?? "", map["bill"]["base_pay"] ?? "", map["bill"]["gross"] ?? "", map["icon"] ?? "", map["bill"]["minutes_spent"] ?? 0, map["currency"] ?? "", map["status"] ?? "", map["bill"]["status"] ?? "status", map["bill"]["exit_minutes"] ?? "status");
  }
}

class Bill{
  int id;

  String to_pay;

  List<PaymentMethod> paymentMethods;

  String phonenumber;

  String total_payable, total_paid, vat_rate, vat_amount, currency, discount;


  Bill(this.id, this.total_paid, this.to_pay, this.total_payable, this.vat_rate,
      this.vat_amount, this.currency, this.paymentMethods, this.phonenumber, this.discount);

  factory Bill.fromJson(Map<String, dynamic> map){
    return Bill(map["id"] ?? 0, map["total_paid"] ?? "0.0", map["to_pay"] ?? " ", map["total_payable"] ?? "", map["vat"]["rate"]  ?? "", map["vat"]["amount"] ?? "", map["currency"] ?? "", [], map["phone"], map["discount"] ?? "");
  }

  setPaymentMethods(List<PaymentMethod> methods){
    this.paymentMethods = methods;
  }
}

class PaymentMethod{
  int id;

  String title;
  String icon;



  PaymentMethod(this.id, this.title, this.icon);

  factory PaymentMethod.fromJson(Map<String, dynamic> map){
    return PaymentMethod(map["id"] ?? 0, map["title"] ?? "", map["icon"] ?? "");
  }
}

class PaymentStatus{
  bool status;
  String message;
  String paybill;
  int account;

  PaymentStatus(this.status, this.message, this.paybill, this.account);
  
  factory PaymentStatus.fromJson(Map<String, dynamic> map){
    return PaymentStatus(map["status"] ?? false, map["message"] ?? "", map["details"]["paybill"] ?? "", map["details"]["account"] ?? 0);
  }
}