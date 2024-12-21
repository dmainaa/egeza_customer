
import 'dart:async';
import 'dart:ffi';

import 'package:easypark/app/di.dart';
import 'package:easypark/domain/model/model.dart';
import 'package:easypark/domain/usecase/homepage_usecase.dart';
import 'package:easypark/domain/usecase/logout_usecase.dart';
import 'package:easypark/presentation/base/baseviewmodel.dart';
import 'package:easypark/presentation/common/state_renderer.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';
import 'package:easypark/presentation/home/home_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePageViewModel extends BaseViewModel with HomePageViewModelInputs, HomePageViewModelOutputs{
  LocationData? currentLocation;

  HomePageUseCase _useCase;

  Function(ParkingSpot) onMarkerClicked;

  StreamController parkingSpotsController = StreamController<List<ParkingSpot>>.broadcast();

  StreamController hasActiveSessionsController = StreamController<List<ParkingSpot>>.broadcast();

  StreamController resultsController = StreamController<List<dynamic>>.broadcast();

  StreamController markersController = StreamController<Set<Marker>>.broadcast();

  StreamController logoutController = StreamController<bool>.broadcast();

  BitmapDescriptor? bitmapDescriptor;


  HomePageViewModel(this._useCase, this.onMarkerClicked){
    setBitmapImage();
  }

  void setBitmapImage()async{
    bitmapDescriptor =  await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "assets/images/parkinginfo/parking_icon.png");
  }

  @override
  void dispose(){

  }

  void logout() async{
    loadingStreamController.add(true);
    LogOutUseCase logOutUseCase = LogOutUseCase();
    (await logOutUseCase.execute("input")).fold((l) {
      inputLogout.add(false);

    } , (r) => inputLogout.add(true));
  }

  @override
  // TODO: implement InputFetchMarkers
  Sink get InputFetchMarkers {
    return markersController.sink;
  }

  @override
  void getMarkers() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();


    double latitude = preferences.getDouble("latitude") ?? -1.2849483;
    double longitude = preferences.getDouble("longitude") ?? 36.8228721;
    // TODO: implement getMarkers
    (await _useCase.execute(HomePageUseCaseInputs(latitude, longitude))).fold((l) {



    }, (r) {
      List<ParkingSpot> parkingSpots  = r;
      parkingSpots.forEach((spot) {
        // print(spot.name);
      });
      List<dynamic> res = [];
      res.add(parkingSpots[0].hasActiveSessions ?? false);
      res.add(parkingSpots[0].qrCode ?? "");
      inputResults.add(res);
      decodeMarkersFromParkingSpots(parkingSpots);
    });
  }

  decodeMarkersFromParkingSpots(List<ParkingSpot> parkingSpots)async{
    Set<Marker> markers = {};
    parkingSpots.forEach((parkingSpot) {
      markers.add(Marker(
        markerId: MarkerId(parkingSpot.id.toString()),
        onTap: (){
          onMarkerClicked(parkingSpot);
        },
        position: LatLng(parkingSpot.latitude, parkingSpot.longitude),
        icon: bitmapDescriptor ?? BitmapDescriptor.defaultMarkerWithHue(4),
      
      ));
    });
    markersController.add(markers);
  }

  @override
  // TODO: implement outputMarkersStream
  Stream<Set<Marker>> get outputMarkersStream {
  return markersController.stream.map((event) => event);
  }

  @override
  // TODO: implement parkingSpotsStream
  Stream<List<ParkingSpot>> get parkingSpotsStream {
    return parkingSpotsController.stream.map((event) => event);
  }

  @override
  void setLocation(LocationData? locationData) {
    // TODO: implement setLocation
    this.currentLocation = locationData;
  }

  @override
  void start() {
    // TODO: implement start
  }

  void checkIfHasActiveSession() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();

    bool isTrue = await preferences.getBool("hasActiveSession") ?? false;

    inputActiveSession.add(isTrue);

  }

  @override
  // TODO: implement inputActiveSession
  Sink get inputActiveSession => hasActiveSessionsController.sink;

  @override
  // TODO: implement outputActiveSessions
  Stream<bool> get outputActiveSessions => hasActiveSessionsController.stream.map((event) => event);

  @override
  // TODO: implement inputResults
  Sink get inputResults => resultsController.sink;

  @override
  // TODO: implement outputResults
  Stream<List> get outputResults => resultsController.stream.map((event) => event);

  @override
  // TODO: implement inputLogout
  Sink get inputLogout => logoutController.sink;

  @override
  // TODO: implement outputLogout
  Stream<bool> get outputLogout => logoutController.stream.map((event) => event);



}

abstract class HomePageViewModelInputs{

  Sink get InputFetchMarkers;

  Sink get inputActiveSession;
  
  Sink get inputResults;

  Sink get inputLogout;

  void getMarkers();

  void setLocation(LocationData locationData);
}

abstract class HomePageViewModelOutputs{
  Stream<Set<Marker>> get outputMarkersStream;

  Stream<bool> get outputActiveSessions;

  Stream<bool> get outputLogout;

  Stream<List<dynamic>> get outputResults;

  Stream<List<ParkingSpot>> get parkingSpotsStream;


}