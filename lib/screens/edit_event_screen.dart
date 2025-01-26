// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:provider/provider.dart';
import 'package:ticket_wise/provider/datepicker_provider.dart';
import 'package:ticket_wise/widgets/date_picker.dart';
import 'package:ticket_wise/widgets/time_picker_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:ticket_wise/models/event_model.dart';
import 'package:ticket_wise/provider/category_provider.dart';
import 'package:ticket_wise/provider/file_upload_provider.dart';
import 'package:ticket_wise/provider/image_picker.dart';
import 'package:ticket_wise/provider/event_provider.dart';
import 'package:ticket_wise/provider/video_picker_provider.dart';
import 'package:ticket_wise/screens/user_product_screen.dart';
import 'package:ticket_wise/utils/utils.dart';
import 'package:ticket_wise/widgets/constants.dart';
import 'package:ticket_wise/widgets/custom_dropdown.dart';
import 'package:ticket_wise/widgets/custom_textfield.dart';

class EditEventScreen extends StatefulWidget {
  final EventModel event;

  const EditEventScreen({super.key, required this.event});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late TextEditingController titleController;
  late TextEditingController priceController;
  late TextEditingController locationController;
  late TextEditingController cityController;

  late TextEditingController descriptionController;
  late TextEditingController eventdateController;
  late TextEditingController starttimeController;
  late TextEditingController endtimeController;

  VideoPlayerController? _videoController;

