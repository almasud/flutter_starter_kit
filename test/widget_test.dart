// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_starter_kit/app.dart';
import 'package:flutter_starter_kit/core/domain/models/api_result.dart';
import 'package:flutter_starter_kit/core/domain/models/app_error.dart';
import 'package:flutter_starter_kit/core/di/injection.dart';
import 'package:flutter_starter_kit/features/product/data/datasources/product_datasource.dart';
import 'package:flutter_starter_kit/features/product/data/remote/model/dtos/product_dto.dart';
import 'package:flutter_starter_kit/features/product/data/repositories/product_repository_impl.dart';
import 'package:flutter_starter_kit/features/product/domain/repositories/product_repository.dart';
import 'package:flutter_starter_kit/features/product/domain/usecases/get_products_usecase.dart';
import 'package:flutter_starter_kit/features/product/presentation/bloc/product_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeProductDatasource extends ProductDatasource {
  @override
  Future<ApiResult<ProductDto, AppError>> getProducts() async {
    return Success(
      ProductDto(
        products: const [],
        total: 0,
        skip: 0,
        limit: 30,
      ),
    );
  }
}

void main() {
  setUp(() async {
    await getIt.reset();
    getIt.registerLazySingleton<ProductDatasource>(() => _FakeProductDatasource());
    getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(getIt()));
    getIt.registerLazySingleton<GetProductsUseCase>(() => GetProductsUseCase(getIt()));
    getIt.registerFactory<ProductBloc>(() => ProductBloc(getIt()));
  });

  testWidgets('App renders product screen', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pump();

    expect(find.text('Products'), findsOneWidget);
  });
}
