import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_car/ui/page/add_update_page.dart';
import 'package:show_car/ui/page/login_page.dart';
import 'package:show_car/ui/widget/list_cars.dart';
import 'package:show_car/ui/widget/main_card.dart';
import 'package:show_car/ui/widget/tap_icon.dart';

import '../../cubit/home/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<HomeCubit>().init();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddUpdatePage(isUpdate: false),
            ),
          );
        },
        backgroundColor: Colors.black54,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.user != null) {
              return Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                  right: 30,
                  left: 30,
                  bottom: 80,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome',
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.user!.name!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                        TapIcon(
                          icon: const Icon(Icons.logout, size: 20),
                          onTap: () {
                            context.read<HomeCubit>().logout();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Your most expensive car',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    MainCard(),
                    const SizedBox(height: 20),
                    const Text(
                      'Your cars',
                      style: TextStyle(fontSize: 18),
                    ),
                    ListCars(),
                  ],
                ),
              );
            }

            return Center(
              child: Text('Data Not Found'),
            );
          },
        ),
      ),
    );
  }
}
