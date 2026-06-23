import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:zingo/models/user_profile.dart';
import 'package:zingo/models/user_setting.dart';

part 'user_configuration.g.dart';

@JsonSerializable()
class UserConfiguration extends Equatable {
  final UserProfile? profile;
  final UserSetting? settings;

  const UserConfiguration({this.profile, this.settings});

  factory UserConfiguration.fromJson(Map<String, dynamic> json) =>
      _$UserConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$UserConfigurationToJson(this);

  @override
  List<Object?> get props => [profile, settings];
}
