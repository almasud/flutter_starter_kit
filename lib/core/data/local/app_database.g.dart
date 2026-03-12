// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductEntriesTable extends ProductEntries
    with TableInfo<$ProductEntriesTable, ProductEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountPercentageMeta =
      const VerificationMeta('discountPercentage');
  @override
  late final GeneratedColumn<double> discountPercentage =
      GeneratedColumn<double>(
        'discount_percentage',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
    'rating',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stockMeta = const VerificationMeta('stock');
  @override
  late final GeneratedColumn<int> stock = GeneratedColumn<int>(
    'stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thumbnailMeta = const VerificationMeta(
    'thumbnail',
  );
  @override
  late final GeneratedColumn<String> thumbnail = GeneratedColumn<String>(
    'thumbnail',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagesJsonMeta = const VerificationMeta(
    'imagesJson',
  );
  @override
  late final GeneratedColumn<String> imagesJson = GeneratedColumn<String>(
    'images_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    category,
    price,
    discountPercentage,
    rating,
    stock,
    thumbnail,
    imagesJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('discount_percentage')) {
      context.handle(
        _discountPercentageMeta,
        discountPercentage.isAcceptableOrUnknown(
          data['discount_percentage']!,
          _discountPercentageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_discountPercentageMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    if (data.containsKey('stock')) {
      context.handle(
        _stockMeta,
        stock.isAcceptableOrUnknown(data['stock']!, _stockMeta),
      );
    } else if (isInserting) {
      context.missing(_stockMeta);
    }
    if (data.containsKey('thumbnail')) {
      context.handle(
        _thumbnailMeta,
        thumbnail.isAcceptableOrUnknown(data['thumbnail']!, _thumbnailMeta),
      );
    } else if (isInserting) {
      context.missing(_thumbnailMeta);
    }
    if (data.containsKey('images_json')) {
      context.handle(
        _imagesJsonMeta,
        imagesJson.isAcceptableOrUnknown(data['images_json']!, _imagesJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_imagesJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      discountPercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount_percentage'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating'],
      )!,
      stock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock'],
      )!,
      thumbnail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail'],
      )!,
      imagesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}images_json'],
      )!,
    );
  }

  @override
  $ProductEntriesTable createAlias(String alias) {
    return $ProductEntriesTable(attachedDatabase, alias);
  }
}

class ProductEntry extends DataClass implements Insertable<ProductEntry> {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String thumbnail;
  final String imagesJson;
  const ProductEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.thumbnail,
    required this.imagesJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['category'] = Variable<String>(category);
    map['price'] = Variable<double>(price);
    map['discount_percentage'] = Variable<double>(discountPercentage);
    map['rating'] = Variable<double>(rating);
    map['stock'] = Variable<int>(stock);
    map['thumbnail'] = Variable<String>(thumbnail);
    map['images_json'] = Variable<String>(imagesJson);
    return map;
  }

  ProductEntriesCompanion toCompanion(bool nullToAbsent) {
    return ProductEntriesCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      category: Value(category),
      price: Value(price),
      discountPercentage: Value(discountPercentage),
      rating: Value(rating),
      stock: Value(stock),
      thumbnail: Value(thumbnail),
      imagesJson: Value(imagesJson),
    );
  }

  factory ProductEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductEntry(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      price: serializer.fromJson<double>(json['price']),
      discountPercentage: serializer.fromJson<double>(
        json['discountPercentage'],
      ),
      rating: serializer.fromJson<double>(json['rating']),
      stock: serializer.fromJson<int>(json['stock']),
      thumbnail: serializer.fromJson<String>(json['thumbnail']),
      imagesJson: serializer.fromJson<String>(json['imagesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<String>(category),
      'price': serializer.toJson<double>(price),
      'discountPercentage': serializer.toJson<double>(discountPercentage),
      'rating': serializer.toJson<double>(rating),
      'stock': serializer.toJson<int>(stock),
      'thumbnail': serializer.toJson<String>(thumbnail),
      'imagesJson': serializer.toJson<String>(imagesJson),
    };
  }

  ProductEntry copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    double? price,
    double? discountPercentage,
    double? rating,
    int? stock,
    String? thumbnail,
    String? imagesJson,
  }) => ProductEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    category: category ?? this.category,
    price: price ?? this.price,
    discountPercentage: discountPercentage ?? this.discountPercentage,
    rating: rating ?? this.rating,
    stock: stock ?? this.stock,
    thumbnail: thumbnail ?? this.thumbnail,
    imagesJson: imagesJson ?? this.imagesJson,
  );
  ProductEntry copyWithCompanion(ProductEntriesCompanion data) {
    return ProductEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      price: data.price.present ? data.price.value : this.price,
      discountPercentage: data.discountPercentage.present
          ? data.discountPercentage.value
          : this.discountPercentage,
      rating: data.rating.present ? data.rating.value : this.rating,
      stock: data.stock.present ? data.stock.value : this.stock,
      thumbnail: data.thumbnail.present ? data.thumbnail.value : this.thumbnail,
      imagesJson: data.imagesJson.present
          ? data.imagesJson.value
          : this.imagesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('price: $price, ')
          ..write('discountPercentage: $discountPercentage, ')
          ..write('rating: $rating, ')
          ..write('stock: $stock, ')
          ..write('thumbnail: $thumbnail, ')
          ..write('imagesJson: $imagesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    category,
    price,
    discountPercentage,
    rating,
    stock,
    thumbnail,
    imagesJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.category == this.category &&
          other.price == this.price &&
          other.discountPercentage == this.discountPercentage &&
          other.rating == this.rating &&
          other.stock == this.stock &&
          other.thumbnail == this.thumbnail &&
          other.imagesJson == this.imagesJson);
}

