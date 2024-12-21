

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:easypark/domain/usecase/finish_up.dart';
import 'package:easypark/presentation/common/state_renderer_impl.dart';
import 'package:easypark/presentation/finishup/finishup_controller.dart';
import 'package:easypark/presentation/finishup/finishup_viewmodel.dart';
import 'package:easypark/presentation/resources/color_manager.dart';
import 'package:easypark/presentation/resources/string_manager.dart';
import 'package:easypark/presentation/resources/value_manager.dart';
import 'package:easypark/presentation/universal%20widgets/customtext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../base/base_ui_shell.dart';

class EditProfileView extends StatefulWidget {
  final String firstName, lastName, profileUrl, email;
  const EditProfileView({Key? key, required this.firstName, required this.lastName, required this.profileUrl, required this.email}) : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {

  TextEditingController firstNameController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  ImageUploadController imageUploadController =
  Get.put(ImageUploadController());

  FinishUpViewModel _viewModel = FinishUpViewModel(FinishUpUseCase());

  late SharedPreferences  sharedPreferences;

  XFile? _image;


  @override
  void initState() {

    super.initState();
    _inializePreferences();
    _bind();
  }

  _inializePreferences()async{
    sharedPreferences = await SharedPreferences.getInstance();
  }

  _bind(){
    SchedulerBinding?.instance.addPostFrameCallback((timeStamp) {

    });


    firstNameController.text = widget.firstName;
    secondNameController.text = widget.lastName;
    emailController.text = widget.email;
    _viewModel.setFirstName(widget.firstName);
    _viewModel.setLastName(widget.lastName);
    _viewModel.setEmail(widget.email);
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
      _viewModel.messagesStreamController.add([true, "Details edited successfully"]);

    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.appBarColor,
        titleSpacing: 0,
        title: CustomText(
            AppStrings.editProfile, 16, FontWeight.w700, AppColors.blackColor),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(true);
          },
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.blackColor,
          ),
        ),
      ),

        body: BaseUiShell(
            loadingStreamController: _viewModel.loadingStreamController,
            contentWidget: getContentView(context),
            messageStreamController: _viewModel.messagesStreamController));
  }

  Widget getContentView(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        margin:  EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
            ),
            SizedBox(
              height: size.height * 0.07,
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
                        : Container(
                      height: 263,
                      width: 263,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            widget.profileUrl
                          ),

                        )
                      ),
                      child:  Stack(
                        alignment: Alignment.center,
                        children: [
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
              height: 10,
            ),

            CustomText(
                AppStrings.profileDetails, 16, FontWeight.w700, AppColors.blackColor),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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

                }

            ),
            const SizedBox(
              height: 64,
            ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                backgroundColor:  AppColors.defaultRed ,
                minimumSize: const Size(204, 56)),
            onPressed:   () async {
              _viewModel.finishUp();

            } ,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children:  [
                const Icon(Icons.check_circle, color: Colors.white,),
                const SizedBox(width: 14),
                CustomText(AppStrings.saveProfileChanges, 14, FontWeight.w700,
                    AppColors.whiteColor)
              ],
            ))
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

  _imgFromGallery() async {
    final image = await  ImagePicker.platform.getImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    _image = image;
    _cropImage();

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
}
