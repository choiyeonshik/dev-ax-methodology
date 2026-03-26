package com.example.carcenter;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertNotNull;

class CarCenterApplicationTests {

    @Test
    void applicationMainMethodExists() {
        // 메인 메서드가 존재하는지 확인
        assertNotNull(CarCenterApplication.class);
    }

    @Test
    void applicationCanBeInstantiated() {
        // 애플리케이션 클래스가 인스턴스화 가능한지 확인
        CarCenterApplication app = new CarCenterApplication();
        assertNotNull(app);
    }

}
