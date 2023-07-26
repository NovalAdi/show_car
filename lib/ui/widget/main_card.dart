import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_car/ui/widget/tap_icon.dart';

import '../../cubit/home/home_cubit.dart';
import '../page/add_update_page.dart';

class MainCard extends StatelessWidget {
  const MainCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.mainCar == null) {
          return const Padding(
            padding: EdgeInsets.all(30),
            child: Center(child: Text("You don't have any car")),
          );
        }
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  state.mainCar!.image!,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${state.mainCar!.brand!} ${state.mainCar!.name!}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text("Rp.${state.mainCar!.price!}"),
                      ],
                    ),
                    Row(
                      children: [
                        TapIcon(
                          icon: const Icon(Icons.mode_edit_outline_outlined),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return AddUpdatePage(
                                    isUpdate: true, car: state.mainCar);
                              }),
                            );
                          },
                        ),
                        SizedBox(width: 12),
                        TapIcon(
                          icon: const Icon(Icons.delete_outline),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
