package com.tasbal.backend.application.service;

import com.tasbal.backend.domain.model.Balloon;
import com.tasbal.backend.domain.repository.BalloonRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@Transactional
public class BalloonService {

    private final BalloonRepository balloonRepository;

    public BalloonService(BalloonRepository balloonRepository) {
        this.balloonRepository = balloonRepository;
    }

    public Balloon createBalloon(UUID ownerUserId, String title, String description, Short colorId, Short tagIconId, Boolean isPublic) {
        return balloonRepository.create(ownerUserId, title, description, colorId, tagIconId, isPublic);
    }

    public List<Balloon> getPublicBalloons(int limit, int offset) {
        return balloonRepository.findPublicBalloons(limit, offset);
    }

    public UUID getSelectedBalloon(UUID userId) {
        return balloonRepository.findSelectedBalloon(userId)
                .orElse(null);
    }

    public void setSelectedBalloon(UUID userId, UUID balloonId) {
        balloonRepository.setSelection(userId, balloonId);
    }
}
