import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:show_car/cubit/home/home_cubit.dart';
import 'package:show_car/service/car_service.dart';
import 'package:show_car/ui/widget/tap_icon.dart';

import '../../model/car.dart';
import 'home_page.dart';

class AddUpdatePage extends StatefulWidget {
  bool isUpdate;
  Car? car;

  AddUpdatePage({
    Key? key,
    required this.isUpdate,
    this.car,
  }) : super(key: key);

  @override
  State<AddUpdatePage> createState() => _AddPageState();
}

class _AddPageState extends State<AddUpdatePage> {
  File? image;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final brandController = TextEditingController();
  final priceController = TextEditingController();
  XFile? imageFile;

  Future<void> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      setState(() {
        imageFile = image;
      });
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      log('pickImage $e');
    }
  }

  GestureDetector CardPick() {
    if (widget.isUpdate) {
      return GestureDetector(
        onTap: () => pickImage(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: image != null
              ? Image.file(
                  image!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Image.network(widget.car!.image!),
        ),
      );
    }
    return GestureDetector(
      onTap: () => pickImage(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: image != null
            ? Image.file(
                image!,
                width: double.infinity,
              )
            : Image.asset('assets/image/add_default.png'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isUpdate) {
      nameController.text = widget.car!.name!;
      brandController.text = widget.car!.brand!;
      priceController.text = widget.car!.price!;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 50,
          right: 30,
          left: 30,
          bottom: 30,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TapIcon(
                    icon: Icon(Icons.arrow_back_ios_new),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name can not be empty';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Name / Model',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: brandController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Brand can not be empty';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Brand',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: priceController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Price can not be empty';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Price',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  CardPick(),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (_formKey.currentState!.validate()) {
                      if (widget.isUpdate) {
                        log('update');
                        await CarService.updateCar(
                          name: nameController.text,
                          brand: brandController.text,
                          price: priceController.text,
                          image: imageFile,
                          id: widget.car!.id.toString(),
                        );
                      } else {
                        await CarService.createCar(
                          name: nameController.text,
                          brand: brandController.text,
                          price: priceController.text,
                          image: imageFile,
                        );
                      }
                      if (!mounted) return;
                      context.read<HomeCubit>().init();
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    widget.isUpdate ? 'Update' : 'Add',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
