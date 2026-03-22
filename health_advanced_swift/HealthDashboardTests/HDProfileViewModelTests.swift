//
//  HDProfileViewModelTests.swift
//  HealthDashboardTests
//
//  Created by AI Assistant on 2026/3/22.
//

import XCTest
import Combine
@testable import HealthDashboard

class HDProfileViewModelTests: XCTestCase {
    var viewModel: HDProfileViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = HDProfileViewModel()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - 数据绑定测试
    
    func testStepsGoalBinding() {
        let expectation = XCTestExpectation(description: "stepsGoal updated")
        
        viewModel.$stepsGoalText
            .dropFirst()
            .sink { text in
                XCTAssertEqual(text, "12000")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.updateStepsGoal(12000)
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWaterGoalBinding() {
        let expectation = XCTestExpectation(description: "waterGoal updated")
        
        viewModel.$waterGoalText
            .dropFirst()
            .sink { text in
                XCTAssertEqual(text, "2500")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.updateWaterGoal(2500)
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testTodayStepsDisplay() {
        let expectation = XCTestExpectation(description: "todaySteps displayed")
        
        viewModel.$todayStepsText
            .dropFirst()
            .sink { text in
                XCTAssertFalse(text.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        HDHealthDataModel.shared.addSteps(100)
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWaterMLDisplay() {
        let expectation = XCTestExpectation(description: "waterML displayed")
        
        viewModel.$waterMLText
            .dropFirst()
            .sink { text in
                XCTAssertTrue(text.contains("ml"))
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        HDHealthDataModel.shared.addWater(250)
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - 主题切换测试
    
    func testDarkModeToggle() {
        let expectation = XCTestExpectation(description: "darkMode toggled")
        
        let initialMode = viewModel.isDarkMode
        
        viewModel.$isDarkMode
            .dropFirst()
            .sink { isDark in
                XCTAssertNotEqual(isDark, initialMode)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.toggleDarkMode()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testBackgroundColorChangesWithTheme() {
        let expectation = XCTestExpectation(description: "backgroundColor changed")
        
        viewModel.$backgroundColor
            .dropFirst()
            .sink { color in
                XCTAssertNotNil(color)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.toggleDarkMode()
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - 功能对标测试
    
    func testInitialValuesLoaded() {
        XCTAssertFalse(viewModel.stepsGoalText.isEmpty)
        XCTAssertFalse(viewModel.waterGoalText.isEmpty)
        XCTAssertFalse(viewModel.todayStepsText.isEmpty)
    }
    
    func testStepsGoalBoundaryValues() {
        // 测试边界值
        viewModel.updateStepsGoal(0)
        XCTAssertEqual(viewModel.stepsGoalText, "0")
        
        viewModel.updateStepsGoal(999999)
        XCTAssertEqual(viewModel.stepsGoalText, "999999")
    }
    
    func testWaterGoalBoundaryValues() {
        // 测试边界值
        viewModel.updateWaterGoal(0)
        XCTAssertEqual(viewModel.waterGoalText, "0")
        
        viewModel.updateWaterGoal(5000)
        XCTAssertEqual(viewModel.waterGoalText, "5000")
    }
}