  bool _imagesUpdated = false;
  bool _videoUpdated = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.event.title);
    priceController = TextEditingController(text: widget.event.ticketPrice);
    descriptionController =
        TextEditingController(text: widget.event.description);
    eventdateController = TextEditingController(text: widget.event.eventDate);
    starttimeController = TextEditingController(
      text: widget.event.startTime,
    );

    endtimeController = TextEditingController(
      text: widget.event.endTime,
    );

    if (widget.event.eventvideourl.isNotEmpty) {
      _initializeVideoController(widget.event.eventvideourl);
    }
  }

  void _initializeVideoController(String videoUrl) {
    _videoController = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    eventdateController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImagePickerProvider>(context);
    final videoProvider = Provider.of<VideoPickerProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final productProvider = Provider.of<EventProvider>(context);
    final fileuploadprovider = Provider.of<FileUploadProvider>(context);
    final datepickerprovider = Provider.of<DatePickerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 14, right: 5, top: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 140,
                    width: 200,
                    child: CarouselSlider.builder(
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        autoPlay: false,
                      ),
                      itemCount: widget.event.eventImageUrls.length,
                      itemBuilder: (context, index, _) {
                        return GestureDetector(
                          onTap: () {
                            showBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Choose Product Photos',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () async {
                                            await imageProvider
                                                .pickImageFromCameraForProduct(
                                                    index);
                                            _imagesUpdated = true;
                                            Utils.back(context);
                                          },
                                          icon: const Icon(
                                            Icons.camera,
                                            color: PrimaryColor,
                                          ),
                                          label: const Text(
                                            'Camera',
                                            style:
                                                TextStyle(color: PrimaryColor),
                                          ),
                                        ),
                                        TextButton.icon(
                                          onPressed: () async {
                                            await imageProvider
                                                .pickImageFromGalleryForProduct(
                                                    index);
                                            _imagesUpdated = true;
                                            Utils.back(context);
                                          },
                                          icon: const Icon(
                                            Icons.image,
                                            color: PrimaryColor,
                                          ),
                                          label: const Text(
                                            'Gallery',
                                            style:
                                                TextStyle(color: PrimaryColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 140,
                            width: 145,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    widget.event.eventImageUrls[index]),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(
                                color: PrimaryColor,
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Choose Video',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton.icon(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await videoProvider.pickVideoFromCamera();
                                      _videoUpdated = true;
                                      setState(() {
                                        _videoController = VideoPlayerController
                                            .file(videoProvider.selectedVideo!)
                                          ..initialize().then((_) {
                                            setState(() {});
                                          });
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.camera,
                                      color: PrimaryColor,
                                    ),
                                    label: const Text(
                                      'Camera',
                                      style: TextStyle(color: PrimaryColor),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await videoProvider
                                          .pickVideoFromGallery();
                                      _videoUpdated = true;
                                      setState(() {
                                        _videoController = VideoPlayerController
                                            .file(videoProvider.selectedVideo!)
                                          ..initialize().then((_) {
                                            setState(() {});
                                          });
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.video_collection_rounded,
                                      color: PrimaryColor,
                                    ),
                                    label: const Text(
                                      'Gallery',
                                      style: TextStyle(color: PrimaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 140,
                      width: 145,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: PrimaryColor,
                          width: 2,
                        ),
                      ),
                      child: _videoController != null &&
                              _videoController!.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _videoController!.value.aspectRatio,
                              child: VideoPlayer(_videoController!),
                            )
                          : const Icon(
                              Icons.video_call,
                              color: PrimaryColor,
                              size: 40,
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 16),
                      child: const Text(
                        'Click to add photos',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: PrimaryColor),
                      ),
                    ),
                    const SizedBox(width: 85),
                    const Text(
                      'Click to add videos',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, color: PrimaryColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  CustomTextField(
                    controller: titleController,
                    hintText: 'Enter Event Name:',
                    hintStyle:
                        const TextStyle(fontSize: 15, color: PrimaryColor),
                    textAlign: TextAlign.left,
                    enableBorder: true,
                    textStyle: const TextStyle(color: PrimaryColor),
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: priceController,
                    hintText: 'Enter Ticket Price :',
                    hintStyle:
                        const TextStyle(fontSize: 15, color: PrimaryColor),
                    textAlign: TextAlign.left,
                    enableBorder: true,
                    textStyle: const TextStyle(color: PrimaryColor),
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: locationController,
                    hintText: 'Enter Event Address :',
                    hintStyle:
                        const TextStyle(fontSize: 15, color: PrimaryColor),
                    textAlign: TextAlign.left,
                    enableBorder: true,
                    textStyle: const TextStyle(color: PrimaryColor),
                  ),
                  const SizedBox(height: 15),
                  const DatePickerWidget(),
                  const SizedBox(height: 15),
                  const TimePickerWidget(
                    isStartTime: true,
                    hint: 'Select event Start Time',
                  ),
                  const SizedBox(height: 15),
                  const TimePickerWidget(
                    isStartTime: false,
                    hint: 'Select event End Time',
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.only(right: 0),
                    height: 70,
                    width: 400,
                    child: CustomDropDown(
                      onChanged: (value) =>
                          categoryProvider.updateSelectedValue(value!),
                      value: categoryProvider.selectedValue,
                      list: categoryProvider.categoryNames,
                      expanded: true,
                      hintText: 'Select Category',
                      textColor: PrimaryColor,
                      borderColor: PrimaryColor,
                      hintTextColor: PrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: descriptionController,
                    hintText: 'Enter Description',
                    maxLines: 10,
                    hintStyle:
                        const TextStyle(fontSize: 15, color: PrimaryColor),
                    textAlign: TextAlign.left,
                    enableBorder: true,
                    textStyle: const TextStyle(color: PrimaryColor),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size(130, 40)),
                      alignment: Alignment.center,
                    ),
                    onPressed: () async {
                      EasyLoading.show();

                      List<String> imageUrls = widget.event.eventImageUrls;
                      String videoUrl = widget.event.eventvideourl;

                      if (_imagesUpdated) {
                        List<File> selectedImages = imageProvider.selectedImages
                            .where((file) => file != null)
                            .cast<File>()
                            .toList();
                        imageUrls =
                            await fileuploadprovider.uploadMultipleFiles(
                          files: selectedImages,
                          folder: 'products/images',
                        );
                      }

                      if (_videoUpdated) {
                        videoUrl = await fileuploadprovider.fileUpload(
                              file: videoProvider.selectedVideo!,
                              fileName: 'product_video.mp4',
                              folder: 'products/videos',
                            ) ??
                            videoUrl;
                      }

                      EventModel updatedProduct = EventModel(
                          id: widget.event.id,
                          title: titleController.text,
                          category: categoryProvider.selectedValue.toString(),
                          description: descriptionController.text,
                          eventImageUrls: imageUrls,
                          eventvideourl: videoUrl,
                          eventDate: eventdateController.text,
                          ticketPrice: priceController.text,
                          startTime: datepickerprovider.startTime,
                          endTime: datepickerprovider.endTime,
                          location: locationController.text);

                      await productProvider.updateEvent(
                          widget.event.id, updatedProduct);

                      titleController.clear();
                      priceController.clear();
                      eventdateController.clear();
                      locationController.clear();
                      imageProvider.reset();
                      descriptionController.clear();
                      videoProvider.reset();

                      EasyLoading.dismiss();
                      Utils.navigateTo(context, const YourEventsScreen());
                    },
                    child: const Text(
                      'Update Event',
                      style: TextStyle(color: PrimaryColor),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
