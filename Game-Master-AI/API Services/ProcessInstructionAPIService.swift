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
                print(error)
                return .failure(.init("Apple authorization error. Please try again later."))
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
                    .responseStream { [weak self] stream in
                        switch stream.event {
                        case .stream(let result):
                            if let data = try? result.get(), let rawChunk = String(data: data, encoding: .utf8), !rawChunk.contains("[DONE]") {
                                let chunk = rawChunk
                                    .replacingOccurrences(of: "data:", with: "")
                                    .replacingOccurrences(of: "\n", with: "")
                                    .replacingOccurrences(of: "\\n", with: "\n")
                                    .replacingOccurrences(of: "\r", with: "")

                                if chunk == "^" {
                                    onReceive(chunk)
                                } else if let errorMessage = self?.getErrorMessageFromStream(chunk: chunk) {
                                    continuation.resume(returning: Result.failure(.init(errorMessage)))
                                } else {
                                    guard let jsonData = chunk.data(using: .utf8),
                                          let subjectDTO = try? JSONDecoder().decode(EssentialsSubjectDTO.self, from: jsonData)
                                    else { return }

                                    continuation.resume(returning: Result.success(subjectDTO))
                                }
                            }

                        case .complete(let completion):
                            if let afError = completion.error?.asAFError, let statusCode = afError.responseCode {
                                continuation.resume(returning: Result.failure(.init(fromStatusCode: statusCode)))
                            }
                        }
                    }
            }
        return returnResult ?? .failure(.init("Could not connect to the server."))
    }
}

extension ProcessInstructionAPIService {
    struct Error: EssentialsToastProvidableError {
        let message: String

        init(fromStatusCode code: Int) {
            switch code {
            case 401:
                message = "Authorization error. Please try again later."
            case 403:
                message = "You have reached the free limit for game creation. Please upgrade to premium."
            case 413:
                message = "You've choosen too many photos. Please upgrade to premium to upload up to 40 pages"
            case 429:
                message = "Too many requests in a short period of time. Please try again in a minute."
            case 443:
                message = "You have reached monthly limit for game creation. Please wait until the next cycle."
            default:
                message = "An unexpected error occurred. Please try again later."
            }
        }

        init(_ message: String?) {
            self.message = "An unexpected error occurred. Please try again later."
        }

        init(_ message: String) {
            self.message = message
        }
    }
}