class ProductEntriesCompanion extends UpdateCompanion<ProductEntry> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> category;
  final Value<double> price;
  final Value<double> discountPercentage;
  final Value<double> rating;
  final Value<int> stock;
  final Value<String> thumbnail;
  final Value<String> imagesJson;
  const ProductEntriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.price = const Value.absent(),
    this.discountPercentage = const Value.absent(),
    this.rating = const Value.absent(),
    this.stock = const Value.absent(),
    this.thumbnail = const Value.absent(),
    this.imagesJson = const Value.absent(),
  });
  ProductEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String description,
    required String category,
    required double price,
    required double discountPercentage,
    required double rating,
    required int stock,
    required String thumbnail,
    required String imagesJson,
  }) : title = Value(title),
       description = Value(description),
       category = Value(category),
       price = Value(price),
       discountPercentage = Value(discountPercentage),
       rating = Value(rating),
       stock = Value(stock),
       thumbnail = Value(thumbnail),
       imagesJson = Value(imagesJson);
  static Insertable<ProductEntry> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? category,
    Expression<double>? price,
    Expression<double>? discountPercentage,
    Expression<double>? rating,
    Expression<int>? stock,
    Expression<String>? thumbnail,
    Expression<String>? imagesJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (price != null) 'price': price,
      if (discountPercentage != null) 'discount_percentage': discountPercentage,
      if (rating != null) 'rating': rating,
      if (stock != null) 'stock': stock,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (imagesJson != null) 'images_json': imagesJson,
    });
  }

  ProductEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? description,
    Value<String>? category,
    Value<double>? price,
    Value<double>? discountPercentage,
    Value<double>? rating,
    Value<int>? stock,
    Value<String>? thumbnail,
    Value<String>? imagesJson,
  }) {
    return ProductEntriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      rating: rating ?? this.rating,
      stock: stock ?? this.stock,
      thumbnail: thumbnail ?? this.thumbnail,
      imagesJson: imagesJson ?? this.imagesJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (discountPercentage.present) {
      map['discount_percentage'] = Variable<double>(discountPercentage.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (stock.present) {
      map['stock'] = Variable<int>(stock.value);
    }
    if (thumbnail.present) {
      map['thumbnail'] = Variable<String>(thumbnail.value);
    }
    if (imagesJson.present) {
      map['images_json'] = Variable<String>(imagesJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductEntriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('price: $price, ')
          ..write('discountPercentage: $discountPercentage, ')
          ..write('rating: $rating, ')
          ..write('stock: $stock, ')
          ..write('thumbnail: $thumbnail, ')
          ..write('imagesJson: $imagesJson')
          ..write(')'))
        .toString();
  }
}

class $ProductCacheEntriesTable extends ProductCacheEntries
    with TableInfo<$ProductCacheEntriesTable, ProductCacheEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductCacheEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cacheKeyMeta = const VerificationMeta(
    'cacheKey',
  );
  @override
  late final GeneratedColumn<String> cacheKey = GeneratedColumn<String>(
    'cache_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skipMeta = const VerificationMeta('skip');
  @override
  late final GeneratedColumn<int> skip = GeneratedColumn<int>(
    'skip',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _limitMeta = const VerificationMeta('limit');
  @override
  late final GeneratedColumn<int> limit = GeneratedColumn<int>(
    'limit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    cacheKey,
    total,
    skip,
    limit,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_cache_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductCacheEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cache_key')) {
      context.handle(
        _cacheKeyMeta,
        cacheKey.isAcceptableOrUnknown(data['cache_key']!, _cacheKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_cacheKeyMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('skip')) {
      context.handle(
        _skipMeta,
        skip.isAcceptableOrUnknown(data['skip']!, _skipMeta),
      );
    } else if (isInserting) {
      context.missing(_skipMeta);
    }
    if (data.containsKey('limit')) {
      context.handle(
        _limitMeta,
        limit.isAcceptableOrUnknown(data['limit']!, _limitMeta),
      );
    } else if (isInserting) {
      context.missing(_limitMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cacheKey};
  @override
  ProductCacheEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductCacheEntry(
      cacheKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cache_key'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      skip: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}skip'],
      )!,
      limit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}limit'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $ProductCacheEntriesTable createAlias(String alias) {
    return $ProductCacheEntriesTable(attachedDatabase, alias);
  }
}

class ProductCacheEntry extends DataClass
    implements Insertable<ProductCacheEntry> {
  final String cacheKey;
  final int total;
  final int skip;
  final int limit;
  final DateTime fetchedAt;
  const ProductCacheEntry({
    required this.cacheKey,
    required this.total,
    required this.skip,
    required this.limit,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cache_key'] = Variable<String>(cacheKey);
    map['total'] = Variable<int>(total);
    map['skip'] = Variable<int>(skip);
    map['limit'] = Variable<int>(limit);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  ProductCacheEntriesCompanion toCompanion(bool nullToAbsent) {
    return ProductCacheEntriesCompanion(
      cacheKey: Value(cacheKey),
      total: Value(total),
      skip: Value(skip),
      limit: Value(limit),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory ProductCacheEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductCacheEntry(
      cacheKey: serializer.fromJson<String>(json['cacheKey']),
      total: serializer.fromJson<int>(json['total']),
      skip: serializer.fromJson<int>(json['skip']),
      limit: serializer.fromJson<int>(json['limit']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cacheKey': serializer.toJson<String>(cacheKey),
      'total': serializer.toJson<int>(total),
      'skip': serializer.toJson<int>(skip),
      'limit': serializer.toJson<int>(limit),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  ProductCacheEntry copyWith({
    String? cacheKey,
    int? total,
    int? skip,
    int? limit,
    DateTime? fetchedAt,
  }) => ProductCacheEntry(
    cacheKey: cacheKey ?? this.cacheKey,
    total: total ?? this.total,
    skip: skip ?? this.skip,
    limit: limit ?? this.limit,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  ProductCacheEntry copyWithCompanion(ProductCacheEntriesCompanion data) {
    return ProductCacheEntry(
      cacheKey: data.cacheKey.present ? data.cacheKey.value : this.cacheKey,
      total: data.total.present ? data.total.value : this.total,
      skip: data.skip.present ? data.skip.value : this.skip,
      limit: data.limit.present ? data.limit.value : this.limit,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductCacheEntry(')
          ..write('cacheKey: $cacheKey, ')
          ..write('total: $total, ')
          ..write('skip: $skip, ')
          ..write('limit: $limit, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cacheKey, total, skip, limit, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductCacheEntry &&
          other.cacheKey == this.cacheKey &&
          other.total == this.total &&
          other.skip == this.skip &&
          other.limit == this.limit &&
          other.fetchedAt == this.fetchedAt);
}

class ProductCacheEntriesCompanion extends UpdateCompanion<ProductCacheEntry> {
  final Value<String> cacheKey;
  final Value<int> total;
  final Value<int> skip;
  final Value<int> limit;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const ProductCacheEntriesCompanion({
    this.cacheKey = const Value.absent(),
    this.total = const Value.absent(),
    this.skip = const Value.absent(),
    this.limit = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductCacheEntriesCompanion.insert({
    required String cacheKey,
    required int total,
    required int skip,
    required int limit,
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  }) : cacheKey = Value(cacheKey),
       total = Value(total),
       skip = Value(skip),
       limit = Value(limit),
       fetchedAt = Value(fetchedAt);
  static Insertable<ProductCacheEntry> custom({
    Expression<String>? cacheKey,
    Expression<int>? total,
    Expression<int>? skip,
    Expression<int>? limit,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cacheKey != null) 'cache_key': cacheKey,
      if (total != null) 'total': total,
      if (skip != null) 'skip': skip,
      if (limit != null) 'limit': limit,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductCacheEntriesCompanion copyWith({
    Value<String>? cacheKey,
    Value<int>? total,
    Value<int>? skip,
    Value<int>? limit,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return ProductCacheEntriesCompanion(
      cacheKey: cacheKey ?? this.cacheKey,
      total: total ?? this.total,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cacheKey.present) {
      map['cache_key'] = Variable<String>(cacheKey.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (skip.present) {
      map['skip'] = Variable<int>(skip.value);
    }
    if (limit.present) {
      map['limit'] = Variable<int>(limit.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductCacheEntriesCompanion(')
          ..write('cacheKey: $cacheKey, ')
          ..write('total: $total, ')
          ..write('skip: $skip, ')
          ..write('limit: $limit, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductEntriesTable productEntries = $ProductEntriesTable(this);
  late final $ProductCacheEntriesTable productCacheEntries =
      $ProductCacheEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    productEntries,
    productCacheEntries,
  ];
}

typedef $$ProductEntriesTableCreateCompanionBuilder =
    ProductEntriesCompanion Function({
      Value<int> id,
      required String title,
      required String description,
      required String category,
      required double price,
      required double discountPercentage,
      required double rating,
      required int stock,
      required String thumbnail,
      required String imagesJson,
    });
typedef $$ProductEntriesTableUpdateCompanionBuilder =
    ProductEntriesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> description,
      Value<String> category,
      Value<double> price,
      Value<double> discountPercentage,
      Value<double> rating,
      Value<int> stock,
      Value<String> thumbnail,
      Value<String> imagesJson,
    });

class $$ProductEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ProductEntriesTable> {
  $$ProductEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discountPercentage => $composableBuilder(
    column: $table.discountPercentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnail => $composableBuilder(
    column: $table.thumbnail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagesJson => $composableBuilder(
    column: $table.imagesJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductEntriesTable> {
  $$ProductEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discountPercentage => $composableBuilder(
    column: $table.discountPercentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnail => $composableBuilder(
    column: $table.thumbnail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagesJson => $composableBuilder(
    column: $table.imagesJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductEntriesTable> {
  $$ProductEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get discountPercentage => $composableBuilder(
    column: $table.discountPercentage,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<int> get stock =>
      $composableBuilder(column: $table.stock, builder: (column) => column);

  GeneratedColumn<String> get thumbnail =>
      $composableBuilder(column: $table.thumbnail, builder: (column) => column);

  GeneratedColumn<String> get imagesJson => $composableBuilder(
    column: $table.imagesJson,
    builder: (column) => column,
  );
}

class $$ProductEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductEntriesTable,
          ProductEntry,
          $$ProductEntriesTableFilterComposer,
          $$ProductEntriesTableOrderingComposer,
          $$ProductEntriesTableAnnotationComposer,
          $$ProductEntriesTableCreateCompanionBuilder,
          $$ProductEntriesTableUpdateCompanionBuilder,
          (
            ProductEntry,
            BaseReferences<_$AppDatabase, $ProductEntriesTable, ProductEntry>,
          ),
          ProductEntry,
          PrefetchHooks Function()
        > {
  $$ProductEntriesTableTableManager(
    _$AppDatabase db,
    $ProductEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<double> discountPercentage = const Value.absent(),
                Value<double> rating = const Value.absent(),
                Value<int> stock = const Value.absent(),
                Value<String> thumbnail = const Value.absent(),
                Value<String> imagesJson = const Value.absent(),
              }) => ProductEntriesCompanion(
                id: id,
                title: title,
                description: description,
                category: category,
                price: price,
                discountPercentage: discountPercentage,
                rating: rating,
                stock: stock,
                thumbnail: thumbnail,
                imagesJson: imagesJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String description,
                required String category,
                required double price,
                required double discountPercentage,
                required double rating,
                required int stock,
                required String thumbnail,
                required String imagesJson,
              }) => ProductEntriesCompanion.insert(
                id: id,
                title: title,
                description: description,
                category: category,
                price: price,
                discountPercentage: discountPercentage,
                rating: rating,
                stock: stock,
                thumbnail: thumbnail,
                imagesJson: imagesJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductEntriesTable,
      ProductEntry,
      $$ProductEntriesTableFilterComposer,
      $$ProductEntriesTableOrderingComposer,
      $$ProductEntriesTableAnnotationComposer,
      $$ProductEntriesTableCreateCompanionBuilder,
      $$ProductEntriesTableUpdateCompanionBuilder,
      (
        ProductEntry,
        BaseReferences<_$AppDatabase, $ProductEntriesTable, ProductEntry>,
      ),
      ProductEntry,
      PrefetchHooks Function()
    >;
typedef $$ProductCacheEntriesTableCreateCompanionBuilder =
    ProductCacheEntriesCompanion Function({
      required String cacheKey,
      required int total,
      required int skip,
      required int limit,
      required DateTime fetchedAt,
      Value<int> rowid,
    });
typedef $$ProductCacheEntriesTableUpdateCompanionBuilder =
    ProductCacheEntriesCompanion Function({
      Value<String> cacheKey,
      Value<int> total,
      Value<int> skip,
      Value<int> limit,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$ProductCacheEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ProductCacheEntriesTable> {
  $$ProductCacheEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cacheKey => $composableBuilder(
    column: $table.cacheKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get skip => $composableBuilder(
    column: $table.skip,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get limit => $composableBuilder(
    column: $table.limit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductCacheEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductCacheEntriesTable> {
  $$ProductCacheEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cacheKey => $composableBuilder(
    column: $table.cacheKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get skip => $composableBuilder(
    column: $table.skip,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get limit => $composableBuilder(
    column: $table.limit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductCacheEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductCacheEntriesTable> {
  $$ProductCacheEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cacheKey =>
      $composableBuilder(column: $table.cacheKey, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get skip =>
      $composableBuilder(column: $table.skip, builder: (column) => column);

  GeneratedColumn<int> get limit =>
      $composableBuilder(column: $table.limit, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$ProductCacheEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductCacheEntriesTable,
          ProductCacheEntry,
          $$ProductCacheEntriesTableFilterComposer,
          $$ProductCacheEntriesTableOrderingComposer,
          $$ProductCacheEntriesTableAnnotationComposer,
          $$ProductCacheEntriesTableCreateCompanionBuilder,
          $$ProductCacheEntriesTableUpdateCompanionBuilder,
          (
            ProductCacheEntry,
            BaseReferences<
              _$AppDatabase,
              $ProductCacheEntriesTable,
              ProductCacheEntry
            >,
          ),
          ProductCacheEntry,
          PrefetchHooks Function()
        > {
  $$ProductCacheEntriesTableTableManager(
    _$AppDatabase db,
    $ProductCacheEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductCacheEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductCacheEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ProductCacheEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> cacheKey = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<int> skip = const Value.absent(),
                Value<int> limit = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductCacheEntriesCompanion(
                cacheKey: cacheKey,
                total: total,
                skip: skip,
                limit: limit,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String cacheKey,
                required int total,
                required int skip,
                required int limit,
                required DateTime fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProductCacheEntriesCompanion.insert(
                cacheKey: cacheKey,
                total: total,
                skip: skip,
                limit: limit,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductCacheEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductCacheEntriesTable,
      ProductCacheEntry,
      $$ProductCacheEntriesTableFilterComposer,
      $$ProductCacheEntriesTableOrderingComposer,
      $$ProductCacheEntriesTableAnnotationComposer,
      $$ProductCacheEntriesTableCreateCompanionBuilder,
      $$ProductCacheEntriesTableUpdateCompanionBuilder,
      (
        ProductCacheEntry,
        BaseReferences<
          _$AppDatabase,
          $ProductCacheEntriesTable,
          ProductCacheEntry
        >,
      ),
      ProductCacheEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductEntriesTableTableManager get productEntries =>
      $$ProductEntriesTableTableManager(_db, _db.productEntries);
  $$ProductCacheEntriesTableTableManager get productCacheEntries =>
      $$ProductCacheEntriesTableTableManager(_db, _db.productCacheEntries);
}
