import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:drift/drift.dart';

class UserProfile {
  final String userId;
  final String? fullName;
  final String email;
  final String? phoneNumber;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPremium;

  UserProfile({
    required this.userId,
    this.fullName,
    required this.email,
    this.phoneNumber,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.isPremium,
  });
}

class UserProfileState {
  final UserProfile? userProfile;
  final bool isLoading;
  final String? errorMessage;

  UserProfileState({
    this.userProfile,
    required this.isLoading,
    this.errorMessage,
  });

  UserProfileState copyWith({
    UserProfile? userProfile,
    bool? isLoading,
    String? errorMessage,
  }) {
    return UserProfileState(
      userProfile: userProfile ?? this.userProfile,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class UserProfileNotifier extends StateNotifier<UserProfileState> {
  final AppDatabase _db;

  UserProfileNotifier(Ref ref)
      : _db = ref.watch(databaseProvider),
        super(
          UserProfileState(
            isLoading: false,
          ),
        );

  Future<void> loadUserProfile(String userId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final userProfile = await _db.findUserProfileById(userId);

      if (userProfile != null) {
        state = state.copyWith(
          userProfile: UserProfile(
            userId: userProfile.userId,
            fullName: userProfile.fullName,
            email: userProfile.email,
            phoneNumber: userProfile.phoneNumber,
            profileImageUrl: userProfile.profileImageUrl,
            createdAt: userProfile.createdAt,
            updatedAt: userProfile.updatedAt,
            isPremium: userProfile.isPremium,
          ),
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          userProfile: null,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load user profile',
      );
    }
  }

  Future<void> createUserProfile({
    required String userId,
    String? fullName,
    required String email,
    String? phoneNumber,
    String? profileImageUrl,
    bool isPremium = false,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final now = DateTime.now();
      
      final userProfilesCompanion = UserProfilesCompanion(
        userId: Value(userId),
        fullName: Value(fullName),
        email: Value(email),
        phoneNumber: Value(phoneNumber),
        profileImageUrl: Value(profileImageUrl),
        createdAt: Value(now),
        updatedAt: Value(now),
        isPremium: Value(isPremium),
      );
      
      await _db.addUserProfile(userProfilesCompanion);

      // Load the created profile
      await loadUserProfile(userId);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create user profile',
      );
    }
  }

  Future<void> updateUserProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final now = DateTime.now();
      
      final userProfilesCompanion = UserProfilesCompanion(
        userId: Value(userId),
        fullName: fullName != null ? Value(fullName) : const Value.absent(),
        phoneNumber: phoneNumber != null ? Value(phoneNumber) : const Value.absent(),
        profileImageUrl: profileImageUrl != null ? Value(profileImageUrl) : const Value.absent(),
        updatedAt: Value(now),
      );
      
      await _db.updateUserProfile(userProfilesCompanion);

      // Reload the updated profile
      await loadUserProfile(userId);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update user profile',
      );
    }
  }

  Future<void> syncWithFirebaseUser(firebase_auth.User firebaseUser) async {
    try {
      // Check if profile exists
      final existingProfile = await _db.findUserProfileById(firebaseUser.uid);

      if (existingProfile == null) {
        // Create new profile from Firebase user
        await createUserProfile(
          userId: firebaseUser.uid,
          fullName: firebaseUser.displayName,
          email: firebaseUser.email ?? '',
          profileImageUrl: firebaseUser.photoURL,
          isPremium: false,
        );
      } else {
        // Update existing profile with Firebase user data if needed
        bool needsUpdate = false;
        UserProfilesCompanion updateCompanion = UserProfilesCompanion(
          userId: Value(firebaseUser.uid),
        );

        if (firebaseUser.displayName != null && 
            firebaseUser.displayName != existingProfile.fullName) {
          updateCompanion = updateCompanion.copyWith(
            fullName: Value(firebaseUser.displayName),
          );
          needsUpdate = true;
        }

        if (firebaseUser.photoURL != null && 
            firebaseUser.photoURL != existingProfile.profileImageUrl) {
          updateCompanion = updateCompanion.copyWith(
            profileImageUrl: Value(firebaseUser.photoURL),
          );
          needsUpdate = true;
        }

        if (needsUpdate) {
          updateCompanion = updateCompanion.copyWith(
            updatedAt: Value(DateTime.now()),
          );
          await _db.updateUserProfile(updateCompanion);
          await loadUserProfile(firebaseUser.uid);
        }
      }
    } catch (e) {
      // Handle error silently as this is a sync operation
    }
  }
}

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfileState>((ref) {
  return UserProfileNotifier(ref);
});