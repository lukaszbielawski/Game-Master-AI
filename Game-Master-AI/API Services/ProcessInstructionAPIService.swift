//
//  ProcessInstructionAPIService.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 06/02/2025.
//

import Alamofire
import Essentials
import Foundation
import StoreKit

final class ProcessInstructionAPIService: EssentialsAPIService {
    @discardableResult
    func processInstruction(
        request: ProcessInstructionRequest,
        deployEnvironment: DeployEnvironmentType? = nil,
        onReceive: @escaping (String) -> Void
    ) async -> Result<EssentialsSubjectDTO, Error> {
        let url: String = hostname + "/api/" + moduleName + "/process-instruction"

        let deployEnvironment: DeployEnvironmentType = deployEnvironment
            ?? DeployEnvironmentType.current

        if deployEnvironment != .simulator {
            switch await authorizationService.fetchTransactionIdAndDeviceToken() {
            case .success(let success):
                authorizationModel = success
            case .failure(let error):
                return .failure(error)
            }
        }

        let headers = createHeaders(deployEnvironment: deployEnvironment)

        let returnResult: Result<EssentialsSubjectDTO, Error>? =
            await withCheckedContinuation { continuation in
                AF.streamRequest(url,
                                 method: .post,
                                 parameters: request,
                                 encoder: JSONParameterEncoder(),
                                 headers: headers)
                { $0.timeoutInterval = 240.0 }
                    .validate()
                    .responseStream { stream in
                        switch stream.event {
                        case .stream(let result):
                            switch result {
                            case .success(let data):
                                if let str = String(data: data, encoding: .utf8), !str.contains("[DONE]") {
                                    let cleanedString = str
                                        .replacingOccurrences(of: "data:", with: "")
                                        .replacingOccurrences(of: "\n", with: "")
                                        .replacingOccurrences(of: "\\n", with: "\n")
                                        .replacingOccurrences(of: "\r", with: "")
                                    if cleanedString == "^" {
                                        onReceive(cleanedString)
                                    } else {
                                        guard let jsonData = cleanedString.data(using: .utf8),
                                              let subjectDTO = try? JSONDecoder().decode(EssentialsSubjectDTO.self, from: jsonData)
                                        else { return }

                                        continuation.resume(returning: Result.success(subjectDTO))
                                    }
                                }
                            case .failure(let error):
                                continuation.resume(returning: Result.failure(error))
                            }
                        case .complete:
                            break
                        }
                    }
            }
        return returnResult ?? .failure(EssentialsAPIError.other)
    }
}
