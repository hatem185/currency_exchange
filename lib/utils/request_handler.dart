import 'package:currency_exchange/utils/request_state.dart';

class RequsetHandler<T> {
  late final RequestState state;
  late final T? data;
  late final String? errorMsg;

  RequsetHandler.isSuccess(this.data) {
    state = RequestState.isSuccess;
    errorMsg = null;
  }

  RequsetHandler.isError(this.errorMsg) {
    state = RequestState.isError;
    data = null;
  }

  RequsetHandler.isLoading() {
    state = RequestState.isLoading;
    errorMsg = null;
    data = null;
  }
}
