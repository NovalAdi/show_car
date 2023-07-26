part of 'home_cubit.dart';

class HomeState extends Equatable {
  bool isLoading;
  User? user;
  Car? mainCar;
  List<Car> listCar;

  HomeState({
    this.isLoading = false,
    this.user,
    this.mainCar,
    this.listCar = const [],
  });

  HomeState copyWith({
    bool? isLoading,
    User? user,
    Car? mainCar,
    List<Car>? listCar,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      mainCar: mainCar ?? this.mainCar,
      listCar: listCar ?? this.listCar,
    );
  }

  @override
  List<Object?> get props =>
      [
        isLoading,
        user,
        mainCar,
        listCar,
      ];
}
