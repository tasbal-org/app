package com.tasbal.backend.application.service;

import com.tasbal.backend.domain.model.User;
import com.tasbal.backend.domain.model.UserSettings;
import com.tasbal.backend.domain.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
@Transactional
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public User createGuestUser(String handle) {
        return userRepository.createGuest(handle);
    }

    public User getUserById(UUID userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    public UserSettings getUserSettings(UUID userId) {
        return userRepository.findSettingsByUserId(userId)
                .orElseThrow(() -> new RuntimeException("User settings not found"));
    }

    public UserSettings updateUserSettings(UUID userId, String countryCode, Short renderQuality, Boolean autoLowPower) {
        return userRepository.updateSettings(userId, countryCode, renderQuality, autoLowPower);
    }
}
