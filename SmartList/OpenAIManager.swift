//
//  OpenAIManager.swift
//  SmartList
//
//  Created by Zhiyuan Zhou on 11/24/23.
//

import Foundation
import OpenAISwift

typealias OpenAIResult = OpenAI

class OpenAIManager {
    static let key = "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"
    
    func requestWithRequest(request: String) async -> Result<OpenAIResult<TextResult>, OpenAIError> {
        await withCheckedContinuation { [weak self] continuation in
            self?.requestWithPrompt(prompt: request, completion: { result in
                continuation.resume(returning: result)
            })
        }
    }
    
    private func requestWithPrompt(prompt: String, completion: @escaping (Result<OpenAIResult<TextResult>, OpenAIError>) -> Void ) {
        let openAI = OpenAISwift(authToken: Self.key)
        openAI.sendCompletion(with: prompt) { result in
            completion(result)
        }
    }
}
