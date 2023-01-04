//
//  Functions.swift
//  Runner
//
//  Created by kurotu on 2023/01/04.
//

import Foundation

func moveToTrash(path: String) throws {
  let fileURL = URL(fileURLWithPath: path)
  let fileManager = FileManager.default
  try fileManager.trashItem(at: fileURL, resultingItemURL: nil)
}
