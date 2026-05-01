// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalMaterialsTable extends LocalMaterials
    with TableInfo<$LocalMaterialsTable, LocalMaterial> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalMaterialsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _materialTypeMeta = const VerificationMeta(
    'materialType',
  );
  @override
  late final GeneratedColumn<String> materialType = GeneratedColumn<String>(
    'material_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedDurationMinutesMeta =
      const VerificationMeta('estimatedDurationMinutes');
  @override
  late final GeneratedColumn<int> estimatedDurationMinutes =
      GeneratedColumn<int>(
        'estimated_duration_minutes',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasActivePlanMeta = const VerificationMeta(
    'hasActivePlan',
  );
  @override
  late final GeneratedColumn<bool> hasActivePlan = GeneratedColumn<bool>(
    'has_active_plan',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_active_plan" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _activePlanIdMeta = const VerificationMeta(
    'activePlanId',
  );
  @override
  late final GeneratedColumn<String> activePlanId = GeneratedColumn<String>(
    'active_plan_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activePlanTitleMeta = const VerificationMeta(
    'activePlanTitle',
  );
  @override
  late final GeneratedColumn<String> activePlanTitle = GeneratedColumn<String>(
    'active_plan_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    title,
    materialType,
    content,
    estimatedDurationMinutes,
    description,
    tags,
    hasActivePlan,
    activePlanId,
    activePlanTitle,
    syncStatus,
    isDeleted,
    updatedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_materials';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalMaterial> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('material_type')) {
      context.handle(
        _materialTypeMeta,
        materialType.isAcceptableOrUnknown(
          data['material_type']!,
          _materialTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_materialTypeMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('estimated_duration_minutes')) {
      context.handle(
        _estimatedDurationMinutesMeta,
        estimatedDurationMinutes.isAcceptableOrUnknown(
          data['estimated_duration_minutes']!,
          _estimatedDurationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estimatedDurationMinutesMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('has_active_plan')) {
      context.handle(
        _hasActivePlanMeta,
        hasActivePlan.isAcceptableOrUnknown(
          data['has_active_plan']!,
          _hasActivePlanMeta,
        ),
      );
    }
    if (data.containsKey('active_plan_id')) {
      context.handle(
        _activePlanIdMeta,
        activePlanId.isAcceptableOrUnknown(
          data['active_plan_id']!,
          _activePlanIdMeta,
        ),
      );
    }
    if (data.containsKey('active_plan_title')) {
      context.handle(
        _activePlanTitleMeta,
        activePlanTitle.isAcceptableOrUnknown(
          data['active_plan_title']!,
          _activePlanTitleMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalMaterial map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalMaterial(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      materialType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}material_type'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      estimatedDurationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_duration_minutes'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      hasActivePlan: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_active_plan'],
      )!,
      activePlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_plan_id'],
      ),
      activePlanTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_plan_title'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      ),
    );
  }

  @override
  $LocalMaterialsTable createAlias(String alias) {
    return $LocalMaterialsTable(attachedDatabase, alias);
  }
}

class LocalMaterial extends DataClass implements Insertable<LocalMaterial> {
  final String id;
  final String userId;
  final String title;
  final String materialType;
  final String content;
  final int estimatedDurationMinutes;
  final String? description;
  final String? tags;
  final bool hasActivePlan;
  final String? activePlanId;
  final String? activePlanTitle;
  final String syncStatus;
  final bool isDeleted;
  final DateTime? updatedAtUtc;
  const LocalMaterial({
    required this.id,
    required this.userId,
    required this.title,
    required this.materialType,
    required this.content,
    required this.estimatedDurationMinutes,
    this.description,
    this.tags,
    required this.hasActivePlan,
    this.activePlanId,
    this.activePlanTitle,
    required this.syncStatus,
    required this.isDeleted,
    this.updatedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['title'] = Variable<String>(title);
    map['material_type'] = Variable<String>(materialType);
    map['content'] = Variable<String>(content);
    map['estimated_duration_minutes'] = Variable<int>(estimatedDurationMinutes);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    map['has_active_plan'] = Variable<bool>(hasActivePlan);
    if (!nullToAbsent || activePlanId != null) {
      map['active_plan_id'] = Variable<String>(activePlanId);
    }
    if (!nullToAbsent || activePlanTitle != null) {
      map['active_plan_title'] = Variable<String>(activePlanTitle);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || updatedAtUtc != null) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    }
    return map;
  }

  LocalMaterialsCompanion toCompanion(bool nullToAbsent) {
    return LocalMaterialsCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      materialType: Value(materialType),
      content: Value(content),
      estimatedDurationMinutes: Value(estimatedDurationMinutes),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      hasActivePlan: Value(hasActivePlan),
      activePlanId: activePlanId == null && nullToAbsent
          ? const Value.absent()
          : Value(activePlanId),
      activePlanTitle: activePlanTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(activePlanTitle),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
      updatedAtUtc: updatedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAtUtc),
    );
  }

  factory LocalMaterial.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalMaterial(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      materialType: serializer.fromJson<String>(json['materialType']),
      content: serializer.fromJson<String>(json['content']),
      estimatedDurationMinutes: serializer.fromJson<int>(
        json['estimatedDurationMinutes'],
      ),
      description: serializer.fromJson<String?>(json['description']),
      tags: serializer.fromJson<String?>(json['tags']),
      hasActivePlan: serializer.fromJson<bool>(json['hasActivePlan']),
      activePlanId: serializer.fromJson<String?>(json['activePlanId']),
      activePlanTitle: serializer.fromJson<String?>(json['activePlanTitle']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      updatedAtUtc: serializer.fromJson<DateTime?>(json['updatedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'title': serializer.toJson<String>(title),
      'materialType': serializer.toJson<String>(materialType),
      'content': serializer.toJson<String>(content),
      'estimatedDurationMinutes': serializer.toJson<int>(
        estimatedDurationMinutes,
      ),
      'description': serializer.toJson<String?>(description),
      'tags': serializer.toJson<String?>(tags),
      'hasActivePlan': serializer.toJson<bool>(hasActivePlan),
      'activePlanId': serializer.toJson<String?>(activePlanId),
      'activePlanTitle': serializer.toJson<String?>(activePlanTitle),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'updatedAtUtc': serializer.toJson<DateTime?>(updatedAtUtc),
    };
  }

  LocalMaterial copyWith({
    String? id,
    String? userId,
    String? title,
    String? materialType,
    String? content,
    int? estimatedDurationMinutes,
    Value<String?> description = const Value.absent(),
    Value<String?> tags = const Value.absent(),
    bool? hasActivePlan,
    Value<String?> activePlanId = const Value.absent(),
    Value<String?> activePlanTitle = const Value.absent(),
    String? syncStatus,
    bool? isDeleted,
    Value<DateTime?> updatedAtUtc = const Value.absent(),
  }) => LocalMaterial(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    materialType: materialType ?? this.materialType,
    content: content ?? this.content,
    estimatedDurationMinutes:
        estimatedDurationMinutes ?? this.estimatedDurationMinutes,
    description: description.present ? description.value : this.description,
    tags: tags.present ? tags.value : this.tags,
    hasActivePlan: hasActivePlan ?? this.hasActivePlan,
    activePlanId: activePlanId.present ? activePlanId.value : this.activePlanId,
    activePlanTitle: activePlanTitle.present
        ? activePlanTitle.value
        : this.activePlanTitle,
    syncStatus: syncStatus ?? this.syncStatus,
    isDeleted: isDeleted ?? this.isDeleted,
    updatedAtUtc: updatedAtUtc.present ? updatedAtUtc.value : this.updatedAtUtc,
  );
  LocalMaterial copyWithCompanion(LocalMaterialsCompanion data) {
    return LocalMaterial(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      materialType: data.materialType.present
          ? data.materialType.value
          : this.materialType,
      content: data.content.present ? data.content.value : this.content,
      estimatedDurationMinutes: data.estimatedDurationMinutes.present
          ? data.estimatedDurationMinutes.value
          : this.estimatedDurationMinutes,
      description: data.description.present
          ? data.description.value
          : this.description,
      tags: data.tags.present ? data.tags.value : this.tags,
      hasActivePlan: data.hasActivePlan.present
          ? data.hasActivePlan.value
          : this.hasActivePlan,
      activePlanId: data.activePlanId.present
          ? data.activePlanId.value
          : this.activePlanId,
      activePlanTitle: data.activePlanTitle.present
          ? data.activePlanTitle.value
          : this.activePlanTitle,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalMaterial(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('materialType: $materialType, ')
          ..write('content: $content, ')
          ..write('estimatedDurationMinutes: $estimatedDurationMinutes, ')
          ..write('description: $description, ')
          ..write('tags: $tags, ')
          ..write('hasActivePlan: $hasActivePlan, ')
          ..write('activePlanId: $activePlanId, ')
          ..write('activePlanTitle: $activePlanTitle, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('updatedAtUtc: $updatedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    title,
    materialType,
    content,
    estimatedDurationMinutes,
    description,
    tags,
    hasActivePlan,
    activePlanId,
    activePlanTitle,
    syncStatus,
    isDeleted,
    updatedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalMaterial &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.materialType == this.materialType &&
          other.content == this.content &&
          other.estimatedDurationMinutes == this.estimatedDurationMinutes &&
          other.description == this.description &&
          other.tags == this.tags &&
          other.hasActivePlan == this.hasActivePlan &&
          other.activePlanId == this.activePlanId &&
          other.activePlanTitle == this.activePlanTitle &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted &&
          other.updatedAtUtc == this.updatedAtUtc);
}

class LocalMaterialsCompanion extends UpdateCompanion<LocalMaterial> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> title;
  final Value<String> materialType;
  final Value<String> content;
  final Value<int> estimatedDurationMinutes;
  final Value<String?> description;
  final Value<String?> tags;
  final Value<bool> hasActivePlan;
  final Value<String?> activePlanId;
  final Value<String?> activePlanTitle;
  final Value<String> syncStatus;
  final Value<bool> isDeleted;
  final Value<DateTime?> updatedAtUtc;
  final Value<int> rowid;
  const LocalMaterialsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.materialType = const Value.absent(),
    this.content = const Value.absent(),
    this.estimatedDurationMinutes = const Value.absent(),
    this.description = const Value.absent(),
    this.tags = const Value.absent(),
    this.hasActivePlan = const Value.absent(),
    this.activePlanId = const Value.absent(),
    this.activePlanTitle = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalMaterialsCompanion.insert({
    required String id,
    required String userId,
    required String title,
    required String materialType,
    required String content,
    required int estimatedDurationMinutes,
    this.description = const Value.absent(),
    this.tags = const Value.absent(),
    this.hasActivePlan = const Value.absent(),
    this.activePlanId = const Value.absent(),
    this.activePlanTitle = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       title = Value(title),
       materialType = Value(materialType),
       content = Value(content),
       estimatedDurationMinutes = Value(estimatedDurationMinutes);
  static Insertable<LocalMaterial> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<String>? materialType,
    Expression<String>? content,
    Expression<int>? estimatedDurationMinutes,
    Expression<String>? description,
    Expression<String>? tags,
    Expression<bool>? hasActivePlan,
    Expression<String>? activePlanId,
    Expression<String>? activePlanTitle,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
    Expression<DateTime>? updatedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (materialType != null) 'material_type': materialType,
      if (content != null) 'content': content,
      if (estimatedDurationMinutes != null)
        'estimated_duration_minutes': estimatedDurationMinutes,
      if (description != null) 'description': description,
      if (tags != null) 'tags': tags,
      if (hasActivePlan != null) 'has_active_plan': hasActivePlan,
      if (activePlanId != null) 'active_plan_id': activePlanId,
      if (activePlanTitle != null) 'active_plan_title': activePlanTitle,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalMaterialsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? title,
    Value<String>? materialType,
    Value<String>? content,
    Value<int>? estimatedDurationMinutes,
    Value<String?>? description,
    Value<String?>? tags,
    Value<bool>? hasActivePlan,
    Value<String?>? activePlanId,
    Value<String?>? activePlanTitle,
    Value<String>? syncStatus,
    Value<bool>? isDeleted,
    Value<DateTime?>? updatedAtUtc,
    Value<int>? rowid,
  }) {
    return LocalMaterialsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      materialType: materialType ?? this.materialType,
      content: content ?? this.content,
      estimatedDurationMinutes:
          estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      hasActivePlan: hasActivePlan ?? this.hasActivePlan,
      activePlanId: activePlanId ?? this.activePlanId,
      activePlanTitle: activePlanTitle ?? this.activePlanTitle,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (materialType.present) {
      map['material_type'] = Variable<String>(materialType.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (estimatedDurationMinutes.present) {
      map['estimated_duration_minutes'] = Variable<int>(
        estimatedDurationMinutes.value,
      );
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (hasActivePlan.present) {
      map['has_active_plan'] = Variable<bool>(hasActivePlan.value);
    }
    if (activePlanId.present) {
      map['active_plan_id'] = Variable<String>(activePlanId.value);
    }
    if (activePlanTitle.present) {
      map['active_plan_title'] = Variable<String>(activePlanTitle.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalMaterialsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('materialType: $materialType, ')
          ..write('content: $content, ')
          ..write('estimatedDurationMinutes: $estimatedDurationMinutes, ')
          ..write('description: $description, ')
          ..write('tags: $tags, ')
          ..write('hasActivePlan: $hasActivePlan, ')
          ..write('activePlanId: $activePlanId, ')
          ..write('activePlanTitle: $activePlanTitle, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalMaterialChunksTable extends LocalMaterialChunks
    with TableInfo<$LocalMaterialChunksTable, LocalMaterialChunk> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalMaterialChunksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _learningMaterialIdMeta =
      const VerificationMeta('learningMaterialId');
  @override
  late final GeneratedColumn<String> learningMaterialId =
      GeneratedColumn<String>(
        'learning_material_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _orderNoMeta = const VerificationMeta(
    'orderNo',
  );
  @override
  late final GeneratedColumn<int> orderNo = GeneratedColumn<int>(
    'order_no',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _keywordsMeta = const VerificationMeta(
    'keywords',
  );
  @override
  late final GeneratedColumn<String> keywords = GeneratedColumn<String>(
    'keywords',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _difficultyLevelMeta = const VerificationMeta(
    'difficultyLevel',
  );
  @override
  late final GeneratedColumn<int> difficultyLevel = GeneratedColumn<int>(
    'difficulty_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedStudyMinutesMeta =
      const VerificationMeta('estimatedStudyMinutes');
  @override
  late final GeneratedColumn<int> estimatedStudyMinutes = GeneratedColumn<int>(
    'estimated_study_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _characterCountMeta = const VerificationMeta(
    'characterCount',
  );
  @override
  late final GeneratedColumn<int> characterCount = GeneratedColumn<int>(
    'character_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isGeneratedByAIMeta = const VerificationMeta(
    'isGeneratedByAI',
  );
  @override
  late final GeneratedColumn<bool> isGeneratedByAI = GeneratedColumn<bool>(
    'is_generated_by_a_i',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_generated_by_a_i" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    learningMaterialId,
    orderNo,
    title,
    content,
    summary,
    keywords,
    difficultyLevel,
    estimatedStudyMinutes,
    characterCount,
    isGeneratedByAI,
    syncStatus,
    isDeleted,
    updatedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_material_chunks';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalMaterialChunk> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('learning_material_id')) {
      context.handle(
        _learningMaterialIdMeta,
        learningMaterialId.isAcceptableOrUnknown(
          data['learning_material_id']!,
          _learningMaterialIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_learningMaterialIdMeta);
    }
    if (data.containsKey('order_no')) {
      context.handle(
        _orderNoMeta,
        orderNo.isAcceptableOrUnknown(data['order_no']!, _orderNoMeta),
      );
    } else if (isInserting) {
      context.missing(_orderNoMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('keywords')) {
      context.handle(
        _keywordsMeta,
        keywords.isAcceptableOrUnknown(data['keywords']!, _keywordsMeta),
      );
    }
    if (data.containsKey('difficulty_level')) {
      context.handle(
        _difficultyLevelMeta,
        difficultyLevel.isAcceptableOrUnknown(
          data['difficulty_level']!,
          _difficultyLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_difficultyLevelMeta);
    }
    if (data.containsKey('estimated_study_minutes')) {
      context.handle(
        _estimatedStudyMinutesMeta,
        estimatedStudyMinutes.isAcceptableOrUnknown(
          data['estimated_study_minutes']!,
          _estimatedStudyMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estimatedStudyMinutesMeta);
    }
    if (data.containsKey('character_count')) {
      context.handle(
        _characterCountMeta,
        characterCount.isAcceptableOrUnknown(
          data['character_count']!,
          _characterCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterCountMeta);
    }
    if (data.containsKey('is_generated_by_a_i')) {
      context.handle(
        _isGeneratedByAIMeta,
        isGeneratedByAI.isAcceptableOrUnknown(
          data['is_generated_by_a_i']!,
          _isGeneratedByAIMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalMaterialChunk map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalMaterialChunk(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      learningMaterialId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}learning_material_id'],
      )!,
      orderNo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_no'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      ),
      keywords: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}keywords'],
      ),
      difficultyLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difficulty_level'],
      )!,
      estimatedStudyMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_study_minutes'],
      )!,
      characterCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}character_count'],
      )!,
      isGeneratedByAI: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_generated_by_a_i'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      ),
    );
  }

  @override
  $LocalMaterialChunksTable createAlias(String alias) {
    return $LocalMaterialChunksTable(attachedDatabase, alias);
  }
}

class LocalMaterialChunk extends DataClass
    implements Insertable<LocalMaterialChunk> {
  final String id;
  final String learningMaterialId;
  final int orderNo;
  final String? title;
  final String content;
  final String? summary;
  final String? keywords;
  final int difficultyLevel;
  final int estimatedStudyMinutes;
  final int characterCount;
  final bool isGeneratedByAI;
  final String syncStatus;
  final bool isDeleted;
  final DateTime? updatedAtUtc;
  const LocalMaterialChunk({
    required this.id,
    required this.learningMaterialId,
    required this.orderNo,
    this.title,
    required this.content,
    this.summary,
    this.keywords,
    required this.difficultyLevel,
    required this.estimatedStudyMinutes,
    required this.characterCount,
    required this.isGeneratedByAI,
    required this.syncStatus,
    required this.isDeleted,
    this.updatedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['learning_material_id'] = Variable<String>(learningMaterialId);
    map['order_no'] = Variable<int>(orderNo);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    if (!nullToAbsent || keywords != null) {
      map['keywords'] = Variable<String>(keywords);
    }
    map['difficulty_level'] = Variable<int>(difficultyLevel);
    map['estimated_study_minutes'] = Variable<int>(estimatedStudyMinutes);
    map['character_count'] = Variable<int>(characterCount);
    map['is_generated_by_a_i'] = Variable<bool>(isGeneratedByAI);
    map['sync_status'] = Variable<String>(syncStatus);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || updatedAtUtc != null) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    }
    return map;
  }

  LocalMaterialChunksCompanion toCompanion(bool nullToAbsent) {
    return LocalMaterialChunksCompanion(
      id: Value(id),
      learningMaterialId: Value(learningMaterialId),
      orderNo: Value(orderNo),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      content: Value(content),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      keywords: keywords == null && nullToAbsent
          ? const Value.absent()
          : Value(keywords),
      difficultyLevel: Value(difficultyLevel),
      estimatedStudyMinutes: Value(estimatedStudyMinutes),
      characterCount: Value(characterCount),
      isGeneratedByAI: Value(isGeneratedByAI),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
      updatedAtUtc: updatedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAtUtc),
    );
  }

  factory LocalMaterialChunk.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalMaterialChunk(
      id: serializer.fromJson<String>(json['id']),
      learningMaterialId: serializer.fromJson<String>(
        json['learningMaterialId'],
      ),
      orderNo: serializer.fromJson<int>(json['orderNo']),
      title: serializer.fromJson<String?>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      summary: serializer.fromJson<String?>(json['summary']),
      keywords: serializer.fromJson<String?>(json['keywords']),
      difficultyLevel: serializer.fromJson<int>(json['difficultyLevel']),
      estimatedStudyMinutes: serializer.fromJson<int>(
        json['estimatedStudyMinutes'],
      ),
      characterCount: serializer.fromJson<int>(json['characterCount']),
      isGeneratedByAI: serializer.fromJson<bool>(json['isGeneratedByAI']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      updatedAtUtc: serializer.fromJson<DateTime?>(json['updatedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'learningMaterialId': serializer.toJson<String>(learningMaterialId),
      'orderNo': serializer.toJson<int>(orderNo),
      'title': serializer.toJson<String?>(title),
      'content': serializer.toJson<String>(content),
      'summary': serializer.toJson<String?>(summary),
      'keywords': serializer.toJson<String?>(keywords),
      'difficultyLevel': serializer.toJson<int>(difficultyLevel),
      'estimatedStudyMinutes': serializer.toJson<int>(estimatedStudyMinutes),
      'characterCount': serializer.toJson<int>(characterCount),
      'isGeneratedByAI': serializer.toJson<bool>(isGeneratedByAI),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'updatedAtUtc': serializer.toJson<DateTime?>(updatedAtUtc),
    };
  }

  LocalMaterialChunk copyWith({
    String? id,
    String? learningMaterialId,
    int? orderNo,
    Value<String?> title = const Value.absent(),
    String? content,
    Value<String?> summary = const Value.absent(),
    Value<String?> keywords = const Value.absent(),
    int? difficultyLevel,
    int? estimatedStudyMinutes,
    int? characterCount,
    bool? isGeneratedByAI,
    String? syncStatus,
    bool? isDeleted,
    Value<DateTime?> updatedAtUtc = const Value.absent(),
  }) => LocalMaterialChunk(
    id: id ?? this.id,
    learningMaterialId: learningMaterialId ?? this.learningMaterialId,
    orderNo: orderNo ?? this.orderNo,
    title: title.present ? title.value : this.title,
    content: content ?? this.content,
    summary: summary.present ? summary.value : this.summary,
    keywords: keywords.present ? keywords.value : this.keywords,
    difficultyLevel: difficultyLevel ?? this.difficultyLevel,
    estimatedStudyMinutes: estimatedStudyMinutes ?? this.estimatedStudyMinutes,
    characterCount: characterCount ?? this.characterCount,
    isGeneratedByAI: isGeneratedByAI ?? this.isGeneratedByAI,
    syncStatus: syncStatus ?? this.syncStatus,
    isDeleted: isDeleted ?? this.isDeleted,
    updatedAtUtc: updatedAtUtc.present ? updatedAtUtc.value : this.updatedAtUtc,
  );
  LocalMaterialChunk copyWithCompanion(LocalMaterialChunksCompanion data) {
    return LocalMaterialChunk(
      id: data.id.present ? data.id.value : this.id,
      learningMaterialId: data.learningMaterialId.present
          ? data.learningMaterialId.value
          : this.learningMaterialId,
      orderNo: data.orderNo.present ? data.orderNo.value : this.orderNo,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      summary: data.summary.present ? data.summary.value : this.summary,
      keywords: data.keywords.present ? data.keywords.value : this.keywords,
      difficultyLevel: data.difficultyLevel.present
          ? data.difficultyLevel.value
          : this.difficultyLevel,
      estimatedStudyMinutes: data.estimatedStudyMinutes.present
          ? data.estimatedStudyMinutes.value
          : this.estimatedStudyMinutes,
      characterCount: data.characterCount.present
          ? data.characterCount.value
          : this.characterCount,
      isGeneratedByAI: data.isGeneratedByAI.present
          ? data.isGeneratedByAI.value
          : this.isGeneratedByAI,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalMaterialChunk(')
          ..write('id: $id, ')
          ..write('learningMaterialId: $learningMaterialId, ')
          ..write('orderNo: $orderNo, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('summary: $summary, ')
          ..write('keywords: $keywords, ')
          ..write('difficultyLevel: $difficultyLevel, ')
          ..write('estimatedStudyMinutes: $estimatedStudyMinutes, ')
          ..write('characterCount: $characterCount, ')
          ..write('isGeneratedByAI: $isGeneratedByAI, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('updatedAtUtc: $updatedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    learningMaterialId,
    orderNo,
    title,
    content,
    summary,
    keywords,
    difficultyLevel,
    estimatedStudyMinutes,
    characterCount,
    isGeneratedByAI,
    syncStatus,
    isDeleted,
    updatedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalMaterialChunk &&
          other.id == this.id &&
          other.learningMaterialId == this.learningMaterialId &&
          other.orderNo == this.orderNo &&
          other.title == this.title &&
          other.content == this.content &&
          other.summary == this.summary &&
          other.keywords == this.keywords &&
          other.difficultyLevel == this.difficultyLevel &&
          other.estimatedStudyMinutes == this.estimatedStudyMinutes &&
          other.characterCount == this.characterCount &&
          other.isGeneratedByAI == this.isGeneratedByAI &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted &&
          other.updatedAtUtc == this.updatedAtUtc);
}

class LocalMaterialChunksCompanion extends UpdateCompanion<LocalMaterialChunk> {
  final Value<String> id;
  final Value<String> learningMaterialId;
  final Value<int> orderNo;
  final Value<String?> title;
  final Value<String> content;
  final Value<String?> summary;
  final Value<String?> keywords;
  final Value<int> difficultyLevel;
  final Value<int> estimatedStudyMinutes;
  final Value<int> characterCount;
  final Value<bool> isGeneratedByAI;
  final Value<String> syncStatus;
  final Value<bool> isDeleted;
  final Value<DateTime?> updatedAtUtc;
  final Value<int> rowid;
  const LocalMaterialChunksCompanion({
    this.id = const Value.absent(),
    this.learningMaterialId = const Value.absent(),
    this.orderNo = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.summary = const Value.absent(),
    this.keywords = const Value.absent(),
    this.difficultyLevel = const Value.absent(),
    this.estimatedStudyMinutes = const Value.absent(),
    this.characterCount = const Value.absent(),
    this.isGeneratedByAI = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalMaterialChunksCompanion.insert({
    required String id,
    required String learningMaterialId,
    required int orderNo,
    this.title = const Value.absent(),
    required String content,
    this.summary = const Value.absent(),
    this.keywords = const Value.absent(),
    required int difficultyLevel,
    required int estimatedStudyMinutes,
    required int characterCount,
    this.isGeneratedByAI = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       learningMaterialId = Value(learningMaterialId),
       orderNo = Value(orderNo),
       content = Value(content),
       difficultyLevel = Value(difficultyLevel),
       estimatedStudyMinutes = Value(estimatedStudyMinutes),
       characterCount = Value(characterCount);
  static Insertable<LocalMaterialChunk> custom({
    Expression<String>? id,
    Expression<String>? learningMaterialId,
    Expression<int>? orderNo,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? summary,
    Expression<String>? keywords,
    Expression<int>? difficultyLevel,
    Expression<int>? estimatedStudyMinutes,
    Expression<int>? characterCount,
    Expression<bool>? isGeneratedByAI,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
    Expression<DateTime>? updatedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (learningMaterialId != null)
        'learning_material_id': learningMaterialId,
      if (orderNo != null) 'order_no': orderNo,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (summary != null) 'summary': summary,
      if (keywords != null) 'keywords': keywords,
      if (difficultyLevel != null) 'difficulty_level': difficultyLevel,
      if (estimatedStudyMinutes != null)
        'estimated_study_minutes': estimatedStudyMinutes,
      if (characterCount != null) 'character_count': characterCount,
      if (isGeneratedByAI != null) 'is_generated_by_a_i': isGeneratedByAI,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalMaterialChunksCompanion copyWith({
    Value<String>? id,
    Value<String>? learningMaterialId,
    Value<int>? orderNo,
    Value<String?>? title,
    Value<String>? content,
    Value<String?>? summary,
    Value<String?>? keywords,
    Value<int>? difficultyLevel,
    Value<int>? estimatedStudyMinutes,
    Value<int>? characterCount,
    Value<bool>? isGeneratedByAI,
    Value<String>? syncStatus,
    Value<bool>? isDeleted,
    Value<DateTime?>? updatedAtUtc,
    Value<int>? rowid,
  }) {
    return LocalMaterialChunksCompanion(
      id: id ?? this.id,
      learningMaterialId: learningMaterialId ?? this.learningMaterialId,
      orderNo: orderNo ?? this.orderNo,
      title: title ?? this.title,
      content: content ?? this.content,
      summary: summary ?? this.summary,
      keywords: keywords ?? this.keywords,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      estimatedStudyMinutes:
          estimatedStudyMinutes ?? this.estimatedStudyMinutes,
      characterCount: characterCount ?? this.characterCount,
      isGeneratedByAI: isGeneratedByAI ?? this.isGeneratedByAI,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (learningMaterialId.present) {
      map['learning_material_id'] = Variable<String>(learningMaterialId.value);
    }
    if (orderNo.present) {
      map['order_no'] = Variable<int>(orderNo.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (keywords.present) {
      map['keywords'] = Variable<String>(keywords.value);
    }
    if (difficultyLevel.present) {
      map['difficulty_level'] = Variable<int>(difficultyLevel.value);
    }
    if (estimatedStudyMinutes.present) {
      map['estimated_study_minutes'] = Variable<int>(
        estimatedStudyMinutes.value,
      );
    }
    if (characterCount.present) {
      map['character_count'] = Variable<int>(characterCount.value);
    }
    if (isGeneratedByAI.present) {
      map['is_generated_by_a_i'] = Variable<bool>(isGeneratedByAI.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalMaterialChunksCompanion(')
          ..write('id: $id, ')
          ..write('learningMaterialId: $learningMaterialId, ')
          ..write('orderNo: $orderNo, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('summary: $summary, ')
          ..write('keywords: $keywords, ')
          ..write('difficultyLevel: $difficultyLevel, ')
          ..write('estimatedStudyMinutes: $estimatedStudyMinutes, ')
          ..write('characterCount: $characterCount, ')
          ..write('isGeneratedByAI: $isGeneratedByAI, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalStudyPlansTable extends LocalStudyPlans
    with TableInfo<$LocalStudyPlansTable, LocalStudyPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalStudyPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _learningMaterialIdMeta =
      const VerificationMeta('learningMaterialId');
  @override
  late final GeneratedColumn<String> learningMaterialId =
      GeneratedColumn<String>(
        'learning_material_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
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
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dailyTargetMinutesMeta =
      const VerificationMeta('dailyTargetMinutes');
  @override
  late final GeneratedColumn<int> dailyTargetMinutes = GeneratedColumn<int>(
    'daily_target_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    learningMaterialId,
    title,
    startDate,
    dailyTargetMinutes,
    status,
    syncStatus,
    isDeleted,
    updatedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_study_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalStudyPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('learning_material_id')) {
      context.handle(
        _learningMaterialIdMeta,
        learningMaterialId.isAcceptableOrUnknown(
          data['learning_material_id']!,
          _learningMaterialIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_learningMaterialIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('daily_target_minutes')) {
      context.handle(
        _dailyTargetMinutesMeta,
        dailyTargetMinutes.isAcceptableOrUnknown(
          data['daily_target_minutes']!,
          _dailyTargetMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dailyTargetMinutesMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalStudyPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalStudyPlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      learningMaterialId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}learning_material_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      )!,
      dailyTargetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_target_minutes'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      ),
    );
  }

  @override
  $LocalStudyPlansTable createAlias(String alias) {
    return $LocalStudyPlansTable(attachedDatabase, alias);
  }
}

class LocalStudyPlan extends DataClass implements Insertable<LocalStudyPlan> {
  final String id;
  final String userId;
  final String learningMaterialId;
  final String title;
  final String startDate;
  final int dailyTargetMinutes;
  final String status;
  final String syncStatus;
  final bool isDeleted;
  final DateTime? updatedAtUtc;
  const LocalStudyPlan({
    required this.id,
    required this.userId,
    required this.learningMaterialId,
    required this.title,
    required this.startDate,
    required this.dailyTargetMinutes,
    required this.status,
    required this.syncStatus,
    required this.isDeleted,
    this.updatedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['learning_material_id'] = Variable<String>(learningMaterialId);
    map['title'] = Variable<String>(title);
    map['start_date'] = Variable<String>(startDate);
    map['daily_target_minutes'] = Variable<int>(dailyTargetMinutes);
    map['status'] = Variable<String>(status);
    map['sync_status'] = Variable<String>(syncStatus);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || updatedAtUtc != null) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    }
    return map;
  }

  LocalStudyPlansCompanion toCompanion(bool nullToAbsent) {
    return LocalStudyPlansCompanion(
      id: Value(id),
      userId: Value(userId),
      learningMaterialId: Value(learningMaterialId),
      title: Value(title),
      startDate: Value(startDate),
      dailyTargetMinutes: Value(dailyTargetMinutes),
      status: Value(status),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
      updatedAtUtc: updatedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAtUtc),
    );
  }

  factory LocalStudyPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalStudyPlan(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      learningMaterialId: serializer.fromJson<String>(
        json['learningMaterialId'],
      ),
      title: serializer.fromJson<String>(json['title']),
      startDate: serializer.fromJson<String>(json['startDate']),
      dailyTargetMinutes: serializer.fromJson<int>(json['dailyTargetMinutes']),
      status: serializer.fromJson<String>(json['status']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      updatedAtUtc: serializer.fromJson<DateTime?>(json['updatedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'learningMaterialId': serializer.toJson<String>(learningMaterialId),
      'title': serializer.toJson<String>(title),
      'startDate': serializer.toJson<String>(startDate),
      'dailyTargetMinutes': serializer.toJson<int>(dailyTargetMinutes),
      'status': serializer.toJson<String>(status),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'updatedAtUtc': serializer.toJson<DateTime?>(updatedAtUtc),
    };
  }

  LocalStudyPlan copyWith({
    String? id,
    String? userId,
    String? learningMaterialId,
    String? title,
    String? startDate,
    int? dailyTargetMinutes,
    String? status,
    String? syncStatus,
    bool? isDeleted,
    Value<DateTime?> updatedAtUtc = const Value.absent(),
  }) => LocalStudyPlan(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    learningMaterialId: learningMaterialId ?? this.learningMaterialId,
    title: title ?? this.title,
    startDate: startDate ?? this.startDate,
    dailyTargetMinutes: dailyTargetMinutes ?? this.dailyTargetMinutes,
    status: status ?? this.status,
    syncStatus: syncStatus ?? this.syncStatus,
    isDeleted: isDeleted ?? this.isDeleted,
    updatedAtUtc: updatedAtUtc.present ? updatedAtUtc.value : this.updatedAtUtc,
  );
  LocalStudyPlan copyWithCompanion(LocalStudyPlansCompanion data) {
    return LocalStudyPlan(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      learningMaterialId: data.learningMaterialId.present
          ? data.learningMaterialId.value
          : this.learningMaterialId,
      title: data.title.present ? data.title.value : this.title,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      dailyTargetMinutes: data.dailyTargetMinutes.present
          ? data.dailyTargetMinutes.value
          : this.dailyTargetMinutes,
      status: data.status.present ? data.status.value : this.status,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalStudyPlan(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('learningMaterialId: $learningMaterialId, ')
          ..write('title: $title, ')
          ..write('startDate: $startDate, ')
          ..write('dailyTargetMinutes: $dailyTargetMinutes, ')
          ..write('status: $status, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('updatedAtUtc: $updatedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    learningMaterialId,
    title,
    startDate,
    dailyTargetMinutes,
    status,
    syncStatus,
    isDeleted,
    updatedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalStudyPlan &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.learningMaterialId == this.learningMaterialId &&
          other.title == this.title &&
          other.startDate == this.startDate &&
          other.dailyTargetMinutes == this.dailyTargetMinutes &&
          other.status == this.status &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted &&
          other.updatedAtUtc == this.updatedAtUtc);
}

class LocalStudyPlansCompanion extends UpdateCompanion<LocalStudyPlan> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> learningMaterialId;
  final Value<String> title;
  final Value<String> startDate;
  final Value<int> dailyTargetMinutes;
  final Value<String> status;
  final Value<String> syncStatus;
  final Value<bool> isDeleted;
  final Value<DateTime?> updatedAtUtc;
  final Value<int> rowid;
  const LocalStudyPlansCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.learningMaterialId = const Value.absent(),
    this.title = const Value.absent(),
    this.startDate = const Value.absent(),
    this.dailyTargetMinutes = const Value.absent(),
    this.status = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalStudyPlansCompanion.insert({
    required String id,
    required String userId,
    required String learningMaterialId,
    required String title,
    required String startDate,
    required int dailyTargetMinutes,
    required String status,
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       learningMaterialId = Value(learningMaterialId),
       title = Value(title),
       startDate = Value(startDate),
       dailyTargetMinutes = Value(dailyTargetMinutes),
       status = Value(status);
  static Insertable<LocalStudyPlan> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? learningMaterialId,
    Expression<String>? title,
    Expression<String>? startDate,
    Expression<int>? dailyTargetMinutes,
    Expression<String>? status,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
    Expression<DateTime>? updatedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (learningMaterialId != null)
        'learning_material_id': learningMaterialId,
      if (title != null) 'title': title,
      if (startDate != null) 'start_date': startDate,
      if (dailyTargetMinutes != null)
        'daily_target_minutes': dailyTargetMinutes,
      if (status != null) 'status': status,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalStudyPlansCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? learningMaterialId,
    Value<String>? title,
    Value<String>? startDate,
    Value<int>? dailyTargetMinutes,
    Value<String>? status,
    Value<String>? syncStatus,
    Value<bool>? isDeleted,
    Value<DateTime?>? updatedAtUtc,
    Value<int>? rowid,
  }) {
    return LocalStudyPlansCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      learningMaterialId: learningMaterialId ?? this.learningMaterialId,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      dailyTargetMinutes: dailyTargetMinutes ?? this.dailyTargetMinutes,
      status: status ?? this.status,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (learningMaterialId.present) {
      map['learning_material_id'] = Variable<String>(learningMaterialId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (dailyTargetMinutes.present) {
      map['daily_target_minutes'] = Variable<int>(dailyTargetMinutes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalStudyPlansCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('learningMaterialId: $learningMaterialId, ')
          ..write('title: $title, ')
          ..write('startDate: $startDate, ')
          ..write('dailyTargetMinutes: $dailyTargetMinutes, ')
          ..write('status: $status, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalStudyPlanItemsTable extends LocalStudyPlanItems
    with TableInfo<$LocalStudyPlanItemsTable, LocalStudyPlanItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalStudyPlanItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studyPlanIdMeta = const VerificationMeta(
    'studyPlanId',
  );
  @override
  late final GeneratedColumn<String> studyPlanId = GeneratedColumn<String>(
    'study_plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _materialChunkIdMeta = const VerificationMeta(
    'materialChunkId',
  );
  @override
  late final GeneratedColumn<String> materialChunkId = GeneratedColumn<String>(
    'material_chunk_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _itemTypeMeta = const VerificationMeta(
    'itemType',
  );
  @override
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
    'item_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderNoMeta = const VerificationMeta(
    'orderNo',
  );
  @override
  late final GeneratedColumn<int> orderNo = GeneratedColumn<int>(
    'order_no',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedDateUtcMeta = const VerificationMeta(
    'plannedDateUtc',
  );
  @override
  late final GeneratedColumn<DateTime> plannedDateUtc =
      GeneratedColumn<DateTime>(
        'planned_date_utc',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _plannedStartTimeMeta = const VerificationMeta(
    'plannedStartTime',
  );
  @override
  late final GeneratedColumn<String> plannedStartTime = GeneratedColumn<String>(
    'planned_start_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plannedEndTimeMeta = const VerificationMeta(
    'plannedEndTime',
  );
  @override
  late final GeneratedColumn<String> plannedEndTime = GeneratedColumn<String>(
    'planned_end_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studyPlanId,
    materialChunkId,
    title,
    description,
    itemType,
    orderNo,
    plannedDateUtc,
    plannedStartTime,
    plannedEndTime,
    durationMinutes,
    status,
    syncStatus,
    isDeleted,
    updatedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_study_plan_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalStudyPlanItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('study_plan_id')) {
      context.handle(
        _studyPlanIdMeta,
        studyPlanId.isAcceptableOrUnknown(
          data['study_plan_id']!,
          _studyPlanIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_studyPlanIdMeta);
    }
    if (data.containsKey('material_chunk_id')) {
      context.handle(
        _materialChunkIdMeta,
        materialChunkId.isAcceptableOrUnknown(
          data['material_chunk_id']!,
          _materialChunkIdMeta,
        ),
      );
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
    }
    if (data.containsKey('item_type')) {
      context.handle(
        _itemTypeMeta,
        itemType.isAcceptableOrUnknown(data['item_type']!, _itemTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_itemTypeMeta);
    }
    if (data.containsKey('order_no')) {
      context.handle(
        _orderNoMeta,
        orderNo.isAcceptableOrUnknown(data['order_no']!, _orderNoMeta),
      );
    } else if (isInserting) {
      context.missing(_orderNoMeta);
    }
    if (data.containsKey('planned_date_utc')) {
      context.handle(
        _plannedDateUtcMeta,
        plannedDateUtc.isAcceptableOrUnknown(
          data['planned_date_utc']!,
          _plannedDateUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedDateUtcMeta);
    }
    if (data.containsKey('planned_start_time')) {
      context.handle(
        _plannedStartTimeMeta,
        plannedStartTime.isAcceptableOrUnknown(
          data['planned_start_time']!,
          _plannedStartTimeMeta,
        ),
      );
    }
    if (data.containsKey('planned_end_time')) {
      context.handle(
        _plannedEndTimeMeta,
        plannedEndTime.isAcceptableOrUnknown(
          data['planned_end_time']!,
          _plannedEndTimeMeta,
        ),
      );
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalStudyPlanItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalStudyPlanItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      studyPlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}study_plan_id'],
      )!,
      materialChunkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}material_chunk_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      itemType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_type'],
      )!,
      orderNo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_no'],
      )!,
      plannedDateUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}planned_date_utc'],
      )!,
      plannedStartTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}planned_start_time'],
      ),
      plannedEndTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}planned_end_time'],
      ),
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      ),
    );
  }

  @override
  $LocalStudyPlanItemsTable createAlias(String alias) {
    return $LocalStudyPlanItemsTable(attachedDatabase, alias);
  }
}

class LocalStudyPlanItem extends DataClass
    implements Insertable<LocalStudyPlanItem> {
  final String id;
  final String studyPlanId;
  final String? materialChunkId;
  final String title;
  final String? description;
  final String itemType;
  final int orderNo;
  final DateTime plannedDateUtc;
  final String? plannedStartTime;
  final String? plannedEndTime;
  final int durationMinutes;
  final String status;
  final String syncStatus;
  final bool isDeleted;
  final DateTime? updatedAtUtc;
  const LocalStudyPlanItem({
    required this.id,
    required this.studyPlanId,
    this.materialChunkId,
    required this.title,
    this.description,
    required this.itemType,
    required this.orderNo,
    required this.plannedDateUtc,
    this.plannedStartTime,
    this.plannedEndTime,
    required this.durationMinutes,
    required this.status,
    required this.syncStatus,
    required this.isDeleted,
    this.updatedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['study_plan_id'] = Variable<String>(studyPlanId);
    if (!nullToAbsent || materialChunkId != null) {
      map['material_chunk_id'] = Variable<String>(materialChunkId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['item_type'] = Variable<String>(itemType);
    map['order_no'] = Variable<int>(orderNo);
    map['planned_date_utc'] = Variable<DateTime>(plannedDateUtc);
    if (!nullToAbsent || plannedStartTime != null) {
      map['planned_start_time'] = Variable<String>(plannedStartTime);
    }
    if (!nullToAbsent || plannedEndTime != null) {
      map['planned_end_time'] = Variable<String>(plannedEndTime);
    }
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['status'] = Variable<String>(status);
    map['sync_status'] = Variable<String>(syncStatus);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || updatedAtUtc != null) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    }
    return map;
  }

  LocalStudyPlanItemsCompanion toCompanion(bool nullToAbsent) {
    return LocalStudyPlanItemsCompanion(
      id: Value(id),
      studyPlanId: Value(studyPlanId),
      materialChunkId: materialChunkId == null && nullToAbsent
          ? const Value.absent()
          : Value(materialChunkId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      itemType: Value(itemType),
      orderNo: Value(orderNo),
      plannedDateUtc: Value(plannedDateUtc),
      plannedStartTime: plannedStartTime == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedStartTime),
      plannedEndTime: plannedEndTime == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedEndTime),
      durationMinutes: Value(durationMinutes),
      status: Value(status),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
      updatedAtUtc: updatedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAtUtc),
    );
  }

  factory LocalStudyPlanItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalStudyPlanItem(
      id: serializer.fromJson<String>(json['id']),
      studyPlanId: serializer.fromJson<String>(json['studyPlanId']),
      materialChunkId: serializer.fromJson<String?>(json['materialChunkId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      itemType: serializer.fromJson<String>(json['itemType']),
      orderNo: serializer.fromJson<int>(json['orderNo']),
      plannedDateUtc: serializer.fromJson<DateTime>(json['plannedDateUtc']),
      plannedStartTime: serializer.fromJson<String?>(json['plannedStartTime']),
      plannedEndTime: serializer.fromJson<String?>(json['plannedEndTime']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      status: serializer.fromJson<String>(json['status']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      updatedAtUtc: serializer.fromJson<DateTime?>(json['updatedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studyPlanId': serializer.toJson<String>(studyPlanId),
      'materialChunkId': serializer.toJson<String?>(materialChunkId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'itemType': serializer.toJson<String>(itemType),
      'orderNo': serializer.toJson<int>(orderNo),
      'plannedDateUtc': serializer.toJson<DateTime>(plannedDateUtc),
      'plannedStartTime': serializer.toJson<String?>(plannedStartTime),
      'plannedEndTime': serializer.toJson<String?>(plannedEndTime),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'status': serializer.toJson<String>(status),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'updatedAtUtc': serializer.toJson<DateTime?>(updatedAtUtc),
    };
  }

  LocalStudyPlanItem copyWith({
    String? id,
    String? studyPlanId,
    Value<String?> materialChunkId = const Value.absent(),
    String? title,
    Value<String?> description = const Value.absent(),
    String? itemType,
    int? orderNo,
    DateTime? plannedDateUtc,
    Value<String?> plannedStartTime = const Value.absent(),
    Value<String?> plannedEndTime = const Value.absent(),
    int? durationMinutes,
    String? status,
    String? syncStatus,
    bool? isDeleted,
    Value<DateTime?> updatedAtUtc = const Value.absent(),
  }) => LocalStudyPlanItem(
    id: id ?? this.id,
    studyPlanId: studyPlanId ?? this.studyPlanId,
    materialChunkId: materialChunkId.present
        ? materialChunkId.value
        : this.materialChunkId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    itemType: itemType ?? this.itemType,
    orderNo: orderNo ?? this.orderNo,
    plannedDateUtc: plannedDateUtc ?? this.plannedDateUtc,
    plannedStartTime: plannedStartTime.present
        ? plannedStartTime.value
        : this.plannedStartTime,
    plannedEndTime: plannedEndTime.present
        ? plannedEndTime.value
        : this.plannedEndTime,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    status: status ?? this.status,
    syncStatus: syncStatus ?? this.syncStatus,
    isDeleted: isDeleted ?? this.isDeleted,
    updatedAtUtc: updatedAtUtc.present ? updatedAtUtc.value : this.updatedAtUtc,
  );
  LocalStudyPlanItem copyWithCompanion(LocalStudyPlanItemsCompanion data) {
    return LocalStudyPlanItem(
      id: data.id.present ? data.id.value : this.id,
      studyPlanId: data.studyPlanId.present
          ? data.studyPlanId.value
          : this.studyPlanId,
      materialChunkId: data.materialChunkId.present
          ? data.materialChunkId.value
          : this.materialChunkId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      orderNo: data.orderNo.present ? data.orderNo.value : this.orderNo,
      plannedDateUtc: data.plannedDateUtc.present
          ? data.plannedDateUtc.value
          : this.plannedDateUtc,
      plannedStartTime: data.plannedStartTime.present
          ? data.plannedStartTime.value
          : this.plannedStartTime,
      plannedEndTime: data.plannedEndTime.present
          ? data.plannedEndTime.value
          : this.plannedEndTime,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      status: data.status.present ? data.status.value : this.status,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalStudyPlanItem(')
          ..write('id: $id, ')
          ..write('studyPlanId: $studyPlanId, ')
          ..write('materialChunkId: $materialChunkId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('itemType: $itemType, ')
          ..write('orderNo: $orderNo, ')
          ..write('plannedDateUtc: $plannedDateUtc, ')
          ..write('plannedStartTime: $plannedStartTime, ')
          ..write('plannedEndTime: $plannedEndTime, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('status: $status, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('updatedAtUtc: $updatedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    studyPlanId,
    materialChunkId,
    title,
    description,
    itemType,
    orderNo,
    plannedDateUtc,
    plannedStartTime,
    plannedEndTime,
    durationMinutes,
    status,
    syncStatus,
    isDeleted,
    updatedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalStudyPlanItem &&
          other.id == this.id &&
          other.studyPlanId == this.studyPlanId &&
          other.materialChunkId == this.materialChunkId &&
          other.title == this.title &&
          other.description == this.description &&
          other.itemType == this.itemType &&
          other.orderNo == this.orderNo &&
          other.plannedDateUtc == this.plannedDateUtc &&
          other.plannedStartTime == this.plannedStartTime &&
          other.plannedEndTime == this.plannedEndTime &&
          other.durationMinutes == this.durationMinutes &&
          other.status == this.status &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted &&
          other.updatedAtUtc == this.updatedAtUtc);
}

class LocalStudyPlanItemsCompanion extends UpdateCompanion<LocalStudyPlanItem> {
  final Value<String> id;
  final Value<String> studyPlanId;
  final Value<String?> materialChunkId;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> itemType;
  final Value<int> orderNo;
  final Value<DateTime> plannedDateUtc;
  final Value<String?> plannedStartTime;
  final Value<String?> plannedEndTime;
  final Value<int> durationMinutes;
  final Value<String> status;
  final Value<String> syncStatus;
  final Value<bool> isDeleted;
  final Value<DateTime?> updatedAtUtc;
  final Value<int> rowid;
  const LocalStudyPlanItemsCompanion({
    this.id = const Value.absent(),
    this.studyPlanId = const Value.absent(),
    this.materialChunkId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.itemType = const Value.absent(),
    this.orderNo = const Value.absent(),
    this.plannedDateUtc = const Value.absent(),
    this.plannedStartTime = const Value.absent(),
    this.plannedEndTime = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.status = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalStudyPlanItemsCompanion.insert({
    required String id,
    required String studyPlanId,
    this.materialChunkId = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required String itemType,
    required int orderNo,
    required DateTime plannedDateUtc,
    this.plannedStartTime = const Value.absent(),
    this.plannedEndTime = const Value.absent(),
    required int durationMinutes,
    required String status,
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       studyPlanId = Value(studyPlanId),
       title = Value(title),
       itemType = Value(itemType),
       orderNo = Value(orderNo),
       plannedDateUtc = Value(plannedDateUtc),
       durationMinutes = Value(durationMinutes),
       status = Value(status);
  static Insertable<LocalStudyPlanItem> custom({
    Expression<String>? id,
    Expression<String>? studyPlanId,
    Expression<String>? materialChunkId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? itemType,
    Expression<int>? orderNo,
    Expression<DateTime>? plannedDateUtc,
    Expression<String>? plannedStartTime,
    Expression<String>? plannedEndTime,
    Expression<int>? durationMinutes,
    Expression<String>? status,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
    Expression<DateTime>? updatedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studyPlanId != null) 'study_plan_id': studyPlanId,
      if (materialChunkId != null) 'material_chunk_id': materialChunkId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (itemType != null) 'item_type': itemType,
      if (orderNo != null) 'order_no': orderNo,
      if (plannedDateUtc != null) 'planned_date_utc': plannedDateUtc,
      if (plannedStartTime != null) 'planned_start_time': plannedStartTime,
      if (plannedEndTime != null) 'planned_end_time': plannedEndTime,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (status != null) 'status': status,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalStudyPlanItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? studyPlanId,
    Value<String?>? materialChunkId,
    Value<String>? title,
    Value<String?>? description,
    Value<String>? itemType,
    Value<int>? orderNo,
    Value<DateTime>? plannedDateUtc,
    Value<String?>? plannedStartTime,
    Value<String?>? plannedEndTime,
    Value<int>? durationMinutes,
    Value<String>? status,
    Value<String>? syncStatus,
    Value<bool>? isDeleted,
    Value<DateTime?>? updatedAtUtc,
    Value<int>? rowid,
  }) {
    return LocalStudyPlanItemsCompanion(
      id: id ?? this.id,
      studyPlanId: studyPlanId ?? this.studyPlanId,
      materialChunkId: materialChunkId ?? this.materialChunkId,
      title: title ?? this.title,
      description: description ?? this.description,
      itemType: itemType ?? this.itemType,
      orderNo: orderNo ?? this.orderNo,
      plannedDateUtc: plannedDateUtc ?? this.plannedDateUtc,
      plannedStartTime: plannedStartTime ?? this.plannedStartTime,
      plannedEndTime: plannedEndTime ?? this.plannedEndTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      status: status ?? this.status,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studyPlanId.present) {
      map['study_plan_id'] = Variable<String>(studyPlanId.value);
    }
    if (materialChunkId.present) {
      map['material_chunk_id'] = Variable<String>(materialChunkId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (itemType.present) {
      map['item_type'] = Variable<String>(itemType.value);
    }
    if (orderNo.present) {
      map['order_no'] = Variable<int>(orderNo.value);
    }
    if (plannedDateUtc.present) {
      map['planned_date_utc'] = Variable<DateTime>(plannedDateUtc.value);
    }
    if (plannedStartTime.present) {
      map['planned_start_time'] = Variable<String>(plannedStartTime.value);
    }
    if (plannedEndTime.present) {
      map['planned_end_time'] = Variable<String>(plannedEndTime.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalStudyPlanItemsCompanion(')
          ..write('id: $id, ')
          ..write('studyPlanId: $studyPlanId, ')
          ..write('materialChunkId: $materialChunkId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('itemType: $itemType, ')
          ..write('orderNo: $orderNo, ')
          ..write('plannedDateUtc: $plannedDateUtc, ')
          ..write('plannedStartTime: $plannedStartTime, ')
          ..write('plannedEndTime: $plannedEndTime, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('status: $status, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalStudySessionsTable extends LocalStudySessions
    with TableInfo<$LocalStudySessionsTable, LocalStudySession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalStudySessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studyPlanIdMeta = const VerificationMeta(
    'studyPlanId',
  );
  @override
  late final GeneratedColumn<String> studyPlanId = GeneratedColumn<String>(
    'study_plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studyPlanItemIdMeta = const VerificationMeta(
    'studyPlanItemId',
  );
  @override
  late final GeneratedColumn<String> studyPlanItemId = GeneratedColumn<String>(
    'study_plan_item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _learningMaterialIdMeta =
      const VerificationMeta('learningMaterialId');
  @override
  late final GeneratedColumn<String> learningMaterialId =
      GeneratedColumn<String>(
        'learning_material_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _studyProgressIdMeta = const VerificationMeta(
    'studyProgressId',
  );
  @override
  late final GeneratedColumn<String> studyProgressId = GeneratedColumn<String>(
    'study_progress_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scheduledAtUtcMeta = const VerificationMeta(
    'scheduledAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAtUtc =
      GeneratedColumn<DateTime>(
        'scheduled_at_utc',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _startedAtUtcMeta = const VerificationMeta(
    'startedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> startedAtUtc = GeneratedColumn<DateTime>(
    'started_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtUtcMeta = const VerificationMeta(
    'completedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> completedAtUtc =
      GeneratedColumn<DateTime>(
        'completed_at_utc',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sequenceNumberMeta = const VerificationMeta(
    'sequenceNumber',
  );
  @override
  late final GeneratedColumn<int> sequenceNumber = GeneratedColumn<int>(
    'sequence_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _qualityScoreMeta = const VerificationMeta(
    'qualityScore',
  );
  @override
  late final GeneratedColumn<int> qualityScore = GeneratedColumn<int>(
    'quality_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _difficultyScoreMeta = const VerificationMeta(
    'difficultyScore',
  );
  @override
  late final GeneratedColumn<int> difficultyScore = GeneratedColumn<int>(
    'difficulty_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualDurationMinutesMeta =
      const VerificationMeta('actualDurationMinutes');
  @override
  late final GeneratedColumn<int> actualDurationMinutes = GeneratedColumn<int>(
    'actual_duration_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reviewNotesMeta = const VerificationMeta(
    'reviewNotes',
  );
  @override
  late final GeneratedColumn<String> reviewNotes = GeneratedColumn<String>(
    'review_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studyPlanId,
    studyPlanItemId,
    learningMaterialId,
    userId,
    studyProgressId,
    scheduledAtUtc,
    startedAtUtc,
    completedAtUtc,
    isCompleted,
    sequenceNumber,
    qualityScore,
    difficultyScore,
    actualDurationMinutes,
    reviewNotes,
    status,
    syncStatus,
    isDeleted,
    updatedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_study_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalStudySession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('study_plan_id')) {
      context.handle(
        _studyPlanIdMeta,
        studyPlanId.isAcceptableOrUnknown(
          data['study_plan_id']!,
          _studyPlanIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_studyPlanIdMeta);
    }
    if (data.containsKey('study_plan_item_id')) {
      context.handle(
        _studyPlanItemIdMeta,
        studyPlanItemId.isAcceptableOrUnknown(
          data['study_plan_item_id']!,
          _studyPlanItemIdMeta,
        ),
      );
    }
    if (data.containsKey('learning_material_id')) {
      context.handle(
        _learningMaterialIdMeta,
        learningMaterialId.isAcceptableOrUnknown(
          data['learning_material_id']!,
          _learningMaterialIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_learningMaterialIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('study_progress_id')) {
      context.handle(
        _studyProgressIdMeta,
        studyProgressId.isAcceptableOrUnknown(
          data['study_progress_id']!,
          _studyProgressIdMeta,
        ),
      );
    }
    if (data.containsKey('scheduled_at_utc')) {
      context.handle(
        _scheduledAtUtcMeta,
        scheduledAtUtc.isAcceptableOrUnknown(
          data['scheduled_at_utc']!,
          _scheduledAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtUtcMeta);
    }
    if (data.containsKey('started_at_utc')) {
      context.handle(
        _startedAtUtcMeta,
        startedAtUtc.isAcceptableOrUnknown(
          data['started_at_utc']!,
          _startedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('completed_at_utc')) {
      context.handle(
        _completedAtUtcMeta,
        completedAtUtc.isAcceptableOrUnknown(
          data['completed_at_utc']!,
          _completedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('sequence_number')) {
      context.handle(
        _sequenceNumberMeta,
        sequenceNumber.isAcceptableOrUnknown(
          data['sequence_number']!,
          _sequenceNumberMeta,
        ),
      );
    }
    if (data.containsKey('quality_score')) {
      context.handle(
        _qualityScoreMeta,
        qualityScore.isAcceptableOrUnknown(
          data['quality_score']!,
          _qualityScoreMeta,
        ),
      );
    }
    if (data.containsKey('difficulty_score')) {
      context.handle(
        _difficultyScoreMeta,
        difficultyScore.isAcceptableOrUnknown(
          data['difficulty_score']!,
          _difficultyScoreMeta,
        ),
      );
    }
    if (data.containsKey('actual_duration_minutes')) {
      context.handle(
        _actualDurationMinutesMeta,
        actualDurationMinutes.isAcceptableOrUnknown(
          data['actual_duration_minutes']!,
          _actualDurationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('review_notes')) {
      context.handle(
        _reviewNotesMeta,
        reviewNotes.isAcceptableOrUnknown(
          data['review_notes']!,
          _reviewNotesMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalStudySession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalStudySession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      studyPlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}study_plan_id'],
      )!,
      studyPlanItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}study_plan_item_id'],
      ),
      learningMaterialId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}learning_material_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      studyProgressId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}study_progress_id'],
      ),
      scheduledAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at_utc'],
      )!,
      startedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at_utc'],
      ),
      completedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at_utc'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      sequenceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence_number'],
      )!,
      qualityScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quality_score'],
      ),
      difficultyScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difficulty_score'],
      ),
      actualDurationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_duration_minutes'],
      ),
      reviewNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review_notes'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      ),
    );
  }

  @override
  $LocalStudySessionsTable createAlias(String alias) {
    return $LocalStudySessionsTable(attachedDatabase, alias);
  }
}

class LocalStudySession extends DataClass
    implements Insertable<LocalStudySession> {
  final String id;
  final String studyPlanId;
  final String? studyPlanItemId;
  final String learningMaterialId;
  final String? userId;
  final String? studyProgressId;
  final DateTime scheduledAtUtc;
  final DateTime? startedAtUtc;
  final DateTime? completedAtUtc;
  final bool isCompleted;
  final int sequenceNumber;
  final int? qualityScore;
  final int? difficultyScore;
  final int? actualDurationMinutes;
  final String? reviewNotes;
  final String status;
  final String syncStatus;
  final bool isDeleted;
  final DateTime? updatedAtUtc;
  const LocalStudySession({
    required this.id,
    required this.studyPlanId,
    this.studyPlanItemId,
    required this.learningMaterialId,
    this.userId,
    this.studyProgressId,
    required this.scheduledAtUtc,
    this.startedAtUtc,
    this.completedAtUtc,
    required this.isCompleted,
    required this.sequenceNumber,
    this.qualityScore,
    this.difficultyScore,
    this.actualDurationMinutes,
    this.reviewNotes,
    required this.status,
    required this.syncStatus,
    required this.isDeleted,
    this.updatedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['study_plan_id'] = Variable<String>(studyPlanId);
    if (!nullToAbsent || studyPlanItemId != null) {
      map['study_plan_item_id'] = Variable<String>(studyPlanItemId);
    }
    map['learning_material_id'] = Variable<String>(learningMaterialId);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || studyProgressId != null) {
      map['study_progress_id'] = Variable<String>(studyProgressId);
    }
    map['scheduled_at_utc'] = Variable<DateTime>(scheduledAtUtc);
    if (!nullToAbsent || startedAtUtc != null) {
      map['started_at_utc'] = Variable<DateTime>(startedAtUtc);
    }
    if (!nullToAbsent || completedAtUtc != null) {
      map['completed_at_utc'] = Variable<DateTime>(completedAtUtc);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    map['sequence_number'] = Variable<int>(sequenceNumber);
    if (!nullToAbsent || qualityScore != null) {
      map['quality_score'] = Variable<int>(qualityScore);
    }
    if (!nullToAbsent || difficultyScore != null) {
      map['difficulty_score'] = Variable<int>(difficultyScore);
    }
    if (!nullToAbsent || actualDurationMinutes != null) {
      map['actual_duration_minutes'] = Variable<int>(actualDurationMinutes);
    }
    if (!nullToAbsent || reviewNotes != null) {
      map['review_notes'] = Variable<String>(reviewNotes);
    }
    map['status'] = Variable<String>(status);
    map['sync_status'] = Variable<String>(syncStatus);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || updatedAtUtc != null) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    }
    return map;
  }

  LocalStudySessionsCompanion toCompanion(bool nullToAbsent) {
    return LocalStudySessionsCompanion(
      id: Value(id),
      studyPlanId: Value(studyPlanId),
      studyPlanItemId: studyPlanItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(studyPlanItemId),
      learningMaterialId: Value(learningMaterialId),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      studyProgressId: studyProgressId == null && nullToAbsent
          ? const Value.absent()
          : Value(studyProgressId),
      scheduledAtUtc: Value(scheduledAtUtc),
      startedAtUtc: startedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAtUtc),
      completedAtUtc: completedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAtUtc),
      isCompleted: Value(isCompleted),
      sequenceNumber: Value(sequenceNumber),
      qualityScore: qualityScore == null && nullToAbsent
          ? const Value.absent()
          : Value(qualityScore),
      difficultyScore: difficultyScore == null && nullToAbsent
          ? const Value.absent()
          : Value(difficultyScore),
      actualDurationMinutes: actualDurationMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(actualDurationMinutes),
      reviewNotes: reviewNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewNotes),
      status: Value(status),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
      updatedAtUtc: updatedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAtUtc),
    );
  }

  factory LocalStudySession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalStudySession(
      id: serializer.fromJson<String>(json['id']),
      studyPlanId: serializer.fromJson<String>(json['studyPlanId']),
      studyPlanItemId: serializer.fromJson<String?>(json['studyPlanItemId']),
      learningMaterialId: serializer.fromJson<String>(
        json['learningMaterialId'],
      ),
      userId: serializer.fromJson<String?>(json['userId']),
      studyProgressId: serializer.fromJson<String?>(json['studyProgressId']),
      scheduledAtUtc: serializer.fromJson<DateTime>(json['scheduledAtUtc']),
      startedAtUtc: serializer.fromJson<DateTime?>(json['startedAtUtc']),
      completedAtUtc: serializer.fromJson<DateTime?>(json['completedAtUtc']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      sequenceNumber: serializer.fromJson<int>(json['sequenceNumber']),
      qualityScore: serializer.fromJson<int?>(json['qualityScore']),
      difficultyScore: serializer.fromJson<int?>(json['difficultyScore']),
      actualDurationMinutes: serializer.fromJson<int?>(
        json['actualDurationMinutes'],
      ),
      reviewNotes: serializer.fromJson<String?>(json['reviewNotes']),
      status: serializer.fromJson<String>(json['status']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      updatedAtUtc: serializer.fromJson<DateTime?>(json['updatedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studyPlanId': serializer.toJson<String>(studyPlanId),
      'studyPlanItemId': serializer.toJson<String?>(studyPlanItemId),
      'learningMaterialId': serializer.toJson<String>(learningMaterialId),
      'userId': serializer.toJson<String?>(userId),
      'studyProgressId': serializer.toJson<String?>(studyProgressId),
      'scheduledAtUtc': serializer.toJson<DateTime>(scheduledAtUtc),
      'startedAtUtc': serializer.toJson<DateTime?>(startedAtUtc),
      'completedAtUtc': serializer.toJson<DateTime?>(completedAtUtc),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'sequenceNumber': serializer.toJson<int>(sequenceNumber),
      'qualityScore': serializer.toJson<int?>(qualityScore),
      'difficultyScore': serializer.toJson<int?>(difficultyScore),
      'actualDurationMinutes': serializer.toJson<int?>(actualDurationMinutes),
      'reviewNotes': serializer.toJson<String?>(reviewNotes),
      'status': serializer.toJson<String>(status),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'updatedAtUtc': serializer.toJson<DateTime?>(updatedAtUtc),
    };
  }

  LocalStudySession copyWith({
    String? id,
    String? studyPlanId,
    Value<String?> studyPlanItemId = const Value.absent(),
    String? learningMaterialId,
    Value<String?> userId = const Value.absent(),
    Value<String?> studyProgressId = const Value.absent(),
    DateTime? scheduledAtUtc,
    Value<DateTime?> startedAtUtc = const Value.absent(),
    Value<DateTime?> completedAtUtc = const Value.absent(),
    bool? isCompleted,
    int? sequenceNumber,
    Value<int?> qualityScore = const Value.absent(),
    Value<int?> difficultyScore = const Value.absent(),
    Value<int?> actualDurationMinutes = const Value.absent(),
    Value<String?> reviewNotes = const Value.absent(),
    String? status,
    String? syncStatus,
    bool? isDeleted,
    Value<DateTime?> updatedAtUtc = const Value.absent(),
  }) => LocalStudySession(
    id: id ?? this.id,
    studyPlanId: studyPlanId ?? this.studyPlanId,
    studyPlanItemId: studyPlanItemId.present
        ? studyPlanItemId.value
        : this.studyPlanItemId,
    learningMaterialId: learningMaterialId ?? this.learningMaterialId,
    userId: userId.present ? userId.value : this.userId,
    studyProgressId: studyProgressId.present
        ? studyProgressId.value
        : this.studyProgressId,
    scheduledAtUtc: scheduledAtUtc ?? this.scheduledAtUtc,
    startedAtUtc: startedAtUtc.present ? startedAtUtc.value : this.startedAtUtc,
    completedAtUtc: completedAtUtc.present
        ? completedAtUtc.value
        : this.completedAtUtc,
    isCompleted: isCompleted ?? this.isCompleted,
    sequenceNumber: sequenceNumber ?? this.sequenceNumber,
    qualityScore: qualityScore.present ? qualityScore.value : this.qualityScore,
    difficultyScore: difficultyScore.present
        ? difficultyScore.value
        : this.difficultyScore,
    actualDurationMinutes: actualDurationMinutes.present
        ? actualDurationMinutes.value
        : this.actualDurationMinutes,
    reviewNotes: reviewNotes.present ? reviewNotes.value : this.reviewNotes,
    status: status ?? this.status,
    syncStatus: syncStatus ?? this.syncStatus,
    isDeleted: isDeleted ?? this.isDeleted,
    updatedAtUtc: updatedAtUtc.present ? updatedAtUtc.value : this.updatedAtUtc,
  );
  LocalStudySession copyWithCompanion(LocalStudySessionsCompanion data) {
    return LocalStudySession(
      id: data.id.present ? data.id.value : this.id,
      studyPlanId: data.studyPlanId.present
          ? data.studyPlanId.value
          : this.studyPlanId,
      studyPlanItemId: data.studyPlanItemId.present
          ? data.studyPlanItemId.value
          : this.studyPlanItemId,
      learningMaterialId: data.learningMaterialId.present
          ? data.learningMaterialId.value
          : this.learningMaterialId,
      userId: data.userId.present ? data.userId.value : this.userId,
      studyProgressId: data.studyProgressId.present
          ? data.studyProgressId.value
          : this.studyProgressId,
      scheduledAtUtc: data.scheduledAtUtc.present
          ? data.scheduledAtUtc.value
          : this.scheduledAtUtc,
      startedAtUtc: data.startedAtUtc.present
          ? data.startedAtUtc.value
          : this.startedAtUtc,
      completedAtUtc: data.completedAtUtc.present
          ? data.completedAtUtc.value
          : this.completedAtUtc,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      sequenceNumber: data.sequenceNumber.present
          ? data.sequenceNumber.value
          : this.sequenceNumber,
      qualityScore: data.qualityScore.present
          ? data.qualityScore.value
          : this.qualityScore,
      difficultyScore: data.difficultyScore.present
          ? data.difficultyScore.value
          : this.difficultyScore,
      actualDurationMinutes: data.actualDurationMinutes.present
          ? data.actualDurationMinutes.value
          : this.actualDurationMinutes,
      reviewNotes: data.reviewNotes.present
          ? data.reviewNotes.value
          : this.reviewNotes,
      status: data.status.present ? data.status.value : this.status,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalStudySession(')
          ..write('id: $id, ')
          ..write('studyPlanId: $studyPlanId, ')
          ..write('studyPlanItemId: $studyPlanItemId, ')
          ..write('learningMaterialId: $learningMaterialId, ')
          ..write('userId: $userId, ')
          ..write('studyProgressId: $studyProgressId, ')
          ..write('scheduledAtUtc: $scheduledAtUtc, ')
          ..write('startedAtUtc: $startedAtUtc, ')
          ..write('completedAtUtc: $completedAtUtc, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('sequenceNumber: $sequenceNumber, ')
          ..write('qualityScore: $qualityScore, ')
          ..write('difficultyScore: $difficultyScore, ')
          ..write('actualDurationMinutes: $actualDurationMinutes, ')
          ..write('reviewNotes: $reviewNotes, ')
          ..write('status: $status, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('updatedAtUtc: $updatedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    studyPlanId,
    studyPlanItemId,
    learningMaterialId,
    userId,
    studyProgressId,
    scheduledAtUtc,
    startedAtUtc,
    completedAtUtc,
    isCompleted,
    sequenceNumber,
    qualityScore,
    difficultyScore,
    actualDurationMinutes,
    reviewNotes,
    status,
    syncStatus,
    isDeleted,
    updatedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalStudySession &&
          other.id == this.id &&
          other.studyPlanId == this.studyPlanId &&
          other.studyPlanItemId == this.studyPlanItemId &&
          other.learningMaterialId == this.learningMaterialId &&
          other.userId == this.userId &&
          other.studyProgressId == this.studyProgressId &&
          other.scheduledAtUtc == this.scheduledAtUtc &&
          other.startedAtUtc == this.startedAtUtc &&
          other.completedAtUtc == this.completedAtUtc &&
          other.isCompleted == this.isCompleted &&
          other.sequenceNumber == this.sequenceNumber &&
          other.qualityScore == this.qualityScore &&
          other.difficultyScore == this.difficultyScore &&
          other.actualDurationMinutes == this.actualDurationMinutes &&
          other.reviewNotes == this.reviewNotes &&
          other.status == this.status &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted &&
          other.updatedAtUtc == this.updatedAtUtc);
}

class LocalStudySessionsCompanion extends UpdateCompanion<LocalStudySession> {
  final Value<String> id;
  final Value<String> studyPlanId;
  final Value<String?> studyPlanItemId;
  final Value<String> learningMaterialId;
  final Value<String?> userId;
  final Value<String?> studyProgressId;
  final Value<DateTime> scheduledAtUtc;
  final Value<DateTime?> startedAtUtc;
  final Value<DateTime?> completedAtUtc;
  final Value<bool> isCompleted;
  final Value<int> sequenceNumber;
  final Value<int?> qualityScore;
  final Value<int?> difficultyScore;
  final Value<int?> actualDurationMinutes;
  final Value<String?> reviewNotes;
  final Value<String> status;
  final Value<String> syncStatus;
  final Value<bool> isDeleted;
  final Value<DateTime?> updatedAtUtc;
  final Value<int> rowid;
  const LocalStudySessionsCompanion({
    this.id = const Value.absent(),
    this.studyPlanId = const Value.absent(),
    this.studyPlanItemId = const Value.absent(),
    this.learningMaterialId = const Value.absent(),
    this.userId = const Value.absent(),
    this.studyProgressId = const Value.absent(),
    this.scheduledAtUtc = const Value.absent(),
    this.startedAtUtc = const Value.absent(),
    this.completedAtUtc = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.sequenceNumber = const Value.absent(),
    this.qualityScore = const Value.absent(),
    this.difficultyScore = const Value.absent(),
    this.actualDurationMinutes = const Value.absent(),
    this.reviewNotes = const Value.absent(),
    this.status = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalStudySessionsCompanion.insert({
    required String id,
    required String studyPlanId,
    this.studyPlanItemId = const Value.absent(),
    required String learningMaterialId,
    this.userId = const Value.absent(),
    this.studyProgressId = const Value.absent(),
    required DateTime scheduledAtUtc,
    this.startedAtUtc = const Value.absent(),
    this.completedAtUtc = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.sequenceNumber = const Value.absent(),
    this.qualityScore = const Value.absent(),
    this.difficultyScore = const Value.absent(),
    this.actualDurationMinutes = const Value.absent(),
    this.reviewNotes = const Value.absent(),
    this.status = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       studyPlanId = Value(studyPlanId),
       learningMaterialId = Value(learningMaterialId),
       scheduledAtUtc = Value(scheduledAtUtc);
  static Insertable<LocalStudySession> custom({
    Expression<String>? id,
    Expression<String>? studyPlanId,
    Expression<String>? studyPlanItemId,
    Expression<String>? learningMaterialId,
    Expression<String>? userId,
    Expression<String>? studyProgressId,
    Expression<DateTime>? scheduledAtUtc,
    Expression<DateTime>? startedAtUtc,
    Expression<DateTime>? completedAtUtc,
    Expression<bool>? isCompleted,
    Expression<int>? sequenceNumber,
    Expression<int>? qualityScore,
    Expression<int>? difficultyScore,
    Expression<int>? actualDurationMinutes,
    Expression<String>? reviewNotes,
    Expression<String>? status,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
    Expression<DateTime>? updatedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studyPlanId != null) 'study_plan_id': studyPlanId,
      if (studyPlanItemId != null) 'study_plan_item_id': studyPlanItemId,
      if (learningMaterialId != null)
        'learning_material_id': learningMaterialId,
      if (userId != null) 'user_id': userId,
      if (studyProgressId != null) 'study_progress_id': studyProgressId,
      if (scheduledAtUtc != null) 'scheduled_at_utc': scheduledAtUtc,
      if (startedAtUtc != null) 'started_at_utc': startedAtUtc,
      if (completedAtUtc != null) 'completed_at_utc': completedAtUtc,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (sequenceNumber != null) 'sequence_number': sequenceNumber,
      if (qualityScore != null) 'quality_score': qualityScore,
      if (difficultyScore != null) 'difficulty_score': difficultyScore,
      if (actualDurationMinutes != null)
        'actual_duration_minutes': actualDurationMinutes,
      if (reviewNotes != null) 'review_notes': reviewNotes,
      if (status != null) 'status': status,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalStudySessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? studyPlanId,
    Value<String?>? studyPlanItemId,
    Value<String>? learningMaterialId,
    Value<String?>? userId,
    Value<String?>? studyProgressId,
    Value<DateTime>? scheduledAtUtc,
    Value<DateTime?>? startedAtUtc,
    Value<DateTime?>? completedAtUtc,
    Value<bool>? isCompleted,
    Value<int>? sequenceNumber,
    Value<int?>? qualityScore,
    Value<int?>? difficultyScore,
    Value<int?>? actualDurationMinutes,
    Value<String?>? reviewNotes,
    Value<String>? status,
    Value<String>? syncStatus,
    Value<bool>? isDeleted,
    Value<DateTime?>? updatedAtUtc,
    Value<int>? rowid,
  }) {
    return LocalStudySessionsCompanion(
      id: id ?? this.id,
      studyPlanId: studyPlanId ?? this.studyPlanId,
      studyPlanItemId: studyPlanItemId ?? this.studyPlanItemId,
      learningMaterialId: learningMaterialId ?? this.learningMaterialId,
      userId: userId ?? this.userId,
      studyProgressId: studyProgressId ?? this.studyProgressId,
      scheduledAtUtc: scheduledAtUtc ?? this.scheduledAtUtc,
      startedAtUtc: startedAtUtc ?? this.startedAtUtc,
      completedAtUtc: completedAtUtc ?? this.completedAtUtc,
      isCompleted: isCompleted ?? this.isCompleted,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      qualityScore: qualityScore ?? this.qualityScore,
      difficultyScore: difficultyScore ?? this.difficultyScore,
      actualDurationMinutes:
          actualDurationMinutes ?? this.actualDurationMinutes,
      reviewNotes: reviewNotes ?? this.reviewNotes,
      status: status ?? this.status,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studyPlanId.present) {
      map['study_plan_id'] = Variable<String>(studyPlanId.value);
    }
    if (studyPlanItemId.present) {
      map['study_plan_item_id'] = Variable<String>(studyPlanItemId.value);
    }
    if (learningMaterialId.present) {
      map['learning_material_id'] = Variable<String>(learningMaterialId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (studyProgressId.present) {
      map['study_progress_id'] = Variable<String>(studyProgressId.value);
    }
    if (scheduledAtUtc.present) {
      map['scheduled_at_utc'] = Variable<DateTime>(scheduledAtUtc.value);
    }
    if (startedAtUtc.present) {
      map['started_at_utc'] = Variable<DateTime>(startedAtUtc.value);
    }
    if (completedAtUtc.present) {
      map['completed_at_utc'] = Variable<DateTime>(completedAtUtc.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (sequenceNumber.present) {
      map['sequence_number'] = Variable<int>(sequenceNumber.value);
    }
    if (qualityScore.present) {
      map['quality_score'] = Variable<int>(qualityScore.value);
    }
    if (difficultyScore.present) {
      map['difficulty_score'] = Variable<int>(difficultyScore.value);
    }
    if (actualDurationMinutes.present) {
      map['actual_duration_minutes'] = Variable<int>(
        actualDurationMinutes.value,
      );
    }
    if (reviewNotes.present) {
      map['review_notes'] = Variable<String>(reviewNotes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalStudySessionsCompanion(')
          ..write('id: $id, ')
          ..write('studyPlanId: $studyPlanId, ')
          ..write('studyPlanItemId: $studyPlanItemId, ')
          ..write('learningMaterialId: $learningMaterialId, ')
          ..write('userId: $userId, ')
          ..write('studyProgressId: $studyProgressId, ')
          ..write('scheduledAtUtc: $scheduledAtUtc, ')
          ..write('startedAtUtc: $startedAtUtc, ')
          ..write('completedAtUtc: $completedAtUtc, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('sequenceNumber: $sequenceNumber, ')
          ..write('qualityScore: $qualityScore, ')
          ..write('difficultyScore: $difficultyScore, ')
          ..write('actualDurationMinutes: $actualDurationMinutes, ')
          ..write('reviewNotes: $reviewNotes, ')
          ..write('status: $status, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOutboxTable extends SyncOutbox
    with TableInfo<$SyncOutboxTable, SyncOutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationTypeMeta = const VerificationMeta(
    'operationType',
  );
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
    'operation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> createdAtUtc = GeneratedColumn<DateTime>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextAttemptAtUtcMeta = const VerificationMeta(
    'nextAttemptAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> nextAttemptAtUtc =
      GeneratedColumn<DateTime>(
        'next_attempt_at_utc',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    operationType,
    entityType,
    entityId,
    payload,
    status,
    retryCount,
    lastError,
    createdAtUtc,
    updatedAtUtc,
    nextAttemptAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncOutboxData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('operation_type')) {
      context.handle(
        _operationTypeMeta,
        operationType.isAcceptableOrUnknown(
          data['operation_type']!,
          _operationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationTypeMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('next_attempt_at_utc')) {
      context.handle(
        _nextAttemptAtUtcMeta,
        nextAttemptAtUtc.isAcceptableOrUnknown(
          data['next_attempt_at_utc']!,
          _nextAttemptAtUtcMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncOutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOutboxData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      operationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_type'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at_utc'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      ),
      nextAttemptAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at_utc'],
      ),
    );
  }

  @override
  $SyncOutboxTable createAlias(String alias) {
    return $SyncOutboxTable(attachedDatabase, alias);
  }
}

class SyncOutboxData extends DataClass implements Insertable<SyncOutboxData> {
  final String id;
  final String operationType;
  final String entityType;
  final String entityId;
  final String payload;
  final String status;
  final int retryCount;
  final String? lastError;
  final DateTime createdAtUtc;
  final DateTime? updatedAtUtc;
  final DateTime? nextAttemptAtUtc;
  const SyncOutboxData({
    required this.id,
    required this.operationType,
    required this.entityType,
    required this.entityId,
    required this.payload,
    required this.status,
    required this.retryCount,
    this.lastError,
    required this.createdAtUtc,
    this.updatedAtUtc,
    this.nextAttemptAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['operation_type'] = Variable<String>(operationType);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['payload'] = Variable<String>(payload);
    map['status'] = Variable<String>(status);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at_utc'] = Variable<DateTime>(createdAtUtc);
    if (!nullToAbsent || updatedAtUtc != null) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    }
    if (!nullToAbsent || nextAttemptAtUtc != null) {
      map['next_attempt_at_utc'] = Variable<DateTime>(nextAttemptAtUtc);
    }
    return map;
  }

  SyncOutboxCompanion toCompanion(bool nullToAbsent) {
    return SyncOutboxCompanion(
      id: Value(id),
      operationType: Value(operationType),
      entityType: Value(entityType),
      entityId: Value(entityId),
      payload: Value(payload),
      status: Value(status),
      retryCount: Value(retryCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAtUtc: Value(createdAtUtc),
      updatedAtUtc: updatedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAtUtc),
      nextAttemptAtUtc: nextAttemptAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAtUtc),
    );
  }

  factory SyncOutboxData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOutboxData(
      id: serializer.fromJson<String>(json['id']),
      operationType: serializer.fromJson<String>(json['operationType']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      payload: serializer.fromJson<String>(json['payload']),
      status: serializer.fromJson<String>(json['status']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAtUtc: serializer.fromJson<DateTime>(json['createdAtUtc']),
      updatedAtUtc: serializer.fromJson<DateTime?>(json['updatedAtUtc']),
      nextAttemptAtUtc: serializer.fromJson<DateTime?>(
        json['nextAttemptAtUtc'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'operationType': serializer.toJson<String>(operationType),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'payload': serializer.toJson<String>(payload),
      'status': serializer.toJson<String>(status),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAtUtc': serializer.toJson<DateTime>(createdAtUtc),
      'updatedAtUtc': serializer.toJson<DateTime?>(updatedAtUtc),
      'nextAttemptAtUtc': serializer.toJson<DateTime?>(nextAttemptAtUtc),
    };
  }

  SyncOutboxData copyWith({
    String? id,
    String? operationType,
    String? entityType,
    String? entityId,
    String? payload,
    String? status,
    int? retryCount,
    Value<String?> lastError = const Value.absent(),
    DateTime? createdAtUtc,
    Value<DateTime?> updatedAtUtc = const Value.absent(),
    Value<DateTime?> nextAttemptAtUtc = const Value.absent(),
  }) => SyncOutboxData(
    id: id ?? this.id,
    operationType: operationType ?? this.operationType,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    payload: payload ?? this.payload,
    status: status ?? this.status,
    retryCount: retryCount ?? this.retryCount,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    updatedAtUtc: updatedAtUtc.present ? updatedAtUtc.value : this.updatedAtUtc,
    nextAttemptAtUtc: nextAttemptAtUtc.present
        ? nextAttemptAtUtc.value
        : this.nextAttemptAtUtc,
  );
  SyncOutboxData copyWithCompanion(SyncOutboxCompanion data) {
    return SyncOutboxData(
      id: data.id.present ? data.id.value : this.id,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      payload: data.payload.present ? data.payload.value : this.payload,
      status: data.status.present ? data.status.value : this.status,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
      nextAttemptAtUtc: data.nextAttemptAtUtc.present
          ? data.nextAttemptAtUtc.value
          : this.nextAttemptAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxData(')
          ..write('id: $id, ')
          ..write('operationType: $operationType, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('nextAttemptAtUtc: $nextAttemptAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    operationType,
    entityType,
    entityId,
    payload,
    status,
    retryCount,
    lastError,
    createdAtUtc,
    updatedAtUtc,
    nextAttemptAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOutboxData &&
          other.id == this.id &&
          other.operationType == this.operationType &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.payload == this.payload &&
          other.status == this.status &&
          other.retryCount == this.retryCount &&
          other.lastError == this.lastError &&
          other.createdAtUtc == this.createdAtUtc &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.nextAttemptAtUtc == this.nextAttemptAtUtc);
}

class SyncOutboxCompanion extends UpdateCompanion<SyncOutboxData> {
  final Value<String> id;
  final Value<String> operationType;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> payload;
  final Value<String> status;
  final Value<int> retryCount;
  final Value<String?> lastError;
  final Value<DateTime> createdAtUtc;
  final Value<DateTime?> updatedAtUtc;
  final Value<DateTime?> nextAttemptAtUtc;
  final Value<int> rowid;
  const SyncOutboxCompanion({
    this.id = const Value.absent(),
    this.operationType = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.payload = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.nextAttemptAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOutboxCompanion.insert({
    required String id,
    required String operationType,
    required String entityType,
    required String entityId,
    required String payload,
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    required DateTime createdAtUtc,
    this.updatedAtUtc = const Value.absent(),
    this.nextAttemptAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       operationType = Value(operationType),
       entityType = Value(entityType),
       entityId = Value(entityId),
       payload = Value(payload),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<SyncOutboxData> custom({
    Expression<String>? id,
    Expression<String>? operationType,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? payload,
    Expression<String>? status,
    Expression<int>? retryCount,
    Expression<String>? lastError,
    Expression<DateTime>? createdAtUtc,
    Expression<DateTime>? updatedAtUtc,
    Expression<DateTime>? nextAttemptAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operationType != null) 'operation_type': operationType,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (payload != null) 'payload': payload,
      if (status != null) 'status': status,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastError != null) 'last_error': lastError,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (nextAttemptAtUtc != null) 'next_attempt_at_utc': nextAttemptAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOutboxCompanion copyWith({
    Value<String>? id,
    Value<String>? operationType,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? payload,
    Value<String>? status,
    Value<int>? retryCount,
    Value<String?>? lastError,
    Value<DateTime>? createdAtUtc,
    Value<DateTime?>? updatedAtUtc,
    Value<DateTime?>? nextAttemptAtUtc,
    Value<int>? rowid,
  }) {
    return SyncOutboxCompanion(
      id: id ?? this.id,
      operationType: operationType ?? this.operationType,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      nextAttemptAtUtc: nextAttemptAtUtc ?? this.nextAttemptAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<DateTime>(createdAtUtc.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (nextAttemptAtUtc.present) {
      map['next_attempt_at_utc'] = Variable<DateTime>(nextAttemptAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxCompanion(')
          ..write('id: $id, ')
          ..write('operationType: $operationType, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('nextAttemptAtUtc: $nextAttemptAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalMaterialsTable localMaterials = $LocalMaterialsTable(this);
  late final $LocalMaterialChunksTable localMaterialChunks =
      $LocalMaterialChunksTable(this);
  late final $LocalStudyPlansTable localStudyPlans = $LocalStudyPlansTable(
    this,
  );
  late final $LocalStudyPlanItemsTable localStudyPlanItems =
      $LocalStudyPlanItemsTable(this);
  late final $LocalStudySessionsTable localStudySessions =
      $LocalStudySessionsTable(this);
  late final $SyncOutboxTable syncOutbox = $SyncOutboxTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localMaterials,
    localMaterialChunks,
    localStudyPlans,
    localStudyPlanItems,
    localStudySessions,
    syncOutbox,
  ];
}

typedef $$LocalMaterialsTableCreateCompanionBuilder =
    LocalMaterialsCompanion Function({
      required String id,
      required String userId,
      required String title,
      required String materialType,
      required String content,
      required int estimatedDurationMinutes,
      Value<String?> description,
      Value<String?> tags,
      Value<bool> hasActivePlan,
      Value<String?> activePlanId,
      Value<String?> activePlanTitle,
      Value<String> syncStatus,
      Value<bool> isDeleted,
      Value<DateTime?> updatedAtUtc,
      Value<int> rowid,
    });
typedef $$LocalMaterialsTableUpdateCompanionBuilder =
    LocalMaterialsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> title,
      Value<String> materialType,
      Value<String> content,
      Value<int> estimatedDurationMinutes,
      Value<String?> description,
      Value<String?> tags,
      Value<bool> hasActivePlan,
      Value<String?> activePlanId,
      Value<String?> activePlanTitle,
      Value<String> syncStatus,
      Value<bool> isDeleted,
      Value<DateTime?> updatedAtUtc,
      Value<int> rowid,
    });

class $$LocalMaterialsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalMaterialsTable> {
  $$LocalMaterialsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get materialType => $composableBuilder(
    column: $table.materialType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedDurationMinutes => $composableBuilder(
    column: $table.estimatedDurationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasActivePlan => $composableBuilder(
    column: $table.hasActivePlan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activePlanId => $composableBuilder(
    column: $table.activePlanId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activePlanTitle => $composableBuilder(
    column: $table.activePlanTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalMaterialsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalMaterialsTable> {
  $$LocalMaterialsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get materialType => $composableBuilder(
    column: $table.materialType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedDurationMinutes => $composableBuilder(
    column: $table.estimatedDurationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasActivePlan => $composableBuilder(
    column: $table.hasActivePlan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activePlanId => $composableBuilder(
    column: $table.activePlanId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activePlanTitle => $composableBuilder(
    column: $table.activePlanTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalMaterialsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalMaterialsTable> {
  $$LocalMaterialsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get materialType => $composableBuilder(
    column: $table.materialType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get estimatedDurationMinutes => $composableBuilder(
    column: $table.estimatedDurationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<bool> get hasActivePlan => $composableBuilder(
    column: $table.hasActivePlan,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activePlanId => $composableBuilder(
    column: $table.activePlanId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activePlanTitle => $composableBuilder(
    column: $table.activePlanTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );
}

class $$LocalMaterialsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalMaterialsTable,
          LocalMaterial,
          $$LocalMaterialsTableFilterComposer,
          $$LocalMaterialsTableOrderingComposer,
          $$LocalMaterialsTableAnnotationComposer,
          $$LocalMaterialsTableCreateCompanionBuilder,
          $$LocalMaterialsTableUpdateCompanionBuilder,
          (
            LocalMaterial,
            BaseReferences<_$AppDatabase, $LocalMaterialsTable, LocalMaterial>,
          ),
          LocalMaterial,
          PrefetchHooks Function()
        > {
  $$LocalMaterialsTableTableManager(
    _$AppDatabase db,
    $LocalMaterialsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalMaterialsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalMaterialsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalMaterialsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> materialType = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<int> estimatedDurationMinutes = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<bool> hasActivePlan = const Value.absent(),
                Value<String?> activePlanId = const Value.absent(),
                Value<String?> activePlanTitle = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> updatedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalMaterialsCompanion(
                id: id,
                userId: userId,
                title: title,
                materialType: materialType,
                content: content,
                estimatedDurationMinutes: estimatedDurationMinutes,
                description: description,
                tags: tags,
                hasActivePlan: hasActivePlan,
                activePlanId: activePlanId,
                activePlanTitle: activePlanTitle,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String title,
                required String materialType,
                required String content,
                required int estimatedDurationMinutes,
                Value<String?> description = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<bool> hasActivePlan = const Value.absent(),
                Value<String?> activePlanId = const Value.absent(),
                Value<String?> activePlanTitle = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> updatedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalMaterialsCompanion.insert(
                id: id,
                userId: userId,
                title: title,
                materialType: materialType,
                content: content,
                estimatedDurationMinutes: estimatedDurationMinutes,
                description: description,
                tags: tags,
                hasActivePlan: hasActivePlan,
                activePlanId: activePlanId,
                activePlanTitle: activePlanTitle,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalMaterialsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalMaterialsTable,
      LocalMaterial,
      $$LocalMaterialsTableFilterComposer,
      $$LocalMaterialsTableOrderingComposer,
      $$LocalMaterialsTableAnnotationComposer,
      $$LocalMaterialsTableCreateCompanionBuilder,
      $$LocalMaterialsTableUpdateCompanionBuilder,
      (
        LocalMaterial,
        BaseReferences<_$AppDatabase, $LocalMaterialsTable, LocalMaterial>,
      ),
      LocalMaterial,
      PrefetchHooks Function()
    >;
typedef $$LocalMaterialChunksTableCreateCompanionBuilder =
    LocalMaterialChunksCompanion Function({
      required String id,
      required String learningMaterialId,
      required int orderNo,
      Value<String?> title,
      required String content,
      Value<String?> summary,
      Value<String?> keywords,
      required int difficultyLevel,
      required int estimatedStudyMinutes,
      required int characterCount,
      Value<bool> isGeneratedByAI,
      Value<String> syncStatus,
      Value<bool> isDeleted,
      Value<DateTime?> updatedAtUtc,
      Value<int> rowid,
    });
typedef $$LocalMaterialChunksTableUpdateCompanionBuilder =
    LocalMaterialChunksCompanion Function({
      Value<String> id,
      Value<String> learningMaterialId,
      Value<int> orderNo,
      Value<String?> title,
      Value<String> content,
      Value<String?> summary,
      Value<String?> keywords,
      Value<int> difficultyLevel,
      Value<int> estimatedStudyMinutes,
      Value<int> characterCount,
      Value<bool> isGeneratedByAI,
      Value<String> syncStatus,
      Value<bool> isDeleted,
      Value<DateTime?> updatedAtUtc,
      Value<int> rowid,
    });

class $$LocalMaterialChunksTableFilterComposer
    extends Composer<_$AppDatabase, $LocalMaterialChunksTable> {
  $$LocalMaterialChunksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get learningMaterialId => $composableBuilder(
    column: $table.learningMaterialId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderNo => $composableBuilder(
    column: $table.orderNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keywords => $composableBuilder(
    column: $table.keywords,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get difficultyLevel => $composableBuilder(
    column: $table.difficultyLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedStudyMinutes => $composableBuilder(
    column: $table.estimatedStudyMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get characterCount => $composableBuilder(
    column: $table.characterCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isGeneratedByAI => $composableBuilder(
    column: $table.isGeneratedByAI,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalMaterialChunksTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalMaterialChunksTable> {
  $$LocalMaterialChunksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get learningMaterialId => $composableBuilder(
    column: $table.learningMaterialId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderNo => $composableBuilder(
    column: $table.orderNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keywords => $composableBuilder(
    column: $table.keywords,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficultyLevel => $composableBuilder(
    column: $table.difficultyLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedStudyMinutes => $composableBuilder(
    column: $table.estimatedStudyMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get characterCount => $composableBuilder(
    column: $table.characterCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isGeneratedByAI => $composableBuilder(
    column: $table.isGeneratedByAI,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalMaterialChunksTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalMaterialChunksTable> {
  $$LocalMaterialChunksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get learningMaterialId => $composableBuilder(
    column: $table.learningMaterialId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderNo =>
      $composableBuilder(column: $table.orderNo, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get keywords =>
      $composableBuilder(column: $table.keywords, builder: (column) => column);

  GeneratedColumn<int> get difficultyLevel => $composableBuilder(
    column: $table.difficultyLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get estimatedStudyMinutes => $composableBuilder(
    column: $table.estimatedStudyMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get characterCount => $composableBuilder(
    column: $table.characterCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isGeneratedByAI => $composableBuilder(
    column: $table.isGeneratedByAI,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );
}

class $$LocalMaterialChunksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalMaterialChunksTable,
          LocalMaterialChunk,
          $$LocalMaterialChunksTableFilterComposer,
          $$LocalMaterialChunksTableOrderingComposer,
          $$LocalMaterialChunksTableAnnotationComposer,
          $$LocalMaterialChunksTableCreateCompanionBuilder,
          $$LocalMaterialChunksTableUpdateCompanionBuilder,
          (
            LocalMaterialChunk,
            BaseReferences<
              _$AppDatabase,
              $LocalMaterialChunksTable,
              LocalMaterialChunk
            >,
          ),
          LocalMaterialChunk,
          PrefetchHooks Function()
        > {
  $$LocalMaterialChunksTableTableManager(
    _$AppDatabase db,
    $LocalMaterialChunksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalMaterialChunksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalMaterialChunksTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalMaterialChunksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> learningMaterialId = const Value.absent(),
                Value<int> orderNo = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<String?> keywords = const Value.absent(),
                Value<int> difficultyLevel = const Value.absent(),
                Value<int> estimatedStudyMinutes = const Value.absent(),
                Value<int> characterCount = const Value.absent(),
                Value<bool> isGeneratedByAI = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> updatedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalMaterialChunksCompanion(
                id: id,
                learningMaterialId: learningMaterialId,
                orderNo: orderNo,
                title: title,
                content: content,
                summary: summary,
                keywords: keywords,
                difficultyLevel: difficultyLevel,
                estimatedStudyMinutes: estimatedStudyMinutes,
                characterCount: characterCount,
                isGeneratedByAI: isGeneratedByAI,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String learningMaterialId,
                required int orderNo,
                Value<String?> title = const Value.absent(),
                required String content,
                Value<String?> summary = const Value.absent(),
                Value<String?> keywords = const Value.absent(),
                required int difficultyLevel,
                required int estimatedStudyMinutes,
                required int characterCount,
                Value<bool> isGeneratedByAI = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> updatedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalMaterialChunksCompanion.insert(
                id: id,
                learningMaterialId: learningMaterialId,
                orderNo: orderNo,
                title: title,
                content: content,
                summary: summary,
                keywords: keywords,
                difficultyLevel: difficultyLevel,
                estimatedStudyMinutes: estimatedStudyMinutes,
                characterCount: characterCount,
                isGeneratedByAI: isGeneratedByAI,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalMaterialChunksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalMaterialChunksTable,
      LocalMaterialChunk,
      $$LocalMaterialChunksTableFilterComposer,
      $$LocalMaterialChunksTableOrderingComposer,
      $$LocalMaterialChunksTableAnnotationComposer,
      $$LocalMaterialChunksTableCreateCompanionBuilder,
      $$LocalMaterialChunksTableUpdateCompanionBuilder,
      (
        LocalMaterialChunk,
        BaseReferences<
          _$AppDatabase,
          $LocalMaterialChunksTable,
          LocalMaterialChunk
        >,
      ),
      LocalMaterialChunk,
      PrefetchHooks Function()
    >;
typedef $$LocalStudyPlansTableCreateCompanionBuilder =
    LocalStudyPlansCompanion Function({
      required String id,
      required String userId,
      required String learningMaterialId,
      required String title,
      required String startDate,
      required int dailyTargetMinutes,
      required String status,
      Value<String> syncStatus,
      Value<bool> isDeleted,
      Value<DateTime?> updatedAtUtc,
      Value<int> rowid,
    });
typedef $$LocalStudyPlansTableUpdateCompanionBuilder =
    LocalStudyPlansCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> learningMaterialId,
      Value<String> title,
      Value<String> startDate,
      Value<int> dailyTargetMinutes,
      Value<String> status,
      Value<String> syncStatus,
      Value<bool> isDeleted,
      Value<DateTime?> updatedAtUtc,
      Value<int> rowid,
    });

class $$LocalStudyPlansTableFilterComposer
    extends Composer<_$AppDatabase, $LocalStudyPlansTable> {
  $$LocalStudyPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get learningMaterialId => $composableBuilder(
    column: $table.learningMaterialId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyTargetMinutes => $composableBuilder(
    column: $table.dailyTargetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalStudyPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalStudyPlansTable> {
  $$LocalStudyPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get learningMaterialId => $composableBuilder(
    column: $table.learningMaterialId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyTargetMinutes => $composableBuilder(
    column: $table.dailyTargetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalStudyPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalStudyPlansTable> {
  $$LocalStudyPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get learningMaterialId => $composableBuilder(
    column: $table.learningMaterialId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<int> get dailyTargetMinutes => $composableBuilder(
    column: $table.dailyTargetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );
}

class $$LocalStudyPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalStudyPlansTable,
          LocalStudyPlan,
          $$LocalStudyPlansTableFilterComposer,
          $$LocalStudyPlansTableOrderingComposer,
          $$LocalStudyPlansTableAnnotationComposer,
          $$LocalStudyPlansTableCreateCompanionBuilder,
          $$LocalStudyPlansTableUpdateCompanionBuilder,
          (
            LocalStudyPlan,
            BaseReferences<
              _$AppDatabase,
              $LocalStudyPlansTable,
              LocalStudyPlan
            >,
          ),
          LocalStudyPlan,
          PrefetchHooks Function()
        > {
  $$LocalStudyPlansTableTableManager(
    _$AppDatabase db,
    $LocalStudyPlansTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalStudyPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalStudyPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalStudyPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> learningMaterialId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<int> dailyTargetMinutes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> updatedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalStudyPlansCompanion(
                id: id,
                userId: userId,
                learningMaterialId: learningMaterialId,
                title: title,
                startDate: startDate,
                dailyTargetMinutes: dailyTargetMinutes,
                status: status,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String learningMaterialId,
                required String title,
                required String startDate,
                required int dailyTargetMinutes,
                required String status,
                Value<String> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> updatedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalStudyPlansCompanion.insert(
                id: id,
                userId: userId,
                learningMaterialId: learningMaterialId,
                title: title,
                startDate: startDate,
                dailyTargetMinutes: dailyTargetMinutes,
                status: status,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalStudyPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalStudyPlansTable,
      LocalStudyPlan,
      $$LocalStudyPlansTableFilterComposer,
      $$LocalStudyPlansTableOrderingComposer,
      $$LocalStudyPlansTableAnnotationComposer,
      $$LocalStudyPlansTableCreateCompanionBuilder,
      $$LocalStudyPlansTableUpdateCompanionBuilder,
      (
        LocalStudyPlan,
        BaseReferences<_$AppDatabase, $LocalStudyPlansTable, LocalStudyPlan>,
      ),
      LocalStudyPlan,
      PrefetchHooks Function()
    >;
typedef $$LocalStudyPlanItemsTableCreateCompanionBuilder =
    LocalStudyPlanItemsCompanion Function({
      required String id,
      required String studyPlanId,
      Value<String?> materialChunkId,
      required String title,
      Value<String?> description,
      required String itemType,
      required int orderNo,
      required DateTime plannedDateUtc,
      Value<String?> plannedStartTime,
      Value<String?> plannedEndTime,
      required int durationMinutes,
      required String status,
      Value<String> syncStatus,
      Value<bool> isDeleted,
      Value<DateTime?> updatedAtUtc,
      Value<int> rowid,
    });
typedef $$LocalStudyPlanItemsTableUpdateCompanionBuilder =
    LocalStudyPlanItemsCompanion Function({
      Value<String> id,
      Value<String> studyPlanId,
      Value<String?> materialChunkId,
      Value<String> title,
      Value<String?> description,
      Value<String> itemType,
      Value<int> orderNo,
      Value<DateTime> plannedDateUtc,
      Value<String?> plannedStartTime,
      Value<String?> plannedEndTime,
      Value<int> durationMinutes,
      Value<String> status,
      Value<String> syncStatus,
      Value<bool> isDeleted,
      Value<DateTime?> updatedAtUtc,
      Value<int> rowid,
    });

class $$LocalStudyPlanItemsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalStudyPlanItemsTable> {
  $$LocalStudyPlanItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studyPlanId => $composableBuilder(
    column: $table.studyPlanId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get materialChunkId => $composableBuilder(
    column: $table.materialChunkId,
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

  ColumnFilters<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderNo => $composableBuilder(
    column: $table.orderNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get plannedDateUtc => $composableBuilder(
    column: $table.plannedDateUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plannedStartTime => $composableBuilder(
    column: $table.plannedStartTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plannedEndTime => $composableBuilder(
    column: $table.plannedEndTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalStudyPlanItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalStudyPlanItemsTable> {
  $$LocalStudyPlanItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studyPlanId => $composableBuilder(
    column: $table.studyPlanId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get materialChunkId => $composableBuilder(
    column: $table.materialChunkId,
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

  ColumnOrderings<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderNo => $composableBuilder(
    column: $table.orderNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get plannedDateUtc => $composableBuilder(
    column: $table.plannedDateUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plannedStartTime => $composableBuilder(
    column: $table.plannedStartTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plannedEndTime => $composableBuilder(
    column: $table.plannedEndTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalStudyPlanItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalStudyPlanItemsTable> {
  $$LocalStudyPlanItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get studyPlanId => $composableBuilder(
    column: $table.studyPlanId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get materialChunkId => $composableBuilder(
    column: $table.materialChunkId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<int> get orderNo =>
      $composableBuilder(column: $table.orderNo, builder: (column) => column);

  GeneratedColumn<DateTime> get plannedDateUtc => $composableBuilder(
    column: $table.plannedDateUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get plannedStartTime => $composableBuilder(
    column: $table.plannedStartTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get plannedEndTime => $composableBuilder(
    column: $table.plannedEndTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );
}

class $$LocalStudyPlanItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalStudyPlanItemsTable,
          LocalStudyPlanItem,
          $$LocalStudyPlanItemsTableFilterComposer,
          $$LocalStudyPlanItemsTableOrderingComposer,
          $$LocalStudyPlanItemsTableAnnotationComposer,
          $$LocalStudyPlanItemsTableCreateCompanionBuilder,
          $$LocalStudyPlanItemsTableUpdateCompanionBuilder,
          (
            LocalStudyPlanItem,
            BaseReferences<
              _$AppDatabase,
              $LocalStudyPlanItemsTable,
              LocalStudyPlanItem
            >,
          ),
          LocalStudyPlanItem,
          PrefetchHooks Function()
        > {
  $$LocalStudyPlanItemsTableTableManager(
    _$AppDatabase db,
    $LocalStudyPlanItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalStudyPlanItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalStudyPlanItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalStudyPlanItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> studyPlanId = const Value.absent(),
                Value<String?> materialChunkId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> itemType = const Value.absent(),
                Value<int> orderNo = const Value.absent(),
                Value<DateTime> plannedDateUtc = const Value.absent(),
                Value<String?> plannedStartTime = const Value.absent(),
                Value<String?> plannedEndTime = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> updatedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalStudyPlanItemsCompanion(
                id: id,
                studyPlanId: studyPlanId,
                materialChunkId: materialChunkId,
                title: title,
                description: description,
                itemType: itemType,
                orderNo: orderNo,
                plannedDateUtc: plannedDateUtc,
                plannedStartTime: plannedStartTime,
                plannedEndTime: plannedEndTime,
                durationMinutes: durationMinutes,
                status: status,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String studyPlanId,
                Value<String?> materialChunkId = const Value.absent(),
                required String title,
                Value<String?> description = const Value.absent(),
                required String itemType,
                required int orderNo,
                required DateTime plannedDateUtc,
                Value<String?> plannedStartTime = const Value.absent(),
                Value<String?> plannedEndTime = const Value.absent(),
                required int durationMinutes,
                required String status,
                Value<String> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> updatedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalStudyPlanItemsCompanion.insert(
                id: id,
                studyPlanId: studyPlanId,
                materialChunkId: materialChunkId,
                title: title,
                description: description,
                itemType: itemType,
                orderNo: orderNo,
                plannedDateUtc: plannedDateUtc,
                plannedStartTime: plannedStartTime,
                plannedEndTime: plannedEndTime,
                durationMinutes: durationMinutes,
                status: status,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalStudyPlanItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalStudyPlanItemsTable,
      LocalStudyPlanItem,
      $$LocalStudyPlanItemsTableFilterComposer,
      $$LocalStudyPlanItemsTableOrderingComposer,
      $$LocalStudyPlanItemsTableAnnotationComposer,
      $$LocalStudyPlanItemsTableCreateCompanionBuilder,
      $$LocalStudyPlanItemsTableUpdateCompanionBuilder,
      (
        LocalStudyPlanItem,
        BaseReferences<
          _$AppDatabase,
          $LocalStudyPlanItemsTable,
          LocalStudyPlanItem
        >,
      ),
      LocalStudyPlanItem,
      PrefetchHooks Function()
    >;
typedef $$LocalStudySessionsTableCreateCompanionBuilder =
    LocalStudySessionsCompanion Function({
      required String id,
      required String studyPlanId,
      Value<String?> studyPlanItemId,
      required String learningMaterialId,
      Value<String?> userId,
      Value<String?> studyProgressId,
      required DateTime scheduledAtUtc,
      Value<DateTime?> startedAtUtc,
      Value<DateTime?> completedAtUtc,
      Value<bool> isCompleted,
      Value<int> sequenceNumber,
      Value<int?> qualityScore,
      Value<int?> difficultyScore,
      Value<int?> actualDurationMinutes,
      Value<String?> reviewNotes,
      Value<String> status,
      Value<String> syncStatus,
      Value<bool> isDeleted,
      Value<DateTime?> updatedAtUtc,
      Value<int> rowid,
    });
typedef $$LocalStudySessionsTableUpdateCompanionBuilder =
    LocalStudySessionsCompanion Function({
      Value<String> id,
      Value<String> studyPlanId,
      Value<String?> studyPlanItemId,
      Value<String> learningMaterialId,
      Value<String?> userId,
      Value<String?> studyProgressId,
      Value<DateTime> scheduledAtUtc,
      Value<DateTime?> startedAtUtc,
      Value<DateTime?> completedAtUtc,
      Value<bool> isCompleted,
      Value<int> sequenceNumber,
      Value<int?> qualityScore,
      Value<int?> difficultyScore,
      Value<int?> actualDurationMinutes,
      Value<String?> reviewNotes,
      Value<String> status,
      Value<String> syncStatus,
      Value<bool> isDeleted,
      Value<DateTime?> updatedAtUtc,
      Value<int> rowid,
    });

class $$LocalStudySessionsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalStudySessionsTable> {
  $$LocalStudySessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studyPlanId => $composableBuilder(
    column: $table.studyPlanId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studyPlanItemId => $composableBuilder(
    column: $table.studyPlanItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get learningMaterialId => $composableBuilder(
    column: $table.learningMaterialId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studyProgressId => $composableBuilder(
    column: $table.studyProgressId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAtUtc => $composableBuilder(
    column: $table.scheduledAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAtUtc => $composableBuilder(
    column: $table.startedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAtUtc => $composableBuilder(
    column: $table.completedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sequenceNumber => $composableBuilder(
    column: $table.sequenceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qualityScore => $composableBuilder(
    column: $table.qualityScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get difficultyScore => $composableBuilder(
    column: $table.difficultyScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualDurationMinutes => $composableBuilder(
    column: $table.actualDurationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewNotes => $composableBuilder(
    column: $table.reviewNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalStudySessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalStudySessionsTable> {
  $$LocalStudySessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studyPlanId => $composableBuilder(
    column: $table.studyPlanId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studyPlanItemId => $composableBuilder(
    column: $table.studyPlanItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get learningMaterialId => $composableBuilder(
    column: $table.learningMaterialId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studyProgressId => $composableBuilder(
    column: $table.studyProgressId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAtUtc => $composableBuilder(
    column: $table.scheduledAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAtUtc => $composableBuilder(
    column: $table.startedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAtUtc => $composableBuilder(
    column: $table.completedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sequenceNumber => $composableBuilder(
    column: $table.sequenceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qualityScore => $composableBuilder(
    column: $table.qualityScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficultyScore => $composableBuilder(
    column: $table.difficultyScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualDurationMinutes => $composableBuilder(
    column: $table.actualDurationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewNotes => $composableBuilder(
    column: $table.reviewNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalStudySessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalStudySessionsTable> {
  $$LocalStudySessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get studyPlanId => $composableBuilder(
    column: $table.studyPlanId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get studyPlanItemId => $composableBuilder(
    column: $table.studyPlanItemId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get learningMaterialId => $composableBuilder(
    column: $table.learningMaterialId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get studyProgressId => $composableBuilder(
    column: $table.studyProgressId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get scheduledAtUtc => $composableBuilder(
    column: $table.scheduledAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAtUtc => $composableBuilder(
    column: $table.startedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAtUtc => $composableBuilder(
    column: $table.completedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sequenceNumber => $composableBuilder(
    column: $table.sequenceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get qualityScore => $composableBuilder(
    column: $table.qualityScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get difficultyScore => $composableBuilder(
    column: $table.difficultyScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualDurationMinutes => $composableBuilder(
    column: $table.actualDurationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reviewNotes => $composableBuilder(
    column: $table.reviewNotes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );
}

class $$LocalStudySessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalStudySessionsTable,
          LocalStudySession,
          $$LocalStudySessionsTableFilterComposer,
          $$LocalStudySessionsTableOrderingComposer,
          $$LocalStudySessionsTableAnnotationComposer,
          $$LocalStudySessionsTableCreateCompanionBuilder,
          $$LocalStudySessionsTableUpdateCompanionBuilder,
          (
            LocalStudySession,
            BaseReferences<
              _$AppDatabase,
              $LocalStudySessionsTable,
              LocalStudySession
            >,
          ),
          LocalStudySession,
          PrefetchHooks Function()
        > {
  $$LocalStudySessionsTableTableManager(
    _$AppDatabase db,
    $LocalStudySessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalStudySessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalStudySessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalStudySessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> studyPlanId = const Value.absent(),
                Value<String?> studyPlanItemId = const Value.absent(),
                Value<String> learningMaterialId = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> studyProgressId = const Value.absent(),
                Value<DateTime> scheduledAtUtc = const Value.absent(),
                Value<DateTime?> startedAtUtc = const Value.absent(),
                Value<DateTime?> completedAtUtc = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> sequenceNumber = const Value.absent(),
                Value<int?> qualityScore = const Value.absent(),
                Value<int?> difficultyScore = const Value.absent(),
                Value<int?> actualDurationMinutes = const Value.absent(),
                Value<String?> reviewNotes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> updatedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalStudySessionsCompanion(
                id: id,
                studyPlanId: studyPlanId,
                studyPlanItemId: studyPlanItemId,
                learningMaterialId: learningMaterialId,
                userId: userId,
                studyProgressId: studyProgressId,
                scheduledAtUtc: scheduledAtUtc,
                startedAtUtc: startedAtUtc,
                completedAtUtc: completedAtUtc,
                isCompleted: isCompleted,
                sequenceNumber: sequenceNumber,
                qualityScore: qualityScore,
                difficultyScore: difficultyScore,
                actualDurationMinutes: actualDurationMinutes,
                reviewNotes: reviewNotes,
                status: status,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String studyPlanId,
                Value<String?> studyPlanItemId = const Value.absent(),
                required String learningMaterialId,
                Value<String?> userId = const Value.absent(),
                Value<String?> studyProgressId = const Value.absent(),
                required DateTime scheduledAtUtc,
                Value<DateTime?> startedAtUtc = const Value.absent(),
                Value<DateTime?> completedAtUtc = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> sequenceNumber = const Value.absent(),
                Value<int?> qualityScore = const Value.absent(),
                Value<int?> difficultyScore = const Value.absent(),
                Value<int?> actualDurationMinutes = const Value.absent(),
                Value<String?> reviewNotes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> updatedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalStudySessionsCompanion.insert(
                id: id,
                studyPlanId: studyPlanId,
                studyPlanItemId: studyPlanItemId,
                learningMaterialId: learningMaterialId,
                userId: userId,
                studyProgressId: studyProgressId,
                scheduledAtUtc: scheduledAtUtc,
                startedAtUtc: startedAtUtc,
                completedAtUtc: completedAtUtc,
                isCompleted: isCompleted,
                sequenceNumber: sequenceNumber,
                qualityScore: qualityScore,
                difficultyScore: difficultyScore,
                actualDurationMinutes: actualDurationMinutes,
                reviewNotes: reviewNotes,
                status: status,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalStudySessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalStudySessionsTable,
      LocalStudySession,
      $$LocalStudySessionsTableFilterComposer,
      $$LocalStudySessionsTableOrderingComposer,
      $$LocalStudySessionsTableAnnotationComposer,
      $$LocalStudySessionsTableCreateCompanionBuilder,
      $$LocalStudySessionsTableUpdateCompanionBuilder,
      (
        LocalStudySession,
        BaseReferences<
          _$AppDatabase,
          $LocalStudySessionsTable,
          LocalStudySession
        >,
      ),
      LocalStudySession,
      PrefetchHooks Function()
    >;
typedef $$SyncOutboxTableCreateCompanionBuilder =
    SyncOutboxCompanion Function({
      required String id,
      required String operationType,
      required String entityType,
      required String entityId,
      required String payload,
      Value<String> status,
      Value<int> retryCount,
      Value<String?> lastError,
      required DateTime createdAtUtc,
      Value<DateTime?> updatedAtUtc,
      Value<DateTime?> nextAttemptAtUtc,
      Value<int> rowid,
    });
typedef $$SyncOutboxTableUpdateCompanionBuilder =
    SyncOutboxCompanion Function({
      Value<String> id,
      Value<String> operationType,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> payload,
      Value<String> status,
      Value<int> retryCount,
      Value<String?> lastError,
      Value<DateTime> createdAtUtc,
      Value<DateTime?> updatedAtUtc,
      Value<DateTime?> nextAttemptAtUtc,
      Value<int> rowid,
    });

class $$SyncOutboxTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAttemptAtUtc => $composableBuilder(
    column: $table.nextAttemptAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAttemptAtUtc => $composableBuilder(
    column: $table.nextAttemptAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextAttemptAtUtc => $composableBuilder(
    column: $table.nextAttemptAtUtc,
    builder: (column) => column,
  );
}

class $$SyncOutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncOutboxTable,
          SyncOutboxData,
          $$SyncOutboxTableFilterComposer,
          $$SyncOutboxTableOrderingComposer,
          $$SyncOutboxTableAnnotationComposer,
          $$SyncOutboxTableCreateCompanionBuilder,
          $$SyncOutboxTableUpdateCompanionBuilder,
          (
            SyncOutboxData,
            BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxData>,
          ),
          SyncOutboxData,
          PrefetchHooks Function()
        > {
  $$SyncOutboxTableTableManager(_$AppDatabase db, $SyncOutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> operationType = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAtUtc = const Value.absent(),
                Value<DateTime?> updatedAtUtc = const Value.absent(),
                Value<DateTime?> nextAttemptAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion(
                id: id,
                operationType: operationType,
                entityType: entityType,
                entityId: entityId,
                payload: payload,
                status: status,
                retryCount: retryCount,
                lastError: lastError,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                nextAttemptAtUtc: nextAttemptAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String operationType,
                required String entityType,
                required String entityId,
                required String payload,
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required DateTime createdAtUtc,
                Value<DateTime?> updatedAtUtc = const Value.absent(),
                Value<DateTime?> nextAttemptAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion.insert(
                id: id,
                operationType: operationType,
                entityType: entityType,
                entityId: entityId,
                payload: payload,
                status: status,
                retryCount: retryCount,
                lastError: lastError,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                nextAttemptAtUtc: nextAttemptAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncOutboxTable,
      SyncOutboxData,
      $$SyncOutboxTableFilterComposer,
      $$SyncOutboxTableOrderingComposer,
      $$SyncOutboxTableAnnotationComposer,
      $$SyncOutboxTableCreateCompanionBuilder,
      $$SyncOutboxTableUpdateCompanionBuilder,
      (
        SyncOutboxData,
        BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxData>,
      ),
      SyncOutboxData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalMaterialsTableTableManager get localMaterials =>
      $$LocalMaterialsTableTableManager(_db, _db.localMaterials);
  $$LocalMaterialChunksTableTableManager get localMaterialChunks =>
      $$LocalMaterialChunksTableTableManager(_db, _db.localMaterialChunks);
  $$LocalStudyPlansTableTableManager get localStudyPlans =>
      $$LocalStudyPlansTableTableManager(_db, _db.localStudyPlans);
  $$LocalStudyPlanItemsTableTableManager get localStudyPlanItems =>
      $$LocalStudyPlanItemsTableTableManager(_db, _db.localStudyPlanItems);
  $$LocalStudySessionsTableTableManager get localStudySessions =>
      $$LocalStudySessionsTableTableManager(_db, _db.localStudySessions);
  $$SyncOutboxTableTableManager get syncOutbox =>
      $$SyncOutboxTableTableManager(_db, _db.syncOutbox);
}
