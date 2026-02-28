import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/init_dependencies.dart';
import '../../../login/domain/entities/user_entity.dart';
import '../bloc/products/product_listing_bloc.dart';
import '../widgets/product_listing_view.dart';

class ProductListingPage extends StatelessWidget {
  final UserEntity user;

  const ProductListingPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductListingBloc>()..add(LoadAllProductsEvent()),
      child: ProductListingView(user: user),
    );
  }
}