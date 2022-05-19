// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => $checkedCreate(
      r'_$_User',
      json,
      ($checkedConvert) {
        final val = _$_User(
          id: $checkedConvert('id', (v) => v as int),
          name: $checkedConvert('name', (v) => v as String),
          username: $checkedConvert('username', (v) => v as String),
          email: $checkedConvert('email', (v) => v as String),
          phone: $checkedConvert('phone', (v) => v as String),
          website: $checkedConvert('website', (v) => v as String),
          address: $checkedConvert(
              'address', (v) => Address.fromJson(v as Map<String, dynamic>)),
          company: $checkedConvert(
              'company', (v) => Company.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'email': instance.email,
      'phone': instance.phone,
      'website': instance.website,
      'address': instance.address,
      'company': instance.company,
    };

_$_Address _$$_AddressFromJson(Map<String, dynamic> json) => $checkedCreate(
      r'_$_Address',
      json,
      ($checkedConvert) {
        final val = _$_Address(
          street: $checkedConvert('street', (v) => v as String),
          suite: $checkedConvert('suite', (v) => v as String),
          city: $checkedConvert('city', (v) => v as String),
          zipcode: $checkedConvert('zipcode', (v) => v as String),
          geo: $checkedConvert(
              'geo', (v) => Geo.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$$_AddressToJson(_$_Address instance) =>
    <String, dynamic>{
      'street': instance.street,
      'suite': instance.suite,
      'city': instance.city,
      'zipcode': instance.zipcode,
      'geo': instance.geo,
    };

_$_Geo _$$_GeoFromJson(Map<String, dynamic> json) => $checkedCreate(
      r'_$_Geo',
      json,
      ($checkedConvert) {
        final val = _$_Geo(
          lat: $checkedConvert('lat', (v) => v as String),
          lng: $checkedConvert('lng', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$$_GeoToJson(_$_Geo instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };

_$_Company _$$_CompanyFromJson(Map<String, dynamic> json) => $checkedCreate(
      r'_$_Company',
      json,
      ($checkedConvert) {
        final val = _$_Company(
          name: $checkedConvert('name', (v) => v as String),
          catchPhrase: $checkedConvert('catchPhrase', (v) => v as String),
          bs: $checkedConvert('bs', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$$_CompanyToJson(_$_Company instance) =>
    <String, dynamic>{
      'name': instance.name,
      'catchPhrase': instance.catchPhrase,
      'bs': instance.bs,
    };
