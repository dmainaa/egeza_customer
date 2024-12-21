// ignore_for_file: unnecessary_new

import 'dart:io';

import 'package:easypark/app/di.dart';
import 'package:easypark/domain/usecase/finish_up.dart';
import 'package:easypark/presentation/base/base_ui_shell.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';
import 'package:easypark/presentation/finishup/finishup_controller.dart';
import 'package:easypark/presentation/finishup/finishup_viewmodel.dart';
import 'package:easypark/presentation/finishup/textfield_local.dart';
import 'package:easypark/presentation/home/home_page_view.dart';
import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/resources/string_manager.dart';
import 'package:easypark/presentation/resources/value_manager.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:easypark/presentation/universal%20widgets/textfield_small.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/app_utils.dart';


class LetFinUp extends StatefulWidget {
  LetFinUp({Key? key}) : super(key: key);



  @override
  State<LetFinUp> createState() => _LetFinUpState();
}

XFile? _image;

class _LetFinUpState extends State<LetFinUp> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  ImageUploadController imageUploadController =
  Get.put(ImageUploadController());

  final FinishUpViewModel _viewModel = FinishUpViewModel(FinishUpUseCase());

  final AppUtils _appUtils = GetIt.I<AppUtils>();
  late SharedPreferences  sharedPreferences;

  _bind(){

    emailController.addListener(() {
      _viewModel.setEmail(emailController.text);
    });
    firstNameController.addListener(() {
      _viewModel.setFirstName(firstNameController.text);
    });
    secondNameController.addListener(() {
      _viewModel.setLastName(secondNameController.text);
    });

    _viewModel.finishUpStreamController.stream.listen((isSuccess) {
      sharedPreferences.setBool("isLoggedin", true);
      SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder:
                  (context, animation, secondaryAnimation) {
                return HomePageView();
              },
              transitionDuration: const Duration(milliseconds: 400),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                final tween = Tween(begin: begin, end: end);
                final offsetAnimation = animation.drive(tween);
                return SlideTransition(
                    position: offsetAnimation, child: child);
              },
            ));
      });

    });

    _viewModel.responseStreamController.stream.listen((isSuccess) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pop(context);
        showDialog(context: context, builder: (context){
          return _appUtils.getPopUpDialog(isSuccess: isSuccess, context: context, errorMessage: _viewModel.responseMessage, onTryAgain: (){
            _viewModel.finishUp();
          });
        });
      });
    });

  }

  _initializePreferences()async{
    sharedPreferences = await SharedPreferences.getInstance();
  }


  @override
  void initState() {
    super.initState();
    _initializePreferences();
    _bind();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.lightRed,
        body: BaseUiShell(
            loadingStreamController: _viewModel.loadingStreamController,
            contentWidget: getContentView(context),
            messageStreamController: _viewModel.messagesStreamController));
  }

  Widget getContentView(BuildContext context){
    return SingleChildScrollView(
      child: Container(
        margin:  EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             const SizedBox(
              width: double.infinity,
            ),
            const SizedBox(
              height: 88,
            ),
             CustomText(
                AppStrings.finishUp, 24, FontWeight.w600, AppColors.blackColor),
            const SizedBox(
              height: 23,
            ),
            StreamBuilder<String>(
              stream: _viewModel.outputCroppedFile,
              builder: (context, snapshot){
               return GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: snapshot?.data != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.file(
                        File(_image!.path),
                        width: 263,
                        height: 263,
                        fit: BoxFit.cover,
                      ),
                    )
                        : SizedBox(
                      height: 263,
                      width: 263,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                              "assets/images/letsfinishup/background.svg"),
                          SvgPicture.asset(
                              "assets/images/letsfinishup/person.svg"),
                          Positioned(
                              bottom: 20,
                              child: SvgPicture.asset(
                                  "assets/images/letsfinishup/upload.svg"))
                        ],
                      ),
                    ));
              },

            ),
            const SizedBox(
              height: 35,
            ),
             CustomText(
                AppStrings.whatsYourName, 16, FontWeight.w700, AppColors.blackColor),
            const SizedBox(
              height: 24,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: StreamBuilder<bool>(
                    stream: _viewModel.outputIsFirstNameValid,
                    builder: (context, snapshot){
                      
                      return Padding(
                        padding: EdgeInsets.all(AppSize.s8),
                        child: TextField(

                          keyboardType: TextInputType.text,
                          controller: firstNameController,
                          decoration: InputDecoration(
                            hintText:  AppStrings.firstName,
                            labelText: AppStrings.firstName,
                            errorText: (snapshot.data ?? false) ? AppStrings.enterValidFirstName : null,

                          ),

                        ),
                      );
                    },

                  ),
                ),
              
                Expanded(
                  child: StreamBuilder<bool>(
                    stream: _viewModel.outputIsLastNameValid,
                    builder: (context, snapshot){
                      return Padding(
                        padding: EdgeInsets.all(AppSize.s8),
                        child: TextField(

                          keyboardType: TextInputType.text,
                          controller: secondNameController,
                          decoration: InputDecoration(


                            hintText:  AppStrings.lastName,
                            labelText: AppStrings.lastName,
                            errorText: (snapshot.data ?? false) ? AppStrings.enterValidSecondName : null,

                          ),

                        ),
                      );

                    },

                  ),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            StreamBuilder<String>(
              stream: _viewModel.outputEmailIsValid,
              builder: (context, snapshot){
                return TextField(

                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(


                    hintText:  AppStrings.emailForReceipts,
                    labelText: AppStrings.emailForReceipts,
                    errorText: (snapshot?.data ) ?? null

                  ),

                );

                // return TextFieldLocal(
                //   AppStrings.emailForReceipts,
                //   const Icon(Icons.circle, color: AppColors.lightRed),
                //   false,
                //   TextInputAction.done,
                //   TextInputType.emailAddress,
                //       (p0) {},
                //       (value) {},
                //   "curtis.weaver@gmail.com",
                //   (snapshot?.data) ??  "",
                //   onChanged: (p0) {},
                // );
              }

            ),
            const SizedBox(
              height: 64,
            ),
            StreamBuilder<bool>(
              stream: _viewModel.outputIsAllInputValid,
              builder: (context, snapshot){
                return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        backgroundColor: (snapshot.data ?? false)  ? AppColors.defaultRed : Colors.grey,
                        minimumSize: const Size(204, 56)),
                    onPressed: (snapshot.data ?? false) ?   () async {
                      _viewModel.finishUp();
                    } : (){

                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children:  [
                        const Icon(Icons.check_circle, color: Colors.white,),
                        const SizedBox(width: 14),
                        CustomText(AppStrings.finishProfile, 14, FontWeight.w700,
                            AppColors.whiteColor)
                      ],
                    ));
              },

            )
          ],
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text(AppStrings.photoLibrary),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text(AppStrings.camera),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }



  _cropImage()async{

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image?.path ?? "",

      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    _viewModel.setFile(croppedFile);
  }

  _imgFromCamera() async {
    final image = await ImagePicker.platform.getImage(
        source: ImageSource.camera, imageQuality: 50
    );
    _image = image;
    _cropImage();
  }

  _imgFromGallery() async {
    final image = await ImagePicker.platform.getImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    _image = image;
    _cropImage();

  }
}
