//
//  OpenAIManager.swift
//  SmartList
//
//  Created by Zhiyuan Zhou on 11/24/23.
//

import Foundation
import OpenAISwift

typealias ChatResult = Result<OpenAI<MessageResult>, OpenAIError>

enum Instructions {
    static let systemmInstruction =
"""
You are to help the user create daily tasks. Each task has a  date, start time, duration, title and description. Return the response in JSON with tasks under the name \"task_items\", and each item has \"date\", \"start_time\", \"duration\", \"title\" and \"description\" being fields.

Return date in mm:dd:yyyy format as a string.
Return start time in hh:mm format as a string.
Return duration in minutes as a string.
Return description and title as strings.

Leave the field blank if the user has not provided associated information.

Return an empty string if you fail to understand the task.
"""
}

class OpenAIManager {
    static let key = "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"
    
    func requestWithChat(chats: [ChatMessage]) async -> ChatResult {
        await withCheckedContinuation({ continuation in
            requestWithChats(chats: chats, completion: { result in
                continuation.resume(returning: result)
            })
        })
    }
    
    private func requestWithChats(chats: [ChatMessage], completion: @escaping (ChatResult) -> Void) {
        let openAI = OpenAISwift(config: .makeDefaultOpenAI(apiKey: Self.key))
        openAI.sendChat(with: chats, maxTokens: 1000) { result in
            completion(result)
        }
    }
    
    func requestWithRequest(request: String) async -> ChatResult {
        await withCheckedContinuation { [weak self] continuation in
            self?.requestWithPrompt(prompt: request, completion: { result in
                continuation.resume(returning: result)
            })
        }
    }
    
    private func requestWithPrompt(prompt: String, completion: @escaping (ChatResult) -> Void ) {
        let openAI = OpenAISwift(config: .makeDefaultOpenAI(apiKey: Self.key))
        openAI.sendChat(with: [
            ChatMessage(role: .system, content: Instructions.systemmInstruction),
            ChatMessage(role: .user, content: "I am going to wake up at 11 am tomorrow and then exercise for 30 minutes. I will have a meeting at 2pm to 3pm. I'll have dinner at 6"),
        ]) { result in
            completion(result)
        }
    }
}
