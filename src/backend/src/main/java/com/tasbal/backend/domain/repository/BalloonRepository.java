package com.tasbal.backend.domain.repository;

import com.tasbal.backend.domain.model.Balloon;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface BalloonRepository {
    Balloon create(UUID ownerUserId, String title, String description, Short colorId, Short tagIconId, Boolean isPublic);

    List<Balloon> findPublicBalloons(int limit, int offset);

    Optional<UUID> findSelectedBalloon(UUID userId);

    void setSelection(UUID userId, UUID balloonId);
}
