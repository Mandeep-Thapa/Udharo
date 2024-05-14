part of 'view_kyc_bloc.dart';

@immutable
sealed class ViewKycEvent extends Equatable {
  const ViewKycEvent();

  @override
  List<Object> get props => [];
}

class ViewKycEventLoadKYC extends ViewKycEvent {}
