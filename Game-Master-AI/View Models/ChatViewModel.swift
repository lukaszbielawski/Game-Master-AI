//
//  ChatViewModel.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 11/01/2025.
//

import Combine
import Essentials
import Foundation
import StoreKit

@MainActor
final class ChatViewModel: ObservableObject {
    private let completionsAPI =
        EssentialsCompletionsAPIService()
//    EssentialsFakeCompletionsAPIService()
    private let sessionAPI = EssentialsSessionsAPIService()
    private let audioCaptureService = EssentialsAudioCaptureService()
    private let boardGameModel: BoardGameModel
    private let toastProvider = EssentialsToastProvider.shared

    @Published private(set) var messages: EssentialsLoadingState<[Essentials.EssentialsMessage], EssentialsCompletionsAPIServiceError> = .initial
    @Published private(set) var streamedMessage: String? = nil

    @Published private(set) var volumeFractions: [CGFloat] = []

    @Published private(set) var recordingState: EssentialsRecordingState = .stopped

    @Published private(set) var recordingDurationSeconds: Int = 0

    lazy var assistantGreetingMessage = EssentialsMessage(role: "assistant", content: """
    Hello! I’m your dedicated \(boardGameModel.name) rules expert. I’m here to help you understand and clarify any questions you have about the rules of \(boardGameModel.name), based solely on its official rulebook. Feel free to ask me anything, such as:

    [Button]How to set up the game[/Button].
    [Button]Rules for winning or ending the game[/Button]

    If something isn’t specified in the rulebook, I’ll let you know. Let’s dive into \(boardGameModel.name)—what would you like to know?
    """)

    init(boardGameModel: BoardGameModel) {
        self.boardGameModel = boardGameModel
        audioCaptureService.delegate = self
    }

    func fetchAllMessages() async {
        messages = .initial
        switch await sessionAPI.getSessionMessages(sessionId: boardGameModel.sessionId) {
        case .success(let response):
            var fetchedMessages = response.messages
            fetchedMessages.insert(assistantGreetingMessage, at: 0)
            messages = .success(fetchedMessages)
        case .failure(let error):
            messages = .failure(error: error.toEssentialsCompletionsAPIServiceError())
        }
    }

    func resetConversation() async {
        messages = .success([assistantGreetingMessage])
        switch await sessionAPI.resetSession(sessionId: boardGameModel.sessionId) {
        case .success:
            toastProvider.enqueueToast(.success("New session started!"))
        case .failure:
            toastProvider.enqueueToast(.failure("Could not reset a session. Please try again"))
        }
    }

    func startRecording() async {
        guard recordingState == .stopped else { return }
        recordingState = .startingToRecord
        let result = await audioCaptureService.startRecordingAudio()
        switch result {
        case .success(let success):
            recordingState = .recording
        case .failure(let error):
            recordingState = .stopped
            print(error)
        }
    }

    func cancelRecording() async {
        guard recordingState == .recording else { return }
        recordingState = .stoppingToRecord
        audioCaptureService.cancelRecording()
        recordingState = .stopped
    }

    func stopRecording() async {
        guard recordingState == .recording else { return }
        recordingState = .stoppingToRecord
        let result = await audioCaptureService.stopRecording()
        switch result {
        case .success(let m4aData):
            await sendWhisperRecording(m4aData: m4aData)
            recordingState = .stopped
        case .failure(let error):
            recordingState = .recording
            print(error)
        }
    }

    func sendWhisperRecording(m4aData: Data) async {
        let base64EncodedAudio = m4aData.base64EncodedString()

        let request = BoardGameWhisperCompletionsRequest(
            boardGameId: boardGameModel.id, base64AudioM4A: base64EncodedAudio
        )

        let result = await completionsAPI.getChatCompletionsStream(
            request: request,
            completionsType: .whisper,
            onReceive: { [weak self] chunk, messageType in
                guard let self, let messageType else { return }
                if messageType == .user {
                    let userMessage = EssentialsMessage(role: messageType.rawValue, content: chunk)
                    messages.appendIfSuccess(userMessage)
                } else if messageType == .assistant {
                    if let streamedMessage {
                        self.streamedMessage = streamedMessage.appending(chunk)
                    } else {
                        streamedMessage = chunk
                    }
                }
            }
        )
        switch result {
        case .success(let message):
            messages.appendIfSuccess(message)
            streamedMessage = nil
        case .failure(let error):
            let failureMessage = EssentialsMessage(role: "failure", content: error.message)
            messages.appendIfSuccess(failureMessage)
            print(error)
        }
    }

    func sendMessage(content: String) async {
        guard !content.isEmpty else { return }

        let newMessage = EssentialsMessage(role: "user", content: content)
        messages.appendIfSuccess(newMessage)
        let request = BoardGameCompletionsRequest(boardGameId: boardGameModel.id, userQuery: content)

        let result = await completionsAPI.getChatCompletionsStream(
            request: request,
            onReceive: { [weak self] chunk, _ in
                if let streamedMessage = self?.streamedMessage {
                    self?.streamedMessage = streamedMessage.appending(chunk)
                } else {
                    self?.streamedMessage = chunk
                }
            }
        )
        switch result {
        case .success(let message):
            messages.appendIfSuccess(message)
            streamedMessage = nil
        case .failure(let error):
            let failureMessage = EssentialsMessage(role: "failure", content: error.message)
            messages.appendIfSuccess(failureMessage)
            print(error)
        }
    }
}

extension ChatViewModel: EssentialsAudioCaptureDelegate {
    func updateMeter(currentValue: Float, currentTime: TimeInterval) {
        let fraction = 0.025 * currentValue + 1.25
        let normalizedFraction = min(1.0, max(0.0, fraction))

        recordingDurationSeconds = Int(floor(currentTime))

        volumeFractions.append(CGFloat(normalizedFraction))
    }

    func onCancelUpdatingMeter() {
        volumeFractions.removeAll()
    }
}
