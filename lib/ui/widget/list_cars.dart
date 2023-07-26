import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_car/ui/widget/tap_icon.dart';

import '../../cubit/home/home_cubit.dart';
import '../page/add_update_page.dart';

class ListCars extends StatelessWidget {
  const ListCars({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.listCar.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(30),
            child: Center(child: Text("You don't have any car")),
          );
        }
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final car = state.listCar[index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        car.image!,
                        width: 150,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${car.brand!} ${car.name!}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("Rp.${car.price!}"),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              TapIcon(
                                icon: const Icon(
                                    Icons.mode_edit_outline_outlined),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return AddUpdatePage(
                                        isUpdate: true,
                                        car: car,
                                      );
                                    }),
                                  );
                                },
                              ),
                              SizedBox(width: 12),
                              TapIcon(
                                icon: const Icon(Icons.delete_outline),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Delete ?'),
                                      content: const Text(
                                        'Are you sure you want to delete this item ?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            context
                                                .read<HomeCubit>()
                                                .deleteCar(car.id!);
                                            context.read<HomeCubit>().init();
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Yes'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 15);
          },
          itemCount: state.listCar.length,
        );
      },
    );
  }
}
