import 'package:flutter/material.dart';

class PersonalizationModel extends ChangeNotifier {
  String? _facebookUrl;
  String? _instagramUrl;
  String? _twitterUrl;
  String? _youtubeUrl;
  String? _linkedinUrl;
  String? _slogan;
  String? _welcomeTitle;
  String? _welcomeDescription;
  String? _welcomeFeatured;
  String? _welcomeImage;
  String? _loadingImage;
  String? _footerImage;
  bool _isLoading = false;
  String? _error;

  // Getters
  String? get facebookUrl => _facebookUrl;
  String? get instagramUrl => _instagramUrl;
  String? get twitterUrl => _twitterUrl;
  String? get youtubeUrl => _youtubeUrl;
  String? get linkedinUrl => _linkedinUrl;
  String? get slogan => _slogan;
  String? get welcomeTitle => _welcomeTitle;
  String? get welcomeDescription => _welcomeDescription;
  String? get welcomeFeatured => _welcomeFeatured;
  String? get welcomeImage => _welcomeImage;
  String? get loadingImage => _loadingImage;
  String? get footerImage => _footerImage;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Setters
  void setFacebookUrl(String? url) {
    _facebookUrl = url;
    notifyListeners();
  }

  void setInstagramUrl(String? url) {
    _instagramUrl = url;
    notifyListeners();
  }

  void setTwitterUrl(String? url) {
    _twitterUrl = url;
    notifyListeners();
  }

  void setYoutubeUrl(String? url) {
    _youtubeUrl = url;
    notifyListeners();
  }

  void setLinkedinUrl(String? url) {
    _linkedinUrl = url;
    notifyListeners();
  }

  void setSlogan(String? slogan) {
    _slogan = slogan;
    notifyListeners();
  }

  void setWelcomeTitle(String? title) {
    _welcomeTitle = title;
    notifyListeners();
  }

  void setWelcomeDescription(String? description) {
    _welcomeDescription = description;
    notifyListeners();
  }

  void setWelcomeFeatured(String? featured) {
    _welcomeFeatured = featured;
    notifyListeners();
  }

  void setWelcomeImage(String? image) {
    _welcomeImage = image;
    notifyListeners();
  }

  void setLoadingImage(String? image) {
    _loadingImage = image;
    notifyListeners();
  }

  void setFooterImage(String? image) {
    _footerImage = image;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Clear all data
  void clear() {
    _facebookUrl = null;
    _instagramUrl = null;
    _twitterUrl = null;
    _youtubeUrl = null;
    _linkedinUrl = null;
    _slogan = null;
    _welcomeTitle = null;
    _welcomeDescription = null;
    _welcomeFeatured = null;
    _welcomeImage = null;
    _loadingImage = null;
    _footerImage = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
