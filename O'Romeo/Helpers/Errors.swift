//
//  Errors.swift
//  O'Romeo
//
//  Created by Will morris on 6/21/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation

enum Errors: Error {
    case personAlreadyExists
    case interestAlreadyExists
    case noCurrentUser
    case unwrapDocumentID
    case unwrapPersonUID
    case unwrapCurrentUserUID
    case snapshotGuard
    case unwrapData
}

extension Errors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .personAlreadyExists:
            return NSLocalizedString("Person already exists", comment: "")
        case .interestAlreadyExists:
            return NSLocalizedString("Interest already exists", comment: "")
        case .noCurrentUser:
            return NSLocalizedString("No current user", comment: "")
        case .unwrapDocumentID:
            return NSLocalizedString("Couldn't unwrap ref.documentID", comment: "")
        case .unwrapPersonUID:
            return NSLocalizedString("Couldn't unwrap value.first?.personUID", comment: "")
        case .unwrapCurrentUserUID:
            return NSLocalizedString("Couldn't unwrap Auth.auth().currentUser.uid", comment: "")
        case .snapshotGuard:
            return NSLocalizedString("Failed snapshot guard", comment: "")
        case .unwrapData:
            return NSLocalizedString("Couldnt unwrap data", comment: "")
        }
    }
}
