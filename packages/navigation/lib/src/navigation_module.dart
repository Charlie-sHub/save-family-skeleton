import 'package:get_it/get_it.dart';
import 'package:navigation/src/navigation_contract.dart';

void navigationModule() {
  GetIt.I.registerLazySingleton<NavigationContract>(NavigationContractImpl.new);
}
