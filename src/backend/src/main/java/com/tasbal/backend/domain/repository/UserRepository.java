package com.tasbal.backend.domain.repository;

import com.tasbal.backend.domain.model.User;
import com.tasbal.backend.domain.model.UserSettings;
import java.util.Optional;
import java.util.UUID;

public interface UserRepository {
    User createGuest(String handle);

    Optional<User> findById(UUID userId);

    Optional<UserSettings> findSettingsByUserId(UUID userId);

    UserSettings updateSettings(UUID userId, String countryCode, Short renderQuality, Boolean autoLowPower);
}
