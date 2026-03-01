import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/features/product/domain/usecases/get_products_usecase.dart';
import 'package:flutter_starter_kit/features/product/presentation/bloc/product_event.dart';
import 'package:flutter_starter_kit/features/product/presentation/bloc/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(this._getProductsUseCase) : super(ProductState.initial()) {
    on<ProductEvent>(_onEvent);
  }

  final GetProductsUseCase _getProductsUseCase;

  Future<void> _onEvent(ProductEvent event, Emitter<ProductState> emit) async {
    await event.when(
      productsRequested: () async {
        emit(ProductState.loading(previousData: state.data));
        final result = await _getProductsUseCase();
        switch (result) {
          case Success(:final data):
            emit(ProductState.success(data));
          case Failure(:final error):
            emit(
              ProductState.failure(
                message: _mapError(error),
                previousData: state.data,
              ),
            );
        }
      },
    );
  }

  String _mapError(AppError error) {
    return switch (error) {
      NetworkError(:final message) => message ?? 'Network error',
      UnauthorizedError(:final message) => message ?? 'Unauthorized',
      ValidationError(:final message) => message ?? 'Validation error',
      ServerError(:final message) => message ?? 'Server error',
      UnknownError(:final message) => message ?? 'Unknown error',
    };
  }
}
