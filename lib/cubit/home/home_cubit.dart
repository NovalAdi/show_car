import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:show_car/model/car.dart';

import '../../local/secure_storage.dart';
import '../../model/user.dart';
import '../../service/car_service.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  void init() {
    getUser();
    getMainCar();
    getListCar();
  }

  void logout() async {
    await SecureStorage.deleteDataLokal();
  }

  void deleteCar(int id) async {
    emit(state.copyWith(isLoading: true));
    await CarService.deleteCar(
      id: id.toString(),
    );
    emit(state.copyWith(isLoading: false));
  }

  void getUser() async {
    emit(state.copyWith(isLoading: true));
    final user = await SecureStorage.getUser();
    emit(state.copyWith(user: user));
    emit(state.copyWith(isLoading: false));
  }

  void getMainCar() async {
    emit(state.copyWith(isLoading: true));
    final car = await CarService.getMainCar();
    emit(state.copyWith(mainCar: car));
    emit(state.copyWith(isLoading: false));
  }

  void getListCar() async {
    emit(state.copyWith(isLoading: true));
    final listCar = await CarService.getListCar();
    emit(state.copyWith(listCar: listCar));
    emit(state.copyWith(isLoading: false));
  }
}
