class QBUserEntity {
  int? blobId;
  String? customData;
  String? email;
  String? externalId;
  String? facebookId;
  String? fullName;
  int? id;
  String? login;
  String? phone;
  List<String>? tags;
  String? twitterId;
  String? website;
  String? lastRequestAt;

  QBUserEntity(
      {this.blobId,
      this.customData,
      this.email,
      this.externalId,
      this.facebookId,
      this.fullName,
      this.id,
      this.login,
      this.phone,
      this.tags,
      this.twitterId,
      this.website,
      this.lastRequestAt});

  @override
  String toString() {
    return 'QBUserModel{blobId: $blobId, customData: $customData, email: $email, externalId: $externalId, facebookId: $facebookId, fullName: $fullName, id: $id, login: $login, phone: $phone, tags: $tags, twitterId: $twitterId, website: $website, lastRequestAt: $lastRequestAt}';
  }
}
