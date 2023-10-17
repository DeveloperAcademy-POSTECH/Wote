//
//  ProfileSettingsViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/18/23.
//

import Foundation

@Observable
final class ProfileSettingsViewModel {
    var selectedSchoolInfo: SchoolInfoModel?
    var selectedGrade: String?
    var isFormValid = true
    
    var isNicknameValid: Bool {
        return selectedSchoolInfo != nil
    }

    var isSchoolValid: Bool {
        return selectedSchoolInfo != nil
    }

    var isGradeValid: Bool {
        return selectedGrade != nil
    }
}
